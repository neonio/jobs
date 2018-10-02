//
//  DateFormatFactory.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class DateFormatFactory: NSObject {
    @objc func removeAllFormatters() {
        loadedDateFormatters.removeAllObjects()
    }
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(DateFormatFactory.removeAllFormatters), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func dateFormatter(format: String, locale: Locale) -> DateFormatter {
        let key: NSString = (format + locale.identifier) as NSString
        if let dateformat = loadedDateFormatters.object(forKey: key) {
            return dateformat
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            if Locale.current.identifier.contains("_CN") {
                formatter.locale = Locale(identifier: "zh_CN")
            } else {
                formatter.locale = Locale.current
            }
            loadedDateFormatters.setObject(formatter, forKey: key)
            return formatter
        }
    }
    
    func dateFormatter(format: String) -> DateFormatter {
        return dateFormatter(format: format, locale: Locale.current)
    }
    
    var cacheLimit: Int = 10
    static let shared = DateFormatFactory()
    
    private lazy var loadedDateFormatters: NSCache<NSString, DateFormatter> = {
        var cache: NSCache<NSString, DateFormatter> = NSCache<NSString, DateFormatter>()
        cache.countLimit = cacheLimit
        cache.delegate = self
        return cache
    }()
}

extension DateFormatFactory: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let formatter = obj as? DateFormatter {
            print(formatter.debugDescription)
        }
    }
}
