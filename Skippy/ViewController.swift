//
//  ViewController.swift
//  Skipy
//
//  Created by Tyler Sheft on 2/13/23.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var questionLabel: UILabel!

	@IBOutlet weak var objectImageView: UIImageView!

	@IBOutlet weak var choice1Button: UIButton!

	@IBOutlet weak var choice2Button: UIButton!

	@IBOutlet weak var choice3Button: UIButton!

	@IBOutlet weak var choice4Button: UIButton!

	var objects: [Object] = [Cherry()]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

	}

	@IBAction func answerSelected(_ sender: UIButton) {
		
	}

	func showGroupsOfObjects(object: Object, groups: Int) {
		guard let image = UIImage(named: object.imageName) else { return }

		for i in 1...groups {
			let newImageView = UIImageView(image: image)
			newImageView.frame = CGRect(x: CGFloat(i) * (image.size.width + 10), y: 0, width: image.size.width, height: image.size.height)
			objectImageView.addSubview(newImageView)
		}

		func clearImageView() {
			for view in objectImageView.subviews {
				view.removeFromSuperview()
			}
		}

	}


}

