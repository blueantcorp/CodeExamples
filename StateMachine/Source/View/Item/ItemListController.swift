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
//	ID: 4AEAC79F-9AEA-4AE9-9CD0-D2885AB3ED69
//
//	Pkg: StateMachine
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

protocol ItemListControllerDelegate: AnyObject {
	func didFailFetching()
	func didReceiveNoData()
}

final class ItemListController: UIViewController, LoadingHandler {
	
	@IBOutlet weak var label: UILabel!
	
	weak var delegate: ItemListControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		label.isHidden = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchData()
	}
	
	private func fetchData() {
		showLoading()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
			guard let self = self else { return }
			self.hideLoading()
			self.label.isHidden = false
			self.notifyAfterWait()
		}
	}
	
	private func notifyAfterWait() {
		switch Settings.shared.state {
		case .empty: self.delegate?.didReceiveNoData()
		case .error: self.delegate?.didFailFetching()
		default: break // Do nothing, shows content
		}
	}
}
