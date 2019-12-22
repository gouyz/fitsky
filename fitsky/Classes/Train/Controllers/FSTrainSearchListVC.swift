//
//  FSTrainSearchListVC.swift
//  fitsky
//  训练营搜索
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let trainSearchListCell = "trainSearchListCell"
private let trainSearchCourseListCell = "trainSearchCourseListCell"
private let trainSearchListHeader = "trainSearchListHeader"

private let trainSearchCustomPopupMenuCell = "trainSearchCustomPopupMenuCell"

class FSTrainSearchListVC: GYZWhiteNavBaseVC {
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    
    /// 搜索 内容
    var searchContent: String = ""
    let sortTitles: [String] = ["热度","距离"]
    var sortIndex: Int = 1
    var sortCourseIndex: Int = 0
    /// 判断是场馆还是课程
    var isVenue: Bool = true
    
    // 场馆列表
    var dataVenueList: [FSTrainVenueModel] = [FSTrainVenueModel]()
    /// 课程列表
    var dataCourseList:[FSVenueServiceModel] = [FSVenueServiceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        navigationItem.titleView = searchBar
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
        }
        
        self.view.addSubview(bgView)
        bgView.addSubview(venueBtn)
        bgView.addSubview(courseBtn)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(50)
            if #available(iOS 13.0, *){// 不懂为什么多15
                make.top.equalTo(15 + kTitleAndStateHeight)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        venueBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        courseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(venueBtn.snp.right).offset(15)
            make.centerY.size.equalTo(venueBtn)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(bgView.snp.bottom)
        }
        changeBtnState()
    }
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "搜索训练营内容"
        search.delegate = self
        //显示输入光标
        search.tintColor = kHeightGaryFontColor
        search.text = searchContent
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            search.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            if let textfiled = search.subviews.first?.subviews.last as? UITextField {
                textfiled.backgroundColor = kGrayBackGroundColor
            }
        }
        //弹出键盘
        //        search.becomeFirstResponder()
        
        return search
    }()
    
    ///
    lazy var bgView: UIView = {
        
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    /// 场馆
    lazy var venueBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.setTitle("场馆", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = kGrayLineColor
        btn.cornerRadius = 15
        
        btn.tag = 101
        btn.addTarget(self, action: #selector(onclickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 精彩课程
    lazy var courseBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.setTitle("精彩课程", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = kGrayLineColor
        btn.cornerRadius = 15
        
        btn.tag = 102
        btn.addTarget(self, action: #selector(onclickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 110
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSTrainVenueCell.classForCoder(), forCellReuseIdentifier: trainSearchListCell)
        table.register(FSAllConmentHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: trainSearchListHeader)
        table.register(FSTrainCourseCell.classForCoder(), forCellReuseIdentifier: trainSearchCourseListCell)
        
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
    
    ///获取场馆数据
    func requestVenueList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Store/Store/search",parameters: ["p":currPage,"orderby":sortIndex + 1,"keyword":searchContent],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSTrainVenueModel.init(dict: itemInfo)
                    
                    weakSelf?.dataVenueList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataVenueList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    weakSelf?.hiddenEmptyView()
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无信息")
                    weakSelf?.view.bringSubviewToFront((weakSelf?.bgView)!)
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            //第一次加载失败，显示加载错误页面
            if weakSelf?.currPage == 1{
                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.refresh()
                })
            }
            weakSelf?.view.bringSubviewToFront((weakSelf?.bgView)!)
        })
    }
    ///获取课程数据
    func requestCourseList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Store/Goods/search",parameters: ["p":currPage,"orderby":sortCourseIndex + 1,"keyword":searchContent],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSVenueServiceModel.init(dict: itemInfo)
                    
                    weakSelf?.dataCourseList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataCourseList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    weakSelf?.hiddenEmptyView()
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无课程信息")
                    weakSelf?.view.bringSubviewToFront((weakSelf?.bgView)!)
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            //第一次加载失败，显示加载错误页面
            if weakSelf?.currPage == 1{
                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.refresh()
                })
            }
            weakSelf?.view.bringSubviewToFront((weakSelf?.bgView)!)
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        requestData()
    }
    
    func requestData(){
        if isVenue {
            dataVenueList.removeAll()
            tableView.reloadData()
            currPage = 1
            requestVenueList()
        }else{
            dataCourseList.removeAll()
            tableView.reloadData()
            currPage = 1
            requestCourseList()
        }
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        
        if isVenue {
            requestVenueList()
        }else{
            requestCourseList()
        }
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    
    /// 改变按钮状态
    func changeBtnState(){
        if isVenue {
            venueBtn.backgroundColor = kBlueFontColor
            venueBtn.setTitleColor(kWhiteColor, for: .normal)
            courseBtn.backgroundColor = kGrayLineColor
            courseBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        }else{
            courseBtn.backgroundColor = kBlueFontColor
            courseBtn.setTitleColor(kWhiteColor, for: .normal)
            venueBtn.backgroundColor = kGrayLineColor
            venueBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        }
        requestData()
    }
    ///
    @objc func onclickedOperator(sender: UIButton){
        let index = sender.tag
        if index == 101{// 场馆
            if !self.isVenue {
                self.isVenue = true
                self.changeBtnState()
            }
        }else if index == 102{// 课程
            if self.isVenue {
                self.isVenue = false
                self.changeBtnState()
            }
        }
    }
    // 弹出排序
    @objc func onClickedSort(sender:UITapGestureRecognizer){
        YBPopupMenu.showRely(on: sender.view, titles: sortTitles, icons: nil, menuWidth: 120) { [weak self](popupMenu) in
            popupMenu?.delegate = self
            popupMenu?.textColor = kGaryFontColor
            popupMenu?.isShadowShowing = false
            popupMenu?.tableView.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: trainSearchCustomPopupMenuCell)
        }
    }
}
extension FSTrainSearchListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isVenue {
            return dataVenueList.count
        }
        return dataCourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isVenue {
            let cell = tableView.dequeueReusableCell(withIdentifier: trainSearchListCell) as! FSTrainVenueCell
            cell.dataModel = dataVenueList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: trainSearchCourseListCell) as! FSTrainCourseCell
            
            cell.dataModel = dataCourseList[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: trainSearchListHeader) as! FSAllConmentHeaderView
        headerView.sortImgView.addOnClickListener(target: self, action: #selector(onClickedSort(sender:)))
        
        if isVenue {
            if sortIndex == 0 {
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_hot")
            }else{
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_distance")
            }
        }else{
            if sortCourseIndex == 0 {
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_hot")
            }else{
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_distance")
            }
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isVenue {
            let vc = FSVenueHomeVC()
            vc.userId = dataVenueList[indexPath.row].id!
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = FSServiceGoodsDetailVC()
            vc.goodsId = dataCourseList[indexPath.row].id!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
extension FSTrainSearchListVC: UISearchBarDelegate {
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        self.searchContent = searchBar.text ?? ""
        requestData()
    }
    
}
extension FSTrainSearchListVC: YBPopupMenuDelegate{
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        if isVenue {
            sortIndex = index
        }else{
            sortCourseIndex = index
        }
        refresh()
    }
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, cellForRowAt index: Int) -> UITableViewCell! {
        
        let cell = ybPopupMenu.tableView.dequeueReusableCell(withIdentifier: trainSearchCustomPopupMenuCell) as! GYZLabelCenterCell
        cell.nameLab.text = sortTitles[index]
        if index == sortIndex {
            cell.nameLab.textColor = kBlueFontColor
        }else{
            cell.nameLab.textColor = kHeightGaryFontColor
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
