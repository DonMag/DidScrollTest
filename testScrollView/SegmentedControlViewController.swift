//
//  SegmentedControlViewController.swift
//  testScrollView
//
//  Created by Christian Badenhausen on 7/22/20.
//  Copyright © 2020 Christian Badenhausen. All rights reserved.
//


import UIKit

// MARK: custom protocol
protocol SubScrollDelegate: class {
	func didScroll(_ idx: Int)
}

// MARK: "sub controller" containing the scroll view
class SubScrollViewViewController: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet var myContentView: UIView!
	@IBOutlet var labelsStackView: UIStackView!
	
	var animating: Bool = false
	
	var myDelegate: SubScrollDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.delegate = self
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// don't do this if the parent controller told us to scroll to a label
		if !animating {
			// 8-pts padding on each side of each label
			let halfOneSectionWidth = (labelsStackView.arrangedSubviews[0].frame.width + 16) * 0.5
			// get percentage scrolled
			let pct = (scrollView.contentOffset.x + halfOneSectionWidth) / scrollView.contentSize.width
			// convert to index based on number of "sections"
			//	with max of labelsStackView.arrangedSubviews.count - 1
			let idx = min(Int(pct * CGFloat(labelsStackView.arrangedSubviews.count)), labelsStackView.arrangedSubviews.count - 1)
			// tell the delegate we scrolled
			myDelegate?.didScroll(idx)
		}
	}

	func showLabel(_ idx: Int) -> Void {
		// a button was tapped, so animate the corrosponding label into view
		guard idx < labelsStackView.arrangedSubviews.count else {
			return
		}
		// get a reference to the label
		let v = labelsStackView.arrangedSubviews[idx]
		// convert its frame to myContentView coordinate space
		let r = labelsStackView.convert(v.frame.origin, to: myContentView)
		// we don't want "didScroll" messages sent while we're animating the scroll view
		animating = true
		UIView.animate(withDuration: 0.3, animations: {
			self.scrollView.contentOffset.x = r.x - self.labelsStackView.spacing * 0.5
		}, completion: { finished in
			self.animating = false
		})
	}
}

// MARK: main controller
class SegmentedControlViewController: UIViewController, SubScrollDelegate {

    @IBOutlet weak var happyOutlet: UIButton!
    
    @IBOutlet weak var sadOutlet: UIButton!
    
    @IBOutlet weak var lolOutlet: UIButton!
    
    @IBOutlet weak var suprisedOutlet: UIButton!
    
    @IBOutlet weak var angryOutlet: UIButton!
    
    @IBOutlet weak var fireOutlet: UIButton!
    
    @IBOutlet weak var happyView: UIView!
    
    @IBOutlet weak var sadView: UIView!
    
    @IBOutlet weak var testt: UILabel!
    
	// reference to "sub scrollview" controller
	var subScrollViewController: SubScrollViewViewController!

	// we'll store the outlet buttons in an array for easy access
	var outletButtons: [UIButton] = []
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		// get a reference to the SubScrollViewViewController
		if let vc = segue.destination as? SubScrollViewViewController {
			subScrollViewController = vc
		}
		
	}
	
	// our custom SubScrollDelegate function
	func didScroll(_ idx: Int) {
		// this is called by the sub scroll controller, so
		// update the outlet buttons, but Don't tell the sub scroll view to scroll
		updateOutletButtons(outletButtons[idx], doScroll: false)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()

		// make sure we got a reference to the embedded UIContainrView controller
		guard subScrollViewController != nil else {
			// trigger fatal error if this was not initialized
			fatalError("SubScrollViewController not loaded by container view!")
		}

		// set our custom delegate in subScrollViewController
		subScrollViewController.myDelegate = self
		
		happyView.alpha = 1
        sadView.alpha = 0

		// array of outlet buttons
		outletButtons = [happyOutlet, sadOutlet, lolOutlet, suprisedOutlet, angryOutlet, fireOutlet]
    }
    
	func updateOutletButtons(_ btn: UIButton, doScroll: Bool = true) -> Void {
		// UIButton has built-in fade effect
		// to change the tint color on touchUpInside,
		// we have to delay it
		DispatchQueue.main.async {
			self.outletButtons.forEach {
				$0.imageView?.tintColor = #colorLiteral(red: 0.7472794652, green: 0.7472972274, blue: 0.7472876906, alpha: 1)
			}
			btn.imageView?.tintColor = #colorLiteral(red: 0.9294117647, green: 0.4705882353, blue: 0.07450980392, alpha: 1)
			if doScroll {
				self.updateScroll(btn)
			}
		}
	}
	
	func updateScroll(_ btn: UIButton) -> Void {
		// tell the "sub scrollview" controller to show the label
		if let idx = outletButtons.firstIndex(of: btn) {
			subScrollViewController.showLabel(idx)
		}
	}
	
    @IBAction func happy(_ sender: UIButton) {
		updateOutletButtons(sender)
    }
    
    @IBAction func sad(_ sender: UIButton) {
		updateOutletButtons(sender)
    }
    
    @IBAction func lol(_ sender: UIButton) {
		updateOutletButtons(sender)
    }
    
    @IBAction func suprised(_ sender: UIButton) {
		updateOutletButtons(sender)
    }
    
    @IBAction func angry(_ sender: UIButton) {
		updateOutletButtons(sender)
    }
    
    @IBAction func fire(_ sender: UIButton) {
		updateOutletButtons(sender)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let vc = UIAlertController(title: "Please Note", message: "This is Example Code only. It should not be considered \"Production Ready\"!", preferredStyle: .alert)
		vc.addAction(UIAlertAction(title: "OK", style: .default))
		present(vc, animated: true, completion: nil)
	}
	
}


