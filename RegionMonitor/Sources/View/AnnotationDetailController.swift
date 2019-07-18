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
//	ID: 35B0088C-2D68-409C-8CCC-68EF0A7F5BD1
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit
import MapKit

let RegionAnnotationMapCellId = "RegionAnnotationMapCell"
let RegionAnnotationPropertyCellId = "RegionAnnotationPropertyCell"

let RegionAnnotationSettingsDetailSegue = "RegionAnnotationSettingsDetailSegue"

let RegionAnnotationSettingMapCell = 0
let RegionAnnotationSettingCoordinateCell = 1
let RegionAnnotationSettingRasiusCell = 2

class AnnotationDetailController: UITableViewController, MKMapViewDelegate, UITextFieldDelegate {
	
	var regionAnnotation: Annotation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = regionAnnotation?.title
	}
	
	// MARK: Private Methods
	
	func dequeueRegionAnnotationMapCell(_ indexPath: IndexPath) -> AnnotationMapCell {
		return tableView.dequeueReusableCell(withIdentifier: RegionAnnotationMapCellId, for: indexPath) as! AnnotationMapCell
	}
	
	func dequeueRegionAnnotationPropertyCell(_ indexPath: IndexPath) -> AnnotationPropertyCell {
		return tableView.dequeueReusableCell(withIdentifier: RegionAnnotationPropertyCellId, for: indexPath) as! AnnotationPropertyCell
	}
	
	func addRegionMonitoring(_ regionAnnotationMapCell: AnnotationMapCell?) {
		guard let regionAnnotation = regionAnnotation else {
			return
		}
		
		let distance = regionAnnotation.radius * 2
		let region = MKCoordinateRegion.init(center: regionAnnotation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
//		regionAnnotationMapCell?.mapView.delegate = self
//		regionAnnotationMapCell?.mapView.setRegion(region, animated: true)
//		regionAnnotationMapCell?.mapView.addAnnotation(regionAnnotation)
//		regionAnnotationMapCell?.mapView.addOverlay(MKCircle(center: regionAnnotation.coordinate, radius: regionAnnotation.radius))
	}
	
	// MARK: UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if (indexPath as NSIndexPath).row == RegionAnnotationSettingMapCell {
			return 250.0
		} else {
			return 44.0
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		switch (indexPath as NSIndexPath).row {
		case RegionAnnotationSettingMapCell:
			let regionAnnotationMapCell = dequeueRegionAnnotationMapCell(indexPath)
			addRegionMonitoring(regionAnnotationMapCell)
			cell = regionAnnotationMapCell
		case RegionAnnotationSettingCoordinateCell:
			let regionAnnotationPropertyCell = dequeueRegionAnnotationPropertyCell(indexPath)
//			regionAnnotationPropertyCell.propertyLabel.text = "Coordinate"
//			let coordinate = regionAnnotation?.coordinate
//			regionAnnotationPropertyCell.valueTextField.text = String(format: "%f, %f", coordinate!.latitude, coordinate!.longitude)
//			regionAnnotationPropertyCell.valueTextField.delegate = self
			cell = regionAnnotationPropertyCell
		case RegionAnnotationSettingRasiusCell:
			let regionAnnotationPropertyCell = dequeueRegionAnnotationPropertyCell(indexPath)
//			regionAnnotationPropertyCell.propertyLabel.text = "Radius"
//			regionAnnotationPropertyCell.valueTextField.text = String("\(regionAnnotation!.radius)")
//			regionAnnotationPropertyCell.valueTextField.delegate = self
			cell = regionAnnotationPropertyCell
		default:
			cell = UITableViewCell()
			print("Error: invalid indexPath for cellForRowAtIndexPath: \(indexPath)")
		}
		return cell
	}
	
	// MARK: MKMapViewDelegate
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKCircle {
			return AnnotationView.circleRenderer(overlay)
		}
		return MKOverlayRenderer()
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		view.calloutOffset = CGPoint(x: -1000, y: -1000)
	}
	
	// MARK: UITextFieldDelegate
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return false
	}
	
}
