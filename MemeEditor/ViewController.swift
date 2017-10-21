//
//  ViewController.swift
//  MemeEditor
//
//  Created by Jaydev Shah on 10/5/17.
//  Copyright © 2017 Jaydev Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	@IBOutlet weak var memeImage: UIImageView!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!

	struct Meme {
		let topText: String
		let bottomText: String
		let originalImage: UIImage
		let memedImage: UIImage
	}
	
	var meme: Meme?
	
	let memeTextAttributes:[String:Any] = [
		NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
		NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
		NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSAttributedStringKey.strokeWidth.rawValue: -3.0]
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			memeImage.image = image
			shareButton.isEnabled = true
		}
		dismiss(animated: true, completion: nil)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.text == "TOP" || textField.text == "BOTTOM" {
			textField.text = ""
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		topTextField.text = "TOP"
		topTextField.defaultTextAttributes = memeTextAttributes
		topTextField.textAlignment = .center
		
		bottomTextField.text = "BOTTOM"
		bottomTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.textAlignment = .center
		
		topTextField.delegate = self
		bottomTextField.delegate = self
		
		shareButton.isEnabled = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		subscribeToKeyboardNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		unsubscribeFromKeyboardNotifications()
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		view.frame.origin.y -= getKeyboardHeight(notification)
	}
	
	@objc func keyboardWillHide(_ notifcation: Notification) {
		view.frame.origin.y = 0
	}
	
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}
	
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}
	
	@IBAction func pickImage(_ sender: Any) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .photoLibrary
		present(pickerController, animated: true, completion: nil)
	}
	
	@IBAction func pickImageFromCamera(_ sender: Any) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .camera
		present(pickerController, animated: true, completion: nil)
	}
	
	@IBAction func shareMeme(_ sender: Any) {
		let memedImage = generateMemedImage()
		let images: [UIImage] = [memedImage]
		let shareViewController = UIActivityViewController(activityItems: images, applicationActivities: nil)
		present(shareViewController, animated: true) {
			self.meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.memeImage.image!, memedImage: memedImage)
		}
	}
	
	@IBAction func cancelMeme(_ sender: Any) {
		memeImage.image = nil
		shareButton.isEnabled = false
		topTextField.text = "TOP"
		bottomTextField.text = "BOTTOM"
	}
	
	func generateMemedImage() -> UIImage {
		
		// TODO: Hide toolbar and navbar
		
		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		// TODO: Show toolbar and navbar
		
		return memedImage
	}
}

