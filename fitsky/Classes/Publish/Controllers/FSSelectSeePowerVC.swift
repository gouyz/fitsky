//
//  FSSelectSeePowerVC.swift
//  fitsky
//  选择 谁可以看
//  Created by gouyz on 2019/9/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

private let selectSeePowerCell = "selectSeePowerCell"

class FSSelectSeePowerVC: GYZWhiteNavBaseVC {
    
    /// 公开类型（1-公开 2-好友圈 3-仅限自己）
    let titleArr: [String] = ["公开","好友圈","仅限自己查看"]
    /// 选择结果回调
    var resultBlock:((_ type: Int,_ typeName: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "谁可以看"
        let leftBtn = UIButton(type: .custom)
        leftBtn.setTitle("取消", for: .normal)
        leftBtn.titleLabel?.font = k15Font
        leftBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        leftBtn.addTarget(self, action: #selector(onClickLeftBtn), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        
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
        
        table.register(FSSelectSeePowerCell.classForCoder(), forCellReuseIdentifier: selectSeePowerCell)
        
        return table
    }()
    
    /// 取消
    @objc func onClickLeftBtn(){
        self.dismiss(animated: true, completion: nil)
    }
}
extension FSSelectSeePowerVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: selectSeePowerCell) as! FSSelectSeePowerCell
        
        cell.nameLab.text = titleArr[indexPath.row]
        if indexPath.row == 2 {
            cell.desLab.isHidden = true
            cell.desLab.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            cell.nameLab.snp.updateConstraints { (make) in
                make.height.equalTo(40)
            }
        }else{
            cell.desLab.isHidden = false
            cell.desLab.snp.updateConstraints { (make) in
                make.height.equalTo(20)
            }
            cell.nameLab.snp.updateConstraints { (make) in
                make.height.equalTo(20)
            }
            if indexPath.row == 0{
                cell.desLab.text = "所有人可见"
            }else if indexPath.row == 1{
                cell.desLab.text = "仅限粉丝可见"
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
        
        if resultBlock != nil {
            resultBlock!(indexPath.row + 1,titleArr[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
