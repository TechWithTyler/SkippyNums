//
//  Object.swift
//  Skippy
//
//  Created by TechWithTyler on 2/13/23.
//

import UIKit

protocol Object {

	var name: String { get }

	var quantity: Int { get }

	var attributionText: String? { get }

	var soundFilename: String { get }

}

struct Cow: Object {
	
	var name: String = "cows"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "moo.caf"
	
}

struct Elephant: Object {

	var name: String = "elephants"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "elephantTrumpet.caf"

}

struct Car: Object {

	var name: String = "cars"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "carHorn.caf"

}

struct Airplane: Object {

	var name: String = "airplanes"

	var quantity: Int = 5

	var attributionText: String? = nil

	var soundFilename: String = "airplane.caf"

}

struct Bear: Object {

	var name: String = "bears"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "bear.caf"

}

struct Monkey: Object {

	var name: String = "monkeys"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "monkey.caf"

}

struct Robot: Object {

	var name: String = "robots"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "robot.caf"

}
