//
//  GYZScrollView+Extension.swift
//  fitsky
//
//  Created by gouyz on 2020/5/6.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

extension UIScrollView {

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
        super.touchesMoved(touches, with: event)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
//    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        return self
//    }
}
