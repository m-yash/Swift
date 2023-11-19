//
//  ViewController.swift
//  Test1
//
//  Created by user240111 on 9/14/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var myText: UITextField!
    @IBOutlet var myLabel: UILabel!
    
    @IBAction
    func clickAddButton(_ sender : UIButton){
     //   myLabel.text = myText.text
        let i : Int = Int(myLabel.text! as String) ?? 0
        myLabel.text = String(i+1)
    }
    
    @IBAction
    func clickSubButton(_ sender : UIButton){
     //   myLabel.text = myText.text
        let j : Int = Int(myLabel.text! as String) ?? 0
        myLabel.text = String(j-1)
    }
    
    @IBAction
    func clickResetButton(_ sender : UIButton){
     //   myLabel.text = myText.text
        //let k : Int = Int(myLabel.text! as String) ?? 0
        myLabel.text = String(0)
    }
    
    @IBAction
    func clickStepButton(_ sender : UIButton){
     //   myLabel.text = myText.text
        let k : Int = Int(myLabel.text! as String) ?? 0
        myLabel.text = String(k + 2)
    }
}

