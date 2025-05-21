//
//  EventViewModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
//

import UIKit

extension EventView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        let Event = filteredEvents[indexPath.row]
        cell.configure(event: Event)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = filteredEvents[indexPath.row]
        
        guard let token = KeychainService.get(key: K.Keys.accessToken), !token.isEmpty else {
            print("AccessToken이 없음")
            return
        }
        
        EventService.checkEvent(eventId: selectedEvent.id, token: token) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let updated = response.result {
                        // 해당 이벤트의 체크 상태를 업데이트하고 셀 갱신
                        if let index = self.allEvents.firstIndex(where: { $0.id == updated.id }) {
                            self.allEvents[index] = Event(id: updated.id, title: updated.title, category: self.allEvents[index].category, done: updated.done)
                            self.applyCategoryFilter()
                            print("일정 체크 성공")
                        }
                    }
                }
            case .failure(let error):
                print("일정 체크 실패: \(error)")
            }
        }
    }
}
