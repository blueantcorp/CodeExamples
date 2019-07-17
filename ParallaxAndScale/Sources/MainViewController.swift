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
//	ID: A6469E4D-134A-4282-B9A1-901AA52A0256
//
//	Pkg: ParallaxAndScale
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

// MARK: - Constants
struct Constants {
	static fileprivate let headerHeight: CGFloat = 210
}

// MARK: - MainViewController
class MainViewController: UIViewController {
	
	// Properties
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.delegate = self
		scrollView.alwaysBounceVertical = true
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	
	private lazy var label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .white
		let titleFont = UIFont.preferredFont(forTextStyle: .title1)
		if let boldDescriptor = titleFont.fontDescriptor.withSymbolicTraits(.traitBold) {
			label.font = UIFont(descriptor: boldDescriptor, size: 0)
		} else {
			label.font = titleFont
		}
		label.textAlignment = .center
		label.adjustsFontForContentSizeCategory = true
		label.text = "Your content here"
		return label
	}()
	
	private var headerContainerView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private var headerImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		if let image = UIImage(named: "Coffee") {
			imageView.image = image
		}
		imageView.clipsToBounds = true
		return imageView
	}()
	
	
	private var headerTopConstraint: NSLayoutConstraint!
	private var headerHeightConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		headerContainerView.addSubview(headerImageView)
		scrollView.addSubview(headerContainerView)
		scrollView.addSubview(label)
		view.addSubview(scrollView)
		
		arrangeConstraints()
	}
}

// MARK: - UI Setup
private extension MainViewController {
	func setupView() {
		
	}
}

// MARK: - UI Helpers
private extension MainViewController {
	
	func arrangeConstraints() {
		let scrollViewConstraints: [NSLayoutConstraint] = [
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		]
		NSLayoutConstraint.activate(scrollViewConstraints)
		
		headerTopConstraint = headerContainerView.topAnchor.constraint(equalTo: view.topAnchor)
		headerHeightConstraint = headerContainerView.heightAnchor.constraint(equalToConstant: 210)
		let headerContainerViewConstraints: [NSLayoutConstraint] = [
			headerTopConstraint,
			headerContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
			headerHeightConstraint
		]
		NSLayoutConstraint.activate(headerContainerViewConstraints)
		
		let headerImageViewConstraints: [NSLayoutConstraint] = [
			headerImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
			headerImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
			headerImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
			headerImageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
		]
		NSLayoutConstraint.activate(headerImageViewConstraints)
		
		let labelConstraints: [NSLayoutConstraint] = [
			label.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
			label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
			label.heightAnchor.constraint(equalToConstant: 800)
		]
		NSLayoutConstraint.activate(labelConstraints)
	}
}

// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y < 0.0 {
			headerHeightConstraint?.constant = Constants.headerHeight - scrollView.contentOffset.y
		} else {
			let parallaxFactor: CGFloat = 0.25
			let offsetY = scrollView.contentOffset.y * parallaxFactor
			let minOffsetY: CGFloat = 8.0
			let availableOffset = min(offsetY, minOffsetY)
			let contentRectOffsetY = availableOffset / Constants.headerHeight
			
			headerTopConstraint?.constant = view.frame.origin.y
			headerHeightConstraint?.constant = Constants.headerHeight - scrollView.contentOffset.y
			headerImageView.layer.contentsRect = CGRect(x: 0, y: -contentRectOffsetY, width: 1, height: 1)
		}
	}
}
