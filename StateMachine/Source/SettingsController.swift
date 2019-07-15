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
//	ID: 9F531C97-4F7E-41B9-8650-70D0EC690995
//
//	Pkg: StateMachine
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

class SettingsController: UIViewController {
	
	@IBOutlet weak var afterRetrySegmentedControl: UISegmentedControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Settings"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		Settings.shared.reset()
	}
	
	@IBAction func stateAfterLoadingValueChanged(sender: UISegmentedControl) {
		guard let newState = State(rawValue: sender.selectedSegmentIndex) else {
			return
		}
		
		Settings.shared.stateAfterLoading = newState
		
		if case .error = newState {
			afterRetrySegmentedControl.isEnabled = true
		} else {
			afterRetrySegmentedControl.isEnabled = false
		}
	}
	
	@IBAction func stateAfterRetryValueChanged(sender: UISegmentedControl) {
		guard let newState = State(rawValue: sender.selectedSegmentIndex) else {
			return
		}
		
		Settings.shared.stateAfterRetry = newState
	}
	
	@IBAction func doContinue() {
		let stateProvider = ItemStateProvider()
		let stateContainerViewController = StateController(stateProvider: stateProvider)
		show(stateContainerViewController, sender: self)
	}
}

