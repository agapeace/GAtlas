//
//  ObservableCountryObject.swift
//  GAtlas
//
//  Created by Damir Agadilov  on 16.09.2024.
//

import Foundation


class ObservableCountryObject<T> {
    var valueArr: [T] {
        didSet {
            listener?(valueArr)
        }
    }
    
    private var listener: (([T]) -> Void)?
    
    init(valueArr: [T]) {
        self.valueArr = valueArr
    }
    
    func bind(listener: @escaping ([T]) -> Void) {
        self.listener = listener
    }
}
