//
//  CalendarBodyView.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
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
    }
}

class CalendarView: UIView {
    lazy var calculator: CalendarCalculator = {
        let calculator = CalendarCalculator()
        return calculator
    }()
    
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
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    var headView: CalendarHeadView = CalendarHeadView()
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch calculator.mode {
        case .month:
            if calculator.isScrollModeEnabled {
                return 7 * calculator.numberOfSection()
            } else {
                return 42
            }
        case .week:
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let date = calculator.getDate(indexPath: indexPath, mode: calculator.mode)
        let monthPosition = calculator.getMonthPosition(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CalendarCell.self), for: indexPath) as! CalendarCell
        cell.updateUI(position: monthPosition, date: date)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        calculator.reloadSection()
        return calculator.numberOfSection()
    }
    
    
}
