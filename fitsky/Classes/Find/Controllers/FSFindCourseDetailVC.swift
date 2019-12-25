//
//  FSFindCourseDetailVC.swift
//  fitsky
//  发现 课程详情
//  Created by gouyz on 2019/10/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import ZFPlayer

private let findCourseDetailInfoCell = "findCourseDetailInfoCell"
private let findCourseDetailDesCell = "findCourseDetailDesCell"
private let findCourseDetailNumCell = "findCourseDetailNumCell"
private let findCourseDetailHeader = "findCourseDetailHeader"
private let findCourseDetailTuiJianCell = "findCourseDetailTuiJianCell"

class FSFindCourseDetailVC: GYZWhiteNavBaseVC {
    
    var player:ZFPlayerController?
    let titleArr: [String] = ["课程介绍","建议周期","课程特色","注意事项"]
    var courseId: String = ""
    
    var dataModel: FSFindCourseDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "课程介绍"
        self.view.backgroundColor = kWhiteColor
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_icon_more_gray")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedRightBtn))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.tableHeaderView = headerView
        
        headerView.playBtn.addTarget(self, action: #selector(onClickedPlay), for: .touchUpInside)
        
        showVideo()
        
        requestCourseInfo()
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
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 200
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSFindCourseDetailInfoCell.classForCoder(), forCellReuseIdentifier: findCourseDetailInfoCell)
        table.register(FSFindCourseDetailDesCell.classForCoder(), forCellReuseIdentifier: findCourseDetailDesCell)
        table.register(FSFindCourseStudyNumCell.classForCoder(), forCellReuseIdentifier: findCourseDetailNumCell)
        table.register(FSFindSupportCourseCell.classForCoder(), forCellReuseIdentifier: findCourseDetailTuiJianCell)
        table.register(LHSGeneralHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: findCourseDetailHeader)
        
        return table
    }()
    /// 底部view
    lazy var bottomView: FSGoodsDetailBottomView = FSGoodsDetailBottomView()
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
                requestCourseMember()
                self.player?.assetURL = URL.init(string: (model.formData?.video)!)!
                self.controlView.showTitle("", coverURLString: model.formData?.thumb, fullScreenMode: .landscape)
            }
        }
    }
    ///课程基本信息
    func requestCourseInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Course/Course/info", parameters: ["id":courseId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSFindCourseDetailModel.init(dict: data)
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
            
            headerView.containerView.kf.setImage(with: URL.init(string: (model.formData?.thumb)!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
        }
    }
    
    ///添加视频学习人数、播放次数
    func requestCourseMember(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        GYZNetWork.requestNetwork("Course/Course/setCourseMember", parameters: ["id":courseId],  success: { (response) in
            
            GYZLog(response)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    ///收藏（取消收藏）
    @objc func requestFavourite(){
        
        if dataModel == nil {
            return
        }
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberCollect/add", parameters: ["content_id":courseId,"type":(dataModel?.formData?.more_type)!],  success: { (response) in
            
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
    
    /// 发现课程详情
    func goFindCourseDetailVC(id: String){
        let vc = FSFindCourseDetailVC()
        vc.courseId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSFindCourseDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 4
        }else if section == 3 {
            if dataModel != nil {
                return (dataModel?.recommendList.count)!
            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: findCourseDetailInfoCell) as! FSFindCourseDetailInfoCell
            
            cell.dataModel = dataModel
            cell.favouriteBtn.addTarget(self, action: #selector(requestFavourite), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: findCourseDetailDesCell) as! FSFindCourseDetailDesCell
            
            cell.nameLab.text = titleArr[indexPath.row]
            if indexPath.row == 0 {
                cell.desLab.text = dataModel?.formData?.content
            }else if indexPath.row == 1 {
                cell.desLab.text = dataModel?.formData?.proposed_cycle
            }else if indexPath.row == 2 {
                cell.desLab.text = dataModel?.formData?.course_features
            }else if indexPath.row == 3 {
                cell.desLab.text = dataModel?.formData?.precautions
            }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: findCourseDetailNumCell) as! FSFindCourseStudyNumCell
            
            cell.dataModel = dataModel
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: findCourseDetailTuiJianCell) as! FSFindSupportCourseCell
            
            cell.dataModel = dataModel?.recommendList[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 3 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: findCourseDetailHeader) as! LHSGeneralHeaderView
            
            headerView.nameLab.text = "课程推荐"
            
            return headerView
        }
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {// 推荐课程
            goFindCourseDetailVC(id: (self.dataModel?.recommendList[indexPath.row].id)!)
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return kTitleHeight
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }
}
extension FSFindCourseDetailVC{
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
