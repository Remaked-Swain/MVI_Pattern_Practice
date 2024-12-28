//
//  RandomVendingMachineView.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/28/24.
//

import SwiftUI

struct RandomVendingMachineView<Model: RandomVendingMachineStateProtocol, Intent: RandomVendingMachineIntentProtocol>: View {
    @ObservedObject private var container: Container<Model, Intent>
    private var model: Model { container.model }
    private var intent: Intent { container.intent }
    
    @State private var isSheetPresented: Bool = false
    @State private var productName = ""
    @State private var productProbability = ""
    
    init(container: Container<Model, Intent>) {
        self.container = container
    }
    
    var body: some View {
        VStack {
            list()
            interfaces()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    productName = ""
                    productProbability = ""
                    isSheetPresented = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            VStack {
                Text("상품 추가")
                    .font(.headline)
                    .padding()
                
                TextField("이름", text: $productName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                TextField("0부터 100 사이의 숫자로 확률 직접 입력 (%)", text: $productProbability)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                HStack {
                    Button("취소") {
                        isSheetPresented = false
                    }
                    .padding()
                    
                    Button("확인") {
                        guard let probability = Double(productProbability),
                              (0...100).contains(probability)
                        else { return }
                        let product = Product(name: productName, probability: probability / 100)
                        intent.addProduct(product)
                        isSheetPresented = false
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder private func list() -> some View {
        List {
            ForEach(model.products.indices, id: \.self) { index in
                let product = model.products[index]
                HStack {
                    Text(product.name)
                    
                    Spacer()
                    
                    Text("\(product.probability, specifier: "%.5f")%")
                }
            }
            .onDelete(perform: intent.removeProduct)
        }
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder private func interfaces() -> some View {
        HStack {
            Spacer()
            
            if model.isRunning {
                ProgressView("상품을 뽑는 중...")
                    .progressViewStyle(.circular)
            } else {
                if let prize = model.prize {
                    Text(prize.name)
                        .font(.headline)
                } else {
                    Text("상품을 뽑아보세요!")
                        .font(.headline)
                }
            }
            
            Spacer()
            
            Button {
                intent.selectRandomProduct()
            } label: {
                Text("상품 뽑기")
                    .padding()
                    .background(.green)
                    .foregroundStyle(.white)
                    .cornerRadius(14)
            }
            .disabled(model.isRunning)
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
    
    static func build() -> some View {
        let model = RandomVendingMachineModel()
        let intent = RandomVendingMachineIntent(model: model)
        let container = Container(model: model, intent: intent)
        return RandomVendingMachineView<RandomVendingMachineModel, RandomVendingMachineIntent>(container: container)
    }
}

#Preview {
    NavigationStack {
        RandomVendingMachineView<RandomVendingMachineModel, RandomVendingMachineIntent>.build()
    }
}
