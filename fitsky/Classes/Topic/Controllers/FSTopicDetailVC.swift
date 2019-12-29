//
//  FSTopicDetailVC.swift
//  fitsky
//  话题详情
//  Created by gouyz on 2019/9/5.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let topicDetailCell = "topicDetailCell"
private let topicDetailMsgHeader = "topicDetailMsgHeader"
private let topicDetailHeader = "topicDetailHeader"
private let topicDetailEmptyFooter = "topicDetailEmptyFooter"

private let topicCustomPopupMenuCell = "topicCustomPopupMenuCell"

class FSTopicDetailVC: GYZWhiteNavBaseVC {
    
    let imageHeight: CGFloat = 180 + kStateHeight
    
    var topicId: String = ""
    let sortTitles: [String] = ["热度","时间"]
    var rightManagerTitles: [String] = [String]()
    var topicArr: [String] = [String]()
    var sortIndex: Int = 0
    
    var dataModel: FSTopicDetailModel?
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var dataList: [FSSquareHotModel] = [FSSquareHotModel]()
    var isRefresh: Bool = false
    
    var browser:SKPhotoBrowser?

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
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
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
        }
        
        bgImgView.addSubview(topicImgView)
        bgImgView.addSubview(nameLab)
        bgImgView.addSubview(numLab)
        bgImgView.addSubview(talkLab)
        bgImgView.addSubview(hotImgView)
        
        topicImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-24)
            make.size.equalTo(CGSize.init(width: 110, height: 110))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(topicImgView.snp.right).offset(15)
            make.top.equalTo(topicImgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        numLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
            make.right.equalTo(hotImgView.snp.left).offset(-5)
            make.height.equalTo(24)
        }
        talkLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numLab)
            make.top.equalTo(numLab.snp.bottom)
        }
        hotImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.centerY.equalTo(talkLab)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        bgHeaderView.addSubview(bgImgView)
        tableView.tableHeaderView = bgHeaderView
        
        bottomView.onClickedOperatorBlock = {[unowned self] (index) in
            
            if index == 101 { // 参与话题
                self.goPublishDynamic()
            }else if index == 102 { // 创建话题
                self.bottomTopicShowView()
            }
        }
        hotImgView.addOnClickListener(target: self, action: #selector(onClickedActive))
        
        requestTopicInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isRefresh {
            isRefresh = false
        
            dataList.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 100
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSZongHeCell.classForCoder(), forCellReuseIdentifier: topicDetailCell)
        table.register(FSAllConmentHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: topicDetailHeader)
        table.register(FSTopicDetailMsgHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: topicDetailMsgHeader)
        table.register(GYZEmptyFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: topicDetailEmptyFooter)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        ///添加上拉加载更多
        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
            weakSelf?.loadMore()
        })
        
        return table
    }()
    /// 底部菜单view
    lazy var bottomView: FSTopicBottomView = FSTopicBottomView()
    ///
    lazy var rightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_btn_topic_edit"), for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        btn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        
        return btn
    }()

    ///
    lazy var bgHeaderView: UIView = {
        let bgView = UIView()
        bgView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: imageHeight)
        bgView.isUserInteractionEnabled = true
        
        return bgView
    }()
    ///
    lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0x636679)
        imgView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: imageHeight)
        imgView.contentMode = .scaleAspectFill
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 话题图片
    lazy var topicImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.cornerRadius = kCornerRadius
        
        return imgView
    }()
    /// 火
    lazy var hotImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_btn_heat_ranking"))
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kWhiteColor
        
        return lab
    }()
    ///数量
    lazy var numLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        
        return lab
    }()
    ///麦克风
    lazy var talkLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        
        return lab
    }()
    /// 右侧按钮
    @objc func onClickRightBtn(){
        rightManagerTitles.removeAll()
//        rightManagerTitles.append("分享")
        rightManagerTitles.append("管理话题")
        rightManagerTitles.append("申请麦克风")
        rightManagerTitles.append("分享")
//        if dataModel != nil {
//            if dataModel?.formData?.is_admin == "1"{
//                rightManagerTitles.append("管理话题")
//            }
//            if dataModel?.formData?.is_apply_admin == "1"{
//                rightManagerTitles.append("申请麦克风")
//            }
//        }
        YBPopupMenu.showRely(on: rightBtn, titles: rightManagerTitles, icons: nil, menuWidth: 170) { [weak self](popupMenu) in
            popupMenu?.delegate = self
            popupMenu?.isShadowShowing = false
            popupMenu?.textColor = kGaryFontColor
            popupMenu?.tag = 201
            popupMenu?.tableView.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: topicCustomPopupMenuCell)
        }
    }
    
    // 弹出排序
    @objc func onClickedSort(sender:UITapGestureRecognizer){
        YBPopupMenu.showRely(on: sender.view, titles: sortTitles, icons: nil, menuWidth: 170) { [weak self](popupMenu) in
            popupMenu?.delegate = self
            popupMenu?.textColor = kGaryFontColor
            popupMenu?.isShadowShowing = false
            popupMenu?.tag = 202
            popupMenu?.tableView.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: topicCustomPopupMenuCell)
        }
    }
    //发表文字
    func goPublishDynamic(){
        let vc = FSPublishDynamicVC()
        if dataModel != nil {
            vc.topicModel = dataModel?.formData
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// "我的话题","创建话题"
    func bottomTopicShowView(){
        topicArr.removeAll()
        topicArr.append("我的话题")
        topicArr.append("创建话题")
//        if dataModel != nil {
//            topicArr.removeAll()
//            topicArr.append("我的话题")
//            topicArr.append("创建话题")
//            if dataModel?.formData?.is_admin == "1"{
//                topicArr.append("我的话题")
//            }
//            if dataModel?.formData?.is_add_topic == "1"{
//                topicArr.append("创建话题")
//            }
//        }
        if topicArr.count > 0 {
            YBPopupMenu.showRely(on: bottomView.operatorImgView, titles: topicArr, icons: nil, menuWidth: 170) { [weak self](popupMenu) in
                popupMenu?.delegate = self
                popupMenu?.isShadowShowing = false
                popupMenu?.textColor = kGaryFontColor
                popupMenu?.tag = 203
                popupMenu?.tableView.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: topicCustomPopupMenuCell)
            }
        }
    }
    // 活跃度排名
    @objc func onClickedActive(){
        let vc = FSTopicActiveListVC()
        vc.topicId = self.topicId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 设置返回键
    func setBackBtnImage(imgName: String){
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
    }
    
    ///话题基本信息
    func requestTopicInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/TopicPublish/info", parameters: ["id":topicId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSTopicDetailModel.init(dict: data)
                weakSelf?.requestDynamicList()
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
        if let model = dataModel {
            topicImgView.kf.setImage(with: URL.init(string: (model.formData?.thumb)!), placeholder: UIImage.init(named: "icon_bg_square_default"))
            nameLab.text = model.formData?.title
            numLab.text = (model.formData?.dynamic_count_text)! + " " + (model.formData?.read_count_text)!
            
            if !(model.topicAdminModel?.nick_name?.isEmpty)! {
                talkLab.isHidden = false
                talkLab.text = "麦克风：\((model.topicAdminModel?.nick_name)!)"
            }else{
                talkLab.isHidden = true
                talkLab.text = ""
            }
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
    
    ///获取话题 动态列表数据
    func requestDynamicList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/topic",parameters: ["p":currPage,"topic_id": topicId,"orderby": sortIndex + 1],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSSquareHotModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        currPage = 1
        requestDynamicList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestDynamicList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            dataList.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    // 收藏
    @objc func onClickedFavourite(sender:UIButton){
        let tag = sender.tag
        requestFavourite(index: tag)
    }
    // 点赞
    @objc func onClickedZan(sender:UIButton){
        let tag = sender.tag
        requestZan(index: tag)
    }
    ///点赞（取消点赞）
    func requestZan(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        let model = dataList[index]
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberLike/add", parameters: ["content_id":model.id!,"type":(model.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataList[index].like_count = data["count"].stringValue
                weakSelf?.dataList[index].moreModel?.is_like = data["status"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///收藏（取消收藏）
    func requestFavourite(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        let model = dataList[index]
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberCollect/add", parameters: ["content_id":model.id!,"type":(model.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataList[index].collect_count = data["count"].stringValue
                weakSelf?.dataList[index].moreModel?.is_collect = data["status"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    // 评论
    @objc func onClickedShowConment(sender: UIButton){
        let tag = sender.tag
        let model = dataList[tag]
        let vc = FSAllConmentVC()
        vc.contentId = model.id!
        vc.type = model.more_type!
        vc.isLike = (model.moreModel?.is_like)!
        vc.resultBlock = {[unowned self] (isRefresh) in
            if isRefresh {
                self.isRefresh = false
                self.requestDynamicById(dynamicId: self.dataList[tag].id!)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 置顶、删除
    @objc func onClickedDynamicOperator(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        if model.friend_type == "3" {
            
            if dataModel?.formData?.is_admin == "1"{// 麦克风自己的是删除+置顶
                var titleArr : [String] = ["删除"]
                if model.is_top_topic == "1" {
                    titleArr.append("取消置顶")
                }else{
                    titleArr.append("置顶")
                }
                let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: titleArr)
                actionSheet.cancleTextColor = kWhiteColor
                actionSheet.cancleTextFont = k15Font
                actionSheet.itemTextColor = kGaryFontColor
                actionSheet.itemTextFont = k15Font
                actionSheet.didSelectIndex = {[weak self] (index,title) in
                    
                    if index == 0{//删除
                        self?.showDeleteAlert(index: tag!)
                    }else if index == 1{/// 置顶/取消置顶
                        self?.requestTopDynamic(index: tag!)
                    }
                }
            }else{//普通用户自己的是删除
                let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["删除"])
                actionSheet.cancleTextColor = kWhiteColor
                actionSheet.cancleTextFont = k15Font
                actionSheet.itemTextColor = kWhiteColor
                actionSheet.itemTextFont = k15Font
                actionSheet.itemBgColor = UIColor.UIColorFromRGB(valueRGB: 0x777777)
                actionSheet.didSelectIndex = {[weak self] (index,title) in
                    if index == 0{//删除
                        self?.showDeleteAlert(index: tag!)
                    }
                }
            }
        }else{
            if dataModel?.formData?.is_admin == "1"{// 麦克风别人的是举报+置顶
                var titleArr : [String] = ["举报"]
                if model.is_top_topic == "1" {
                    titleArr.append("取消置顶")
                }else{
                    titleArr.append("置顶")
                }
                let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: titleArr)
                actionSheet.cancleTextColor = kWhiteColor
                actionSheet.cancleTextFont = k15Font
                actionSheet.itemTextColor = kGaryFontColor
                actionSheet.itemTextFont = k15Font
                actionSheet.didSelectIndex = {[weak self] (index,title) in
                    
                    if index == 0{//举报
                        self?.goComplainVC(index: tag!)
                    }else if index == 1{/// 置顶/取消置顶
                        self?.requestTopDynamic(index: tag!)
                    }
                }
            }else{//普通用户别人的是举报
                showComplain(tag: tag!)
            }
        }
        
    }
    /// 举报
    func showComplain(tag: Int){
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["举报"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kWhiteColor
        actionSheet.itemTextFont = k15Font
        actionSheet.itemBgColor = UIColor.UIColorFromRGB(valueRGB: 0x777777)
        actionSheet.didSelectIndex = {[weak self] (index,title) in
            if index == 0{//举报
                self?.goComplainVC(index: tag)
            }
        }
    }
    /// 评论投诉
    func goComplainVC(index: Int){
        let model = dataList[index]
        let vc = FSComplainVC()
        vc.type = model.more_type!
        vc.contentId = model.id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 删除提示
    func showDeleteAlert(index: Int){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确定要删除此动态吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (tag) in
            
            if tag != cancelIndex{
                weakSelf?.requestDeleteDynamic(index: index)
            }
        }
    }
    /// 删除动态
    func requestDeleteDynamic(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Dynamic/Publish/delete", parameters: ["id":dataList[index].id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataList.remove(at: index)
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 置顶/取消置顶
    func requestTopDynamic(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        let isTop:String = dataList[index].is_top_topic == "1" ? "0" : "1"
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Dynamic/TopicPublish/top", parameters: ["id":dataList[index].id!,"type": isTop,"topic_id":dataList[index].topic_id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataList.removeAll()
                weakSelf?.tableView.reloadData()
                weakSelf?.refresh()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 动态详情
    func goDynamicDetailVC(id: String){
        let vc = FSHotDynamicVC()
        vc.dynamicId = id
        vc.resultBlock = {[unowned self] (isRefresh,dynamicId) in
            
            if isRefresh {
                self.requestDynamicById(dynamicId: dynamicId)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 视频动态详情
    func goVideoDynamicDetail(dynamicId: String){
        let vc = FSDynamicVideoDetailVC()
        vc.dynamicId = dynamicId
        vc.resultBlock = {[unowned self] (isRefresh,dyId) in
            
            if isRefresh {
                self.requestDynamicById(dynamicId: dyId)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///单个动态
    func requestDynamicById(dynamicId: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/one", parameters: ["id":dynamicId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dealDynamicChange(model: FSSquareHotModel.init(dict: data))
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealDynamicChange(model: FSSquareHotModel){
        for (index,item) in dataList.enumerated() {
            if item.id == model.id {
                dataList[index] = model
                break
            }
        }
        tableView.reloadData()
    }
    /// 作品详情
    func goWorksDetailVC(id: String){
        let vc = FSSquareFollowDetailVC()
        vc.dynamicId = id
        vc.resultBlock = {[unowned self] (isRefresh,dynamicId) in
            
            if isRefresh {
                self.requestDynamicById(dynamicId: dynamicId)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 查看大图
    ///
    /// - Parameters:
    ///   - index: 索引
    ///   - urls: 图片路径
    func goBigPhotos(index: Int, urls: [String]){
        browser = SKPhotoBrowser(photos: GYZTool.createWebPhotos(urls: urls, isShowDel: false, isShowAction: true))
        browser?.initializePageIndex(index)
        
        present(browser!, animated: true, completion: nil)
    }
    /// 用户主页
    @objc func onClickUserImg(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        /// 会员类型（1-普通 2-达人 3-场馆）
        if model.member_type == "3" {
            let vc = FSVenueHomeVC()
            vc.userId = model.member_id!
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = FSPersonHomeVC()
            vc.userId = model.member_id!
            vc.userType = model.member_type!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// 话题详情
    func goTopicDetailVC(index:Int){
        let vc = FSTopicDetailVC()
        vc.topicId = dataList[index].topic_id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goDetailVC(index:Int){
        let model = dataList[index]
        let type = model.type
        if type == "1" || type == "2" {//动态
            goDynamicDetailVC(id: model.id!)
        }else if type == "3"{
            goVideoDynamicDetail(dynamicId: model.id!)
        }else if type == "4" || type == "5" || type == "6" {//作品
            goWorksDetailVC(id: model.id!)
        }
    }
}

extension FSTopicDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: topicDetailCell) as! FSZongHeCell
        
        let model = dataList[indexPath.row]
        cell.dataModel = model
        
        if model.topic_id != "0" {
            
            let content: String = model.content! + " #\(model.topic_id_text!)#"
            let attStr = NSMutableAttributedString.init(string: content)
            attStr.addAttribute(NSAttributedString.Key.font, value: k14Font, range: NSMakeRange(0, content.count))
            attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeFontColor, range: NSMakeRange(content.count - model.topic_id_text!.count - 2,model.topic_id_text!.count + 2))
            attStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: NSMakeRange(content.count - model.topic_id_text!.count - 1,model.topic_id_text!.count))
             
            cell.contentLab.attributedText = attStr
            
        }else{
            let content: String = model.content! + " "
            let attStr = NSMutableAttributedString.init(string: content)
            attStr.addAttribute(NSAttributedString.Key.font, value: k14Font, range: NSMakeRange(0, content.count))

            cell.contentLab.attributedText = attStr
        
        }
        cell.contentLab.tag = indexPath.row
        cell.contentLab.yb_addAttributeTapAction(with: ["#\(dataList[indexPath.row].topic_id_text!)#"]) {[unowned self] (label, string, range, index) in
            print("点击了\(string!)标签 - {\(range.location) , \(range.length)} - \(index)")
            let tag = label?.tag
            self.goTopicDetailVC(index: tag!)
        }
        
        cell.topImgView.isHidden = model.is_top_topic == "1" ? false : true
        cell.followLab.isHidden = true

        cell.downImgView.tag = indexPath.row
        cell.downImgView.addOnClickListener(target: self, action: #selector(onClickedDynamicOperator(sender:)))

        cell.favouriteBtn.tag = indexPath.row
        cell.favouriteBtn.addTarget(self, action: #selector(onClickedFavourite(sender:)), for: .touchUpInside)
        cell.conmentBtn.tag = indexPath.row
        cell.conmentBtn.addTarget(self, action: #selector(onClickedShowConment(sender:)), for: .touchUpInside)
        cell.zanBtn.tag = indexPath.row
        cell.zanBtn.addTarget(self, action: #selector(onClickedZan(sender:)), for: .touchUpInside)
        cell.imgViews.onClickedImgDetailsBlock = {[unowned self](index,urls) in
            
            if self.dataList[indexPath.row].video!.isEmpty {
                self.goBigPhotos(index: index, urls: self.dataList[indexPath.row].materialOrgionUrlList)
            }else{
                self.goDetailVC(index: indexPath.row)
            }
        }
        cell.userImgView.tag = indexPath.row
        cell.userImgView.addOnClickListener(target: self, action: #selector(onClickUserImg(sender:)))
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: topicDetailHeader) as! FSAllConmentHeaderView
            headerView.sortImgView.addOnClickListener(target: self, action: #selector(onClickedSort(sender:)))
            
            if sortIndex == 0 {
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_hot")
            }else{
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_time")
            }
            
            return headerView
        }else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: topicDetailMsgHeader) as! FSTopicDetailMsgHeaderView
            if let model = dataModel{
                headerView.contentLab.text = "简介：" + (model.formData?.content)!
            }
            
            return headerView
        }
        
//        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 && dataList.count == 0 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: topicDetailEmptyFooter) as! GYZEmptyFooterView
            footerView.contentLab.text = "暂无动态"
            
            return footerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goDetailVC(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 && dataList.count == 0 {
            return 120
        }
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
            self.navigationItem.title = dataModel != nil ? dataModel?.formData?.title : ""
            self.rightBtn.setImage(UIImage.init(named: "app_btn_topic_gray"), for: .normal)
            setBackBtnImage(imgName: "icon_back_black")
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
            self.rightBtn.setImage(UIImage.init(named: "app_btn_topic_edit"), for: .normal)
            setBackBtnImage(imgName: "icon_back_white")
        }
       ///  头部下拉效果
//        var y: CGFloat = 0
//        if #available(iOS 11.0, *) {
//            y = -kTitleAndStateHeight
//        }
//        if (contentOffsetY < y) {
//            let totalOffset = imageHeight + abs(contentOffsetY)
//            bgImgView.frame = CGRect.init(x: 0, y: contentOffsetY, width: kScreenWidth, height: totalOffset)
//        }
    }
}
extension FSTopicDetailVC: YBPopupMenuDelegate{
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        let tag = ybPopupMenu.tag
        if tag == 201 {
            if index == 2{/// 分享
                showShared()
            }else if index == 0{
                if dataModel != nil {
                    let vc = FSTopicManagerVC()
                    if let model = dataModel{
                        vc.topicContent = (model.formData?.content)!
                        vc.contentMaxCount = Int((model.formData?.content_limit)!)!
                    }
                    vc.topicId = self.topicId
                    vc.resultBlock = {[unowned self](isRefresh) in
                        if isRefresh{
                            self.dataList.removeAll()
                            self.tableView.reloadData()
                            self.currPage = 1
                            self.requestTopicInfo()
                        }
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
//                    if dataModel?.formData?.is_admin == "1"{/// "管理话题"
//                        let vc = FSTopicManagerVC()
//                        if let model = dataModel{
//                            vc.topicContent = (model.formData?.content)!
//                            vc.contentMaxCount = Int((model.formData?.content_limit)!)!
//                        }
//                        vc.topicId = self.topicId
//                        vc.resultBlock = {[unowned self](isRefresh) in
//                            if isRefresh{
//                                self.dataList.removeAll()
//                                self.tableView.reloadData()
//                                self.currPage = 1
//                                self.requestTopicInfo()
//                            }
//                        }
//                        self.navigationController?.pushViewController(vc, animated: true)
//
//                        return
//                    }
//                    if dataModel?.formData?.is_apply_admin == "1"{/// "申请麦克风"
//                        goApplyMikeVC()
//                    }
                }
    
            }else if index == 1{/// "申请麦克风"
                goApplyMikeVC()
            }
        }else if tag == 202 {// 弹出排序
            sortIndex = index
            dataList.removeAll()
            tableView.reloadData()
            refresh()
        }else if tag == 203 {/// "我的话题","创建话题"
            if index == 0{
                let vc = FSMyTopicVC()
                self.navigationController?.pushViewController(vc, animated: true)
//                if dataModel != nil {
//                    if dataModel?.formData?.is_admin == "1"{/// "我的话题"
//                        let vc = FSMyTopicVC()
//                        self.navigationController?.pushViewController(vc, animated: true)
//                        return
//                    }
//                    if dataModel?.formData?.is_add_topic == "1"{/// "创建话题"
//                        goCreateTopicVC()
//                    }
//                }
            }else if index == 1{/// "创建话题"
                goCreateTopicVC()
            }
        }
        
    }
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, cellForRowAt index: Int) -> UITableViewCell! {
        
        let cell = ybPopupMenu.tableView.dequeueReusableCell(withIdentifier: topicCustomPopupMenuCell) as! GYZLabelCenterCell
        
        let tag = ybPopupMenu.tag
        if tag == 201 {
            cell.nameLab.text = rightManagerTitles[index]
            cell.nameLab.textColor = kGaryFontColor
        }else if tag == 202{
            cell.nameLab.text = sortTitles[index]
            if index == sortIndex {
                cell.nameLab.textColor = kBlueFontColor
            }else{
                cell.nameLab.textColor = kHeightGaryFontColor
            }
        }else{
            cell.nameLab.text = topicArr[index]
            cell.nameLab.textColor = kGaryFontColor
        }
        
        cell.selectionStyle = .none
        return cell
    }
    /// "创建话题"
    func goCreateTopicVC(){
        let vc = FSCreateTopicVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// "申请麦克风"
    func goApplyMikeVC(){
        let vc = FSApplyMikeVC()
        if let model = dataModel {
            vc.topicId = self.topicId
            vc.topicTitle = (model.formData?.title)!
            vc.applyAdminText = (model.formData?.applyMikeDesArr[0])! + (model.formData?.title)! + (model.formData?.applyMikeDesArr[1])!
            vc.topicActiveCount = Int((model.formData?.activity_count)!)!
            vc.isApplyMike = (model.formData?.is_apply_admin)!
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 分享
    func showShared(){
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
}
