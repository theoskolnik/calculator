//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Theodora Skolnik on 6/12/16.
//  Copyright © 2016 Theodora Skolnik. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    var steps = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func getSteps() -> String{
        var stepsString = ""
        for step in steps {
            if let operand = step as? Double {
                stepsString += String(operand)
            } else if let operation = step as? String {
                stepsString += operation
            }
        }
        return stepsString
    }
    
    func addToSteps(digit: String) {
        steps.append(digit)
    }

    func clear() {
        accumulator = 0.0
        pending = nil
        steps.removeAll()
    }
    
     private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "x²" : Operation.UnaryOperation({ $0 * $0 }),
        "xʸ" : Operation.BinaryOperation({ pow($0, $1) }),
        "1/x" : Operation.UnaryOperation({ 1 / $0 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if symbol != "=" {
            steps.append(symbol)
        }
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals :
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}