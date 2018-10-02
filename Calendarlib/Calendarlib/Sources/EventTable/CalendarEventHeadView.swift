//
//  CalendarEventHeadView.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class CalendarEventHeadView: UIView {
    func update(isToday:Bool, content:String) {
        titleLabel.text = content
        if isToday {
            titleLabel.textColor = CalendarConstant.selectedStyle.fillColor
            backgroundColor = CalendarConstant.selectedStyle.fillBackgroundColor
        }else{
            titleLabel.textColor = CalendarConstant.default.fontColor
            backgroundColor = CalendarConstant.default.disableFillColor
        }
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
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        titleLabel.frame = bounds.inset(by: inset)
    }
    
    // MARK: - Properties
    
    var hasEvent: Bool = false
    var isToday: Bool = false
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
}
