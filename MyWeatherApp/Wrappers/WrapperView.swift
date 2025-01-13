//
//  WrapperView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import SwiftUI

struct WrapperView<V: UIView>: UIViewRepresentable {
    
    typealias UIViewType = V
    
    var view: V
    
    init(view: V) {
        self.view = view
    }
    
    func makeUIView(context: Context) -> V {
        return view
    }
    
    func updateUIView(_ uiView: V, context: Context) {}
    
}
