//
//  ResizableLottieView.swift
//  Masking
//
//  Created by Bilal SIMSEK on 30.07.2023.
//

import SwiftUI
import Lottie
struct ResizableLottieView: UIViewRepresentable {
    
    var fileName:String
    var onFinish:(AnimationView)->()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        setupView(for: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func setupView(for to: UIView){
        let animationView = AnimationView(name:fileName, bundle:.main)
        animationView.backgroundColor = .clear
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.shouldRasterizeWhenIdle = true // Memory Optimization
        
        let constraints = [
            animationView.widthAnchor.constraint(equalTo: to.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: to.heightAnchor)
        ]
        
        to.addSubview(animationView)
        to.addConstraints(constraints)
        
        animationView.play{ _ in
            
            onFinish(animationView)
        }
    }
}
