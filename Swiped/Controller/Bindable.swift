//
//  Bindable.swift
//  Swiped
//
//  Created by Nitin on 31/05/25.
//

import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer : @escaping (T?) -> ()) {
        self.observer = observer
    }
}
