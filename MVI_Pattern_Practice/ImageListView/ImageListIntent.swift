//
//  ImageListIntent.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/24/24.
//

import Foundation
import Combine

protocol ImageListIntentProtocol {
    func onAppear()
}

final class ImageListIntent {
    private weak var model: ImageListModelActionProtocol?
    
    private let imagesSubject = PassthroughSubject<[ImageEntity], Error>()
    private var cancellables = Set<AnyCancellable>()
    
    private let networkService: NetworkService
    
    init(
        model: ImageListModelActionProtocol,
        networkService: NetworkService = DefaultNetworkService.shared
    ) {
        self.model = model
        self.networkService = networkService
        subscribe()
    }
    
    private func subscribe() {
        imagesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error): self?.model?.onError(); print(error)
                }
            } receiveValue: { [weak self] images in
                self?.model?.updateImages(images: images)
            }
            .store(in: &cancellables)
    }
}

extension ImageListIntent: ImageListIntentProtocol {
    func onAppear() {
        model?.onLoading()
        
        Task {
            do {
                let images: [ImageEntity] = try await networkService.data(urlString: "https://picsum.photos/v2/list")
                imagesSubject.send(images)
            } catch {
                imagesSubject.send(completion: .failure(error))
            }
        }
    }
}
