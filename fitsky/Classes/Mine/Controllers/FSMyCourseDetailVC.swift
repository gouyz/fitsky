//
//  FSMyCourseDetailVC.swift
//  fitsky
//  我的课程 详情
//  Created by gouyz on 2019/12/24.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import ZFPlayer

private let myCourseDetailCell = "myCourseDetailCell"
private let myCourseDetailInfoCell = "myCourseDetailInfoCell"

class FSMyCourseDetailVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    var goodsId: String = ""
    var dataModel: FSMyCourseDetailModel?
    
    var player:ZFPlayerController?
    var isModify: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "课程介绍"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_link_kefu")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedLinkKeFuBtn))
        
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomBtn.snp.top)
            make.left.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        tableView.tableHeaderView = headerView
        /// 超出部分裁剪
        //        headerView.clipsToBounds = true
        
        headerView.playBtn.addTarget(self, action: #selector(onClickedPlay), for: .touchUpInside)
        
        showVideo()
        requestGoodsInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player?.isViewControllerDisappear = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        self.player?.isViewControllerDisappear = true
    }
    
    override func clickedBackBtn() {
        if isModify && resultBlock != nil {
            resultBlock!()
        }
        super.clickedBackBtn()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 200
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSGoodsDetailCell.classForCoder(), forCellReuseIdentifier: myCourseDetailCell)
        table.register(FSFindCourseDetailDesCell.classForCoder(), forCellReuseIdentifier: myCourseDetailInfoCell)
        
        return table
    }()
    /// 取消
    lazy var bottomBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = kHeightGaryFontColor
        
        btn.addTarget(self, action: #selector(onclickedOperator), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var headerView: FSGoodsDetailHeaderView = FSGoodsDetailHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 250.0 / 375.0))
    
    lazy var controlView: ZFPlayerControlView = {
        let playerView = ZFPlayerControlView.init()
        playerView.fastViewAnimated = true
        playerView.autoHiddenTimeInterval = 5
        playerView.autoFadeTimeInterval = 0.5
        playerView.prepareShowLoading = true
        playerView.prepareShowControlView = true
        
        return playerView
    }()
    
    func showVideo(){
        
        let playerManager = ZFAVPlayerManager.init()
        self.player = ZFPlayerController.init(scrollView: self.tableView, playerManager: playerManager, containerView: self.headerView.containerView)
        self.player?.shouldAutoPlay = false
        /// 1.0是完全消失的时候
        self.player?.playerDisapperaPercent = 1.0
        /// 0.0是刚开始显示的时候
        self.player?.playerApperaPercent = 0.0
        /// 移动网络依然自动播放
        //        self.player?.isWWANAutoPlay = true
        /// 设置退到后台继续播放
        self.player?.pauseWhenAppResignActive = false
        self.player?.controlView = self.controlView
        self.player?.orientationWillChange = {[unowned self] (player,isFullScreen) in
            self.setNeedsStatusBarAppearanceUpdate()
            UIViewController.attemptRotationToDeviceOrientation()
            self.tableView.scrollsToTop = !isFullScreen
        }
        
    }
    /// 联系客服
    @objc func clickedLinkKeFuBtn(){
        if let model = dataModel {
            if !(model.formData?.tel?.isEmpty)!{
                GYZTool.callPhone(phone: (model.formData?.tel)!)
            }
        }
    }
    /// 播放、暂停
    @objc func onClickedPlay(){
        if let model = dataModel {
            if !(model.formData?.video!.isEmpty)!{
                self.player?.assetURL = URL.init(string: (model.formData?.video)!)!
                self.controlView.showTitle("", coverURLString: model.formData?.thumb, fullScreenMode: .landscape)
            }
        }
    }
    ///课程基本信息
    func requestGoodsInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Order/info", parameters: ["id":goodsId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSMyCourseDetailModel.init(dict: data)
                weakSelf?.dealData()
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func dealData(){
        if let model = dataModel {
            if (model.orderModel?.cancel_btn_text!.isEmpty)!{
                bottomBtn.isHidden = true
                bottomBtn.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }else{
                bottomBtn.isHidden = false
                bottomBtn.setTitle(model.orderModel?.cancel_btn_text, for: .normal)
                bottomBtn.snp.updateConstraints { (make) in
                    make.height.equalTo(kBottomTabbarHeight)
                }
            }
            
            headerView.containerView.kf.setImage(with: URL.init(string: (model.formData?.thumb)!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
        }
    }
    
    /// 取消课程
    @objc func onclickedOperator(){
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确定取消订单吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") {[unowned self] (tag) in
            
            if tag != cancelIndex{
                self.requestCancleOrder()
            }
        }
    }
    
    /// 取消订单
    func requestCancleOrder(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/Order/cancel", parameters: ["id":goodsId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isModify = true
                weakSelf?.bottomBtn.isHidden = true
                weakSelf?.bottomBtn.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSMyCourseDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: myCourseDetailCell) as! FSGoodsDetailCell
            
            cell.dataModel = dataModel?.formData
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: myCourseDetailInfoCell) as! FSFindCourseDetailDesCell
            
            if indexPath.row == 1 {//课程介绍
                cell.nameLab.text = "课程介绍"
                cell.desLab.text = dataModel?.formData?.content
            }else if indexPath.row == 2 {//适用人群
                cell.nameLab.text = "适用人群"
                cell.desLab.text = dataModel?.formData?.for_people
            }else if indexPath.row == 3 {//课程须知
                cell.nameLab.text = "课程须知"
                cell.desLab.text = dataModel?.formData?.notes
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
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }
}
extension FSMyCourseDetailVC{
    override var shouldAutorotate: Bool{
        
        return (self.player?.shouldAutorotate)!
    }
    //viewController所支持的全部旋转方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if player != nil && (self.player?.isFullScreen)! && self.player?.orientationObserver.fullScreenMode == .landscape {
            return .landscape
        }
        return .portrait
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if player != nil && self.player!.isFullScreen {
            return .lightContent
        }
        return .default
    }
    override var prefersStatusBarHidden: Bool{
        /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
        return player == nil ? false : (self.player?.isStatusBarHidden)!
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
}
