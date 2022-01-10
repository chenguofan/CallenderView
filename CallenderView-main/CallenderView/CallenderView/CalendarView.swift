//
//  CalendarView.swift
//  TestDemo
//
//  Created by suhengxian on 2021/11/16.
//

import UIKit

protocol CalenderViewDelegate{
    func didSelectDate(dateArr:[String])
}

class CalendarView: UIView,UIScrollViewDelegate,DateViewDelegate {
    func didSelectDate(dateArr: [String]) {
        self.delegate?.didSelectDate(dateArr: dateArr)
    }
    var delegate:CalenderViewDelegate?
    let backScrollView:UIScrollView = UIScrollView()
    
    var dateArray:[Any]?
    var nsdateArray:[Any]?
    
    var dateView:DateView!
    var dateViewArr:[DateView] = [DateView]()
    
    var contentOffsetX:CGFloat = 0.0
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.createView()
    }
    
    func createView(){
        self.backgroundColor = UIColor.blue
        
        let weekArr = ["Sun","Mon","Tue","Wes","Thu","Fri","Sat"]
        for index in 0...6 {
            let labelWidth = 40.0
            let space = (self.frame.size.width - labelWidth * 7)/8.0
            let label = UILabel.init(frame: CGRect.init(x: space + (space + labelWidth) * ((CGFloat)(index)), y: 0.0, width: labelWidth, height: 30))
            
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = weekArr[index]
            label.textColor = UIColor.white
            self.addSubview(label)
        }
        self.backScrollView.frame = CGRect.init(x: 0, y:30, width: self.frame.size.width, height: 50)
        self.backScrollView.contentSize = CGSize.init(width: self.frame.size.width * 3, height: 0)
        self.addSubview(self.backScrollView)
        
        self.backScrollView.delegate = self
        self.backScrollView.isPagingEnabled = true
        self.backScrollView.showsHorizontalScrollIndicator = false
        
        let a = self.getDayChaToSunday(week: self.getNowWeek())
        let b = self.getDayChaToSaturday(week:self.getNowWeek())
     
        //当前星期格式化时间
        self.dateArray = self.getDateArrCarFro(chafro: a, chaTo: b)
        self.nsdateArray = self.getNsDateArrCarFro(chafro: a, chaTo: b)
        
        for index in 0...2 {
            self.dateView = DateView.init(frame: CGRect.init(x: self.frame.size.width * ((CGFloat)(index)), y: 0.0, width: self.frame.size.width, height: 50.0))
            self.dateView.delegate = self
            self.backScrollView.addSubview(self.dateView)
            self.dateViewArr.append(self.dateView)
            
            if index == 0{
                var dateArray = [Any]()
                var nsdateArray = [Any]()
                let date = self.nsdateArray?.first
                for i in 1...7 {
                    let lastDate = Date.init(timeInterval: TimeInterval(-24 * 60 * 60 * i), since: date as! Date)
                    dateArray.insert(self.getDateArr(lastDate), at: 0)
                    nsdateArray.insert(lastDate, at:0)
                }
                self.dateView.reloadButtonTitle(arr: dateArray, nsDateArr: nsdateArray)
                
            }else if(index == 1){
                let a = self.getDayChaToSunday(week: self.getNowWeek())
                let b = self.getDayChaToSaturday(week: self.getNowWeek())
                
                self.dateArray = self.getDateArrCarFro(chafro: a, chaTo: b)
                
                self.dateView.reloadButtonTitle(arr: self.dateArray ?? [Any](), nsDateArr: self.nsdateArray ?? [Any]())
                
            }else{
                var dateArray = [Any]()
                var nsdateArray = [Date]()
                
                let date = (self.nsdateArray?.last)! as! Date
                for index in 1...7 {
                    let lastDay = Date.init(timeInterval:TimeInterval(24 * 60 * 60 * index), since:date)
                    dateArray.append(self.getDateArr(lastDay))
                    nsdateArray.append(lastDay)
                }
                self.dateView.reloadButtonTitle(arr: dateArray, nsDateArr: nsdateArray)
            }
        }
        self.setScrollViewContentOffsetCenter()
    }
    
    func setScrollViewContentOffsetCenter(){
        self.backScrollView.setContentOffset(CGPoint.init(x: self.frame.size.width, y: 0), animated:false)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        
        if(contentOffsetX >= 2 * (self.frame.size.width)){
            self.rightScrollAction()
            (self.dateViewArr[1] ).reloadButtonTitle(arr: self.dateArray!, nsDateArr: self.nsdateArray ?? [Date()])
            
            var dateArray = [Any]()
            var nsdateArray = [Any]()
            let date = self.nsdateArray?.last
            for index in 1...7 {
                let lastDay = Date.init(timeInterval: TimeInterval(24 * 60 * 60 * index), since: date as! Date)
                dateArray.append(self.getDateArr(lastDay))
                nsdateArray.append(lastDay)
            }
            (self.dateViewArr[2] ).reloadButtonTitle(arr: dateArray, nsDateArr: nsdateArray)
            
            var lDateArr = [Any]();
            var lnsdDateArr = [Any]();
            let lDate = self.nsdateArray?.first
            for index in 1...7 {
                let lastDay = Date.init(timeInterval: TimeInterval(-24 * 60 * 60 * index), since: lDate as! Date)
                lDateArr.insert(self.getDateArr(lastDay), at: 0)
                lnsdDateArr.insert(lastDay, at: 0)
            }
            (self.dateViewArr[0] as DateView).reloadButtonTitle(arr: lDateArr, nsDateArr: lnsdDateArr)
            self.backScrollView.setContentOffset(CGPoint.init(x: self.frame.size.width, y: 0), animated: false)
        }
        
        /// 左滑
        if(contentOffsetX <= 0) {
            /// 刷新中间页日期
            self.leftScrollAction()
            (self.dateViewArr[1] ).reloadButtonTitle(arr: self.dateArray!, nsDateArr: self.nsdateArray!)
            /// 刷新前一页日期
            var ldateArray = [Any]()
            var lnsdateArray = [Any]()
            let ldate = self.nsdateArray?.first
            
            for index in 1...7 {
                let lastDay = Date.init(timeInterval: TimeInterval(-24*60*60*index), since:ldate as! Date)
                ldateArray.insert(self.getDateArr(lastDay), at: 0)
                lnsdateArray.insert(lastDay, at: 0)
            }
            (self.dateViewArr[0] ).reloadButtonTitle(arr: ldateArray, nsDateArr: lnsdateArray)
                    
            var dateArray = [Any]();
            var nsdateArray = [Date]();
            
            let date = self.nsdateArray?.last
            for index in 1...7 {
                let lastDay = Date.init(timeInterval: TimeInterval(24 * 60 * 60 * index), since: date as! Date)
                dateArray.append(self.getDateArr(lastDay))
                nsdateArray.append(lastDay)
            }
            
            (self.dateViewArr[2] ).reloadButtonTitle(arr:dateArray, nsDateArr: nsdateArray)
            self.backScrollView.setContentOffset(CGPoint.init(x: self.frame.size.width, y: 0.0), animated:false)
        }
        
    }
    
    func rightScrollAction(){
        let date = self.nsdateArray?.last
        self.dateArray?.removeAll()
        self.nsdateArray?.removeAll()
        for index in 1...7 {
            let lastDay = Date.init(timeInterval: TimeInterval(24 * 60 * 60 * index), since: date as! Date)
            self.dateArray?.append(self.getDateArr(lastDay))
            self.nsdateArray?.append(lastDay)
        }
    }
    
    func leftScrollAction(){
        let date = self.nsdateArray?.first
        self.dateArray?.removeAll()
        self.nsdateArray?.removeAll()
        for index in 1...7 {
            let lastDay = Date.init(timeInterval: TimeInterval(-24 * 60 * 60 * index), since: date as! Date)
            self.dateArray?.insert(self.getDateArr(lastDay), at: 0)
            self.nsdateArray?.insert(lastDay, at: 0)
        }
    }
    
    func getWeekChinese(week:String) -> String{
        if week == "Monday"{
            return "周一"
        }else if(week == "Tuesday"){
            return "周二"
        }else if(week == "Wednesday"){
            return "周三"
        }else if(week == "Thursday"){
            return "周四"
        }else if(week == "Friday"){
            return "周五"
        }else if(week == "Saturday"){
            return "周六"
        }else{
            return "周日"
        }
    }
    
    func getDateArr(_ senddate:Date) ->Array<String>{
        let cal = Calendar.current
        //获取年月日
        let year = cal.component(.year, from: senddate)
        let month = cal.component(.month, from: senddate)
        let day = cal.component(.day, from: senddate)
        
        //周
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "EEEE"
        let weekString = dateFormatter.string(from: senddate)
        
        return ["\(year)","\(month)","\(day)",self.getWeekChinese(week: weekString)]
    }
    
    func getNsDateArrCarFro(chafro:Int,chaTo:Int) ->Array<Date>{
        
        var dateArray:Array = [Date]()
        if chafro > 0{
            for index in 1...chafro {
                let date = Date()
                let lastDate = date.addingTimeInterval(TimeInterval(-24 * 60 * 60 * index))
                dateArray.insert(lastDate, at: 0)
            }
        }
      
        dateArray.append(Date())
        
        if chaTo > 1{
            for index in 1...chaTo {
                let date = Date()
                let lastDate = date.addingTimeInterval(TimeInterval(24 * 60 * 60 * index))
                dateArray.append(lastDate)
            }
        }
        
        return dateArray
    }
    
    //获取当前这个星期格式化的时间
    func getDateArrCarFro(chafro:Int,chaTo:Int)->Array<Any>{
        var dateArr:Array = [Any]()
        
        if chafro > 0{
            for  index in 1...chafro {
                let lastDate = Date.init(timeIntervalSinceNow: TimeInterval(-24 * 60 * 60 * index))
                dateArr.insert(self.getDateArr(lastDate), at: 0)
            }
        }
       
        let tem = self.getDateArr(Date())
        dateArr.append(tem)
        
        if chaTo > 0{
            for index in 1...chaTo {
                let lastDate = Date.init(timeIntervalSinceNow: TimeInterval(24 * 60 * 60 * index))
                dateArr.append(self.getDateArr(lastDate))
            }
        }
        return dateArr
    }
    
    func getDayChaToSunday(week:String) ->Int{
        if week == "Monday"{
            return 1
        }else if(week == "Tuesday"){
            return 2
        }else if(week == "Wednesday"){
            return 3
        }else if(week == "Thursday"){
            return 4
        }else if(week == "Friday"){
            return 5
        }else if(week == "Saturday"){
            return 6
        }else{
            return 0
        }
    }
    func getDayChaToSaturday(week:String) ->Int{
        if week == "Sunday"{
            return 6
        }else if week == "Monday"{
            return 5
        }else if(week == "Tuesday"){
            return 4
        }else if(week == "Wednesday"){
            return 3
        }else if(week == "Thursday"){
            return 2
        }else if(week == "Friday"){
            return 1
        }else{
            return 0
        }
    }
    
    func getNowWeek() ->String {
        let senddate = Date()
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let weekString = dateFormatter.string(from: senddate)
        return weekString
    }
    
    func getNowDate(date:Date) -> String{
        //获取系统当前的时间
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "EEEE"
        let weekString = dateFormatter.string(from: date)
        let dateString = "\(year)" + "年" + "\(month)" + "月" + "\(day)" + "日" + self.getWeekChinese(week: weekString)
        return dateString
    }
    
}
