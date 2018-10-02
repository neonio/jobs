//
//  CalendarHeadView.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class CalendarHeadView : UIView {
    lazy var container: UIStackView = {
        let container = UIStackView()
        container.alignment = .fill
        container.distribution = .fillEqually
        container.axis = .horizontal
        return container
    }()
    
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = bounds
    }
    
    private func createWeekdayLabel(content: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = CalendarConstant.default.fontColor
        label.textAlignment = .center
        label.text = content
        return label
    }
}
