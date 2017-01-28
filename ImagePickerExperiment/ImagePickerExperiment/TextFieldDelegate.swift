//
//  TextFieldDelegate.swift
//  ImagePickerExperiment
//
//  Created by MinGeon Ju on 2017. 1. 19..
//  Copyright © 2017년 MinGeon Ju. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
