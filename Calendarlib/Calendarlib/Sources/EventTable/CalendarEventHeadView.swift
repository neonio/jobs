//
//  CalendarEventHeadView.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class CalendarEventHeadView: UIView {
    func update(date: Date, numberOfEvents: Int) {}
    
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
