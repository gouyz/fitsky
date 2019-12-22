//
//  FSFoodMenuDetailVC.swift
//  fitsky
//  菜谱详情
//  Created by gouyz on 2019/10/16.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD


private let foodMenuDetailDesCell = "foodMenuDetailDesCell"
private let foodMenuDetailCell = "foodMenuDetailCell"
private let foodMenuDetailHeader = "foodMenuDetailHeader"
private let foodMenuDetailContentHeader = "foodMenuDetailContentHeader"

class FSFoodMenuDetailVC: GYZWhiteNavBaseVC {

    var wkHeight: CGFloat = kTitleHeight
    
    var cookBookId: String = ""
    var dataModel: FSCookBookDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
        }
        tableView.tableHeaderView = headerView
        headerView.favouriteBtn.addTarget(self, action: #selector(requestFavourite), for: .touchUpInside)
        
        requestCookBookInfo()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = kTitleHeight
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSFoodMenuDetailDesCell.classForCoder(), forCellReuseIdentifier: foodMenuDetailDesCell)
        table.register(FSFoodMenuDetailCell.classForCoder(), forCellReuseIdentifier: foodMenuDetailCell)
        table.register(LHSGeneralHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: foodMenuDetailHeader)
        table.register(FSFindQiCaiDetailDesHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: foodMenuDetailContentHeader)
               
        
        return table
    }()
    
    lazy var headerView: FSFoodMenuDetailHeaderView = FSFoodMenuDetailHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth))
    
    ///食谱基本信息
    func requestCookBookInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Cookbook/Cookbook/info", parameters: ["id":cookBookId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSCookBookDetailModel.init(dict: data)
                weakSelf?.dealData()
                weakSelf?.tableView.reloadData()
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
            
            headerView.dataModel = model
            tableView.reloadData()
        }
    }
    
    ///收藏（取消收藏）
    @objc func requestFavourite(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberCollect/add", parameters: ["content_id":cookBookId,"type":(dataModel?.formData?.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataModel?.moreModel?.is_collect = data["status"].stringValue
                weakSelf?.dealData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSFoodMenuDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return dataModel == nil ? 0 : (dataModel?.foodModelList.count)!
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: foodMenuDetailDesCell) as! FSFoodMenuDetailDesCell
            
            cell.dataModel = dataModel
            
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: foodMenuDetailCell) as! FSFoodMenuDetailCell
            
            cell.dataModel = dataModel?.foodModelList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: foodMenuDetailContentHeader) as! FSFindQiCaiDetailDesHeaderView
            
            headerView.nameLab.text = "做法步骤"
            if wkHeight <= kTitleHeight {
                if let model = dataModel {
                    headerView.loadContent(url: (model.formData?.content)!)
                }
                headerView.resultHeightBlock = {[unowned self] (height) in
                    self.wkHeight = height
                    self.tableView.reloadData()
                }
            }
            
            /// 超出部分裁剪
            headerView.contentView.clipsToBounds = true
            
            return headerView
        }else if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: foodMenuDetailHeader) as! LHSGeneralHeaderView
            
            headerView.nameLab.text = "食材清单"
            
            return headerView
        }
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return wkHeight
        }else if section == 1 {
            return kTitleHeight
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = kTitleAndStateHeight + kStateHeight - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
            self.navigationItem.title = dataModel == nil ? "" : dataModel?.formData?.title
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
        }
    }
}
