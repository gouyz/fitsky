//
//  FSFoodStoreDetailVC.swift
//  fitsky
//  食材库 详情
//  Created by gouyz on 2019/10/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let foodStoreDetailCell = "findQiCaiCell"
private let foodStoreDetailDesCell = "foodStoreDetailDesCell"
private let foodStoreDetailHeader = "foodStoreDetailHeader"

class FSFoodStoreDetailVC: GYZWhiteNavBaseVC {
    
    var dataModel: FSFoodDetailModel?
    var foodId: String = ""
    var titleArr: [String] = ["热量","碳水","蛋白质","脂肪"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "豆汁"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestFoodInfo()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 50
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSFoodStoreDetailDesCell.classForCoder(), forCellReuseIdentifier: foodStoreDetailDesCell)
        table.register(LHSGeneralHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: foodStoreDetailHeader)
        
        table.register(GYZCommonInfoCell.classForCoder(), forCellReuseIdentifier: foodStoreDetailCell)
        
        
        return table
    }()

    ///食材基本信息
    func requestFoodInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Cookbook/Food/info", parameters: ["id":foodId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSFoodDetailModel.init(dict: data)
                weakSelf?.navigationItem.title = weakSelf?.dataModel?.formData?.name
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSFoodStoreDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: foodStoreDetailDesCell) as! FSFoodStoreDetailDesCell
            
            if let model = dataModel {
                cell.nameLab.text = model.formData?.name
                cell.desLab.text = model.formData?.desContent
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: foodStoreDetailCell) as! GYZCommonInfoCell
            
            cell.contentLab.textColor = kGaryFontColor
            cell.contentLab.font = k15Font
            cell.titleLab.textColor = kGaryFontColor
            cell.titleLab.text = titleArr[indexPath.row]
            
            if let model = dataModel {
                if indexPath.row == 0 {
                    cell.contentLab.text = model.formData?.heat_text
                }else if indexPath.row == 1 {
                    cell.contentLab.text = model.formData?.carbon_text
                }else if indexPath.row == 2 {
                    cell.contentLab.text = model.formData?.protein_text
                }else if indexPath.row == 3 {
                    cell.contentLab.text = model.formData?.fat_text
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: foodStoreDetailHeader) as! LHSGeneralHeaderView
            
            headerView.nameLab.text = dataModel == nil ? "营养价值（每100g可食用部分）" : dataModel?.formData?.autritive_value_text
            headerView.nameLab.textColor = kOrangeFontColor
            
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
        if section == 1 {
            return kTitleHeight
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
