//
//  ImageListModel.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/24/24.
//

import SwiftUI

enum ImageListState {
    case loading
    case contents(images: [ImageEntity])
    case errorOccured
}

protocol ImageListModelStateProtocol: ObservableObject {
    typealias UnavailableContent = (title: String, systemImage: String, prompt: Text?)
    
    var imageListState: ImageListState { get }
    var navigationTitle: String { get }
    var unavailableContent: UnavailableContent? { get }
}

protocol ImageListModelActionProtocol: AnyObject {
    func onLoading()
    func onError()
    func updateImages(images: [ImageEntity])
}

final class ImageListModel: ImageListModelStateProtocol {
    @Published var imageListState: ImageListState = .loading
    @Published var navigationTitle: String = "로딩 중"
    @Published var unavailableContent: UnavailableContent?
}

extension ImageListModel: ImageListModelActionProtocol {
    func onLoading() {
        imageListState = .loading
        navigationTitle = "Loading"
        unavailableContent = ("이미지를 불러오는 중입니다.", "ellipsis", nil)
        print("Loading")
    }
    
    func onError() {
        imageListState = .errorOccured
        navigationTitle = "Error Occured"
        unavailableContent = ("오류가 발생했습니다.", "xmark", nil)
        print("Error Occured")
    }
    
    func updateImages(images: [ImageEntity]) {
        imageListState = .contents(images: images)
        navigationTitle = "Images Updated"
        unavailableContent = nil
        print("Images Updated")
    }
}
