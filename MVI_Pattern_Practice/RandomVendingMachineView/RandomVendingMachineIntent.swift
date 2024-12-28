//
//  RandomVendingMachineIntent.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/28/24.
//

import Foundation

protocol RandomVendingMachineIntentProtocol {
    func addProduct(_ product: Product)
    func removeProduct(_ index: IndexSet)
    func selectRandomProduct()
}

final class RandomVendingMachineIntent {
    private weak var model: RandomVendingMachineActionProtocol?
    
    init(model: RandomVendingMachineActionProtocol) {
        self.model = model
    }
}

extension RandomVendingMachineIntent: RandomVendingMachineIntentProtocol {
    func addProduct(_ product: Product) {
        model?.addProduct(product)
    }
    
    func removeProduct(_ index: IndexSet) {
        model?.removeProduct(index)
    }
    
    func selectRandomProduct() {
        model?.selectRandomProduct()
    }
}
