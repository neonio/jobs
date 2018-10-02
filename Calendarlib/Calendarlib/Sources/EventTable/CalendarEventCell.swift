//
//  CalendarEventCell.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import EventKit
import UIKit
class CalendarEventCell: UITableViewCell {
    // MARK: - Event Response
    
    func update(model: EKEvent) {
        mainTitleLabel.text = model.title
        
        if model.isAllDay {
            startTimeLabel.text = "全天"
            durationLabel.isHidden = true
        } else {
            startTimeLabel.text = DateFormatFactory.shared.dateFormatter(format: "hh:mm").string(from: model.startDate)
            durationLabel.isHidden = false
            durationLabel.text = model.endDate.timeIntervalSince(model.startDate).humanReadable()
        }
        
        if let locationDesc = model.location {
            locationLabel.text = "\(IconFont.location) \(locationDesc)"
        }
        
        for attendee in model.attendees ?? [] {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            if let attendeeName = attendee.name, !attendeeName.isEmpty {
                label.text = String(attendeeName.first!)
            } else if let urlStr = attendee.url.absoluteString.first {
                label.text = String(urlStr)
            }
            
            participantStackView.addArrangedSubview(label)
        }
    }
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialized()
    }
    
    private func initialized() {
        addSubview(durationLabel)
        addSubview(mainTitleLabel)
        addSubview(startTimeLabel)
        addSubview(participantStackView)
        addSubview(locationLabel)
    }
    
    // MARK: - UI setup
    
    // MARK: - Protocol
    
    // MARK: - Property
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var participantStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
