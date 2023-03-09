//
//  Object.swift
//  Skipy
//
//  Created by Tyler Sheft on 2/13/23.
//

import UIKit

protocol Object {

	var displayPluralName: String { get }

	var imageName: String { get }

	var backgroundColor: UIColor { get }

	var buttonColor: UIColor { get }

	var quantity: Int { get }

	var attributionText: String? { get }

	var soundFilename: String { get }

}

struct Cow: Object {
	
	var displayPluralName: String = "cows"

	var imageName: String = "cows.svg"

	var quantity: Int = 2

	var backgroundColor: UIColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

	var buttonColor: UIColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)

	var attributionText: String? = nil

	var soundFilename: String = "moo.caf"
	
}

struct Elephant: Object {

	var displayPluralName: String = "elephants"

	var imageName: String = "elephants.svg"

	var quantity: Int = 2

	var backgroundColor: UIColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)

	var buttonColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

	var attributionText: String? = nil

	var soundFilename: String = "elephantTrumpet.caf"

}
