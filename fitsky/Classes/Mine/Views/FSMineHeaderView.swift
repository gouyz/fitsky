//
//  FSMineHeaderView.swift
//  fitsky
//  我的 header
//  Created by gouyz on 2019/10/8.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import FSCalendar

class FSMineHeaderView: UIView {
    
    var didSelectItemBlock:((_ index: Int) -> Void)?
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    /// 打卡日期
    var dateArr: [String] = [String]()
    /// 填充数据
    var dataModel : FSMineInfoModel?{
        didSet{
            if let model = dataModel {
                
                if let userInfo = model.infoData {
                    userImgView.kf.setImage(with: URL.init(string: userInfo.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                    nameLab.text = userInfo.nick_name
                    uIdLab.text = "ID：\(userInfo.unique_id!)"
                    
                    /// 会员类型（1-普通 2-达人 3-场馆）
                    vipImgView.isHidden = false
                    if userInfo.type == "2"{
                        vipImgView.image = UIImage.init(named: "app_icon_daren")
                    }else if userInfo.type == "3"{
                        vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                    }else{
                        vipImgView.isHidden = true
                    }
                }
                
                followView.contentLab.text = model.countData?.follow
                fenSiView.contentLab.text = model.countData?.fans
                msgView.contentLab.text = model.countData?.message
                favouriteView.contentLab.text = model.countData?.collect
                
                if model.countData?.is_news_fans == "1" {
                    fenSiView.desLab.showBadge(animated: false)
                }else{
                    fenSiView.desLab.clearBadge(animated: false)
                }
                if Int.init((model.countData?.message)!) > 0 {
                    msgView.desLab.showBadge(animated: false)
                }else{
                    msgView.desLab.clearBadge(animated: false)
                }
                
                if model.punchList.count == 7 {
                    if model.punchList[0].week == "今日" {
                        sunDayView.titleLab.textColor = kBlackFontColor
                        sunDayView.dateLab.textColor = kBlackFontColor
                        sunDayView.titleLab.font = UIFont.boldSystemFont(ofSize: 12)
                        sunDayView.dateLab.font = UIFont.boldSystemFont(ofSize: 12)
                    }else{
                        sunDayView.titleLab.textColor = kGaryFontColor
                        sunDayView.dateLab.textColor = kGaryFontColor
                        sunDayView.titleLab.font = k12Font
                        sunDayView.dateLab.font = k12Font
                    }
                    sunDayView.titleLab.text = model.punchList[0].week
                    sunDayView.dateLab.text = model.punchList[0].day
                    sunDayView.lineView.isHidden = model.punchList[0].is_punch != "1"
                    
                    if model.punchList[1].week == "今日" {
                        
                        oneDayView.titleLab.font = UIFont.boldSystemFont(ofSize: 12)
                        oneDayView.dateLab.font = UIFont.boldSystemFont(ofSize: 12)
                    }else{
                        oneDayView.titleLab.font = k12Font
                        oneDayView.dateLab.font = k12Font
                    }
                    oneDayView.titleLab.text = model.punchList[1].week
                    oneDayView.dateLab.text = model.punchList[1].day
                    oneDayView.lineView.isHidden = model.punchList[1].is_punch != "1"
                    
                    if model.punchList[2].week == "今日" {
                        twoDayView.titleLab.font = UIFont.boldSystemFont(ofSize: 12)
                        twoDayView.dateLab.font = UIFont.boldSystemFont(ofSize: 12)
                    }else{
                        twoDayView.titleLab.font = k12Font
                        twoDayView.dateLab.font = k12Font
                    }
                    
                    twoDayView.titleLab.text = model.punchList[2].week
                    twoDayView.dateLab.text = model.punchList[2].day
                    twoDayView.lineView.isHidden = model.punchList[2].is_punch != "1"
                    
                    if model.punchList[3].week == "今日" {
                        threeDayView.titleLab.font = UIFont.boldSystemFont(ofSize: 12)
                        threeDayView.dateLab.font = UIFont.boldSystemFont(ofSize: 12)
                    }else{
                        threeDayView.titleLab.font = k12Font
                        threeDayView.dateLab.font = k12Font
                    }
                    threeDayView.titleLab.text = model.punchList[3].week
                    threeDayView.dateLab.text = model.punchList[3].day
                    threeDayView.lineView.isHidden = model.punchList[3].is_punch != "1"
                    
                    if model.punchList[4].week == "今日" {
                        fourDayView.titleLab.font = UIFont.boldSystemFont(ofSize: 12)
                        fourDayView.dateLab.font = UIFont.boldSystemFont(ofSize: 12)
                    }else{
                        fourDayView.titleLab.font = k12Font
                        fourDayView.dateLab.font = k12Font
                    }
                    fourDayView.titleLab.text = model.punchList[4].week
                    fourDayView.dateLab.text = model.punchList[4].day
                    fourDayView.lineView.isHidden = model.punchList[4].is_punch != "1"
                    
                    if model.punchList[5].week == "今日" {
                        fiveDayView.titleLab.font = UIFont.boldSystemFont(ofSize: 12)
                        fiveDayView.dateLab.font = UIFont.boldSystemFont(ofSize: 12)
                    }else{
                        fiveDayView.titleLab.font = k12Font
                        fiveDayView.dateLab.font = k12Font
                    }
                    fiveDayView.titleLab.text = model.punchList[5].week
                    fiveDayView.dateLab.text = model.punchList[5].day
                    fiveDayView.lineView.isHidden = model.punchList[5].is_punch != "1"
                    
                    if model.punchList[6].week == "今日" {
                        sixDayView.titleLab.textColor = kBlackFontColor
                        sixDayView.dateLab.textColor = kBlackFontColor
                        sixDayView.titleLab.font = UIFont.boldSystemFont(ofSize: 12)
                        sixDayView.dateLab.font = UIFont.boldSystemFont(ofSize: 12)
                    }else{
                        sixDayView.titleLab.textColor = kGaryFontColor
                        sixDayView.dateLab.textColor = kGaryFontColor
                        sixDayView.titleLab.font = k12Font
                        sixDayView.dateLab.font = k12Font
                    }
                    sixDayView.titleLab.text = model.punchList[6].week
                    sixDayView.dateLab.text = model.punchList[6].day
                    sixDayView.lineView.isHidden = model.punchList[6].is_punch != "1"
                    
                }
//                calendarView.reloadData()
            }
        }
    }
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(userBgView)
        userBgView.addSubview(userImgView)
        userBgView.addSubview(vipImgView)
        userBgView.addSubview(nameLab)
        userBgView.addSubview(uIdLab)
        userBgView.addSubview(rightIconView)
        
        addSubview(followBgView)
        followBgView.addSubview(followView)
        followBgView.addSubview(lineView)
        followBgView.addSubview(fenSiView)
        followBgView.addSubview(lineView1)
        followBgView.addSubview(msgView)
        followBgView.addSubview(lineView2)
        followBgView.addSubview(favouriteView)
        
        addSubview(calendarBgView)
        calendarBgView.addSubview(sunDayView)
        calendarBgView.addSubview(oneDayView)
        calendarBgView.addSubview(twoDayView)
        calendarBgView.addSubview(threeDayView)
        calendarBgView.addSubview(fourDayView)
        calendarBgView.addSubview(fiveDayView)
        calendarBgView.addSubview(sixDayView)
        
        addSubview(funcBgView)
        funcBgView.addSubview(courseView)
        funcBgView.addSubview(activityView)
        funcBgView.addSubview(circleView)
        funcBgView.addSubview(deviceView)
        
        
        userBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(kMargin)
            make.height.equalTo(80)
        }
        userImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(userBgView)
            make.left.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 72, height: 72))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
            make.top.equalTo(userImgView).offset(5)
            make.height.equalTo(30)
        }
        uIdLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.bottom.equalTo(userImgView).offset(-kMargin)
            make.height.equalTo(20)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 8, height: 16))
        }
        followBgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.left.equalTo(kMargin)
            make.top.equalTo(userBgView.snp.bottom).offset(kMargin)
            make.height.equalTo(70)
        }
        followView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(followBgView)
            make.width.equalTo(fenSiView)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.left.equalTo(followView.snp.right)
            make.width.equalTo(klineWidth)
        }
        fenSiView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(followView)
            make.width.equalTo(msgView)
            make.left.equalTo(lineView.snp.right)
        }
        lineView1.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(lineView)
            make.left.equalTo(fenSiView.snp.right)
        }
        msgView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(followView)
            make.width.equalTo(favouriteView)
            make.left.equalTo(lineView1.snp.right)
        }
        lineView2.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(lineView)
            make.left.equalTo(msgView.snp.right)
        }
        favouriteView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(followView)
            make.width.equalTo(followView)
            make.left.equalTo(lineView2.snp.right)
            make.right.equalTo(followBgView)
        }
        
        calendarBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(followBgView)
            make.top.equalTo(followBgView.snp.bottom).offset(kMargin)
            make.height.equalTo(60)
        }
        
        sunDayView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(calendarBgView)
            make.width.equalTo(oneDayView)
        }
        oneDayView.snp.makeConstraints { (make) in
            make.left.equalTo(sunDayView.snp.right)
            make.top.bottom.equalTo(sunDayView)
            make.width.equalTo(twoDayView)
        }
        twoDayView.snp.makeConstraints { (make) in
            make.left.equalTo(oneDayView.snp.right)
            make.top.bottom.equalTo(sunDayView)
            make.width.equalTo(threeDayView)
        }
        threeDayView.snp.makeConstraints { (make) in
            make.left.equalTo(twoDayView.snp.right)
            make.top.bottom.equalTo(sunDayView)
            make.width.equalTo(fourDayView)
        }
        fourDayView.snp.makeConstraints { (make) in
            make.left.equalTo(threeDayView.snp.right)
            make.top.bottom.equalTo(sunDayView)
            make.width.equalTo(fiveDayView)
        }
        fiveDayView.snp.makeConstraints { (make) in
            make.left.equalTo(fourDayView.snp.right)
            make.top.bottom.equalTo(sunDayView)
            make.width.equalTo(sixDayView)
        }
        sixDayView.snp.makeConstraints { (make) in
            make.left.equalTo(fiveDayView.snp.right)
            make.top.bottom.equalTo(sunDayView)
            make.width.equalTo(sunDayView)
            make.right.equalTo(calendarBgView)
        }
        
        funcBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(followBgView)
            make.top.equalTo(calendarBgView.snp.bottom).offset(kMargin)
            make.height.equalTo(80)
        }
        courseView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(funcBgView)
            make.width.equalTo(activityView)
        }
        activityView.snp.makeConstraints { (make) in
            make.left.equalTo(courseView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(courseView)
            make.width.equalTo(circleView)
        }
        circleView.snp.makeConstraints { (make) in
            make.left.equalTo(activityView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(courseView)
            make.width.equalTo(deviceView)
        }
        deviceView.snp.makeConstraints { (make) in
            make.left.equalTo(circleView.snp.right).offset(kMargin)
            make.top.bottom.width.equalTo(courseView)
            make.right.equalTo(funcBgView)
        }
    }
    lazy var userBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.tag = 110
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.cornerRadius = 36
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k18Font
        lab.text = "跑跑更健康"
        
        return lab
    }()
    /// 用户id
    lazy var uIdLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "ID:12345678"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_big_right"))
    
    lazy var followBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 8
        view.layer.shadowColor = kGrayLineColor.cgColor
        view.borderColor = kWhiteColor
        view.borderWidth = klineWidth
        // true的情况不出阴影效果
        view.layer.masksToBounds = false
        
        return view
    }()
    /// 关注
    lazy var followView : FSLabAndLabBtnView = {
        let view = FSLabAndLabBtnView()
        view.desLab.text = "关注"
        view.contentLab.text = "1"
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 粉丝
    lazy var fenSiView : FSLabAndLabBtnView = {
        let view = FSLabAndLabBtnView()
        view.desLab.text = "粉丝"
        view.contentLab.text = "1200"
        view.desLab.badgeView.style = .normal
        view.desLab.badgeView.size = CGSize.init(width: 3, height: 3)
//        view.desLab.showBadge(animated: false)
        //        view.desLab.clearBadge(animated: false)
        view.tag = 102
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 消息
    lazy var msgView : FSLabAndLabBtnView = {
        let view = FSLabAndLabBtnView()
        view.desLab.text = "消息"
        view.contentLab.text = "100"
        view.desLab.badgeView.style = .normal
        view.desLab.badgeView.size = CGSize.init(width: 3, height: 3)
        view.desLab.showBadge(animated: false)
        view.tag = 103
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 收藏
    lazy var favouriteView : FSLabAndLabBtnView = {
        let view = FSLabAndLabBtnView()
        view.desLab.text = "收藏"
        view.contentLab.text = "10"
        
        view.tag = 104
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    
//    lazy var calendarView: FSCalendar = {
//
//        let calendar = FSCalendar()
//        calendar.backgroundColor = kWhiteColor
//        calendar.select(Date())
//        calendar.delegate = self
//        calendar.dataSource = self
//        calendar.headerHeight = 0
//        calendar.scope = .week
//        calendar.scrollEnabled = false
//        calendar.swipeToChooseGesture.isEnabled = false
//        calendar.allowsSelection = false
//
//        calendar.appearance.weekdayTextColor = kBlackFontColor
//        calendar.appearance.titleDefaultColor = kBlackFontColor
//        calendar.appearance.titleSelectionColor = kBlackFontColor
//        calendar.appearance.selectionColor = kWhiteColor
//        calendar.appearance.todaySelectionColor = kWhiteColor
//        calendar.appearance.todayColor = kBlackFontColor
//        calendar.appearance.eventDefaultColor = UIColor.UIColorFromRGB(valueRGB: 0xfdc631)
//        calendar.appearance.eventSelectionColor = UIColor.UIColorFromRGB(valueRGB: 0xfdc631)
//
//        calendar.tag = 105
//        calendar.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
//
//        return calendar
//    }()
    /// 日历背景
    lazy var calendarBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.tag = 105
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    // 日
    lazy var sunDayView: FSRiLiItemView = FSRiLiItemView()
    // 一
    lazy var oneDayView: FSRiLiItemView = FSRiLiItemView()
    // 二
    lazy var twoDayView: FSRiLiItemView = FSRiLiItemView()
    // 三
    lazy var threeDayView: FSRiLiItemView = FSRiLiItemView()
    // 四
    lazy var fourDayView: FSRiLiItemView = FSRiLiItemView()
    // 五
    lazy var fiveDayView: FSRiLiItemView = FSRiLiItemView()
    // 六
    lazy var sixDayView: FSRiLiItemView = FSRiLiItemView()
    
    lazy var funcBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 4
        view.layer.shadowColor = kGrayLineColor.cgColor
        view.borderColor = kWhiteColor
        view.borderWidth = klineWidth
        // true的情况不出阴影效果
        view.layer.masksToBounds = false
        
        return view
    }()
    /// 课程
    lazy var courseView: GYZFuncModelView = {
        let view = GYZFuncModelView.init(frame: CGRect.zero, iconName: "app_btn_user_course", title: "课程")
        view.tag = 106
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 活动
    lazy var activityView: GYZFuncModelView = {
        let view = GYZFuncModelView.init(frame: CGRect.zero, iconName: "app_btn_user_activity", title: "活动")
        view.tag = 107
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 社圈
    lazy var circleView: GYZFuncModelView = {
        let view = GYZFuncModelView.init(frame: CGRect.zero, iconName: "app_btn_user_circle", title: "社圈")
        view.tag = 108
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 设备
    lazy var deviceView: GYZFuncModelView = {
        let view = GYZFuncModelView.init(frame: CGRect.zero, iconName: "app_btn_user_equipment", title: "设备")
        view.tag = 109
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    
    @objc func onClickedOperator(sender:UITapGestureRecognizer){
        if didSelectItemBlock != nil {
            didSelectItemBlock!((sender.view?.tag)!)
        }
    }
}

//extension FSMineHeaderView: FSCalendarDataSource, FSCalendarDelegate{
//        func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//            return self.gregorian.isDateInToday(date) ? "今日" : nil
//        }
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//
//        calendarView.snp.updateConstraints { (make) in
//            make.height.equalTo(bounds.height)
//        }
//    }
//
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//
//        if let model = dataModel {
//            var index: Int = -1
//            for (tag,item) in model.punchList.enumerated() {
//                if date.dateToStringWithFormat(format: "yyyy-MM-dd") == item.date {
//                    index = tag
//                    break
//                }
//            }
//            if index != -1 {
//                return model.punchList[index].is_punch == "1" ? 1 : 0
//            }
//        }
//        return 0
//    }
//}
