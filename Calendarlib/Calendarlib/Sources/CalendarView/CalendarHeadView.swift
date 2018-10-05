//
//  CalendarHeadView.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class CalendarHeadView : UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialized()
    }
    
    private func initialized() {
        addSubview(container)
        
        for str in Calendar.current.veryShortWeekdaySymbols {
            container.addArrangedSubview(createWeekdayLabel(content: str))
        }
        layer.insertSublayer(underlineLayer, below: container.layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = bounds
        underlineLayer.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
    }
    
    private func createWeekdayLabel(content: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = CalendarConstant.default.fontColor
        label.textAlignment = .center
        label.text = content
        return label
    }
    
    lazy var container: UIStackView = {
        let container = UIStackView()
        container.alignment = .fill
        container.distribution = .fillEqually
        container.axis = .horizontal
        return container
    }()
    
    private var underlineLayer: CALayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = CalendarConstant.default.gray.cgColor
        return layer
    }()
}
