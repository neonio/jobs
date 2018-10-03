//
//  CalendarCell.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit

// -------
// cell height 44
// indicator 8
// day label 24
// month Label 16
// -------

struct CalendarCellPresenter {
    var isMonthFirstDay: Bool = false
    var isSelect: Bool = false
    var inCurrentMonthScope: Bool = true
    var numberOfEvent: Int = 0
}

class CalendarCell: UICollectionViewCell {
    func updateUI(presentModel: CalendarCellPresenter) {}
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialized()
    }
    
    private func initialized() {
        setupUI()
    }
    
    // MARK: - UI setup
    
    private func setupUI() {
        addSubview(dayLabel)
        addSubview(eventIndicatorView)
        addSubview(monthLabel)
        
        clipsToBounds = false
        contentView.clipsToBounds = false
    }
    
    private func layoutMethod() {
        var topOffset: CGFloat = 0
        monthLabel.frame = CGRect(x: 0, y: topOffset, width: contentView.bounds.width, height: ceil(contentView.bounds.height * 0.3))
        topOffset += monthLabel.bounds.height
        dayLabel.frame = CGRect(x: 0, y: topOffset, width: contentView.bounds.width, height: ceil(contentView.bounds.height * 0.6))
        topOffset += dayLabel.bounds.height
        eventIndicatorView.frame = CGRect(x: 0, y: topOffset, width: contentView.bounds.width, height: ceil(contentView.bounds.height * 0.2))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutMethod()
    }
    
    // MARK: - Protocol
    
    // MARK: - Property
    
    override var reuseIdentifier: String? {
        return NSStringFromClass(CalendarCell.self)
    }
    
    lazy var monthLabel: UILabel = {
        let monthLabel = UILabel()
        monthLabel.font = CalendarConstant.default.monthLabelFont
        monthLabel.textAlignment = .center
        monthLabel.textColor = CalendarConstant.default.fontColor
        return monthLabel
    }()
    
    lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.textAlignment = .center
        dayLabel.textColor = .black
        dayLabel.font = CalendarConstant.default.font
        return dayLabel
    }()
    
    lazy var bgLayer: CAShapeLayer = {
        let bgLayer = CAShapeLayer()
        bgLayer.borderWidth = 1
        bgLayer.borderColor = UIColor.clear.cgColor
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.isHidden = true
        layer.insertSublayer(bgLayer, below: dayLabel.layer)
        return bgLayer
    }()
    
    lazy var eventIndicatorView: UIView = {
        let eventView = UIView()
        eventView.backgroundColor = .clear
        return eventView
    }()
}
