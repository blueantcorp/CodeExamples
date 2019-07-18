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
//	ID: 5485B621-8513-4E31-B12F-C014AA57189B
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	fileprivate var isInitialCurrentLocation = true
	fileprivate let locationManager = CLLocationManager()
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var locationButton: UIBarButtonItem!
	@IBOutlet weak var addButton: UIBarButtonItem!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		locationManager.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Map", comment: "Map")
		locationButton.isEnabled = false;
		addButton.isEnabled = false;
		
		requestLocationPermissions(locationManager)
		setupMapView()
		for annotation in AnnotationStore.shared.storedItems {
			addRegionMonitoring(annotation, shouldUpdate: false)
		}
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(MapController.regionAnnotationItemsDidChange(_:)),
											   name: NSNotification.Name(rawValue: RegionAnnotationItemsDidChangeNotification),
											   object: nil)
	}
	
	// MARK: Private Methods
	
	func requestLocationPermissions(_ locationManager: CLLocationManager) {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestAlwaysAuthorization()
		}
	}
	
	func setupMapView() {
		mapView.delegate = self
		mapView.showsUserLocation = false
	}
	
	func regionAnnotationForCurrentLocation() -> Annotation {
		let identifier = String(format: "%f, %f", mapView.region.center.latitude, mapView.region.center.longitude)
		let region = CLCircularRegion(center: mapView.region.center, radius: RegionAnnotationRadiusDefault, identifier: identifier)
		return Annotation(region: region)
	}
	
	func addRegionMonitoring(_ regionAnnotation: Annotation, shouldUpdate: Bool) {
		mapView.addAnnotation(regionAnnotation)
		startMonitoringGeotification(regionAnnotation)
		if shouldUpdate {
			AnnotationStore.shared.addStoredItem(regionAnnotation)
		}
	}
	
	func removeRegionMonitoring(_ regionAnnotation: Annotation) {
		mapView.removeAnnotation(regionAnnotation)
		locationManager.stopMonitoring(for: regionAnnotation.region)
		AnnotationStore.shared.removeStoredItem(regionAnnotation)
	}
	
	func startMonitoringGeotification(_ regionAnnotation: Annotation) {
		if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
			showRegionMonitoringNotAvailableAlert()
			return
		}
		if CLLocationManager.authorizationStatus() != .authorizedAlways {
			showLocationPermissionsNotGrantedAlert()
		}
		locationManager.startMonitoring(for: regionAnnotation.region)
	}
	
	func addRegionNotification(_ timestamp: Date, event: RegionAnnotationEvent, message: String, appStatus: UIApplication.State) {
		let notification = RegionNotification(timestamp: timestamp, event: event, message: message, appStatus: appStatus)
		print("Region Monitoring: \(notification.description)")
		NotificationStore.shared.addStoredItem(notification)
	}
	
	func handleRegionEvent(_ region: CLRegion, regionAnnotationEvent: RegionAnnotationEvent) {
		if let regionAnnotation = AnnotationStore.annotationForRegionIdentifier(region.identifier),
			let message = regionAnnotation.notificationMessageForEvent(regionAnnotationEvent), !message.isEmpty {
			let appStatus = UIApplication.shared.applicationState
			addRegionNotification(Date(), event: regionAnnotationEvent, message: message, appStatus: appStatus)
			if appStatus != .active {
				let notification = UILocalNotification()
				notification.alertBody = message
				notification.soundName = "Default";
				UIApplication.shared.presentLocalNotificationNow(notification)
			}
		}
	}
	
	func showLocationPermissionsNotGrantedAlert() {
		UIAlertController.showSimpleAlert(self,
										  title: NSLocalizedString("Error", comment: "Error"),
										  message: NSLocalizedString("Location Permission has not been granted",
																	 comment: "Location Permission has not been granted"))
	}
	
	func showRegionMonitoringNotAvailableAlert() {
		UIAlertController.showSimpleAlert(self,
										  title: NSLocalizedString("Error", comment: "Error"),
										  message: NSLocalizedString("Region Monitoring is not available",
																	 comment: "Region Monitoring is not available"))
	}
	
	func zoomToMapLocation(_ coordinate: CLLocationCoordinate2D?) {
		if coordinate != nil {
			let distance = RegionAnnotationRadiusDefault * 2
			let region = MKCoordinateRegion.init(center: coordinate!, latitudinalMeters: distance, longitudinalMeters: distance)
			mapView.setRegion(region, animated: true)
		}
	}
	
	
}

// MARK: - NSNotificationCenter Events
extension MapController {
	@objc func regionAnnotationItemsDidChange(_ notification: Notification) {
		// ... refresh
	}
}

// MARK: - Segues
extension MapController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == RegionAnnotationSettingsDetailSegue {
			let regionAnnotation = sender as? Annotation
			let regionAnnotationSettingsDetailVC = segue.destination as? AnnotationDetailController
			regionAnnotationSettingsDetailVC?.regionAnnotation = regionAnnotation
		}
	}
}

// MARK: - Actions
extension MapController {
	@IBAction func addButtonTapped(_ sender: AnyObject) {
		if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
			addRegionMonitoring(regionAnnotationForCurrentLocation(), shouldUpdate: true)
		} else  {
			showRegionMonitoringNotAvailableAlert()
		}
	}
	
	@IBAction func locationButtonTapped(_ sender: AnyObject) {
		zoomToMapLocation(mapView.userLocation.location?.coordinate)
	}
}

// MARK: - CLLocationManagerDelegate
extension MapController {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		mapView.showsUserLocation = (status == .authorizedAlways)
	}
	
	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		if region is CLCircularRegion {
			handleRegionEvent(region, regionAnnotationEvent: RegionAnnotationEvent.entry)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		if region is CLCircularRegion {
			handleRegionEvent(region, regionAnnotationEvent: RegionAnnotationEvent.exit)
		}
	}
}

// MARK: MKMapViewDelegate
extension MapController {
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		if isInitialCurrentLocation {
			zoomToMapLocation(userLocation.coordinate)
			isInitialCurrentLocation = false
			let delay = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
			DispatchQueue.main.asyncAfter(deadline: delay) {
				self.locationButton.isEnabled = true;
				self.addButton.isEnabled = true;
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let regionAnnotation = annotation as? Annotation,
			let title = regionAnnotation.title {
			var regionView = mapView.dequeueReusableAnnotationView(withIdentifier: title) as? AnnotationView
			if regionView == nil {
				regionView = AnnotationView(annotation: regionAnnotation, reuseIdentifier: title)
			} else {
				regionView!.annotation = annotation;
			}
			regionView!.addRadiusOverlay(mapView)
			return regionView;
		}
		return nil
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKCircle {
			return AnnotationView.circleRenderer(overlay)
		}
		return MKOverlayRenderer()
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if view is AnnotationView {
			let regionAnnotation = view.annotation as? Annotation;
			if control.tag == RegionAnnotationViewDetailsButtonTag {
				performSegue(withIdentifier: RegionAnnotationSettingsDetailSegue, sender: regionAnnotation)
			} else if control.tag == RegionAnnotationViewRemoveButtonTag {
			}
		}
	}
}
