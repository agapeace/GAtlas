

import Foundation


final class ObservableObject<T> {
    
    var valueArr: [[T]] {
        didSet {
            listener?(valueArr)
        }
    }
    
    private var listener: (([[T]]) -> Void)?
    
    init(valueArr: [[T]]) {
        self.valueArr = valueArr
    }
    
    func bind(listener: @escaping ([[T]]) -> Void) {
        self.listener = listener
    }
}
