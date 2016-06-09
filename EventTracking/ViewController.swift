//
//  ViewController.swift
//  EventTracking
//
//  Created by Hussain Shabbir on 6/7/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

import UIKit
import EventKit

var eventDict: [String: String]? = nil
var eventDetails: [AnyObject]? = nil

class ViewController: UIViewController {
    let eventStore = EKEventStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchEvents { (events) in
            if events.count > 0{
                eventDict = [String: String]()
                eventDetails = [AnyObject]()
            }
            for event in events{
                print("Start Date \(event.startDate)")
                print("End Date \(event.endDate)")
                if let organizerName = event.organizer?.name, let organizerEmail = event.organizer?.URL.resourceSpecifier{
                    eventDict = [kEventTitle: event.title,kOrganizerName: organizerName,kOrganizerEmail: organizerEmail]
                }
                if eventDict?.count > 0{
                    eventDetails?.append(eventDict!)
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchEvents(completed: ([EKEvent]) -> ()){
        eventStore.requestAccessToEntityType(.Event) {[weak weakEventStore = self.eventStore] granted,error in
            if let eventStore = weakEventStore {
                let dateComponent = NSDateComponents()
                let calendar = NSCalendar.currentCalendar()
                dateComponent.day = -1
                let startDate = calendar.dateByAddingComponents(dateComponent, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
                let endDate = NSDate(timeIntervalSinceNow: 604800*1);   //This is 10 weeks in seconds
                let predicate = eventStore.predicateForEventsWithStartDate(startDate!, endDate: endDate, calendars: nil)
                let events = self.eventStore.eventsMatchingPredicate(predicate)
                completed(events)
            }
        }
    }
}

