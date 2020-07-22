//
//  ViewController.swift
//  DidScrollTest
//
//  Created by Don Mag on 7/22/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var happyOutlet: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.delegate = self
		self.happyOutlet.imageView?.tintColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		print("content offset x:", scrollView.contentOffset.x)
		
		// if we've scrolled left more than 50 points
		if scrollView.contentOffset.x > 50 {
			print("greater than 50")
			happyOutlet.imageView?.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
		}
		else {
			print("less than 51")
			happyOutlet.imageView?.tintColor = #colorLiteral(red: 0.9294117647, green: 0.4705882353, blue: 0.07450980392, alpha: 1)
		}
		
	}

	@IBAction func happy(_ sender: Any) {
		// to change button image tintColor in response to touchUpInside,
		//	we have to set it after the built-in animation has finished
		DispatchQueue.main.async {
			self.happyOutlet.imageView?.tintColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
		}
	}
}

