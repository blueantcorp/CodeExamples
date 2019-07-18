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
//	ID: 1095BB0B-04F2-4193-A1A3-808C54E2C87B
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation
import MapKit

let RegionAnnotationViewRemoveButtonTag = 1001
let RegionAnnotationViewDetailsButtonTag = 1002

class AnnotationView: MKPinAnnotationView {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(annotation: nil, reuseIdentifier: nil)
		setupPin()
	}
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		setupPin()
	}
	
	// MARK: Static Methods
	
	class func circleRenderer(_ overlay: MKOverlay) -> MKCircleRenderer {
		let circleRenderer = MKCircleRenderer(overlay: overlay)
		circleRenderer.lineWidth = 1.0
		circleRenderer.strokeColor = UIColor.blue
		circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.4)
		return circleRenderer
	}
	
	// MARK: Private Methods
	
	fileprivate func setupPin() {
		pinTintColor = MKPinAnnotationView.redPinColor()
		animatesDrop = true
		canShowCallout = true
		let removeButton : UIButton = UIButton(type: UIButton.ButtonType.custom)
		removeButton.tag = RegionAnnotationViewRemoveButtonTag
		removeButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
		removeButton.setImage(UIImage(named: "close-icon"), for: UIControl.State())
		leftCalloutAccessoryView =  removeButton
		let detailButton : UIButton = UIButton(type: UIButton.ButtonType.detailDisclosure)
		detailButton.tag = RegionAnnotationViewDetailsButtonTag
		rightCalloutAccessoryView = detailButton
	}
	
	// MARK: Public Methods
	
	func addRadiusOverlay(_ mapView: MKMapView?) {
		let regionAnnotation = annotation as! Annotation
		mapView?.addOverlay(MKCircle(center: regionAnnotation.coordinate, radius: regionAnnotation.radius))
	}
	
	func removeRadiusOverlay(_ mapView: MKMapView?) {
		if let overlays = mapView?.overlays {
			for overlay in overlays {
				if let circleOverlay = overlay as? MKCircle {
					let coord = circleOverlay.coordinate
					let regionAnnotation = annotation as! Annotation
					if coord.latitude == regionAnnotation.coordinate.latitude &&
						coord.longitude == regionAnnotation.coordinate.longitude &&
						circleOverlay.radius == regionAnnotation.radius {
						mapView?.removeOverlay(circleOverlay)
						break
					}
				}
			}
		}
	}	
}
