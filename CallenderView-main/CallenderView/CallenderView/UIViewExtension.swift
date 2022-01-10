//
//  UIViewExtension.swift
//  CallenderView
//
//  Created by suhengxian on 2022/1/10.
//

import Foundation
import UIKit

extension UIView{
    var centerX:CGFloat{
        return (self.frame.origin.x + self.frame.size.width)/2.0
    }
    
    var centerY:CGFloat{
        return (self.frame.origin.y + self.frame.size.height)/2.0
    }
    
}

