//	MIT License
//
//	Copyright © 2019 Emile, Blue Ant Corp
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
//	ID: A19E0D7C-B1AA-466E-A0FC-13EE2204AFCE
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation
import UIKit

let RegionNotificationEventKey = "RegionNotificationEvent"
let RegionNotificationTimestampKey = "RegionNotificationTimestamp"
let RegionNotificationMessageKey = "RegionNotificationMessage"
let RegionNotificationAppStatusKey = "RegionNotificationAppStatus"

class RegionNotification: NSObject, NSCoding {
	
	let timestamp: Date
	let event: RegionAnnotationEvent
	let message: String
	let appStatus: UIApplication.State
	
	init(timestamp: Date, event: RegionAnnotationEvent, message: String, appStatus: UIApplication.State) {
		self.timestamp = timestamp
		self.event = event
		self.message = message
		self.appStatus = appStatus
	}
	
	override var description: String {
		return "Timestamp=\(displayTimestamp()), Event=\(displayEvent()), Message=\(message), App Status=\(displayAppStatus())"
	}
	
	// MARK: NSCoding
	
	required init?(coder decoder: NSCoder) {
		timestamp = decoder.decodeObject(forKey: RegionNotificationTimestampKey) as! Date
		event = RegionAnnotationEvent(rawValue: decoder.decodeInteger(forKey: RegionNotificationEventKey))!
		message = decoder.decodeObject(forKey: RegionNotificationMessageKey) as! String
		appStatus = UIApplication.State(rawValue: decoder.decodeInteger(forKey: RegionNotificationAppStatusKey))!
	}
	
	func encode(with coder: NSCoder) {
		coder.encode(timestamp, forKey: RegionNotificationTimestampKey)
		coder.encode(event.rawValue, forKey: RegionNotificationEventKey)
		coder.encode(message, forKey: RegionNotificationMessageKey)
		coder.encode(appStatus.rawValue, forKey: RegionNotificationAppStatusKey)
	}
	
	// MARK: Utility Methods
	
	func displayTimestamp() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = DateFormatter.Style.short
		dateFormatter.timeStyle = DateFormatter.Style.short
		return dateFormatter.string(from: timestamp)
	}
	
	func displayEvent() -> String {
		switch event {
		case .entry:
			return "Entry"
		case .exit:
			return "Exit"
		}
	}
	
	func displayAppStatus() -> String {
		switch appStatus {
		case .active:
			return "Active"
		case .inactive:
			return "Inactive"
		case .background:
			return "Background"
		@unknown default:
			fatalError("Unknown app state")
		}
	}
}
