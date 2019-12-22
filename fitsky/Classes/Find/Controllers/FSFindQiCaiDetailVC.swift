//
//  FSFindQiCaiDetailVC.swift
//  fitsky
//  器材详情
//  Created by gouyz on 2019/10/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import ZFPlayer
import MBProgressHUD

private let findQiCaiDetailCell = "findQiCaiDetailCell"
private let findQiCaiDetailHeader = "findQiCaiDetailHeader"

class FSFindQiCaiDetailVC: GYZWhiteNavBaseVC {
    
    var player:ZFPlayerController?
    var wkHeight: CGFloat = kTitleHeight
    
    var qiCaiId: String = ""
    var dataModel : FSQiCaiDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kWhiteColor
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_icon_more_gray")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedRightBtn))
        
        headerView.addSubview(containerView)
        containerView.addSubview(playBtn)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        playBtn.snp.makeConstraints { (make) in
            make.center.equalTo(containerView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
        }
        tableView.tableHeaderView = headerView
        
        showVideo()
        
        requestQiCaiInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player?.isViewControllerDisappear = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        self.player?.isViewControllerDisappear = true
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 140
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSFindQiCaiDetailCell.classForCoder(), forCellReuseIdentifier: findQiCaiDetailCell)
        table.register(FSFindQiCaiDetailDesHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: findQiCaiDetailHeader)
        
        
        return table
    }()
    
    lazy var headerView:UIView = {
        let headerView = UIView()
        headerView.backgroundColor = kWhiteColor
        headerView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 210.0 / 375.0)
        
        return headerView
    }()
    
    lazy var containerView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.setImageWithURLString("", placeholder: ZFUtilities.image(with: UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1), size: CGSize.init(width: 1, height: 1)))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 开始
    lazy var playBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_square_play"), for: .normal)
        btn.addTarget(self, action: #selector(onClickedPlay), for: .touchUpInside)
        
        return btn
    }()
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
        self.player = ZFPlayerController.init(scrollView: self.tableView, playerManager: playerManager, containerView: self.containerView)
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
    /// 更多
    @objc func clickedRightBtn(){
        if dataModel != nil {
            let mmShareSheet = MMShareSheet.init(title: "分享至", cards: [kSharedCards], duration: nil, cancelBtn: kSharedCancleBtn)
            mmShareSheet.callBack = { [weak self](handler) ->() in
                
                if handler != "cancel" {// 取消
                    if handler == kWXFriendShared || handler == kWXMomentShared{/// 微信分享
                        self?.weChatShared(tag: handler)
                    }else if handler == kQQFriendShared {// QQ
                        self?.qqShared(tag: handler)
                    }
                }
            }
            mmShareSheet.present()
        }
    }
    /// 微信分享
    func weChatShared(tag: String){
        //发送给好友还是朋友圈（默认好友）
        var scene = WXSceneSession
        if tag == kWXMomentShared {//朋友圈
            scene = WXSceneTimeline
        }
        
        WXApiManager.shared.sendLinkURL((dataModel?.sharedModel?.link)!, title: (dataModel?.sharedModel?.title)!, description: (dataModel?.sharedModel?.desc)!, thumbImage: (dataModel?.sharedModel?.img_url)!.getImageFromURL()!, scene: scene,sender: self)
    }
    /// qq 分享
    func qqShared(tag: String){
        
        if !GYZTencentShare.shared.isQQInstall() {
            GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "QQ未安装", cancleTitle: nil, viewController: self, buttonTitles: "确定")
            return
        }
        //发送给好友还是QQ空间（默认好友）
        let scene: GYZTencentFlag = .QQ
        //        if tag == kQZoneShared {//QQ空间
        //            scene = .QZone
        //        }
        GYZTencentShare.shared.shareNews(URL.init(string: (dataModel?.sharedModel?.link)!)!, preUrl: URL.init(string: (dataModel?.sharedModel?.img_url)!), preImage: nil, title: (dataModel?.sharedModel?.title)!, description: (dataModel?.sharedModel?.desc)!, flag: scene) { (success, description) in
            
        }
    }
    /// 播放、暂停
    @objc func onClickedPlay(){
        if let model = dataModel {
            if !(model.formData?.video!.isEmpty)!{
                self.requestQiCaiMember()
                self.player?.assetURL = URL.init(string: (model.formData?.video)!)!
                self.controlView.showTitle("", coverURLString: model.formData?.thumb, fullScreenMode: .landscape)
            }
        }
    }
    
    ///器材基本信息
    func requestQiCaiInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Course/Instrument/info", parameters: ["id":qiCaiId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSQiCaiDetailModel.init(dict: data)
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
            
            containerView.kf.setImage(with: URL.init(string: (model.formData?.thumb)!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
        }
    }
    
    ///添加视频学习人数、播放次数
    func requestQiCaiMember(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        GYZNetWork.requestNetwork("Course/Course/setInstrumentMember", parameters: ["id":qiCaiId],  success: { (response) in
            
            GYZLog(response)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    ///收藏（取消收藏）
    @objc func requestFavourite(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberCollect/add", parameters: ["content_id":qiCaiId,"type":(dataModel?.formData?.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataModel?.moreModel?.is_collect = data["status"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension FSFindQiCaiDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: findQiCaiDetailCell) as! FSFindQiCaiDetailCell
        
        cell.dataModel = dataModel
        cell.favouriteBtn.addTarget(self, action: #selector(requestFavourite), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: findQiCaiDetailHeader) as! FSFindQiCaiDetailDesHeaderView
            
            
            if wkHeight <= kTitleHeight {
                if let model = dataModel {
                    headerView.loadContent(url: (model.formData?.content)!)
                }
                headerView.resultHeightBlock = {[unowned self] (height) in
                    self.wkHeight = height
                    self.tableView.reloadData()
                }
            }
            
            /// 超出部分裁剪
            headerView.contentView.clipsToBounds = true
            
            return headerView
        }
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return wkHeight
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        scrollView.zf_scrollViewDidScroll()
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = kTitleAndStateHeight + kStateHeight - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
            self.navigationItem.title = dataModel == nil ? "": dataModel?.formData?.name
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
        }
    }
}
extension FSFindQiCaiDetailVC{
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
