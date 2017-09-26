//
//  ScheduleController.swift
//  Wen
//
//  Created by Josh Doman on 4/5/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit
import Material

class ScheduleController: OrganizationSearchController {
    
    var schedules: [DaySchedule]!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //makes cells swipe horizontally
        layout.minimumLineSpacing = 0 //decreases gap between cells
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        cv.isPagingEnabled = true //makes the cells snap (paging behavior)
        cv.register(ScheduleCell.self, forCellWithReuseIdentifier: self.cellID)
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Th", "F", "Sat", "Sun", "M", "T", "W"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteGrey
        sc.backgroundColor = UIColor.whiteGrey
        sc.selectedSegmentIndex = 1
        sc.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.oceanBlue], for: .selected)
        sc.addTarget(self, action: #selector(handleSegmentControlChange), for: .valueChanged)
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName : UIFont(name: UIFont.lightFont, size: 18.5)!]
        sc.setTitleTextAttributes(attributes, for: .normal)
        return sc
    }()
    
    internal let cellID = "cellId"
    
    private var navBarHeight: CGFloat {
        return 0 //self.navigationController?.navigationBar.frame.height ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.definesPresentationContext = true //necessary so that search bar shows on top of shadow
        
        loadSchedules()
        setupView()
        reloadCollectionViewData()
    }
    
    private func setupView() {
        view.addSubview(segmentControl)
        _ = segmentControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        view.addSubview(collectionView)
        
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: segmentControl.topAnchor, right: view.rightAnchor, topConstant: navBarHeight + 30.0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        if let firstView = view.subviews.first {
            view.bringSubview(toFront: firstView)
        }
    }
    
    private func loadSchedules() {
        schedules = [DaySchedule]()
        var day = Date()
        for _ in 0...6 {
            schedules.append(DaySchedule(date: day, events: Event.mockEvents))
            day = Date.addDay(to: day)
        }
    }
    
    internal func handleSegmentControlChange(_ segmentControl: UISegmentedControl) {
        collectionView.scrollToItem(at: IndexPath(item: segmentControl.selectedSegmentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func reloadCollectionViewData() {
        segmentControl.selectedSegmentIndex = 0
        if schedules.count > 0 {
            for i in 0...(schedules.count-1) {
                segmentControl.setTitle(schedules[i].date.abbreviation, forSegmentAt: i)
            }
        }
    }
}

extension ScheduleController {
    func handleAdd(_ sender: UIButton) {
        print("add")
    }
    
    func handleMenu(_ sender: UIButton) {
        print("menu")
    }
}
