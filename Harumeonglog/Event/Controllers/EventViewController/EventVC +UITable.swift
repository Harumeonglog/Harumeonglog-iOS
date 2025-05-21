//
//  EventViewModel.swift
//  Harumeonglog
//
//  Created by Dana Lim on 5/21/25.
// API + 날짜 처리

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
        cell.configure(Event: Event.title, isChecked: false)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = filteredEvents[indexPath.row]
        delegate?.didSelectEvent(selectedEvent)
    }
}
