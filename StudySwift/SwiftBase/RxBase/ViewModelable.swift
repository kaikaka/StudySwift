//
//  ViewModelable.swift
//  Foowwphone
//
//  Created by Yoon on 2020/10/30.
//  Copyright © 2020 Fooww. All rights reserved.
//

import UIKit

protocol ViewModelable {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
protocol NestedViewModelable {

    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

protocol HasViewModel {
    associatedtype VMType: ViewModel
}

//var key = "Key"
extension HasViewModel {
    var viewModel: ViewModel {
        guard
            let classType = "\(VMType.self)".classType(VMType.self)
        else {
            return VMType()
        }
        return classType.init()
    }
}
