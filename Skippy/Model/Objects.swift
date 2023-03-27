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

	var soundRate: Float { get }

}

struct Cow: Object {

	
	var name: String = "cows"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "moo.caf"

	var soundRate: Float = 1
	
}

struct Elephant: Object {

	var name: String = "elephants"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "elephantTrumpet.caf"

	var soundRate: Float = 1

}

struct Car: Object {

	var name: String = "cars"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "carHorn.caf"

	var soundRate: Float = 1

}

struct Airplane: Object {

	var name: String = "airplanes"

	var quantity: Int = 5

	var attributionText: String? = nil

	var soundFilename: String = "airplane.caf"

	var soundRate: Float = 2.5

}

struct Bear: Object {

	var name: String = "bears"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "bear.caf"

	var soundRate: Float = 1.5

}

struct Monkey: Object {

	var name: String = "monkeys"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "monkey.caf"

	var soundRate: Float = 1.5

}

struct Robot: Object {

	var name: String = "robots"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "robot.caf"

	var soundRate: Float = 1.5

}
