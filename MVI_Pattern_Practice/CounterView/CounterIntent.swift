//
//  CounterIntent.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/23/24.
//

import Foundation

protocol CounterIntentProtocol {
    func increaseOne()
    func decreaseOne()
}

final class CounterIntent: ObservableObject {
    private weak var model: CounterModelActionProtocol?
    
    init(model: CounterModelActionProtocol) {
        self.model = model
    }
}

extension CounterIntent: CounterIntentProtocol {
    func increaseOne() {
        model?.increaseOne()
    }
    
    func decreaseOne() {
        model?.decreaseOne()
    }
}
