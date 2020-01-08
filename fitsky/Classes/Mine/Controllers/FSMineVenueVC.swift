//
//  FSMineVenueVC.swift
//  fitsky
//  我的 场馆主页
//  Created by gouyz on 2019/10/31.
//  Copyright © 2019 gyz. All rights reserved.
//  18651958833  123456

import UIKit
import MBProgressHUD

private let mineVenueMenuCell = "mineVenueMenuCell"

class FSMineVenueVC: GYZWhiteNavBaseVC {
    
    /// 功能menu
    var mFuncModels: [FSMineMenuMode] = [FSMineMenuMode]()
    /// 我的主页信息
    var mineInfoModel: FSMineInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        
        let editBar = UIBarButtonItem(image: UIImage(named: "app_btn_eidt_porfile")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedEditProfile))
        let codeBar = UIBarButtonItem(image: UIImage(named: "app_btn_code")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedQRCode))
        
        self.navigationItem.rightBarButtonItems = [codeBar,editBar]
        
        let plistPath : String = Bundle.main.path(forResource: "venueMenuData", ofType: "plist")!
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
        
        table.register(FSMineFuncCell.classForCoder(), forCellReuseIdentifier: mineVenueMenuCell)
        
        return table
    }()
    
    lazy var headerView: FSVenueMineHeaderView = FSVenueMineHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 260))
    
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
    /// 编辑个人资料
    @objc func clickedEditProfile(){
        let vc = FSMyVenueProfileVC()
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
        case 106://服务
            goMyServer()
        case 107://教练
            goMyCoach()
        case 108://社圈
            break
        case 109://交易
            goMyTrade()
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
            let vc = FSVenueHomeVC()
            vc.userId = (mineInfoModel?.infoData?.id)!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    /// 交易
    func goMyTrade(){
        let vc = FSTradeOrderVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 教练
    func goMyCoach(){
        let vc = FSMyVenueCoachVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 课程
    func goMyServer(){
        let vc = FSMyVenueServerVC()
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

extension FSMineVenueVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mFuncModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mineVenueMenuCell) as! FSMineFuncCell
        
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        goController(menu: mFuncModels[indexPath.row])
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
            if mineInfoModel != nil {
                self.navigationItem.title = mineInfoModel?.infoData?.nick_name
            }
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
        }
    }
}
