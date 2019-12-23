//
//  FSMineVC.swift
//  fitsky
//  我的 
//  Created by gouyz on 2019/8/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let mineMenuCell = "mineMenuCell"
private let mineHealthCell = "mineHealthCell"
//private let squareHotCell = "squareHotCell"

class FSMineVC: GYZWhiteNavBaseVC {
    
    /// 功能menu
    var mFuncModels: [FSMineMenuMode] = [FSMineMenuMode]()
    
    /// 我的主页信息
    var mineInfoModel: FSMineInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_icon_publish")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedPublishBtn))
        
        let editBar = UIBarButtonItem(image: UIImage(named: "app_btn_eidt_porfile")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedEditProfile))
        let codeBar = UIBarButtonItem(image: UIImage(named: "app_btn_code")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedQRCode))
        
        self.navigationItem.rightBarButtonItems = [codeBar,editBar]
        
        let plistPath : String = Bundle.main.path(forResource: "mineMenuData", ofType: "plist")!
        let menuArr : [[String:String]] = NSArray(contentsOfFile: plistPath) as! [[String : String]]
        
        for item in menuArr{
            
            let model = FSMineMenuMode.init(dict: item)
            mFuncModels.append(model)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.tableHeaderView = headerView
        
        headerView.didSelectItemBlock = {[unowned self] (index) in
            self.dealOperator(index: index)
        }
        
//        requestMineInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestMineInfo()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        //        table.estimatedRowHeight = 100
        //        // 设置行高为自动适配
        //        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSMineHealthCell.classForCoder(), forCellReuseIdentifier: mineHealthCell)
        table.register(FSMineFuncCell.classForCoder(), forCellReuseIdentifier: mineMenuCell)
        
        return table
    }()
    
    lazy var headerView: FSMineHeaderView = FSMineHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 310 + kMargin * 4))
    
    
    //我的
    func requestMineInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/home", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.mineInfoModel = FSMineInfoModel.init(dict: data)
                weakSelf?.dealData()
            
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealData(){
        if mineInfoModel != nil {
            headerView.dataModel = mineInfoModel
            tableView.reloadData()
        }
    }
    
    /// 发布
    @objc func clickedPublishBtn(){
        if mineInfoModel == nil || mineInfoModel?.infoData?.type != "2" {
            return
        }
        let vc = FSPublishWorkVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 编辑个人资料
    @objc func clickedEditProfile(){
        let vc = FSMyProfileVC()
        vc.resultBlock = {[unowned self] (isModify) in
            
            if  isModify {
                self.requestMineInfo()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 个人二维码
    @objc func clickedQRCode(){
        
    }
    
    ///控制跳转
    func goController(menu: FSMineMenuMode){
        //1:动态获取命名空间
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            GYZLog("获取命名空间失败")
            return
        }
        
        let cls: AnyClass? = NSClassFromString(name + "." + menu.controller!) //VCName:表示试图控制器的类名
        
        // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeClass = cls as? GYZBaseVC.Type else {
            GYZLog("cls不能当做UIViewController")
            return
        }
        
        let controller = typeClass.init()
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func dealOperator(index: Int){
        switch index {
        case 101://关注
            goMyFollowVC(type: 0)
        case 102://粉丝
            goMyFollowVC(type: 1)
        case 103://消息
            goMyMessage()
        case 104://收藏
            goMyFavourite()
        case 105://月打卡记录
            goMyClock()
        case 106://课程
            goMyCourse()
        case 107://活动
            goMyActivity()
        case 108://社圈
            MBProgressHUD.showAutoDismissHUD(message: "社圈功能暂未开放，敬请期待")
        case 109://设备
            MBProgressHUD.showAutoDismissHUD(message: "此功能暂未开放，敬请期待")
        case 110://个人主页
            goMyHome()
        default:
            break
        }
    }
    /// 我的关注、粉丝
    func goMyFollowVC(type:Int){
        let vc = FSMyFollowAndFenSiVC()
        vc.typeIndex = type
        vc.userId = mineInfoModel != nil ? (mineInfoModel?.infoData?.id)! : ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 收藏
    func goMyFavourite(){
        let vc = FSMyFavouriteVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 消息
    func goMyMessage(){
        let vc = FSMessageVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 个人主页
    func goMyHome(){
        if mineInfoModel != nil {
            let vc = FSPersonHomeVC()
            vc.userId = (mineInfoModel?.infoData?.id)!
            vc.userType = (mineInfoModel?.infoData?.type)!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    /// 活动
    func goMyActivity(){
        let vc = FSMyActivityVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 月打卡记录
    func goMyClock(){
        let vc = FSMonthClockVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 课程
    func goMyCourse(){
        let vc = FSMyCourseVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 运动数据
    func goSupportData(){
        let vc = FSMySupportDataVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 身体数据
    func goBodyData(){
        let vc = FSMyBodyDataVC()
        vc.resultBlock = {[unowned self] (ismodify) in
            if ismodify {
                self.requestMineInfo()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 申请认证
    func goApplyVC(){
        let vc = FSMyApplyConfirmVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 设置
    func goSettingVC(){
        let vc = FSMySettingVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 帮助与关于
    func goAboutVC(){
        let vc = FSHelpVSAboutVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 我的积分
    func goMyCoin(){
        let vc = FSMyCoinChangeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FSMineVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return mFuncModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: mineHealthCell) as! FSMineHealthCell
            
            var suport: String = "累计（天）：0  消耗（千卡）：0"
            var body: String = "身高（CM）：0  体重（KG）：0"
            if mineInfoModel != nil {
                suport = "累计（天）：\((mineInfoModel?.supportData?.days)!)  消耗（千卡）：\((mineInfoModel?.supportData?.consume)!) "
                body = "身高（CM）：\((mineInfoModel?.bodyData?.height)!)  体重（KG）：\((mineInfoModel?.bodyData?.weight)!)"
            }
            if indexPath.row == 0 {
                cell.nameLab.text = suport
                cell.iconView.image = UIImage.init(named: "app_icon_user_sport_date")
            }else{
                cell.nameLab.text = body
                cell.iconView.image = UIImage.init(named: "app_icon_user_health_date")
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: mineMenuCell) as! FSMineFuncCell
            
            let model = mFuncModels[indexPath.row]
            cell.nameLab.text = model.title
            cell.iconView.image = UIImage.init(named: model.image!)
            
            if indexPath.row == 0 {
                cell.nameLab.textColor = kOrangeFontColor
            }else{
                cell.nameLab.textColor = kGaryFontColor
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {//运动数据
                goSupportData()
            }else {//身体数据
                goBodyData()
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {//申请认证
                goApplyVC()
            }else if indexPath.row == 1 {//我的积分
                goMyCoin()
            }else if indexPath.row == 2 {//我的设置
                goSettingVC()
            }else if indexPath.row == 3 {//帮助与关于
                goAboutVC()
            }
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 50
        }
        return 65
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = kTitleAndStateHeight - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
            self.navigationItem.title = "我的"
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
        }
    }
}
