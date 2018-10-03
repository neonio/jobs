//
//  EventWorker.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/3.
//  Copyright © 2018 amoyio. All rights reserved.
//

import EventKit
import Foundation
class EventWorker {
    static let shared = EventWorker()
    var isPermissionAllowed: Bool {
        return EKEventStore.authorizationStatus(for: .event) == .authorized
    }
    
    lazy var eventStore: EKEventStore = {
        let store = EKEventStore()
        return store
    }()
    
    func requestCalendarPermissionIfNeeded() {
        if EKEventStore.authorizationStatus(for: .event) == .notDetermined {
            eventStore.requestAccess(to: .event) { [weak self] isGranted, error in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if isGranted {
                        self.update()
                    } else {
                        print("No calendar permission")
                    }
                }
            }
        }
    }
    
    func update() {}
}
