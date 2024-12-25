//
//  ImageListView.swift
//  MVI_Pattern_Practice
//
//  Created by Swain Yun on 12/24/24.
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat
    var alignment: HorizontalAlignment

    init(spacing: CGFloat = 10, alignment: HorizontalAlignment = .leading) {
        self.spacing = spacing
        self.alignment = alignment
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        var totalWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            if totalWidth + size.width > proposal.width ?? .infinity {
                totalWidth = 0
                totalHeight += rowHeight + spacing
                rowHeight = 0
            }
            totalWidth += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        totalHeight += rowHeight
        return CGSize(width: proposal.width ?? 0, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var totalWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var yOffset: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            if totalWidth + size.width > bounds.width {
                totalWidth = 0
                yOffset += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: totalWidth, y: yOffset), proposal: ProposedViewSize(size))
            totalWidth += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

struct ImageListView<Model: ImageListModelStateProtocol, Intent: ImageListIntentProtocol>: View {
    @ObservedObject private var container: Container<Model, Intent>
    
    init(container: Container<Model, Intent>) {
        self.container = container
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch container.model.imageListState {
                case .contents(let images):
                    ScrollView {
                        FlowLayout(spacing: 10) {
                            ForEach(images, id: \.id) { image in
                                imageCell(image)
                            }
                        }
                    }
                    .padding()
                default:
                    unavailableView()
                }
            }
            .navigationTitle(container.model.navigationTitle)
            .onAppear {
                container.intent.onAppear()
            }
        }
    }
    
    @ViewBuilder private func unavailableView() -> some View {
        if let (title, systemImage, description) = container.model.unavailableContent {
            ContentUnavailableView(title, systemImage: systemImage, description: description)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private func imageCell(_ image: ImageEntity) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: image.downloadURL) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "ellipsis")
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                default:
                    Image(systemName: "xmark")
                }
            }
            
            HStack {
                Text(image.author)
                    .font(.headline)
                
                Spacer()
                
                LikesView<LikesModel, LikesIntent>.build()
            }
        }
    }
    
    static func build() -> some View {
        let model = ImageListModel()
        let intent = ImageListIntent(model: model)
        let container = Container<ImageListModel, ImageListIntent>(model: model, intent: intent)
        return ImageListView<ImageListModel, ImageListIntent>(container: container)
    }
}

#Preview {
    NavigationStack {
        ImageListView<ImageListModel, ImageListIntent>.build()
    }
}
