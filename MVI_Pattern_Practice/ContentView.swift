//
//  ContentView.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            RandomVendingMachineView<RandomVendingMachineModel, RandomVendingMachineIntent>.build()
        }
    }
}

#Preview {
    ContentView()
}
