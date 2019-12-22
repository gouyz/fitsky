//
//  FSMsgZanVC.swift
//  fitsky
//  点赞
//  Created by gouyz on 2019/12/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let messageZanCell = "messageZanCell"

class FSMsgZanVC: GYZWhiteNavBaseVC {
    
    var dataList:[FSMsgZanModel] = [FSMsgZanModel]()
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    /// 1点赞2收藏
    var type:String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = type == "1" ? "点赞":"收藏"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestMsgList()
        requestSetRead()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(FSMsgZanCell.classForCoder(), forCellReuseIdentifier: messageZanCell)
        
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
    //设置已读
    func requestSetRead(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        var method: String = "Message/Message/likeRead"
        if type == "2" {
            method = "Message/Message/collectRead"
        }
        
        GYZNetWork.requestNetwork(method, parameters: nil,  success: { (response) in
            
            GYZLog(response)
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    ///获取数据
    func requestMsgList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        var method: String = "Message/Message/like"
        if type == "2" {
            method = "Message/Message/collect"
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
                    let model = FSMsgZanModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无消息")
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
        requestMsgList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestMsgList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    
    /// 跳转详情
    func goDetail(contentId:String,type:String,isOpus:String,commentId:String,pushType:String){
        
        
        switch pushType {
        case "1":// 点赞
            if type == "1" {
                if commentId != "0" {// 评论
                    goConmentVC(id: contentId, type: type)
                }else if isOpus == "1"{// 是否作品
                    goWorksDetailVC(id: contentId)
                }else{
                    goDynamicDetailVC(id: contentId)
                }
            }
        case "2":// 收藏
            if type == "1" {
                if isOpus == "1"{// 是否作品
                    goWorksDetailVC(id: contentId)
                }else{
                    goDynamicDetailVC(id: contentId)
                }
            }else if type == "13" {//服务课程详情
                goDetailVC(goodsId: contentId)
            }
        default:
            break
        }
    }
    /// 课程详情
    func goDetailVC(goodsId: String){
        let vc = FSServiceGoodsDetailVC()
        vc.goodsId = goodsId
        self.navigationController?.pushViewController(vc, animated: true)
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
}
extension FSMsgZanVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: messageZanCell) as! FSMsgZanCell
        
        cell.dataModel = dataList[indexPath.row]
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
        let model = dataList[indexPath.row]
        goDetail(contentId: model.content_id!, type: model.content_type!, isOpus: model.is_opus!,commentId:model.comment_id!,pushType:model.push_type!)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
}
