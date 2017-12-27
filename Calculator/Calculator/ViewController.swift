//
//  ViewController.swift
//  Calculator
//
//  Created by manoj karki on 12/18/17.
//  Copyright © 2017 manoj karki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayBox: UITextField!
    var displayStack: [String] = []
    var calculationStack: [String] = []
    var isFirstInputMinus = false
    var currentItem = ""
    var joiner = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        if let text = sender.titleLabel?.text {
            switch text {
            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
                pressedDigit(text)
                break
            case "0":
                pressedZero()
                break
            case ".":
                pressedDecimal()
                break
            case "/", "*", "+", "-":
                pressedOperator(text)
                break
            case "=":
                pressedEqual()
                break
            case "←":
                clearLastItem()
                break
            default:
                break
            }
        }
    }
    
    func clearLastItem() {
        if isFirstInputMinus {
            isFirstInputMinus = false
            currentItem = ""
            return
        }
        
         if !displayStack.isEmpty {
            currentItem = displayStack.last!
            displayStack.removeLast()
            calculationStack.removeLast()
            if isOperator(currentItem) {
                currentItem = ""
            }else {
                let newString = currentItem.prefix(currentItem.count - 1)
                 currentItem = String(newString)
                if currentItem.count == 0 || (newString.count == 1 && newString == "-") {
                    currentItem = ""
                } else  {
                    displayStack.append(currentItem)
                    calculationStack.append(String((currentItem as NSString).doubleValue))
                }
            }
              displayText()
        }
        
    }
    
    @IBAction func clearDisplayBox(_ sender: UIButton) {
       resetAll()
    }
    
    func resetAll() {
        currentItem = ""
        displayStack.removeAll()
        calculationStack.removeAll()
        isFirstInputMinus = false
        displayText()
    }
    
    func pressedDigit(_ num: String){
        if isFirstInputMinus {
            currentItem = "-" + num
            displayStack.append(currentItem)
            calculationStack.append(String((currentItem as NSString).doubleValue))
            isFirstInputMinus = false
        }else {
            if displayStack.isEmpty {
                currentItem = num
                displayStack.append(currentItem)
                calculationStack.append(String((currentItem as NSString).doubleValue))
            }else {
                if isOperator(displayStack.last!) {
                    currentItem = num
                    displayStack.append(currentItem)
                    calculationStack.append(String((currentItem as NSString).doubleValue))
                }else {
                    var lastItem = displayStack.last!
                    if lastItem == "0" {
                        lastItem = ""
                    }
                    displayStack.removeLast()
                    calculationStack.removeLast()
                    currentItem = lastItem + num
                    displayStack.append(currentItem)
                    calculationStack.append(String((currentItem as NSString).doubleValue))
                }
            }
         
        }
        displayText()
        
    }
    
    func pressedDecimal() {
        if displayStack.isEmpty {
            if isFirstInputMinus {
                isFirstInputMinus = false
                currentItem = "-0."
            }else {
                 currentItem = "0."
            }
            displayStack.append(currentItem)
            calculationStack.append(String((currentItem as NSString).doubleValue))
        }else {
            let lastItem = displayStack.removeLast()
            calculationStack.removeLast()
            if isOperator(lastItem) {
                currentItem = "0."
            }else  {
                 currentItem = lastItem + "."
            }
            displayStack.append(currentItem)
            calculationStack.append(String((currentItem as NSString).doubleValue))
        }
        displayText()
    }
    
    func pressedEqual() {
        if displayStack.isEmpty {
            isFirstInputMinus = false
            currentItem = ""
            displayText()
            return
        }
        let expression = NSExpression(format: calculationStack.joined(separator: joiner))
        let result = expression.expressionValue(with: nil, context: nil) as! NSNumber
        currentItem = String(describing: result)
        displayStack.removeAll()
        calculationStack.removeAll()
        displayStack.append(currentItem)
        calculationStack.append(String((currentItem as NSString).doubleValue))
        displayText()
    }
    
    func pressedOperator(_ op: String) {
        if displayStack.isEmpty {
            if op == "-" {
                isFirstInputMinus = true
                currentItem = "-"
            }else {
                isFirstInputMinus = false
                currentItem = ""
            }
            
        }else {
            currentItem = op
            if isOperator(displayStack.last!) {
                displayStack.removeLast()
                calculationStack.removeLast()
                displayStack.append(op)
                calculationStack.append(op)
            }else {
                displayStack.append(op)
                calculationStack.append(op)
            }
            displayText()
        }
    }
    
    func pressedZero() {
        if displayStack.isEmpty {
            if isFirstInputMinus {
                isFirstInputMinus = false
                currentItem = "-0"
            }else {
                currentItem = "0"
            }
            displayStack.append(currentItem)
            calculationStack.append(String((currentItem as NSString).doubleValue))
            
        }else {
            if isOperator(displayStack.last!) {
                 currentItem = "0"
                 displayStack.append(currentItem)
                 calculationStack.append(String((currentItem as NSString).doubleValue))
            }else {
                currentItem = displayStack.last!
                if currentItem != "0" {
                    currentItem = currentItem + "0"
                    displayStack.removeLast()
                    calculationStack.removeLast()
                    displayStack.append(currentItem)
                    calculationStack.append(String((currentItem as NSString).doubleValue))
                }
            }
        }
        displayText()
    }
    
    func isOperator(_ text: String) -> Bool {
        if text == "-" ||  text == "+" || text == "*" || text == "/" {
            return true
        }else {
            return false
        }
    }
    func displayText() {
        displayBox.text = displayStack.joined(separator: joiner)
    }
}

