//
//  ViewController.swift
//  test
//
//  Created by user240111 on 9/21/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var country: UITextField!
    @IBOutlet var age: UITextField!
    @IBOutlet var result: UITextView!
    @IBOutlet var message: UILabel!
    
    
    @IBAction
    func clickAddButton(_ sender : UIButton){
        //   myLabel.text = myText.text
        var fName : String = firstName.text! as String
        var lName : String = lastName.text! as String
        var cty : String = country.text! as String
        var aging : Int = Int(age.text! as String) ?? 0
        
        var textViewData : String = "Full Name :\(fName) \(lName) \nCountry :\(cty) \nAge : \(aging)"
        
        result.text = String(textViewData)
    }
    
    @IBAction
    func clearButton(_ sender : UIButton){
        firstName.text = String("")
        lastName.text = String("")
        country.text = String("")
        age.text = String("")
        result.text = String("")
    }
    
    @IBAction
    func submitButton(_ sender : UIButton){
        var fName : String = firstName.text! as String
        var lName : String = lastName.text! as String
        var cty : String = country.text! as String
        var aging : String = age.text! as String
        
        if fName.isEmpty || lName.isEmpty || cty.isEmpty || aging.isEmpty{
            message.text = String("Complete the missing info!")
        } else {
            message.text = String("Successfully Submtted!")
        }
    }
    
    
    @IBAction
    func tapMode(_ sender : Any){
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        country.resignFirstResponder()
        age.resignFirstResponder()
    }
}

