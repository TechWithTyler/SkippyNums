//
//  Object.swift
//  Skipy
//
//  Created by Tyler Sheft on 2/13/23.
//

import UIKit

protocol Object {

	var displayPluralName: String { get set }

	var imageName: String { get set }

	var backgroundColor: UIColor { get set }

	var buttonColor: UIColor { get set }

	var quantity: Int { get set }

	var attributionText: String? { get set }

}

struct Cherry: Object {
	
	var displayPluralName: String = "cherries"

	var imageName: String = "cherries.svg"

	var quantity: Int = 2

	var backgroundColor: UIColor = UIColor(red: 0.65, green: 0, blue: 0, alpha: 1)

	var buttonColor: UIColor = UIColor(red: 0, green: 0.75, blue: 0, alpha: 1)

	var attributionText: String? = nil

}
