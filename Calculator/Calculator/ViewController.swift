//
//  ViewController.swift
//  Calculator
//
//  Created by user on 1/13/18.
//  Copyright © 2018 jon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //TODO: CREATE A VARIABLE THAT HOLDS THE FUNCTION THAT WILL RUN EG "*" OR "/"
    
    var total:Double = 0
    // Bool whether the negative has been pressed
    var isNegative = false
    var dotIsPressed = false
    var percentIsPressed = false
    var isFirstValue = true
    var firstValue = 0.0
    //Bool that distinguishes that a value will be overridden with the next value that is pressed
    var shouldReplace = false
    var operand: Int = 0
    
    //MARK: - Button Methods
    
    @IBAction func operandIsPressed(_ sender: UIButton) {
        
        // Check if value is the first one
        let isFirst = checkIfFirstValAndUpdateTotal(sender: sender)
        
        // Not the first value
        if isFirst == false {
            
            let secondValue = Double(totalLabel.text!)!
            
            let answerStr = doMath(sender: sender, secondValue: secondValue)
            totalLabel.text = removeNeedlessZero(visibleString: answerStr)
        }
    }
    
    @IBAction func topButtonsPressed(_ sender: UIButton) {
        
        // Reset everything if c is pressed
        if sender.tag == 20 {
            
            total = 0.0
            firstValue = 0.0
            isNegative = false
            dotIsPressed = false
            percentIsPressed = false
            totalLabel.text = String(describing: Int(total))
            isFirstValue = true
            operand = 0
        }
        
        // Setting value as negative
        if sender.tag == 21 {
            
            if shouldReplace == true {
                
                totalLabel.text = "0"
                isNegative = true
                shouldReplace = false
                
                return
            }
            
            if isNegative == true {
                // Switch back to positive
                if totalLabel.text! != "0" {
                    totalLabel.text!.remove(at: totalLabel.text!.startIndex)
                    isNegative = false
                }
                else {
                    isNegative = false
                }
            }
            else {
                if totalLabel.text! != "0" {
                    isNegative = true
                    totalLabel.text!.insert("-", at: totalLabel.text!.startIndex)
                }
                else {
                    isNegative = true
                }
            }
        }
        
         //Setting value as percentage
        
        if sender.tag == 22 {
            if percentIsPressed == false {
                
                percentIsPressed = true
            }
            else {
                percentIsPressed = false
            }
        }
    }
    
    
    @IBAction func valueIsPressed(_ sender: UIButton) {
        
        if shouldReplace == true {
            
            totalLabel.text = String(describing: sender.tag)

            shouldReplace = false
            
            return
        }
        
        let innerTotal = Int(totalLabel.text!)
        
        if innerTotal == 0 {
            if isNegative == true {
                
                totalLabel.text! = "-"
                totalLabel.text! += String(describing: sender.tag)
            }
            else {
                totalLabel.text! = String(describing: sender.tag)
            }
            return
        }
        
        totalLabel.text! += String(sender.tag)
    }
    
    @IBAction func periodIsPressed(_ sender: Any) {
        
        if shouldReplace == true {
            
            totalLabel.text = "0."
            shouldReplace = false
            
            return
        }
        
        if dotIsPressed == true {
            return
        }
        
        dotIsPressed = true
        totalLabel.text! += "."
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        totalLabel.text = String(describing: Int(total))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - IBOutlets
    
    @IBOutlet var totalLabel: UILabel!

    //MARK: - Calculator Methods
    
    func setTheCorrectOperand() {
        
        
    }
    
    func removeNeedlessZero(visibleString number:String) -> String{
        
        var num = number
        let offset = num.count - 2
        
        let secondToLastIndex = num.index(num.startIndex, offsetBy: offset)
        let lastIndex = num.index(num.endIndex, offsetBy: -1)
        
        if num[secondToLastIndex] == "." {
            
            if num[lastIndex] == "0" {
                
                num.remove(at: lastIndex)
                num.remove(at: secondToLastIndex)
            }
        }
        return num
    }
    
    func updateTotal(value:Int) {
        
        if self.total == 0 {
            
            self.total = Double(value)
        }
        
        else {
            
            self.total = self.total * 10 + Double(value)
        }
    }
    
    func checkIfFirstValAndUpdateTotal(sender: UIButton) -> Bool {
        
        if isFirstValue == true {
            
            firstValue = Double(totalLabel.text!)!
            
            if percentIsPressed == true {
                
                total = firstValue * 0.01
                firstValue = total
            }
            else {
                
                total = Double(totalLabel.text!)!
                firstValue = total
            }
            
            //Check which operand to use
            
            operand = sender.tag
            print(operand)
            
            isFirstValue = false
            shouldReplace = true
            
            return true
        }
        
        return false
    }
    
    func doMath(sender: UIButton, secondValue: Double) -> String {
        
        var sentInVal = secondValue
        if percentIsPressed == true {
            
            sentInVal *= 0.01
        }
        
        if operand < 14 && operand > 9 {
            
            //uses the sender tag saved in operand to know what operation to run
            
            if operand == 10 {
                
                total = firstValue / sentInVal
            }
            else if operand == 11 {
                
                total = firstValue * sentInVal
            }
            else if operand == 12 {
                
                total = firstValue - sentInVal
            }
            else if operand == 13 {
                
                total = firstValue + sentInVal
            }
            // The equals sign just sets up the value
            else if operand == 14 {
                
                if percentIsPressed == true {
                    
                    total = Double(totalLabel.text!)! * 0.01
                }
            }
        }
        operand = sender.tag
        firstValue = total
        isNegative = false
        percentIsPressed = false
        shouldReplace = true
        
        return String(describing: total)
    }

}

