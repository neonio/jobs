//
//  ViewController.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    @objc func didTapMoreAction(item: UIBarButtonItem) {
        print("\(#function)")
    }
    
    @objc func didTapDisplayAction(item: UIBarButtonItem) {
        print("\(#function)")
    }
    
    @objc func didTapAddAction(item: UIBarButtonItem) {
        print("\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CalendarConstant.default.itemSize
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let calView = CalendarBodyView(frame: .zero, collectionViewLayout: layout)
        calView.register(CalendarCell.self, forCellWithReuseIdentifier: NSStringFromClass(CalendarCell.self))
        view.addSubview(calView)
        calView.translatesAutoresizingMaskIntoConstraints = false
        calView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        calView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        calView.delegate = self
        calView.dataSource = self
        calView.backgroundColor = UIColor.lightGray
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(CalendarEventCell.self, forCellReuseIdentifier: NSStringFromClass(CalendarEventCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: calView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.backgroundColor = .cyan
    }
    
    private func setupNav() {
        title = "一月 2019"
        let moreActionButton = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(didTapMoreAction(item:)))
        let addActionButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAddAction(item:)))
        let displayModeActionButton = UIBarButtonItem(title: "Display", style: .done, target: self, action: #selector(didTapDisplayAction(item:)))
        
        self.navigationItem.leftBarButtonItems = [moreActionButton]
        self.navigationItem.rightBarButtonItems = [addActionButton, displayModeActionButton]
    }
}

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

extension DemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CalendarEventCell.self), for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "-- \(section)"
    }
}
