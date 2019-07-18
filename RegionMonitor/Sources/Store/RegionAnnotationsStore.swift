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
//	ID: F445E342-DDE5-48D2-8FAC-8EBB1C062CDD
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation

let RegionAnnotationItemsKey = "RegionAnnotationItems"
let RegionAnnotationItemsDidChangeNotification = "RegionAnnotationItemsDidChangeNotification"

class RegionAnnotationsStore {
	
	// MARK: Singleton
	
	static let sharedInstance = GenericStore<RegionAnnotation>(storeItemsKey: RegionAnnotationItemsKey, storeItemsDidChangeNotification: RegionAnnotationItemsDidChangeNotification)
	
	class func annotationForRegionIdentifier(_ identifier: String) -> RegionAnnotation? {
		for annotation in RegionAnnotationsStore.sharedInstance.storedItems {
			if annotation.identifier == identifier {
				return annotation
			}
		}
		return nil
	}
	
}
