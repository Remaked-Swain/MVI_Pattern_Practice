//
//  LikesModel.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/25/24.
//

import Foundation

enum LikesState {
    case on, off
}

protocol LikesModelStateProtocol: ObservableObject {
    var likesState: LikesState { get }
}

protocol LikesModelActionProtocol: AnyObject {
    func toggleLike()
}

final class LikesModel: LikesModelStateProtocol {
    @Published var likesState: LikesState = .off
}

extension LikesModel: LikesModelActionProtocol {
    func toggleLike() {
        guard likesState == .off else {
            likesState = .off
            return
        }
        likesState = .on
    }
}
