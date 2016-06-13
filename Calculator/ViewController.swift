//
//  ViewController.swift
//  Calculator
//
//  Created by Theodora Skolnik on 6/12/16.
//  Copyright © 2016 Theodora Skolnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    private var userIsInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()

    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var calculatorSteps: UILabel!
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction private func clearDisplay() {
        brain.clear()
        display.text = String(0)
        calculatorSteps.text = String(0)
    }
    
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            brain.addToSteps(String(displayValue))
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            calculatorSteps.text = brain.getSteps()
        }
        displayValue = brain.result
        
    }
    
    @IBAction func addDecimalPoint(sender: UIButton) {
        let period = sender.currentTitle!
        if userIsInTheMiddleOfTyping && !display.text!.containsString(".") {
            display.text = display.text! + period
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
}
