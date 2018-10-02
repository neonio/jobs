//
//  CalendarEventCell.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class CalendarEventCell: UITableViewCell {
    // MARK: - Event Response
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialized()
    }
    
    private func initialized() {}
    
    // MARK: - UI setup
    
    // MARK: - Protocol
    
    // MARK: - Property
}
