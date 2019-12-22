//
//  FSMyCourseSearchVC.swift
//  fitsky
//  我的课程 搜索
//  Created by gouyz on 2019/12/9.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myCourseOrderSearchListCell = "myCourseOrderSearchListCell"

class FSMyCourseSearchVC: GYZWhiteNavBaseVC {
    ///
    var dataList: [FSCourseOrderModel] = [FSCourseOrderModel]()
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    /// 搜索 内容
    var searchContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestOrderList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kBackgroundColor
        // 设置大概高度
        table.estimatedRowHeight = 200
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSMyCourseOrderCell.classForCoder(), forCellReuseIdentifier: myCourseOrderSearchListCell)
        
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
        
        search.placeholder = "搜索全部"
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
    ///获取课程订单数据
    func requestOrderList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Member/Order/search",parameters: ["p":currPage,"keyword":searchContent],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCourseOrderModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无订单信息")
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
            
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        dataList.removeAll()
        tableView.reloadData()
        currPage = 1
        requestOrderList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestOrderList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 课程详情
    //    func goDetailVC(){
    //        let vc = FSFindCourseDetailVC()
    //        self.naviController?.pushViewController(vc, animated: true)
    //    }
    /// 场馆首页
    @objc func onClickedVenueHome(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        goVenueHome(id: dataList[tag!].friend_id!)
    }
    func goVenueHome(id: String){
        let vc = FSVenueHomeVC()
        vc.userId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 取消订单
    @objc func onClickedCancleOrder(sender:UIButton){
        
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确定取消订单吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") {[unowned self] (tag) in
            
            if tag != cancelIndex{
                self.requestCancleOrder(index: sender.tag)
            }
        }
    }
    
    /// 取消订单
    func requestCancleOrder(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/Order/cancel", parameters: ["id":self.dataList[index].id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.requestOrderById(index: index)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///课程订单-单个订单
    func requestOrderById(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Order/one", parameters: ["id":dataList[index].id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["formdata"].dictionaryObject else { return }
                weakSelf?.dealOrderChange(model: FSCourseOrderModel.init(dict: data),index: index)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealOrderChange(model: FSCourseOrderModel,index: Int){
        dataList[index] = model
        tableView.reloadData()
    }
    /// 反馈
    @objc func onClickedfeedBackOrder(sender:UIButton){
        let vc = FSOrderFeedBackVC()
        vc.orderId = dataList[sender.tag].id!
        vc.resultBlock = {[unowned self] () in
            self.requestOrderById(index: sender.tag)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 支付
    @objc func onClickedPayOrder(sender:UIButton){
        let vc = FSPayOrderVC()
        vc.orderSn = dataList[sender.tag].order_sn!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSMyCourseSearchVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myCourseOrderSearchListCell) as! FSMyCourseOrderCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.venueNameLab.tag = indexPath.row
        cell.venueNameLab.addOnClickListener(target: self, action: #selector(onClickedVenueHome(sender:)))
        cell.cancleBtn.tag = indexPath.row
        cell.cancleBtn.addTarget(self, action: #selector(onClickedCancleOrder(sender:)), for: .touchUpInside)
        cell.feedBackBtn.tag = indexPath.row
        cell.feedBackBtn.addTarget(self, action: #selector(onClickedfeedBackOrder(sender:)), for: .touchUpInside)
        cell.payBtn.tag = indexPath.row
        cell.payBtn.addTarget(self, action: #selector(onClickedPayOrder(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        goDetailVC()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
extension FSMyCourseSearchVC: UISearchBarDelegate {
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        self.searchContent = searchBar.text ?? ""
        requestOrderList()
    }
    
}
