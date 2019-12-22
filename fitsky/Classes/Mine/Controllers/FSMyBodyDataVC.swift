//
//  FSMyBodyDataVC.swift
//  fitsky
//  身体数据
//  Created by gouyz on 2019/10/18.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myBodyDataCell = "myBodyDataCell"

class FSMyBodyDataVC: GYZBaseVC {
    /// 选择结果回调
    var resultBlock:((_ isModify: Bool) -> Void)?
    let titleArr: [String] = ["身高","体重","BMI","胸围","腰围","臀围","静息心率","最大心率"]
    
    var dataModel: FSMineHealthModel?
    var isModify: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "身体数据"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestHealthInfo()
    }
    
    override func clickedBackBtn() {
        if resultBlock != nil {
            resultBlock!(isModify)
        }
        super.clickedBackBtn()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        table.backgroundColor = kWhiteColor
        
        
        table.register(GYZCommonArrowCell.classForCoder(), forCellReuseIdentifier: myBodyDataCell)
        
        return table
    }()
    /// 显示填写身体数据
    func showInputData(title: String,placeholder: String,content:String,unit: String,key: String){
        let alertView = FSCustomInputBodyDataAlert.init(title: title, placeholder: placeholder,content: content, unit: unit)
        if key == "height" || key == "weight" {
            alertView.inputTxtFiled.keyboardType = .numberPad
        }else{
            alertView.inputTxtFiled.keyboardType = .decimalPad
        }
        alertView.show()
        alertView.action = {[unowned self] (alert,index) in
            if index == 2 {// 确定
                self.requestBodyData(key: key, value: alert.inputTxtFiled.text!)
            }
        }
    }
    //修改数据
    func requestBodyData(key:String,value:String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/editHealth", parameters: [key:value],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                switch key {
                case "height":
                    weakSelf?.isModify = true
                    weakSelf?.dataModel?.height = value
                case "weight":
                    weakSelf?.isModify = true
                    weakSelf?.dataModel?.weight = value
                case "bust":
                    weakSelf?.dataModel?.bust = value
                case "waistline":
                    weakSelf?.dataModel?.waistline = value
                case "hipline":
                    weakSelf?.dataModel?.hipline = value
                case "resting_heart_rate":
                    weakSelf?.dataModel?.resting_heart_rate = value
                case "max_heart_rate":
                    weakSelf?.dataModel?.max_heart_rate = value
                default:
                    break
                }
                weakSelf?.tableView.reloadData()
            
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    //我的-身体数据
    func requestHealthInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/health", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["health"].dictionaryObject else { return }
                weakSelf?.dataModel = FSMineHealthModel.init(dict: data)
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

extension FSMyBodyDataVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myBodyDataCell) as! GYZCommonArrowCell
        
        cell.nameLab.font = k15Font
        cell.nameLab.textColor = kGaryFontColor
        cell.contentLab.font = k15Font
        cell.contentLab.textColor = kGaryFontColor
        cell.rightIconView.isHidden = false
        
        cell.nameLab.text = titleArr[indexPath.row]
        if dataModel != nil {
            switch indexPath.row {
            case 0:
                cell.contentLab.text = (dataModel?.height)! + " cm"
            case 1:
                cell.contentLab.text = (dataModel?.weight)! + " kg"
            case 2:
                cell.rightIconView.isHidden = true
                cell.contentLab.text = dataModel?.bmi
            case 3:
                cell.contentLab.text = (dataModel?.bust)! + " cm"
            case 4:
                cell.contentLab.text = (dataModel?.waistline)! + " cm"
            case 5:
                cell.contentLab.text = (dataModel?.hipline)! + " cm"
            case 6:
                cell.contentLab.text = (dataModel?.resting_heart_rate)! + " bpm"
            case 7:
                cell.contentLab.text = (dataModel?.max_heart_rate)! + " bpm"
            default:
                break
            }
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
        switch indexPath.row {
        case 0:
            
            showInputData(title: "请输入当前身高", placeholder: "请输入身高", content: dataModel == nil ? "" : (dataModel?.height)!,unit: "cm", key: "height")
        case 1:
            showInputData(title: "请输入当前体重", placeholder: "请输入体重", content: dataModel == nil ? "" : (dataModel?.weight)!,unit: "kg", key: "weight")
        case 3:
            showInputData(title: "请输入当前胸围", placeholder: "请输入胸围", content: dataModel == nil ? "" : (dataModel?.bust)!,unit: "cm", key: "bust")
        case 4:
            showInputData(title: "请输入当前腰围", placeholder: "请输入腰围", content: dataModel == nil ? "" : (dataModel?.waistline)!,unit: "cm", key: "waistline")
        case 5:
            showInputData(title: "请输入当前臀围", placeholder: "请输入臀围", content: dataModel == nil ? "" : (dataModel?.hipline)!,unit: "cm", key: "hipline")
        case 6:
            showInputData(title: "请输入当前静息心率", placeholder: "请输入静息心率", content: dataModel == nil ? "" : (dataModel?.resting_heart_rate)!,unit: "bpm", key: "resting_heart_rate")
        case 7:
            showInputData(title: "请输入当前最大心率", placeholder: "请输入最大心率", content: dataModel == nil ? "" : (dataModel?.max_heart_rate)!,unit: "bpm", key: "max_heart_rate")
        default:
            break
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 64
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
}
