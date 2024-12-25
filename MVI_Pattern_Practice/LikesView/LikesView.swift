//
//  LikesView.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/25/24.
//

import SwiftUI

struct LikesView<Model: LikesModelStateProtocol, Intent: LikesIntentProtocol>: View {
    @ObservedObject private var container: Container<Model, Intent>
    
    init(container: Container<Model, Intent>) {
        self.container = container
    }
    
    var body: some View {
        Button {
            container.intent.toggleLike()
        } label: {
            Image(systemName: container.model.likesState == .on ? "heart.fill" : "heart")
        }
    }
    
    static func build() -> some View {
        let model = LikesModel()
        let intent = LikesIntent(model: model)
        let container = Container<LikesModel, LikesIntent>(model: model, intent: intent)
        return LikesView<LikesModel, LikesIntent>(container: container)
    }
}

#Preview {
    LikesView<LikesModel, LikesIntent>.build()
}
