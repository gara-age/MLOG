//
//  LottieAnimationVIew.swift
//  Malendar
//
//  Created by 최민서 on 11/25/23.
//

import SwiftUI
import Lottie

struct LottieAnimationVIew: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LottieAnimationVIew>) -> some UIView {
        let view = UIView(frame: .zero )
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named("Anim1")
        animationView.animation = animation
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .repeat(1)
        animationView.animationSpeed = 1
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
         
    }
}

