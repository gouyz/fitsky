//
//  FSMonthClockVC.swift
//  fitsky
//  月打卡记录
//  Created by gouyz on 2019/10/30.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import FSCalendar
import MBProgressHUD

class FSMonthClockVC: GYZWhiteNavBaseVC {
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    /// 每月第一天
    var firstDayForMonth: String = ""
    
    var dateList:[FSMinePunchModel] = [FSMinePunchModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "月打卡记录"
        self.view.backgroundColor = kWhiteColor
        
        self.view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(300)
        }
        firstDayForMonth = self.dateFormatter.string(from: calendarView.currentPage)
        
        requestMonthPunch()
    }
    

    lazy var calendarView: FSCalendar = {
        
        let calendar = FSCalendar()
        calendar.backgroundColor = kWhiteColor
        calendar.select(Date())
        calendar.delegate = self
        calendar.dataSource = self
//        calendar.headerHeight = 0
        calendar.scope = .month
//        calendar.scrollEnabled = false
//        calendar.swipeToChooseGesture.isEnabled = false
        calendar.allowsSelection = false
//        calendar.placeholderType = .none
        
        calendar.appearance.weekdayTextColor = kBlackFontColor
        calendar.appearance.titleDefaultColor = kBlackFontColor
        calendar.appearance.titleSelectionColor = kBlackFontColor
        calendar.appearance.selectionColor = kWhiteColor
        calendar.appearance.todaySelectionColor = kWhiteColor
        calendar.appearance.todayColor = kRedFontColor
        calendar.appearance.eventDefaultColor = kHightBlueFontColor
        calendar.appearance.eventSelectionColor = kHightBlueFontColor
        
        return calendar
    }()

    ///获取打卡数据
    func requestMonthPunch(){
        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        createHUD(message: "加载中...")

        GYZNetWork.requestNetwork("Member/Member/monthPunch",parameters: ["date":firstDayForMonth],  success: { (response) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)

            if response["result"].intValue == kQuestSuccessTag{//请求成功

                guard let data = response["data"]["list"].array else { return }
                weakSelf?.dateList.removeAll()
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSMinePunchModel.init(dict: itemInfo)

                    weakSelf?.dateList.append(model)
                }
                weakSelf?.calendarView.reloadData()

            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }

        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)

        })
    }
}
extension FSMonthClockVC: FSCalendarDataSource, FSCalendarDelegate{
        func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
            return self.gregorian.isDateInToday(date) ? "今天" : nil
        }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        calendarView.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var index: Int = -1
        for (tag,item) in dateList.enumerated() {
            if date.dateToStringWithFormat(format: "yyyy-MM-dd") == item.date {
                index = tag
                break
            }
        }
        if index != -1 {
            return dateList[index].is_punch == "1" ? 2 : 0
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            
            //多选时
    //        let selectedDates = calendar.selectedDates.map({ $0.dateToStringWithFormat(format: "yyyy/MM/dd")})
    //        print("selected dates is \(selectedDates)")
//            if monthPosition == .next || monthPosition == .previous {
//                calendar.setCurrentPage(date, animated: true)
//            }
        }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        firstDayForMonth = self.dateFormatter.string(from: calendar.currentPage)
        requestMonthPunch()
//        print("\(self.dateFormatter.string(from: calendar.currentPage))")

    }
}
