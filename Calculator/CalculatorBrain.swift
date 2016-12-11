//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ross Sabes on 12/10/16.
//  Copyright © 2016 Ross Sabes. All rights reserved.
//

import Foundation

func multiply( op1: Double, op2: Double) -> Double{
    return op1 * op2
}

class CalculatorBrain{
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI), // M_PI,
        "e" : Operation.Constant(M_E), // M_E,
        "√" : Operation.UnaryOperation(sqrt), // sqrt,
        "cos" : Operation.UnaryOperation(cos), // cos
        "×" : Operation.BinaryOperation( { $0 * $1 } ),
        "÷" : Operation.BinaryOperation( { $0 / $1 } ),
        "+" : Operation.BinaryOperation( { $0 + $1 } ),
        "−" : Operation.BinaryOperation( { $0 - $1 } ),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double )
        case BinaryOperation((Double, Double) -> Double )
        case Equals
    }

    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation( let function):
                accumulator = function(accumulator)
            case .BinaryOperation( let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
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
    
    // read-only property
    var result: Double{
        get{
            return accumulator
        }
    }
    
}
