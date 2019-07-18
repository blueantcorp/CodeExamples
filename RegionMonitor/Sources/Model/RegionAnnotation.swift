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
//	ID: 876C0A3F-560B-4A0B-BE6C-8879F04F7A38
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation
import MapKit

let RegionAnnotationCoordinateKey = "RegionAnnotationCoordinate"
let RegionAnnotationRadiusKey = "RegionAnnotationRadius"
let RegionAnnotationTitleKey = "RegionAnnotationTitle"
let RegionAnnotationSubtitleKey = "RegionAnnotationSubtitle"
let RegionAnnotationOnEntryMessageKey = "RegionAnnotationOnEntryMessage"
let RegionAnnotationOnExitMessageKey = "RegionAnnotationOnExitMessage"

let RegionAnnotationRadiusDefault = 1000.0

enum RegionAnnotationEvent: Int {
	case entry
	case exit
}

class RegionAnnotation: NSObject, MKAnnotation, NSCoding {
	
	let coordinate: CLLocationCoordinate2D
	let radius: CLLocationDistance
	let title: String?
	let subtitle: String?
	let onEntryMessage: String
	let onExitMessage: String
	
	// MARK: Getters
	var region: CLCircularRegion {
		return CLCircularRegion(center: coordinate, radius: radius, identifier: identifier)
	}
	
	var identifier: String {
		return String(format: "C: %f, %f - R: %f", coordinate.latitude, coordinate.longitude, radius)
	}
	
	init(region: CLCircularRegion) {
		coordinate = region.center
		radius = region.radius
		title = NSLocalizedString("Monitored Region", comment: "Monitored Region")
		subtitle = String(format: "C: %.3f, %.3f - R: %.3f", coordinate.latitude, coordinate.longitude, radius)
		onEntryMessage = NSLocalizedString("Monitored region entry", comment: "Monitored region entry")
		onExitMessage = NSLocalizedString("Monitored region exit", comment: "Monitored region exit")
	}
	
	// MARK: NSCoding
	required init?(coder decoder: NSCoder) {
		let location = decoder.decodeObject(forKey: RegionAnnotationCoordinateKey) as! CLLocation
		coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
		radius = decoder.decodeDouble(forKey: RegionAnnotationRadiusKey)
		title = decoder.decodeObject(forKey: RegionAnnotationTitleKey) as? String
		subtitle = decoder.decodeObject(forKey: RegionAnnotationSubtitleKey) as? String
		onEntryMessage = decoder.decodeObject(forKey: RegionAnnotationOnEntryMessageKey) as! String
		onExitMessage = decoder.decodeObject(forKey: RegionAnnotationOnExitMessageKey) as! String
	}
	
	func encode(with coder: NSCoder) {
		let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
		coder.encode(location, forKey: RegionAnnotationCoordinateKey)
		coder.encode(radius, forKey: RegionAnnotationRadiusKey)
		coder.encode(title, forKey: RegionAnnotationTitleKey)
		coder.encode(subtitle, forKey: RegionAnnotationSubtitleKey)
		coder.encode(onEntryMessage, forKey: RegionAnnotationOnEntryMessageKey)
		coder.encode(onExitMessage, forKey: RegionAnnotationOnExitMessageKey)
	}
	
	// MARK: Public Methods
	func notificationMessageForEvent(_ annotationEvent: RegionAnnotationEvent) -> String? {
		switch annotationEvent {
		case .entry: return onEntryMessage
		case .exit: return onExitMessage
		}
	}
}
