//
//  CalendarEventCell.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
import EventKit
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
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var participantStackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
