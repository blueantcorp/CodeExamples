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
//	ID: 99640DC8-C3A4-412A-9692-2C3E7F26E23E
//
//	Pkg: StateMachine
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

enum State: Int {
	case content
	case error
	case empty
}

class StateContainerController: UIViewController, StateChanger {
	
	private let stateProvider: StateProvider
	private var currentState: State?
	
	/// Object initialization
	init(stateProvider: StateProvider) {
		self.stateProvider = stateProvider
		
		super.init(nibName: nil, bundle: nil)
		
		self.stateProvider.stateChanger = self
		self.title = self.stateProvider.title
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// UIViewController lifecycle
	override public func viewDidLoad() {
		super.viewDidLoad()
		changeTo(state: stateProvider.initialState)
	}
	
	/// State management
	func changeTo(state: State) {
		guard currentState != state else {
			return
		}
		
		currentState = state
		
		switch state {
		case .content:
			removePreviousChildAndAdd(viewController: stateProvider.contentViewController())
		case .error:
			removePreviousChildAndAdd(viewController: stateProvider.errorViewController())
		case .empty:
			removePreviousChildAndAdd(viewController: stateProvider.emptyViewController())
		}
	}
}
