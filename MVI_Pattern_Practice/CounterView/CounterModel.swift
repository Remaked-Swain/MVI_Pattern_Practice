//
//  CounterModel.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/23/24.
//

import Foundation

enum CounterAction {
    case increaseOne
    case decreaseOne
}

protocol CounterModelStateProtocol: ObservableObject {
    var count: Int { get }
}

protocol CounterModelActionProtocol: AnyObject {
    func increaseOne()
    func decreaseOne()
}

final class CounterModel: ObservableObject, CounterModelStateProtocol {
    @Published var count: Int = 0
}

extension CounterModel: CounterModelActionProtocol {
    func increaseOne() {
        count += 1
    }
    
    func decreaseOne() {
        count -= 1
    }
}
