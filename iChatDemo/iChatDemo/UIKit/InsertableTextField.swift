//
//  InsertableTextField.swift
//  iChatDemo
//
//  Created by Admin on 16.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

class InsertableTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 18
        layer.masksToBounds = true
        
        placeholder = "Please enter message here..."
        borderStyle = .none
        font = .systemFont(ofSize: 14)
        clearButtonMode = .whileEditing
        
        // left view
        let leftViewImage = UIImage(systemName: "smiley")
        let leftImageView = UIImageView(image: leftViewImage)
        leftImageView.setupColor(.grayColor)
        leftView = leftImageView
        leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        leftViewMode = .always
    
        // right view
        let sentButtonImage = UIImage(named: "Sent")
        let sentButton = UIButton(type: .system)
        sentButton.setImage(sentButtonImage, for: .normal)
        sentButton.applyGradients(cornerRadius: 10)
        rightView = sentButton
        rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        rightViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 12
        return rect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
}

/*
// MARK: - SwiftUI
import SwiftUI

struct InsertableTextFieldProvider: PreviewProvider {
    typealias ProviderType = InsertableTextFieldProvider
    typealias VCType = ProfileViewController
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = VCType()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderType.ContainerView>) -> VCType {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: ProviderType.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderType.ContainerView>) {
        }
    }
}*/
