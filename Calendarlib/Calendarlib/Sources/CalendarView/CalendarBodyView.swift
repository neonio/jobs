//
//  CalendarBodyView.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
protocol CalendarViewDelegate: class {
    func didSelect(in collectionView: CalendarView, at indexPath: IndexPath, with date: Date)
    func willBeginDragging(in collectionView: CalendarView)
}

class CalendarBodyView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialized()
    }
    
    private func initialized() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        scrollsToTop = false
    }
}

class CalendarView: UIView {
    func scrollTo(date: Date, animated: Bool) {
        let validDate = calculator.fitDateByScope(originDate: date)
        if let indexPath = calculator.getIndexPath(date: validDate, mode: calculator.mode, inPosition: .current) {
            bodyView.scrollToItem(at: indexPath, at: .centeredVertically, animated: animated)
        }
    }
    
    func scrollToToday(animated: Bool) {
        scrollTo(date: Date(), animated: animated)
    }
    
    func scrollToSelectedIndexPath(animated: Bool) {
        if let selectedIndexPath = selectedIndexPath {
            bodyView.scrollToItem(at: selectedIndexPath, at: .top, animated: animated)
        }
    }
    
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        bodyView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialized()
    }
    
    private func initialized() {
        setupLayout()
        
        bodyView.delegate = self
        bodyView.dataSource = self
        
        setupUI()
    }
    
    convenience init(calculator: CalendarCalculator) {
        self.init()
        self.calculator = calculator
    }
    
    private func setupUI() {
        bodyView.backgroundColor = UIColor.white
    }
    
    private func setupLayout() {
        addSubview(headView)
        headView.translatesAutoresizingMaskIntoConstraints = false
        headView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        headView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bodyView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bodyView.topAnchor.constraint(equalTo: headView.bottomAnchor).isActive = true
        bodyView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    var layout: UICollectionViewLayout = UICollectionViewFlowLayout() {
        didSet {
            bodyView.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    lazy var bodyView: CalendarBodyView = {
        let collectionView = CalendarBodyView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy var calculator: CalendarCalculator = {
        let calculator = CalendarCalculator()
        return calculator
    }()
    
    var selectedIndexPath: IndexPath?
    var previousIndexPath: IndexPath?
    var headView: CalendarHeadView = CalendarHeadView()
    var isCollapse: Bool = false
    weak var delegate: CalendarViewDelegate?
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch calculator.mode {
        case .month:
            if calculator.isScrollModeEnabled {
                return calculator.numberOfDaysInSection(section: section)
            } else {
                return 42
            }
        case .week:
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CalendarCell.self), for: indexPath) as! CalendarCell
        let date = calculator.getDate(indexPath: indexPath, mode: calculator.mode)
        let dayNum = date.day
        let monthPosition = calculator.getMonthPosition(indexPath: indexPath)
        let isMonthStartDate = (dayNum == 1)
        let eventCount = (dayNum + date.month) % 4
        let isToday = Calendar.current.isDateInToday(date)
        let viewModel = CalendarCellViewModel()
        
        viewModel.isToday = isToday
        viewModel.eventCount = eventCount
        viewModel.isMonthStartDate = isMonthStartDate
        viewModel.date = date
        viewModel.position = monthPosition
        if let selectedIndexPath = selectedIndexPath {
            viewModel.isSelected = (indexPath == selectedIndexPath)
        } else {
            viewModel.isSelected = false
        }
        cell.update(viewmodel: viewModel)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        calculator.reloadSection()
        return calculator.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath != indexPath {
            let oldIndexPath = selectedIndexPath
            self.selectedIndexPath = indexPath
            UIView.animate(withDuration: 0) {
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: [oldIndexPath, indexPath])
                }, completion: nil)
            }
        } else {
            self.selectedIndexPath = indexPath
            UIView.animate(withDuration: 0) {
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: [indexPath])
                }, completion: nil)
            }
        }
        
        return true
    }
    
    // MARK: - ScrollViewDelegate

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.gestureRecognizers?.forEach({ gesture in
            if !gesture.isEqual(scrollView.panGestureRecognizer) {
                gesture.isEnabled = false
            }
        })
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.willBeginDragging(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date: Date = calculator.getDate(indexPath: indexPath, mode: calculator.mode)
        delegate?.didSelect(in: self, at: indexPath, with: date)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let monthStartDate = calculator.monthStartDate(section: section)
            let placeholderCount = calculator.numberOfLastMonthDaysInThisSection(monthStartDate: monthStartDate)
            if placeholderCount > 0 && section != 0 {
                return UIEdgeInsets(top: -floor(layout.itemSize.height), left: 0, bottom: 0, right: 0)
            } else {
                return .zero
            }
        } else {
            return .zero
        }
    }
}
