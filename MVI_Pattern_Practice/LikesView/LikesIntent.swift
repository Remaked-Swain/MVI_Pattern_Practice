//
//  LikesIntent.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/25/24.
//

import Foundation

protocol LikesIntentProtocol {
    func toggleLike()
}

final class LikesIntent {
    private weak var model: LikesModelActionProtocol?
    
    init(model: LikesModelActionProtocol) {
        self.model = model
    }
}

extension LikesIntent: LikesIntentProtocol {
    func toggleLike() {
        model?.toggleLike()
    }
}
