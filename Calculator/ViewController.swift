//
//  ViewController.swift
//  Calculator
//
//  Created by luo on 2017/7/2.
//  Copyright © 2017年 luo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel! // 计算结果展示
    
    var userIsInTheMiddleOfTyping: Bool = false // 标志用户是否点击
    
    /// 点击数字按钮执行的方法
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle! // 用户点击的内容
        if self.userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text! // 点击之前展示的内容
            self.display.text = textCurrentlyInDisplay + digit
            
        } else {
            self.display.text = digit
            self.userIsInTheMiddleOfTyping = true
        }
        
    }
    
    var displayValue: Double { // 暂时计算结果的计算型属性
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    /// 模型属性
    private var brain = CalculatorBrain()
    
    /// π、+、-、×、÷、cos、√、± 等运算
    @IBAction func performOperation(_ sender: UIButton) {
        if self.userIsInTheMiddleOfTyping {
            self.brain.setOperand(displayValue)
            self.userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            print(mathematicalSymbol)
            self.brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result!
        
    }
}

