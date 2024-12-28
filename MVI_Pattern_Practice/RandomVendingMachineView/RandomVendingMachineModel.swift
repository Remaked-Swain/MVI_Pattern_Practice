//
//  RandomVendingMachineModel.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/28/24.
//

import Foundation

enum ProductProbabilityType: String, CaseIterable, Identifiable {
    case high, medium, low, custom
    
    var id: String { self.rawValue }
    
    var probability: Double {
        switch self {
        case .high: return 0.8
        case .medium: return 0.5
        case .low: return 0.2
        case .custom: return 0.0
        }
    }
}

struct Product {
    let name: String
    let probability: Double
    
    init(name: String, probability: Double) {
        self.name = name
        self.probability = probability
    }
    
    init(name: String, probability: ProductProbabilityType) {
        self.init(name: name, probability: probability.probability)
    }
    
    func adjustProbability(_ probability: Double) -> Product {
        guard (0.0...1.0).contains(probability) else { fatalError("잘못된 확률 값") }
        return .init(name: name, probability: probability)
    }
}

protocol RandomVendingMachineStateProtocol: ObservableObject {
    var products: [Product] { get }
    var isRunning: Bool { get }
    var prize: Product? { get }
    var isRunnable: Bool { get }
}

protocol RandomVendingMachineActionProtocol: AnyObject {
    func addProduct(_ product: Product)
    func removeProduct(_ index: IndexSet)
    func selectRandomProduct()
}

final class RandomVendingMachineModel: RandomVendingMachineStateProtocol {
    @Published var products: [Product] = []
    @Published var isRunning: Bool = false
    @Published var prize: Product?
    var isRunnable: Bool { products.count > 1 }
    
    private func normalizeProbabilities() {
        let totalProbability = products.reduce(0) { $0 + $1.probability }
        
        guard totalProbability > 0 else {
            for index in products.indices {
                let product = products[index]
                products[index] = product.adjustProbability(.zero)
            }
            return
        }
        
        for index in products.indices {
            let product = products[index]
            products[index] = product.adjustProbability(product.probability / totalProbability)
        }
    }
}

extension RandomVendingMachineModel: RandomVendingMachineActionProtocol {
    func addProduct(_ product: Product) {
        products.append(product)
        normalizeProbabilities()
    }
    
    func removeProduct(_ index: IndexSet) {
        products.remove(atOffsets: index)
        normalizeProbabilities()
    }
    
    func selectRandomProduct() {
        guard isRunnable else { return }
        isRunning = true
        prize = nil
        normalizeProbabilities()
        
        let workItem = DispatchWorkItem { [weak self] in
            let totalProbability = self?.products.reduce(0) { $0 + $1.probability } ?? 0
            let randomNumber = Double.random(in: 0...totalProbability)
            var cumulativeProbability: Double = 0
            
            for product in self?.products ?? [] {
                cumulativeProbability += product.probability
                if randomNumber < cumulativeProbability {
                    self?.prize = product
                    break
                }
            }
            self?.isRunning = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: workItem)
    }
}
