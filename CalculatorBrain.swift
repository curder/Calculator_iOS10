//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by luo on 2017/7/2.
//  Copyright © 2017年 luo. All rights reserved.
//

import Foundation


struct CalculatorBrain {
    /// 内部计算出的值
    private var accumulator: Double?
    
    /// 枚举操作
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)-> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    /// 操作符对应的计算结果
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({ -$0 }),
        "+": Operation.binaryOperation(+),
        "-": Operation.binaryOperation(-),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "=": Operation.equals
    ];
    
    /// 执行运算操作
    mutating func performOperation(_ symbol: String) {
        if let operation = self.operations[symbol] {
            switch operation {
            case .constant(let associatedConstantValue):
                self.accumulator = associatedConstantValue
            case .unaryOperation(let function):
                if accumulator != nil {
                    self.accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    self.pendingBinaryOperation = PeadingBinaryOperation(function: function, firstOperand: accumulator!)
                }
            case .equals:
                performPendBinaryOperation()
            }
        }
    }
    
    
    private mutating func performPendBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            self.accumulator = pendingBinaryOperation!.perform(with: accumulator!)
        }
    }
    
    private var pendingBinaryOperation: PeadingBinaryOperation?
    
    private struct PeadingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand,  secondOperand)
        }
    }
    
    /// 设置运算符
    mutating func setOperand(_ operand: Double) {
        self.accumulator = operand
    }
    
    var result: Double? {
        get {
            return self.accumulator
        }
    }
}
