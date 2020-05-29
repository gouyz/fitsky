//
//  FSSquareVC.swift
//  fitsky
//  广场
//  Created by gouyz on 2019/8/17.
//  Copyright © 2019 gyz. All rights reserved.
//{
//　　"aps" :
//            {
//                 "alert" : "You got your emails.",
//                 "badge" : 1,
//                 "sound" : "default"
//            },
//     "rc":{
//                 "cType":"PR",
//                 "fId":"2121",
//                 "oName":"RC:TxtMsg",
//                 "tId":"3232",
//                 "rId":"3243",
//                 "id":"5FSClm2gQ9V9BZ-kUZn58B",
//                 "rc-dlt-identifier":"2FSClm2gQ9Q9BZ-kUZn54B"
//     },
//     "appData":"xxxx"
//}

//

import UIKit
import JXSegmentedView
import JXPagingView
import PYSearch

class FSSquareVC: GYZWhiteNavBaseVC {
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    let JXTableHeaderViewHeight: Int = Int(kTitleAndStateHeight)
    let titles = ["热门", "关注", "话题", "附近"]
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(pagingView)
        pagingView.snp.makeConstraints { (make) in
            //            make.top.equalTo(kTitleAndStateHeight)
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        segmentedView.contentScrollView = pagingView.listContainerView.collectionView
        //导航栏隐藏就是设置pinSectionHeaderVerticalOffset属性即可，数值越大越往下沉
        pagingView.pinSectionHeaderVerticalOffset = Int(kStateHeight)
        
        self.view.addSubview(navBarView)
        navBarView.addSubview(cityView)
        cityView.addSubview(cityLab)
        cityView.addSubview(cityImgView)
        navBarView.addSubview(searchView)
        navBarView.addSubview(lineView)
        self.view.addSubview(publishImgView)
        
        navBarView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(kTitleAndStateHeight)
        }
        cityView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.width.equalTo(70)
            make.top.equalTo(kStateHeight)
            make.bottom.equalTo(lineView.snp.top)
        }
        cityLab.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(cityView)
            make.width.equalTo(50)
        }
        cityImgView.snp.makeConstraints { (make) in
            make.left.equalTo(cityLab.snp.right)
            make.centerY.equalTo(cityView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        searchView.snp.makeConstraints { (make) in
            make.left.equalTo(cityView.snp.right).offset(5)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(cityView)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(navBarView)
            make.height.equalTo(klineWidth)
        }
        
        publishImgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 54, height: 54))
        }
        
        searchView.searchBtn.set(image: UIImage.init(named: "app_icon_seach"), title: "搜索文章、用户、话题、附近", titlePosition: .right, additionalSpacing: kMargin, state: .normal)
        
        cityLab.text = "常州"
        searchView.searchBtn.addTarget(self, action: #selector(onClickedSearch), for: .touchUpInside)
        publishImgView.addOnClickListener(target: self, action: #selector(onClickedPublish))
        
        /// 极光推送跳转指定页面
        NotificationCenter.default.addObserver(self, selector: #selector(refreshJPushView(noti:)), name: NSNotification.Name(rawValue: kJPushRefreshData), object: nil)
        
        //如果未登录进入登录界面，登录后进入首页
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            if userDefaults.string(forKey: CURRDayPunch) != Date().dateToStringWithFormat(format: "yyyy-MM-dd") {
                requestPunch()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isSearch {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 获取当前选择城市
        if let currModel =  userDefaults.data(forKey: CURRCITYINFO){
            let currCityModel = NSKeyedUnarchiver.unarchiveObject(with: currModel) as? FSCityListModel
            
            cityLab.text = currCityModel?.name
            //            cityBtn.set(image: UIImage.init(named: "app_square_location"), title: (currCityModel?.name)!, titlePosition: .left, additionalSpacing: 5, state: .normal)
        }
        
        isSearch = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    lazy var pagingView: JXPagingView = {
        let pageView = JXPagingListRefreshView(delegate: self) //JXPagingView.init(delegate: self)
        
        return pageView
    }()
    lazy var segmentedView: JXSegmentedView = {
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleNormalColor = kHeightGaryFontColor
        segmentedViewDataSource.titleSelectedColor = kOrangeFontColor
        segmentedViewDataSource.titleNormalFont = UIFont.boldSystemFont(ofSize: 16)
        segmentedViewDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 16)
        segmentedViewDataSource.titles = titles
        //reloadData(selectedIndex:)一定要调用
        segmentedViewDataSource.reloadData(selectedIndex: 0)
        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor = kOrangeFontColor
        
        let segView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight))
        segView.delegate = self
        segView.backgroundColor = kWhiteColor
        segView.dataSource = segmentedViewDataSource
        segView.indicators = [indicator]
        
        return segView
    }()
    
    lazy var navBarView: UIView = {
        let navView = UIView()
        navView.backgroundColor = kWhiteColor
        navView.isUserInteractionEnabled = true
        
        return navView
    }()
    lazy var cityView: UIView = {
        let navView = UIView()
        navView.backgroundColor = kWhiteColor
        navView.addOnClickListener(target: self, action: #selector(clickedCityBtn))
        
        return navView
    }()
    /// 城市
    lazy var cityLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.textAlignment = .center
        return lab
    }()
    lazy var cityImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_square_location"))
    /// 搜索
    lazy var searchView: GYZSearchBtnView = GYZSearchBtnView()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    /// 发布
    lazy var publishImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_publish"))
    
    /// 选择当前城市
    @objc func clickedCityBtn(){
        
        let vc = FSSelectCityVC()
        let cityNav = GYZBaseNavigationVC(rootViewController:vc)
        self.present(cityNav, animated: true, completion: nil)
    }
    /// 搜索
    @objc func onClickedSearch(){
        isSearch = true
        let searchVC: PYSearchViewController = PYSearchViewController.init(hotSearches: [], searchBarPlaceholder: "搜索文章、用户、话题、附近") { (searchViewController, searchBar, searchText) in
            
            let searchVC = FSSquareSearchVC()
            searchVC.searchContent = searchText!
            searchViewController?.navigationController?.pushViewController(searchVC, animated: true)
        }
        
        let searchNav = GYZBaseNavigationVC(rootViewController:searchVC)
        //
        searchVC.cancelButton.setTitleColor(kHeightGaryFontColor, for: .normal)
        
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            searchVC.searchBar.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            searchVC.searchBarBackgroundColor = kGrayBackGroundColor
        }
        //显示输入光标
        searchVC.searchBar.tintColor = kHeightGaryFontColor
        self.present(searchNav, animated: true, completion: nil)
    }
    /// 发布
    @objc func onClickedPublish(){
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["发表文字","拍照","来自手机相册"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kGaryFontColor
        actionSheet.itemTextFont = k15Font
        actionSheet.didSelectIndex = {[weak self] (index,title) in
            if index == 0{//发表文字
                self?.goPublishDynamic()
            }else if index == 1{/// 拍照
                self?.goCameraVC()
            }else if index == 2{/// 来自手机相册
                self?.goSelectPhotoVC()
            }
        }
    }
    /// 手机相册
    func goSelectPhotoVC(){
        let vc = FSSelectPhotosVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func goCameraVC(){
        let vc = FSMagicCameraVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //发表文字
    func goPublishDynamic(){
        let vc = FSPublishDynamicVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///每天打卡
    func requestPunch(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        GYZNetWork.requestNetwork("Member/MemberPunch/add",parameters: nil,  success: { (response) in
            
            GYZLog(response)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                userDefaults.set(Date().dateToStringWithFormat(format: "yyyy-MM-dd"), forKey: CURRDayPunch)
            }
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    /// 推送，跳转指定页面
    ///
    /// - Parameter noti:
    @objc func refreshJPushView(noti:NSNotification){
        
        let userInfo = noti.userInfo!
        if userInfo.keys.contains("payload") {
            let payloadMsg = userInfo["payload"] as! String
            let payloadDic = payloadMsg.convertStringToDictionary()
            let paramDic = payloadDic!["payload"] as! [String: Any]
            
            /// push_type推送类型（1-点赞 2-收藏 3-评论 4-回复 5-通知 6-订阅号）
            /// 目前用到：
            /// content_type 内容类型（1-动态（作品）13-场馆服务商品 15-系统通知 16-订阅号）
            
            let type = paramDic["content_type"] as! Int
            let contentId = paramDic["content_id"] as! Int
            let pushType = paramDic["push_type"] as! Int
            
            switch pushType {
            case 1:// 点赞
                let isOpus = paramDic["is_opus"] as! Int
                let commentId = paramDic["comment_id"] as! Int
                if type == 1 && commentId > 0 {// 评论
                    goConmentVC(id: "\(contentId)",type: "\(type)")
                }else if type == 1 && isOpus == 1 {// 是否作品
                    goWorksDetailVC(id: "\(contentId)")
                }else{
                    goDynamicDetailVC(id: "\(contentId)")
                }
            case 2:// 收藏
                let isOpus = paramDic["is_opus"] as! Int
                if type == 1 && isOpus == 1 {// 是否作品
                    goWorksDetailVC(id: "\(contentId)")
                }else if type == 1 {// 动态
                    goDynamicDetailVC(id: "\(contentId)")
                }else if type == 13 {// 课程
                    goDetailVC(goodsId: "\(contentId)")
                }
            case 3:// 评论
                goConmentVC(id: "\(contentId)",type: "\(type)")
            case 4:// 回复
                let commentId = paramDic["comment_id"] as! Int
                goReplyVC(id: "\(commentId)")
            case 5:// 系统通知
                let vc = FSMsgNoticeVC()
                self.navigationController?.pushViewController(vc, animated: true)
            case 6:// 订阅号通知
                let vc = FSSubscriptionVC()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }else{ // 聊天推送
            goMyMessage()
        }
        
    }
    /// 消息
    func goMyMessage(){
        let vc = FSMessageVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 回复
    func goReplyVC(id: String){
        let vc = FSAllReplyMsgVC()
        vc.conmentId = id
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 全部评论
    func goConmentVC(id: String,type:String){
        let vc = FSAllConmentVC()
        vc.contentId = id
        vc.type = type
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 动态详情
    func goDynamicDetailVC(id: String){
        let vc = FSHotDynamicVC()
        vc.dynamicId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 作品详情
    func goWorksDetailVC(id: String){
        let vc = FSSquareFollowDetailVC()
        vc.dynamicId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 课程详情
    func goDetailVC(goodsId: String){
        let vc = FSServiceGoodsDetailVC()
        vc.goodsId = goodsId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSSquareVC: JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return UIView()
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(kTitleHeight)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 1 { // 关注
            let zongHeVC = FSSearchZongHeVC()
            zongHeVC.type = "3"
            zongHeVC.naviController = self.navigationController
            return zongHeVC
        }else if index == 2 {// 话题
            let zongHeVC = FSSquareTopicVC()
            zongHeVC.naviController = self.navigationController
            return zongHeVC
        }else if index == 3 {// 附近
            let nearVC = FSSquareNearVC()
            nearVC.naviController = self.navigationController
            return nearVC
        }
        let vc = FSSquareHotVC()
        vc.naviController = self.navigationController
        return vc
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        var percent = scrollView.contentOffset.y/kTitleHeight
        percent = max(0, min(1, percent))
        navBarView.alpha = 1 - percent
    }
}

extension FSSquareVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
        //            navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
        //            if index != 1 {
        //                publishImgView.isHidden = false
        //            }else{
        //                publishImgView.isHidden = true
        //            }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
    }
}
