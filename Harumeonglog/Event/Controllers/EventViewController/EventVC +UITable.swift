//
//  EventViewModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
//

import UIKit

extension EventView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredEvents.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyLabel.text = "일정이 아직 없어요.\n오른쪽 하단 + 버튼을 눌러 새 일정을 추가해보세요!"
            emptyLabel.textColor = .gray03
            emptyLabel.font = .body
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            
            let containerView = UIView(frame: tableView.bounds)
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(emptyLabel)
            
            // Center with slight downward offset to avoid category overlap
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                // Slightly raised so it doesn't collide with the + button, but still visible when calendar collapses
                emptyLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
                emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 24),
                emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -24)
            ])
            
            tableView.backgroundView = containerView
        } else {
            tableView.backgroundView = nil
        }
        return filteredEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        let event = filteredEvents[indexPath.row]
        cell.configure(event: event)
        cell.checkmarkIcon.isUserInteractionEnabled = true
        cell.checkmarkIcon.gestureRecognizers?.forEach {
            cell.checkmarkIcon.removeGestureRecognizer($0)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkmarkIconTapped(_:)))
        cell.checkmarkIcon.addGestureRecognizer(tapGesture)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = filteredEvents[indexPath.row]

        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 없음")
            return
        }

        EventService.getEventDetail(eventId: selectedEvent.id, token: token) { [self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let eventDetail = response.result {
                        print("단일 일정 조회 성공: \(eventDetail.title)")
                        print("getEventDetail 응답 데이터: \(response)")
                        let editVC = EditEventViewController(event: eventDetail, isEditable: true)
                        editVC.delegate = self.findViewController() as? EditEventViewControllerDelegate
                        if let viewController = self.findViewController() {
                            viewController.navigationController?.pushViewController(editVC, animated: true)
                        }
                    }
                }
            case .failure(let error):
                print("단일 일정 조회 실패: \(error)")
            }
        }
    }

    @objc func checkmarkIconTapped(_ sender: UITapGestureRecognizer) {
        guard let icon = sender.view as? UIImageView else { return }
        guard let cell = icon.findSuperview(of: EventCell.self),
              let tableView = self.findTableView(for: cell),
              let indexPath = tableView.indexPath(for: cell) else { return }
        
        let event = filteredEvents[indexPath.row]
        
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 없음")
            return
        }

        EventService.checkEvent(eventId: event.id, token: token) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let updated = response.result,
                       let index = self.allEvents.firstIndex(where: { $0.id == updated.id }) {
                        self.allEvents[index] = Event(id: updated.id, title: updated.title, category: self.allEvents[index].category, done: updated.done)
                        self.applyCategoryFilter()
                        print("일정 체크 성공")
                    }
                }
            case .failure(let error):
                print("일정 체크 실패: \(error)")
            }
        }
    }
}

extension UIView {
    func findSuperview<T: UIView>(of type: T.Type) -> T? {
        var view = self.superview
        while view != nil {
            if let match = view as? T {
                return match
            }
            view = view?.superview
        }
        return nil
    }
}

extension UIResponder {
    func findTableView(for cell: UITableViewCell) -> UITableView? {
        var responder: UIResponder? = cell
        while responder != nil {
            if let tableView = responder as? UITableView {
                return tableView
            }
            responder = responder?.next
        }
        return nil
    }
}
