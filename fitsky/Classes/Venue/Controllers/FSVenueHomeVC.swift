//
//  FSVenueHomeVC.swift
//  fitsky
//  场馆主页
//  Created by gouyz on 2019/9/8.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import JXPagingView
import MBProgressHUD

class FSVenueHomeVC: GYZWhiteNavBaseVC {

    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    let JXTableHeaderViewHeight: Int = 200
    let titles = ["主页", "场馆", "服务", "教练"]
    
    var userId: String = ""
    var userModel: FSSquareUserModel?
    
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
        pagingView.pinSectionHeaderVerticalOffset = Int(kTitleAndStateHeight)
        
        self.view.addSubview(navBarView)
        navBarView.alpha = 0
        
        userHeaderView.leftBtn.addTarget(self, action: #selector(onClickedLeft), for: .touchUpInside)
        userHeaderView.rightBtn.addTarget(self, action: #selector(onClickedRight), for: .touchUpInside)
        navBarView.leftBtn.addTarget(self, action: #selector(onClickedLeft), for: .touchUpInside)
        navBarView.rightBtn.addTarget(self, action: #selector(onClickedRight), for: .touchUpInside)
        userHeaderView.numLab.addOnClickListener(target: self, action: #selector(onClickedFollowAndFenSi))
        userHeaderView.userImgView.addOnClickListener(target: self, action: #selector(onClickedPlayVideo))
        
        requestUserInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        segmentedViewDataSource.titleNormalFont = UIFont.boldSystemFont(ofSize: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 15)
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
    /// 导航栏View
    lazy var navBarView: FSNavUserInfoView = FSNavUserInfoView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTitleAndStateHeight))
    // header
    lazy var userHeaderView: FSPersonHomeHeaderView = FSPersonHomeHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: CGFloat.init(JXTableHeaderViewHeight)))
    
    ///用户基本信息
    func requestUserInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/MemberFriend/home", parameters: ["friend_id":userId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.userModel = FSSquareUserModel.init(dict: data)
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
        if userModel != nil {
            if userModel?.formData?.friend_type == "3"{// 自己时，隐藏举报
                userHeaderView.rightBtn.isHidden = true
                navBarView.rightBtn.isHidden = true
            }
            if  !(userModel?.storeData?.video)!.isEmpty {
                userHeaderView.boardView.isHidden = false
            }
            userHeaderView.userImgView.kf.setImage(with: URL.init(string: (userModel?.storeData?.store_logo_thumb)!), placeholder: UIImage.init(named: "app_img_avatar_def"))
            navBarView.userImgView.kf.setImage(with: URL.init(string: (userModel?.storeData?.store_logo_thumb)!), placeholder: UIImage.init(named: "app_img_avatar_def"))
            
            /// 会员类型（1-普通 2-达人 3-场馆）
            userHeaderView.vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
            navBarView.vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
            
            navBarView.nameLab.text = userModel?.storeData?.store_name
      
            userHeaderView.nameBtn.setTitle((userModel?.storeData?.store_name)!, for: .normal)
            userHeaderView.numLab.text = "关注 \((userModel?.formData?.follow)!) | 粉丝 \((userModel?.formData?.fans)!)"
            userHeaderView.confirmLab.text = "认证：\((userModel?.formData?.type_text)!)"
            
            
            userHeaderView.birthdayLab.text = userModel?.storeData?.area_text
            userHeaderView.addressLab.text = userModel?.storeData?.address
//                (userModel?.storeData?.province)! + (userModel?.storeData?.city)! + (userModel?.storeData?.county)! + (userModel?.storeData?.address)!
            userHeaderView.uidLab.text = userModel?.formData?.unique_id
            userHeaderView.registerLab.text = userModel?.formData?.register_date
        }
    }
    // 播放场馆视频宣传
    @objc func onClickedPlayVideo(){
        if let model = userModel {
            if  !(model.storeData?.video)!.isEmpty {
                let vc = FSVenueVideoView.init(model: userModel!)
                vc.show()
            }
        }
    }
    /// 返回
    @objc func onClickedLeft(){
        self.clickedBackBtn()
    }
    /// 更多
    @objc func onClickedRight(){
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["举报"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kWhiteColor
        actionSheet.itemTextFont = k15Font
        actionSheet.itemBgColor = UIColor.UIColorFromRGB(valueRGB: 0x777777)
        actionSheet.didSelectIndex = {[weak self] (index,title) in
            if index == 0{//举报
                self?.goComplainVC()
            }
        }
    }
    /// 评论投诉
    func goComplainVC(){
        let vc = FSComplainVC()
        vc.type = userModel != nil ? (userModel?.storeData?.more_type)! : "12"
        vc.contentId = userId
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 关注、粉丝
    @objc func onClickedFollowAndFenSi(){
        let vc = FSFollowAndFenSiVC()
        vc.userId = self.userId
        vc.sex = (userModel?.formData?.sex)!
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSVenueHomeVC: JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderView
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
        if index == 0 {
            let homeVC = FSVenueHomeListVC()
            homeVC.userId = self.userId
            homeVC.naviController = self.navigationController
            return homeVC
        }else if index == 1 {
            let infoVC = FSVenueInfoVC()
            infoVC.userModel = self.userModel
            infoVC.naviController = self.navigationController
            return infoVC
        }else if index == 2 {
            let serviceVC = FSVenueServiceVC()
            serviceVC.naviController = self.navigationController
            serviceVC.userId = self.userId
            serviceVC.userModel = self.userModel
            return serviceVC
        }else{
            let teacherVC = FSVenueTeacherVC()
            teacherVC.naviController = self.navigationController
            teacherVC.userId = self.userId
            return teacherVC
        }
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        var percent = scrollView.contentOffset.y/100
        percent = max(0, min(1, percent))
        navBarView.alpha = percent
    }
}

extension FSVenueHomeVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
        //            navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
    }
}

