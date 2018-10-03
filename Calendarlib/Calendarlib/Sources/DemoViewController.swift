//
//  ViewController.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    // MARK: - Event Response
    
    @objc func didTapMoreAction(item: UIBarButtonItem) {
        print("\(#function)")
    }
    
    @objc func didTapDisplayAction(item: UIBarButtonItem) {
        print("\(#function)")
    }
    
    @objc func didTapAddAction(item: UIBarButtonItem) {
        let vc = DetailViewController.create()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        
        let layout = UICollectionViewFlowLayout()
        let cellWidth = view.bounds.width / 7
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let calendarHeadView = CalendarHeadView()
        view.addSubview(calendarHeadView)
        calendarHeadView.translatesAutoresizingMaskIntoConstraints = false
        calendarHeadView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarHeadView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendarHeadView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        calendarHeadView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        let calView = CalendarBodyView(frame: .zero, collectionViewLayout: layout)
        calView.showsVerticalScrollIndicator = false
        calView.showsHorizontalScrollIndicator = false
        calView.register(CalendarCell.self, forCellWithReuseIdentifier: NSStringFromClass(CalendarCell.self))
        view.addSubview(calView)
        calView.translatesAutoresizingMaskIntoConstraints = false
        calView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calView.topAnchor.constraint(equalTo: calendarHeadView.bottomAnchor).isActive = true
        calView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        calView.delegate = self
        calView.dataSource = self
        calView.backgroundColor = UIColor.lightGray
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self.viewModel
        view.addSubview(tableView)
        tableView.register(CalendarEventCell.self, forCellReuseIdentifier: NSStringFromClass(CalendarEventCell.self))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: calView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - UI setup
    
    private func setupNav() {
        updateNavTitle()
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: CalendarConstant.selectedStyle.fillColor
        ]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let moreActionButton = UIBarButtonItem(title: IconFont.more, style: .plain, target: self, action: #selector(didTapMoreAction(item:)))
        moreActionButton.fontAwesome(size: 24)
        moreActionButton.tintColor = CalendarConstant.default.black
        
        let addActionButton = UIBarButtonItem(title: IconFont.add, style: .plain, target: self, action: #selector(didTapAddAction(item:)))
        addActionButton.fontAwesome(size: 24)
        addActionButton.tintColor = CalendarConstant.default.black
        
        let displayModeActionButton = UIBarButtonItem(title: IconFont.list, style: .done, target: self, action: #selector(didTapDisplayAction(item:)))
        displayModeActionButton.fontAwesome(size: 24)
        displayModeActionButton.tintColor = CalendarConstant.default.black
        
        self.navigationItem.leftBarButtonItems = [moreActionButton]
        self.navigationItem.rightBarButtonItems = [addActionButton, displayModeActionButton]
    }
    
    private func updateNavTitle() {
        title = viewModel.pickedDateDesc
    }
    
    // MARK: - Property
    
    var viewModel: DemoCalendarViewModel = DemoCalendarViewModel()
}

// MARK: - Protocol

import EventKit
extension DemoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CalendarCell.self), for: indexPath) as! CalendarCell
        cell.dayLabel.text = "\(indexPath.row)"
        cell.monthLabel.text = "12月"
        
        return cell
    }
}

extension DemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CalendarEventHeadView()
        headerView.update(isToday: false, content: viewModel.sectionTitle(section: section))
        return headerView
    }
}
