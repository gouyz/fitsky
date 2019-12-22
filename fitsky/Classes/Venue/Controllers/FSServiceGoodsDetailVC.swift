//
//  FSServiceGoodsDetailVC.swift
//  fitsky
//  服务详情 课程介绍
//  Created by gouyz on 2019/9/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import ZFPlayer

private let serviceGoodsDetailCell = "serviceGoodsDetailCell"
private let serviceGoodsDetailInfoCell = "serviceGoodsDetailInfoCell"

class FSServiceGoodsDetailVC: GYZWhiteNavBaseVC {
    
    var goodsId: String = ""
    var dataModel: FSServiceGoodsDetailModel?
    
    var player:ZFPlayerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "课程介绍"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_link_kefu")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedLinkKeFuBtn))
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(kTabBarHeight)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-kTabBarHeight)
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
        
        bottomView.onClickedOperatorBlock = {[unowned self] (index) in
            if index == 101 {// 收藏
                self.requestFavourite()
            }else if index == 102{// 加入学习
                self.goSelectCoachVC()
            }
        }
        
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
        
        table.register(FSGoodsDetailCell.classForCoder(), forCellReuseIdentifier: serviceGoodsDetailCell)
        table.register(FSFindCourseDetailDesCell.classForCoder(), forCellReuseIdentifier: serviceGoodsDetailInfoCell)
        
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
        
        GYZNetWork.requestNetwork("Store/Goods/info", parameters: ["id":goodsId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSServiceGoodsDetailModel.init(dict: data)
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
            let originalPrice: String = String(format: "%.2f", Float((model.formData?.original_price)!)!)
            let str = "￥" + String(format: "%.2f", Float((model.formData?.price)!)!) + "  ￥" + originalPrice
            let count: Int = originalPrice.count
            
            let price : NSMutableAttributedString = NSMutableAttributedString(string: str)
            price.addAttribute(NSAttributedString.Key.font, value: k13Font, range: NSMakeRange(str.count - count - 1, count + 1))
            price.addAttribute(NSAttributedString.Key.foregroundColor, value: kGaryFontColor, range: NSMakeRange(str.count - count - 1, count + 1))
            
            price.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(str.count - count - 1, count + 1))
            price.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(str.count - count - 1, count + 1))
            bottomView.priceLab.attributedText = price
            
            if model.moreModel?.is_collect == "1"{
                bottomView.favouriteLab.text = "取消收藏"
            }else{
                bottomView.favouriteLab.text = "收藏"
            }
            
            headerView.containerView.kf.setImage(with: URL.init(string: (model.formData?.thumb)!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
        }
    }
    
    ///收藏（取消收藏）
    func requestFavourite(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberCollect/add", parameters: ["content_id":goodsId,"type":(dataModel?.formData?.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                if data["status"].stringValue == "1"{
                    weakSelf?.bottomView.favouriteLab.text = "取消收藏"
                }else{
                    weakSelf?.bottomView.favouriteLab.text = "收藏"
                }
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 加入学习
    func goSelectCoachVC(){
        let vc = FSBuyGoodsVC()
        vc.goodsId = self.goodsId
        if dataModel != nil {
            vc.kefuPhone = (dataModel?.formData?.tel)!
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSServiceGoodsDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: serviceGoodsDetailCell) as! FSGoodsDetailCell
            
            cell.dataModel = dataModel?.formData
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: serviceGoodsDetailInfoCell) as! FSFindCourseDetailDesCell
            
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
extension FSServiceGoodsDetailVC{
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
