//
//  FSSelectVenueTagVC.swift
//  fitsky
//  添加标签
//  Created by iMac on 2020/5/11.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let venueListCell = "venueListCell"
private let customTagCell = "customTagCell"
private let venueListEmptyFooter = "venueListEmptyFooter"

class FSSelectVenueTagVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ tagNames: String) -> Void)?
    
    // 场馆列表
    var dataVenueList: [FSTrainVenueModel] = [FSTrainVenueModel]()
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    /// 搜索 内容
    var searchContent: String = ""
    /// 标签model
    var viewModel: TagViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        requestVenueList()
    }
    func setupUI(){
        
        navigationItem.titleView = searchBar
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
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
        
        table.register(FSTrainVenueCell.classForCoder(), forCellReuseIdentifier: venueListCell)
        table.register(FSCustomTagSelectedCell.classForCoder(), forCellReuseIdentifier: customTagCell)
        table.register(GYZEmptyFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: venueListEmptyFooter)
        
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
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "搜索标签"
        search.delegate = self
        //显示输入光标
        search.tintColor = kHeightGaryFontColor
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            search.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            if let textfiled = search.subviews.first?.subviews.last as? UITextField {
                textfiled.backgroundColor = kGrayBackGroundColor
            }
        }
        
        return search
    }()
    
    ///获取场馆数据
    func requestVenueList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Store/Store/search",parameters: ["p":currPage,"orderby":1,"keyword":searchContent],  success: { (response) in
            
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
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        dataVenueList.removeAll()
        tableView.reloadData()
        currPage = 1
        requestVenueList()
    }
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        
        requestVenueList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
}
extension FSSelectVenueTagVC: UISearchBarDelegate{
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if searchBar.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入搜索内容")
            return
        }
        self.searchContent = searchBar.text ?? ""
        refresh()
    }
}
extension FSSelectVenueTagVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return dataVenueList.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: venueListCell) as! FSTrainVenueCell
            cell.dataModel = dataVenueList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: customTagCell) as! FSCustomTagSelectedCell
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: venueListEmptyFooter) as! GYZEmptyFooterView
            if dataVenueList.count == 0 {
                footerView.contentLab.text = "暂无场馆信息"
                
                return footerView
            }
        }
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            if dataVenueList.count == 0 {
                
                return 120
            }
        }
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { // 自定义
            currTagList.append(dataList[indexPath.row].name!)
            if isHas {
                cancleSearchClick()
            }else{
                requestAddTags()
            }
        }
    }
    
}
