//
//  FSMyVenueServerVC.swift
//  fitsky
//  我的场馆 服务
//  Created by gouyz on 2019/10/31.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import TTGTagCollectionView

private let myVenueServerCell = "myVenueServerCell"

class FSMyVenueServerVC: GYZWhiteNavBaseVC {
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    
    /// 上一次选中的 tag index
    var lastSelectedIndex: UInt = 0
    /// 分类
    var catrgoryList: [FSCompainCategoryModel] = [FSCompainCategoryModel]()
    var catrgoryNameList: [String] = [String]()
    ///
    var categoryId: String = ""
    
    var dataList:[FSVenueServiceModel] = [FSVenueServiceModel]()
    /// 选择的服务
    var selectServiceDic: [String: FSVenueServiceModel] = [String: FSVenueServiceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "服务"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("停课", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(categoryTagsView)
        view.addSubview(tableView)
        
        categoryTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(54)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryTagsView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        categoryTagsView.addTags(catrgoryNameList)
        categoryTagsView.setTagAt(0, selected: true)
        categoryTagsView.reload()
        
        requestCategoryList()
    }
    
    /// 所有分类
    lazy var categoryTagsView: TTGTextTagCollectionView = {
        
        let view = TTGTextTagCollectionView()
        let config = view.defaultConfig
        config?.textFont = k15Font
        config?.textColor = kHeightGaryFontColor
        config?.selectedTextColor = kWhiteColor
        config?.borderColor = kGrayBackGroundColor
        config?.selectedBorderColor = kOrangeFontColor
        config?.backgroundColor = kGrayBackGroundColor
        config?.selectedBackgroundColor = kOrangeFontColor
        config?.cornerRadius = kCornerRadius
        view.scrollDirection = .horizontal
        config?.shadowOffset = CGSize.init(width: 0, height: 0)
        config?.shadowOpacity = 0
        config?.shadowRadius = 0
        //        config?.extraSpace = CGSize.init(width: 16, height: 10)
        view.numberOfLines = 1
        view.contentInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        view.showsHorizontalScrollIndicator = false
        view.horizontalSpacing = 15
        view.backgroundColor = kWhiteColor
        view.delegate = self
        
        return view
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSMyVenueServerCell.classForCoder(), forCellReuseIdentifier: myVenueServerCell)
        
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
    /// 停课
    @objc func onClickRightBtn(){
        if selectServiceDic.count == 0 {
            MBProgressHUD.showAutoDismissHUD(message: "请选择要停课的服务")
            return
        }
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["确认停课"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kGaryFontColor
        actionSheet.itemTextFont = k15Font
        actionSheet.didSelectIndex = {[unowned self] (index,title) in
            if index == 0{//确认停课
                self.requestStopServices()
            }
        }
    }
    ///获取服务分类数据
    func requestCategoryList(){
        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        createHUD(message: "加载中...")

        GYZNetWork.requestNetwork("Admin/Goods/category",parameters: nil,  success: { (response) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)

            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCompainCategoryModel.init(dict: itemInfo)

                    weakSelf?.catrgoryList.append(model)
                    weakSelf?.catrgoryNameList.append(model.name!)
                }
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
        if catrgoryList.count > 0{
            categoryTagsView.addTags(catrgoryNameList)
            categoryTagsView.setTagAt(0, selected: true)
            categoryTagsView.reload()
            categoryId = catrgoryList[0].id!
        }
        requestServiceList()
    }
    ///获取服务数据
    func requestServiceList(){
        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        showLoadingView()

        GYZNetWork.requestNetwork("Admin/Goods/index",parameters: ["p":currPage,"category_id": categoryId],  success: { (response) in

            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)

            if response["result"].intValue == kQuestSuccessTag{//请求成功

                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue

                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSVenueServiceModel.init(dict: itemInfo)

                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无服务信息")
                    weakSelf?.view.bringSubviewToFront((weakSelf?.categoryTagsView)!)
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
            weakSelf?.view.bringSubviewToFront((weakSelf?.categoryTagsView)!)
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
        requestServiceList()
    }

    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestServiceList()
    }

    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 选择服务
    func changeSelectedService(index: Int){
        let model = dataList[index]
        if selectServiceDic.keys.contains(model.id!) {
            selectServiceDic.removeValue(forKey: model.id!)
        }else{
            selectServiceDic[model.id!] = model
        }
        tableView.reloadData()
    }
    
    //停课
    func requestStopServices(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        var ids: String = ""
        for item in selectServiceDic.keys {
            ids += item + ","
        }
        ids = ids.subString(start: 0, length: ids.count - 1)
        
        GYZNetWork.requestNetwork("Admin/Goods/shelves", parameters: ["id":ids],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.refresh()
            
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSMyVenueServerVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myVenueServerCell) as! FSMyVenueServerCell
        
        let model = dataList[indexPath.row]
        cell.dataModel = model
        if selectServiceDic.keys.contains(model.id!) {
            cell.checkImgView.isHighlighted = true
        }else{
            cell.checkImgView.isHighlighted = false
        }
        
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
        changeSelectedService(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}
extension FSMyVenueServerVC: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        //上一次选中 有值，并且跟本次选中的 index 不同
        if self.lastSelectedIndex != -1 && self.lastSelectedIndex != index {
            //取消上一次选中
            self.categoryTagsView.setTagAt(self.lastSelectedIndex, selected: false)
        }
        self.lastSelectedIndex = index
        self.categoryId = self.catrgoryList[Int(index)].id!
        self.refresh()
    }
}
