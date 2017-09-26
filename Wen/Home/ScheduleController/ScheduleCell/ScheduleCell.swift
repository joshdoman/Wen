//
//  ScheduleCell.swift
//  Wen
//
//  Created by Josh Doman on 4/5/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit

class ScheduleCell: UICollectionViewCell {
    
    var schedule: DaySchedule! {
        didSet {
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
    let cellID = "cellID"
    let headerView = "headerView"
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.bounds)
        tv.delegate = self
        tv.register(AgendaCell.self, forCellReuseIdentifier: self.cellID)
        tv.register(ScheduleCellHeaderView.self, forHeaderFooterViewReuseIdentifier: self.headerView)
        tv.showsVerticalScrollIndicator = false
        //tv.bounces = false //disables bounce
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScheduleCell: UITableViewDataSource, UITableViewDelegate {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AgendaCell
        cell.delegate = self
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerView) as! ScheduleCellHeaderView
        view.date = schedule.date
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AgendaCell.calculateHeightForEvents(for: schedule.events, announcement: nil)
    }
}

extension ScheduleCell: AgendaCellDelegate {
    
    func getEvents() -> [Event] {
        return schedule.events
    }
    
    func getAnnouncement() -> String? {
        return nil
    }
}
