//
//  ViewController.swift
//  CallenderView
//
//  Created by suhengxian on 2022/1/10.
//

import UIKit

class ViewController: UIViewController,CalenderViewDelegate {
    func didSelectDate(dateArr: [String]) {
        print("dateArr:\(dateArr)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let calenderViewHeight = 90.0
        let calenderView = CalendarView.init(frame: CGRect.init(x:0, y:100, width: UIScreen.main.bounds.size.width, height:calenderViewHeight))
        calenderView.delegate = self
        self.view.addSubview(calenderView)
        
    }
}

