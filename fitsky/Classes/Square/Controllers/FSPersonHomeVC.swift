//
//  FSPersonHomeVC.swift
//  fitsky
//  个人主页
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import JXPagingView
import MBProgressHUD

class FSPersonHomeVC: GYZWhiteNavBaseVC {

    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    let JXTableHeaderViewHeight: Int = 200
    var titles: [String] = ["主页", "相册", "作品"]
    
    var userId: String = ""
    /// 会员类型（1-普通 2-达人 3-场馆）
    var userType: String = "2"
    var userModel: FSSquareUserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if userType == "1" {
            titles = ["主页", "相册"]
        }
        
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
        userHeaderView.numDesLab.addOnClickListener(target: self, action: #selector(onClickedFollowAndFenSi))
        userHeaderView.followNumLab.addOnClickListener(target: self, action: #selector(onClickedFollowAndFenSi))
        userHeaderView.fenSiNumLab.addOnClickListener(target: self, action: #selector(onClickedFollowAndFenSi))
        
        
        requestUserInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
            
            /// 会员类型（1-普通 2-达人 3-场馆）
            userHeaderView.vipImgView.isHidden = false
            navBarView.vipImgView.isHidden = false
            if userModel?.formData?.type == "2"{
                userHeaderView.vipImgView.image = UIImage.init(named: "app_icon_daren")
                navBarView.vipImgView.image = UIImage.init(named: "app_icon_daren")
            }else if userModel?.formData?.type == "3"{
                userHeaderView.vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                navBarView.vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
            }else{
                userHeaderView.vipImgView.isHidden = true
                navBarView.vipImgView.isHidden = true
            }
            navBarView.nameLab.text = userModel?.formData?.nick_name
            var sexName: String = ""
//            var headerImg: String = "app_img_avatar_def"
            if userModel?.formData?.sex == "0"{
                sexName = "app_icon_sex_woman"
//                headerImg = "app_img_avatar_def_woman"
            }else if userModel?.formData?.sex == "1"{
                sexName = "app_icon_sex_man"
//                headerImg = "app_img_avatar_def_man"
            }
            userHeaderView.userImgView.kf.setImage(with: URL.init(string: (userModel?.formData?.avatar)!), placeholder: UIImage.init(named: "app_img_avatar_def"))
            navBarView.userImgView.kf.setImage(with: URL.init(string: (userModel?.formData?.avatar)!), placeholder: UIImage.init(named: "app_img_avatar_def"))
            userHeaderView.nameBtn.set(image: UIImage.init(named: sexName), title: (userModel?.formData?.nick_name)!, titlePosition: .left, additionalSpacing: 5, state: .normal)
            userHeaderView.followNumLab.text = "关注 \((userModel?.formData?.follow)!)"
            userHeaderView.fenSiNumLab.text = "粉丝 \((userModel?.formData?.fans)!)"
            userHeaderView.confirmLab.text = "认证：\((userModel?.formData?.type_text)!)"
            
            
            userHeaderView.birthdayLab.text = userModel?.formData?.birthday
            userHeaderView.addressLab.text = (userModel?.formData?.province)! + (userModel?.formData?.city)! + (userModel?.formData?.county)!
            userHeaderView.uidLab.text = userModel?.formData?.unique_id
            userHeaderView.registerLab.text = userModel?.formData?.register_date
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
        vc.type = "11"
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
extension FSPersonHomeVC: JXPagingViewDelegate {
    
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
            let homeVC = FSPersonHomeListVC()
            homeVC.userId = self.userId
            homeVC.naviController = self.navigationController
            return homeVC
        }else if index == 1 {
            let ablumVC = FSPersonHomeAblumVC()
            ablumVC.naviController = self.navigationController
            ablumVC.userId = self.userId
            return ablumVC
        }else{
            let worksVC = FSPersonHomeWorksVC()
            worksVC.naviController = self.navigationController
            worksVC.userId = self.userId
//            worksVC.isMySelf = userModel?.friend_type == "3" ? true : false
            return worksVC
        }
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        var percent = scrollView.contentOffset.y/100
        percent = max(0, min(1, percent))
        navBarView.alpha = percent
    }
}

extension FSPersonHomeVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
        //            navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
    }
}
