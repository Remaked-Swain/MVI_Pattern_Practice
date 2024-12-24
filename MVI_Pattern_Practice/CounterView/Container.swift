//
//  Container.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/23/24.
//

import Foundation
import Combine

final class Container<Model: ObservableObject, Intent>: ObservableObject {
    let model: Model
    let intent: Intent
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        model: Model,
        intent: Intent
    ) {
        self.model = model
        self.intent = intent
        
        model.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
