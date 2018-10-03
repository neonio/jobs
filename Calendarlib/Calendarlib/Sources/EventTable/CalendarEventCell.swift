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
            startTimeLabel.text = DateFormatFactory.shared.dateFormatter(format: "hh:mm a").string(from: model.startDate)
            durationLabel.isHidden = false
            durationLabel.text = model.endDate.timeIntervalSince(model.startDate).humanReadable()
        }
        
        if let locationDesc = model.location, !locationDesc.isEmpty {
            locationLabel.text = "\(IconFont.location) \(locationDesc)"
            locationLabel.isHidden = false
        } else {
            locationLabel.isHidden = true
        }
        
//        let eventColor = UIColor(cgColor: model.calendar.cgColor)
//        eventTypeImageView.tintColor = eventColor
        
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
        participantStackView.isHidden = participantStackView.arrangedSubviews.count == 0
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
        contentView.addSubview(durationLabel)
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(participantStackView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(eventTypeImageView)
        setupLayout()
    }
    
    // MARK: - UI setup
    
    private func setupLayout() {
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        startTimeLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        startTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        startTimeLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.leadingAnchor.constraint(equalTo: startTimeLabel.leadingAnchor).isActive = true
        durationLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 2).isActive = true
        durationLabel.widthAnchor.constraint(equalTo: startTimeLabel.widthAnchor).isActive = true
        durationLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12).isActive = true
        
        eventTypeImageView.translatesAutoresizingMaskIntoConstraints = false
        eventTypeImageView.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: 4).isActive = true
        eventTypeImageView.topAnchor.constraint(equalTo: startTimeLabel.topAnchor).isActive = true
        eventTypeImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        eventTypeImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.leadingAnchor.constraint(equalTo: eventTypeImageView.trailingAnchor, constant: 12).isActive = true
        mainTitleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        mainTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        participantStackView.translatesAutoresizingMaskIntoConstraints = false
        participantStackView.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor).isActive = true
        participantStackView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        participantStackView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: participantStackView.bottomAnchor, constant: 8).isActive = true
        locationLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor).isActive = true
    }
    
    // MARK: - Protocol
    
    // MARK: - Property
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = CalendarConstant.tableview.grayColor
        return label
    }()
    
    lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = CalendarConstant.tableview.darkColor
        return label
    }()
    
    lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = CalendarConstant.tableview.darkColor
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
        label.numberOfLines = 1
        label.textColor = CalendarConstant.tableview.grayColor
        label.fontAwesome(size: 13)
        return label
    }()
    
    lazy var eventTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        let placeholderImage = UIImage.image(withColor: UIColor.black, size: CGSize(width: 8, height: 8), cornerRadius: 4, strokeWidth: nil, strokeColor: nil)
        imageView.image = placeholderImage
        return imageView
    }()
}
