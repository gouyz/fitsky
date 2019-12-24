//
//  FSMyCourseOrderListVC.swift
//  fitsky
//  课程订单列表
//  Created by gouyz on 2019/10/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import MBProgressHUD

private let myCourseOrderListCell = "myCourseOrderListCell"

class FSMyCourseOrderListVC: GYZWhiteNavBaseVC {
    
    weak var naviController: UINavigationController?
    
    /// "0全部","1待支付", "2待使用", "3已完成"
    var type: Int = 0
    /// 
    var dataList: [FSCourseOrderModel] = [FSCourseOrderModel]()
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        table.register(FSMyCourseOrderCell.classForCoder(), forCellReuseIdentifier: myCourseOrderListCell)
        
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
    ///获取课程订单数据
    func requestOrderList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        var method: String = "Member/Order/index"
        if type == 1 {
            method = "Member/Order/nopay"
        }else if type == 2 {
            method = "Member/Order/noused"
        }else if type == 3 {
            method = "Member/Order/used"
        }
        
        GYZNetWork.requestNetwork(method,parameters: ["p":currPage],  success: { (response) in
            
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
        self.naviController?.pushViewController(vc, animated: true)
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
        self.naviController?.pushViewController(vc, animated: true)
    }
    // 支付
    @objc func onClickedPayOrder(sender:UIButton){
        let vc = FSPayOrderVC()
        vc.orderSn = dataList[sender.tag].order_sn!
        self.naviController?.pushViewController(vc, animated: true)
    }
    
    // 课程详情
    @objc func onClickedCourseDetail(sender:UITapGestureRecognizer){
        let vc = FSMyCourseDetailVC()
        vc.goodsId = dataList[(sender.view?.tag)!].order_id!
        vc.resultBlock = {[unowned self] () in
            self.requestOrderById(index: (sender.view?.tag)!)
        }
        self.naviController?.pushViewController(vc, animated: true)
    }
}
extension FSMyCourseOrderListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myCourseOrderListCell) as! FSMyCourseOrderCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.venueNameLab.tag = indexPath.row
        cell.venueNameLab.addOnClickListener(target: self, action: #selector(onClickedVenueHome(sender:)))
        cell.cancleBtn.tag = indexPath.row
        cell.cancleBtn.addTarget(self, action: #selector(onClickedCancleOrder(sender:)), for: .touchUpInside)
        cell.feedBackBtn.tag = indexPath.row
        cell.feedBackBtn.addTarget(self, action: #selector(onClickedfeedBackOrder(sender:)), for: .touchUpInside)
        cell.payBtn.tag = indexPath.row
        cell.payBtn.addTarget(self, action: #selector(onClickedPayOrder(sender:)), for: .touchUpInside)
        
        cell.courseImgView.tag = indexPath.row
        cell.courseImgView.addOnClickListener(target: self, action: #selector(onClickedCourseDetail(sender:)))
        
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
extension FSMyCourseOrderListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
    func listDidAppear() {
        
        //        if userDefaults.bool(forKey: kIsPublishDynamicTagKey) {
        //
        //            // 发布动态返回需要刷新数据
        //            userDefaults.set(false, forKey: kIsPublishDynamicTagKey)
        //            dataList.removeAll()
        //            tableView.reloadData()
        //            refresh()
        //        }
    }
}
