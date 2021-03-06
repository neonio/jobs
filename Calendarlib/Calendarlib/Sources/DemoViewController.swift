//
//  ViewController.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import EventKit
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
        let cellWidth = view.bounds.width / 7.0
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.layout = layout
        
        let calendarView = CalendarView(calculator: calculator)
        calendarView.delegate = self
        calendarView.layout = layout
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: NSStringFromClass(CalendarCell.self))
        self.calendarView = calendarView
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendarViewHeightCons = calendarView.heightAnchor.constraint(equalToConstant: cellWidth * 5 + 28)
        calendarViewHeightCons?.isActive = true
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self.viewModel
        tableView.scrollsToTop = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        self.tableView = tableView
        view.addSubview(tableView)
        tableView.register(CalendarEventCell.self, forCellReuseIdentifier: NSStringFromClass(CalendarEventCell.self))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            calendarView.scrollToToday(animated: false)
            let tableViewIndexPathSection = self.viewModel.tableViewSectionIn(date: Date())
            self.tableView?.scrollToRow(at: IndexPath(row: 0, section: tableViewIndexPathSection), at: .top, animated: false)
        }
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
    
    var calendarViewHeightCons: NSLayoutConstraint?
    var layout: UICollectionViewFlowLayout?
    var tableView: UITableView?
    var calendarView: CalendarView?
    let calculator = CalendarCalculator()
    lazy var viewModel: DemoCalendarViewModel = {
        let viewmodel = DemoCalendarViewModel(calculator: calculator)
        return viewmodel
    }()

}

// MARK: - Protocol

extension DemoViewController: CalendarViewDelegate {
    func didSelect(in collectionView: CalendarView, at indexPath: IndexPath, with date: Date) {
        viewModel.pickedDate = date
        updateNavTitle()
        let tableViewIndexPathSection = viewModel.tableViewSectionIn(date: date)
        tableView?.scrollToRow(at: IndexPath(row: 0, section: tableViewIndexPathSection), at: .top, animated: true)
    }
    
    func willBeginDragging(in collectionView: CalendarView) {
        let cellHeight = layout?.itemSize.height ?? 0
        if collectionView == calendarView && (calendarView?.isCollapse ?? false) {
            calendarViewHeightCons?.constant = cellHeight * 5 + 28
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                self.calendarView?.isCollapse = false
            }
        }
    }
}

extension DemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CalendarEventHeadView()
        let date = viewModel.dateIn(section: section)
        let sectionTitle = viewModel.sectionTitle(section: section)
        headerView.update(date: date, content: sectionTitle)
        return headerView
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let cellHeight = layout?.itemSize.height ?? 0
        
        if scrollView == tableView && !(calendarView?.isCollapse ?? true) {
            calendarViewHeightCons?.constant = cellHeight * 2 + 28
            calendarView?.scrollToSelectedIndexPath(animated: true)
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                self.calendarView?.isCollapse = true
            }
        }
    }
}
