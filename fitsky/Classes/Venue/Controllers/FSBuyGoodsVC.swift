//
//  FSBuyGoodsVC.swift
//  fitsky
//  购买教程 选择教练
//  Created by gouyz on 2019/9/19.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let selectCoachCell = "selectCoachCell"

class FSBuyGoodsVC: GYZWhiteNavBaseVC {
    
    var goodsId: String = ""
    var dataModel: FSGoodsBuyModel?
    /// 选择教练
    var selectIndex: Int = -1
    // 购买数量
    var buyNum: Int = 1
    /// 客服电话
    var kefuPhone:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "选择教练"
        
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
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        tableView.tableHeaderView = headerView
        headerView.onClickedOperatorBlock = {[unowned self] (index) in
            if index == 101{// 减
                if self.buyNum == 1{
                    return
                }
                self.changeGoodsNum(isAdd: false)
            }else if index == 102{// 加
                self.changeGoodsNum(isAdd: true)
            }
            
        }
        
        bottomView.onClickedOperatorBlock = {[unowned self] (index) in
            if index == 102{// 确认学习
                self.requestCreateOrder()
            }
        }
        
        requestBuyGoodsInfo()
        
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 200
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSSelectCoachCell.classForCoder(), forCellReuseIdentifier: selectCoachCell)
        
        return table
    }()
    /// 底部view
    lazy var bottomView: FSGoodsDetailBottomView = {
        let bottomView = FSGoodsDetailBottomView()
        bottomView.favouriteLab.isHidden = true
        bottomView.favouriteLab.snp.updateConstraints({ (make) in
            make.width.equalTo(0)
        })
        
        bottomView.studyLab.text = "确认学习"
        
        return bottomView
    }()
    /// header
    lazy var headerView: FSBuyGoodsHeaderView = FSBuyGoodsHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 90))
    ///购买课程-购买页面
    func requestBuyGoodsInfo(){
        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        createHUD(message: "加载中...")

        GYZNetWork.requestNetwork("Store/Order/form", parameters: ["id":goodsId],  success: { (response) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)

            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSGoodsBuyModel.init(dict: data)
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
            setOrderMoney(price: (model.formData?.price)!, orgPrice: (model.formData?.original_price)!)

        }
    }
    /// 设置money
    func setOrderMoney(price:String,orgPrice: String){
        let originalPrice: String = String(format: "%.2f", Float(orgPrice)!)
        let str = "￥" + String(format: "%.2f", Float(price)!) + "  ￥" + originalPrice
        let count: Int = originalPrice.count
        
        let price : NSMutableAttributedString = NSMutableAttributedString(string: str)
        price.addAttribute(NSAttributedString.Key.font, value: k13Font, range: NSMakeRange(str.count - count - 1, count + 1))
        price.addAttribute(NSAttributedString.Key.foregroundColor, value: kGaryFontColor, range: NSMakeRange(str.count - count - 1, count + 1))
        
        price.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(str.count - count - 1, count + 1))
        price.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(str.count - count - 1, count + 1))
        bottomView.priceLab.attributedText = price
        
        headerView.numLab.text = "\(buyNum)"
    }
    /// 改变数量
    func changeGoodsNum(isAdd: Bool){
        if isAdd {
            buyNum += 1
            headerView.minusView.image = UIImage.init(named: "app_btn_class_sel_reduce")
        }else{
            buyNum -= 1
            if buyNum == 1{
                headerView.minusView.image = UIImage.init(named: "app_btn_class_sel_nor")
            }else{
                headerView.minusView.image = UIImage.init(named: "app_btn_class_sel_reduce")
            }
        }
        requestBuyGoodsNumChange()
    }
    
    ///购买数量改变
    func requestBuyGoodsNumChange(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Store/Order/nums", parameters: ["id":goodsId,"amount":buyNum],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]["order"]
                weakSelf?.setOrderMoney(price: data["order_amount"].stringValue, orgPrice: data["original_price"].stringValue)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///生成订单
    func requestCreateOrder(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var paramDic: [String: Any] = ["id":goodsId,"amount":buyNum,"order_type":"1"]
        if dataModel != nil && selectIndex != -1 {
            paramDic["coach_id"] = (dataModel?.coachList[selectIndex].id)!
        }
        
        GYZNetWork.requestNetwork("Store/Order/addOrder", parameters: paramDic,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]["order"]
                weakSelf?.goPayVC(orderSn: data["order_sn"].stringValue)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 支付
    func goPayVC(orderSn: String){
        let vc = FSPayOrderVC()
        vc.orderSn = orderSn
        vc.kefuPhone = kefuPhone
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 选择教练
    func selectedCoach(index: Int){
        if selectIndex == index {// 如果点击的是选中的，则取消当前选中的
            selectIndex = -1
        }else{
            selectIndex = index
        }
        tableView.reloadData()
        
    }
}
extension FSBuyGoodsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = dataModel {
            return model.coachList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: selectCoachCell) as! FSSelectCoachCell
        
        cell.dataModel = dataModel?.coachList[indexPath.row]
        
        if selectIndex == indexPath.row {
            cell.checkImgView.image = UIImage.init(named: "app_btn_sel_yes")
        }else{
            cell.checkImgView.image = UIImage.init(named: "app_btn_sel_no")
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
        selectedCoach(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
