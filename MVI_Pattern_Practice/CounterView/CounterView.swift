//
//  CounterView.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/23/24.
//

import SwiftUI

struct CounterView<Model: CounterModelStateProtocol, Intent: CounterIntentProtocol>: View {
    @ObservedObject private var container: Container<Model, Intent>
    
    init(container: Container<Model, Intent>) {
        self.container = container
    }
    
    var body: some View {
        HStack {
            Button {
                container.intent.decreaseOne()
            } label: {
                Image(systemName: "minus")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
            Text("\(container.model.count)")
                .monospacedDigit()
                .font(.title3)
            
            Spacer()
            
            Button {
                container.intent.increaseOne()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: 200)
    }
    
    static func build() -> some View {
        let model = CounterModel()
        let intent = CounterIntent(model: model)
        let container = Container(model: model, intent: intent)
        return CounterView<CounterModel, CounterIntent>(container: container)
    }
}

struct CounterView_Preview: PreviewProvider {
    static var previews: some View {
        CounterView<CounterModel, CounterIntent>.build()
    }
}
