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

	var soundFilename: String { get set }

}

struct Cow: Object {
	
	var displayPluralName: String = "cows"

	var imageName: String = "cows.svg"

	var quantity: Int = 2

	var backgroundColor: UIColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

	var buttonColor: UIColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)

	var attributionText: String? = nil

	var soundFilename: String = ""
	
}
