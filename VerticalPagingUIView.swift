//
//  VerticalPagingUIView.swift
//
//  Created by Patrick Tran on 11/10/23.
//

import SwiftUI

struct VerticalPagingView: View {
    let pages: () -> [AnyView]
    var externalSelectedPage: Binding<Int>?
    @State var internalSelectedPage: Int = 0
    
    var selectedPage: Binding<Int> {
        externalSelectedPage ?? $internalSelectedPage
    }
    
    init(selectedPage: Binding<Int>? = nil, pages: @escaping () -> [AnyView]) {
        self.pages = pages
        self.externalSelectedPage = selectedPage
    }
    
    var body: some View {
        let enclosedContents = pages()
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    ForEach(0..<enclosedContents.count, id: \.self) {
                        enclosedContents[$0]
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .id($0)
                    }
                }
                .scrollDisabled(true)
                .onChange(of: selectedPage.wrappedValue, perform: { value in
                    withAnimation(.smooth) {
                        scrollView.scrollTo(value, anchor: .center)
                    }
                })
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            var index = selectedPage.wrappedValue
                            value.translation.height > 20 ? (index -= 1) : (index += 1)
                            selectedPage.wrappedValue = max(0, min(index, enclosedContents.count - 1))
                        }
                )
            }
        }
    }
}

#Preview {
    VerticalPagingView {
        [
            AnyView(Color.red),
            AnyView(Color.green),
            AnyView(Color.blue),
            AnyView(Color.yellow),
        ]
    }
}
