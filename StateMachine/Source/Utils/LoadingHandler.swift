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
//	ID: 66532E5E-2813-4BCA-B5F9-CBAF1E337E69
//
//	Pkg: StateMachine
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

protocol LoadingHandler where Self: UIViewController {
	func showLoading()
	func hideLoading()
}

extension LoadingHandler {
	func showLoading() {
		let indicator = makeActivityIndicator()
		view.addSubview(indicator)
		
		NSLayoutConstraint.activate([
			indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			])
	}
	
	func hideLoading() {
		guard let indicator = view.viewWithTag(indicatorViewTag) else {
			return
		}
		
		indicator.removeFromSuperview()
	}
	
	private func makeActivityIndicator() -> UIActivityIndicatorView {
		if let indicator = view.viewWithTag(indicatorViewTag) as? UIActivityIndicatorView {
			return indicator
		}
		
		let indicator = UIActivityIndicatorView(style: .gray)
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.tag = indicatorViewTag
		indicator.startAnimating()
		return indicator
	}
}

private let indicatorViewTag = 123456
