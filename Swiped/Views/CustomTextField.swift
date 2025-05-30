//
//  CustomTextField.swift
//  Swiped
//
//  Created by Nitin on 30/05/25.
//

import Foundation
import UIKit

// MARK: - CustomTextField

class CustomTextField: UITextField {
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        self.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // yeh hoti h textField ki padding text ke beech yeh start mein
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    // yeh hoti h textField padding text ke end mein
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    // is for the height of textField
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
}
