//
//  DoubleExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import Foundation

extension Double {
    
    var removeZero: String? {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        
        return nf.string(from: NSNumber(value: self))
    }
    
    var removeZeroWithTwoFractions: String? {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        nf.minimumIntegerDigits = 1
        
        return nf.string(from: NSNumber(value: self))
    }
    
    var removeZeroWithCeilTwoFractions: String? {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        nf.minimumIntegerDigits = 1
        
        return nf.string(from: NSNumber(value: ceilf(Float(self * 100)) / 100))
    }
    
    //前提： Int能存储得下double的整数部分 * 100
    var removeZeroWithRoundTwoFractions: String? {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        nf.minimumIntegerDigits = 1
        
        return nf.string(from: NSNumber(value: roundf(Float(self * 100)) / 100))
    }
    
    var removeZeroWithRoundOneFractions: String? {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        nf.minimumIntegerDigits = 1
        
        return nf.string(from: NSNumber(value: roundf(Float(self * 100)) / 100))
    }
    
    static func unitTest() {
        print("double with two tailing test --- start")
        let test1 : Double = 1.201
        let test1Result = test1.removeZeroWithTwoFractions
        print(test1Result!)
        
        let test2 : Double = 1.20
        let test2Result = test2.removeZeroWithTwoFractions
        print(test2Result!)
        
        let test3 : Double = 1.0
        let test3Result = test3.removeZeroWithTwoFractions
        print(test3Result!)
        
        let test11 : Double = 0.201
        let test11Result = test11.removeZeroWithTwoFractions
        let test11Result0 = test11.removeZeroWithCeilTwoFractions
        let test11Result1 = test11.removeZeroWithRoundTwoFractions
        print(test11Result0!)
        print(test11Result1!)
        print(test11Result!)
        
        let test21 : Double = 0.20
        let test21Result = test21.removeZeroWithTwoFractions
        print(test21Result!)
        
        let test31 : Double = 0.0
        let test31Result = test31.removeZeroWithTwoFractions
        print(test31Result!)
        
        let test111 : Double = 00.205
        let test111Result = test111.removeZeroWithCeilTwoFractions
        print(test111Result!)
        let test111Result0 = test111.removeZeroWithRoundTwoFractions
        print(test111Result0!)
        let test111Result1 = test111.removeZeroWithTwoFractions
        print(test111Result1!)
        
        let test211 : Double = 00.20
        let test211Result = test211.removeZeroWithTwoFractions
        print(test211Result!)
        
        let test311 : Double = 00.0
        let test311Result = test311.removeZeroWithTwoFractions
        print(test311Result!)
        
        print("double with two tailing test --- end")
    }
}
