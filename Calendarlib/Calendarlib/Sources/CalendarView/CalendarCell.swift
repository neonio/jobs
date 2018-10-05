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

class CalendarCellViewModel {
    var isToday: Bool = false
    var eventCount: Int = 0
    var isMonthStartDate: Bool = false
    var date: Date = Date()
    var position: CalendarMonthPosition = .current
    var isSelected: Bool = false
}

class CalendarCell: UICollectionViewCell {
    func configSelectedUI() {
        monthLabel.textColor = UIColor.clear
        dayLabel.textColor = CalendarConstant.selectedStyle.fontColor
        bgLayer.fillColor = CalendarConstant.selectedStyle.fillBackgroundColor.cgColor
        bgLayer.isHidden = false
    }
    
    func configNormalUI() {
        monthLabel.textColor = CalendarConstant.default.fontColor
        dayLabel.textColor = CalendarConstant.default.fontColor
        bgLayer.isHidden = true
    }
    
    func update(viewmodel: CalendarCellViewModel) {
        self.viewModel = viewmodel
        let dayNum = viewmodel.date.day
        let monthNum = viewmodel.date.month
        dayLabel.text = "\(dayNum)"
        monthLabel.text = viewmodel.isMonthStartDate ? Calendar.current.shortMonthSymbols[monthNum - 1] : ""
        eventIndicatorView.eventCount = (viewmodel.isSelected ? 0 : viewmodel.eventCount)
        if viewmodel.isToday {
            backgroundColor = UIColor(hex: 0xD2E5F5)
        } else {
            backgroundColor = monthNum % 2 == 0 ? UIColor(hex: 0xF8F8F8) : UIColor.white
        }
        updateUI(viewmodel.position)
        if viewmodel.isSelected {
            configSelectedUI()
        } else {
            configNormalUI()
        }
        setNeedsLayout()
    }
    
    func updateUI(_ position: CalendarMonthPosition) {
        switch position {
        case .nextMonth, .previousMonth:
            break
        case .current:
            break
        }
    }
    
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
    
    var viewModel: CalendarCellViewModel = CalendarCellViewModel()
    
    private func layoutMethod() {
        var topOffset: CGFloat = ceil(contentView.bounds.height * 0.08)
        if viewModel.eventCount == 0 && viewModel.isMonthStartDate {
            topOffset += ceil(contentView.bounds.height * 0.08)
        }
        monthLabel.frame = CGRect(x: 0, y: topOffset, width: contentView.bounds.width, height: ceil(contentView.bounds.height * 0.22))
        topOffset += monthLabel.bounds.height
        var dayLabelY: CGFloat = ceil(contentView.bounds.height * 0.25)
        if viewModel.eventCount == 0 && viewModel.isMonthStartDate {
            dayLabelY = topOffset
        }
        dayLabel.frame = CGRect(x: 0, y: dayLabelY, width: contentView.bounds.width, height: ceil(contentView.bounds.height * 0.5))
        topOffset = dayLabel.frame.maxY
        eventIndicatorView.frame = CGRect(x: 0, y: topOffset, width: contentView.bounds.width, height: ceil(contentView.bounds.height * 0.1))
        let circlePath = UIBezierPath(arcCenter: dayLabel.center, radius: 20, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bgLayer.path = circlePath.cgPath
        underlineLayer.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
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
        bgLayer.fillColor = UIColor.clear.cgColor
        layer.insertSublayer(bgLayer, below: dayLabel.layer)
        return bgLayer
    }()
    
    lazy var underlineLayer: CAShapeLayer = {
        let underlineLayer = CAShapeLayer()
        underlineLayer.backgroundColor = CalendarConstant.default.gray.cgColor
        layer.insertSublayer(underlineLayer, below: bgLayer)
        return underlineLayer
    }()
    
    lazy var eventIndicatorView: EventIndicatorView = {
        let eventView = EventIndicatorView()
        return eventView
    }()
}

class EventIndicatorView: UIView {
    var eventCount: Int = 0 {
        didSet {
            updateUI(eventCount: eventCount)
        }
    }
    
    var radius: CGFloat = 2
    lazy var displayLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = circlePath(radius: radius).cgPath
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private func updateUI(eventCount: Int) {
        displayLayer.fillColor = UIColor(white: 0.2, alpha: CGFloat(eventCount) / 4).cgColor
    }
    
    private func circlePath(radius: CGFloat) -> UIBezierPath {
        let originPoint = CGPoint(x: bounds.width / 2 - radius, y: 0)
        let rect = CGRect(origin: originPoint, size: CGSize(width: radius * 2, height: radius * 2))
        let path = UIBezierPath(ovalIn: rect)
        return path
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        displayLayer.path = circlePath(radius: radius).cgPath
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
        displayLayer.frame = bounds
        layer.addSublayer(displayLayer)
    }
}
