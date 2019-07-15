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
//	ID: 0DB2FF72-11D5-4810-8AA3-3B44A085A961
//
//	Pkg: StateMachine
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

extension UIViewController {
	func addChild(viewController: UIViewController) {
		viewController.willMove(toParent: self)
		viewController.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(viewController.view)
		
		NSLayoutConstraint.activate([
			viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
			viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			])
		
		addChild(viewController)
		viewController.didMove(toParent: self)
	}
	
	func removeChild(viewController: UIViewController) {
		viewController.willMove(toParent: nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParent()
		viewController.didMove(toParent: nil)
	}
	
	func removeAllChildViewControllers() {
		children.forEach({ removeChild(viewController: $0) })
	}
	
	func removePreviousChildAndAdd(viewController: UIViewController?) {
		guard let viewController = viewController else {
			return
		}
		
		removeAllChildViewControllers()
		addChild(viewController: viewController)
	}
}
