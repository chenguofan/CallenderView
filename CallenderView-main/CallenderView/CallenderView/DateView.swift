//
//  DateView.swift
//  TestDemo
//
//  Created by suhengxian on 2021/11/16.
//

import UIKit

protocol DateViewDelegate{
    func didSelectDate(dateArr:[String])
}

class DateView: UIView {
    var dateButtonArray:[UILabel] = [UILabel]()
    var dateArr:[Any]?
    var nsdateArr:[Any]?
    var selectDate:Date = Date()
    var delegate:DateViewDelegate?
 
    lazy var smallPointView:UIView = {
        let smallPointView = UIView()
        smallPointView.frame = CGRect.init(x: 0, y: 0, width: 5, height: 5)
        smallPointView.backgroundColor = UIColor.white
        smallPointView.layer.cornerRadius = 2.5
        smallPointView.layer.masksToBounds = true
        return smallPointView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.createView()
    }
    
    func createView(){
        
        for i in 0...6 {
            let label = UILabel.init()
            let labelWidth = 50.0
            let space = (self.frame.size.width - labelWidth * 7)/8.0
            label.frame = CGRect.init(x:space + (space + labelWidth) * ((CGFloat)(i)), y: 0, width: labelWidth, height: labelWidth)
            label.backgroundColor = UIColor.blue
            label.layer.cornerRadius = labelWidth/2.0
            label.layer.masksToBounds = true
            label.numberOfLines = 0
            label.tag = 100 + i
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            label.textColor = UIColor.white
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
            
            self.addSubview(label)
            self.dateButtonArray.append(label)
        }
    }
    
    func reloadButtonTitle(arr:[Any],nsDateArr:[Any]){
        self.setButtonTiTle(dateArr: arr, nsArray: nsDateArr)
    }
    
    @objc func tapAction(_ tap:UITapGestureRecognizer){
        self.delegate?.didSelectDate(dateArr: self.dateArr![tap.view!.tag - 100] as! [String])
        
        let tag = tap.view?.tag ?? 0
        if (self.nsdateArr!.count > (tag - 100)){
            self.selectDate = (self.nsdateArr?[tag - 100] as! Date)
        }
        
        for index in 0...self.dateButtonArray.count-1 {
            let label = self.dateButtonArray[index];
            if (index == tap.view!.tag - 100){
                label.textColor = UIColor.white
                label.backgroundColor = UIColor.red
                
                label.addSubview(self.smallPointView)
                self.smallPointView.center = CGPoint.init(x: label.centerX, y: label.centerY + 15)
                self.smallPointView.backgroundColor = UIColor.white
                
            }else{
                let formatter = DateFormatter.init()
                formatter.dateFormat = "yyyyMMdd"
                
                let currentDateStr = formatter.string(from: Date.init())
                var tempStr = ""
                if self.nsdateArr!.count > index{
                    tempStr = formatter.string(from: self.nsdateArr![index] as! Date)
                }
                
                if currentDateStr == tempStr{
                    label.backgroundColor = UIColor.blue
                }else{
                    label.backgroundColor = UIColor.blue
                }
                
            }
        }
    }
    
    func getButtonTitle(arr:[String]) ->String{
        return arr[2]
    }
    
    func setButtonTiTle(dateArr:[Any],nsArray:[Any]){
        self.dateArr = dateArr
        self.nsdateArr = nsArray
        
        for index in 0...dateArr.count-1 {
            
            let label = self.dateButtonArray[index];
            let title = self.getButtonTitle(arr: dateArr[index] as! [String])
            
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyyMMdd"
                                             
            let currentDateStr = formatter.string(from: Date.init())
            let arr:[String] = dateArr[index] as! [String]
            
            let tempString = arr[0] + arr[1] + arr[2]
            let selectDateString = formatter.string(from: self.selectDate)
            
            if currentDateStr == tempString{
                //是当天时间选中
                if selectDateString == tempString{
                    label.backgroundColor = UIColor.red
                    
                    label.addSubview(self.smallPointView)
                    self.smallPointView.center = CGPoint.init(x: label.centerX, y: label.centerY + 15)
                    self.smallPointView.backgroundColor = UIColor.white
                    
                    //取消之前的默认选中
                    if index != 1{
                        let lab = self.dateButtonArray[1]
                        lab.backgroundColor = UIColor.blue
                        self.smallPointView.backgroundColor = UIColor.white
                    }
                }
            }else{
                //不是当前时间选中
                if selectDateString == tempString{
                    print("test")
                }else{
                    label.backgroundColor = UIColor.blue
                    if index == 1{
                        label.backgroundColor = UIColor.red
                        
                        label.addSubview(self.smallPointView)
                        self.smallPointView.center = CGPoint.init(x: label.centerX, y: label.centerY + 15)
                        self.smallPointView.backgroundColor = UIColor.white
                        
                    }
                }
            }
            label.text = title
        }
        
    }
}


