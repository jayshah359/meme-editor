//
//  MemeStructModel.swift
//  MemeEditor
//
//  Created by Jaydev Shah on 3/19/18.
//  Copyright © 2018 Jaydev Shah. All rights reserved.
//

import Foundation
import UIKit

// Struct to store meme when using save function and future functionality
struct MemeModel {
	let topText: String
	let bottomText: String
	let originalImage: UIImage
	let memedImage: UIImage
}
