//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by MinGeon Ju on 2017. 1. 19..
//  Copyright © 2017년 MinGeon Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    //struct Meme {
        //var topText:String?
        //var bottomText:String?
        //var originalImage:UIImage?
        //var memedImage:UIImage?
    //}
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -1.0]
    let bottomTextFieldDelegate = TextFieldDelegate()
    let topTextFieldDelegate = TextFieldDelegate()
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate
        
    }
    
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(_ notificaation:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
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
    @IBAction func pickAnImageFromAlbum(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = UIViewContentMode.scaleAspectFit
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func share(_ sender : UIBarButtonItem) {
        let memedImage = [generateMemedImage()]
        
        let activityViewController = UIActivityViewController(activityItems: memedImage, applicationActivities: nil)
        
        
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activityType, complete, returnedItems, activityError ) in
            if complete {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func save() {
        // Create the meme
        if imagePickerView.image != nil {
            let memedImage = generateMemedImage()
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
            // Add it to the memes array in the Application Delegate
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            
            appDelegate.memes.append(meme)
        }
        else {
            let alertView = UIAlertController(title:"이미지를 선택해주세요",message: nil,preferredStyle:UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "확인", style:UIAlertActionStyle.default){
                action in self.dismiss(animated: true, completion: nil)
            }
            alertView.addAction(okButton)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    func generateMemedImage() -> UIImage {
        navigationBar.isHidden = true
        toolBar.isHidden = true
        //dump(self.imagePickerView.frame)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.imagePickerView.frame.size)
        view.drawHierarchy(in: self.imagePickerView.bounds, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}

