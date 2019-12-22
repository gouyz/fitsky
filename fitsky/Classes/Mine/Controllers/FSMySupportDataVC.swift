//
//  FSMySupportDataVC.swift
//  fitsky
//  运动数据
//  Created by gouyz on 2019/10/18.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let mySupportDataCell = "mySupportDataCell"

class FSMySupportDataVC: GYZBaseVC {
    
    var dataModel: FSMineSupportModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "运动数据"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestSupportInfo()
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.alwaysBounceHorizontal = false
        collView.backgroundColor = kBackgroundColor
        
        collView.register(FSMySupportDataCell.classForCoder(), forCellWithReuseIdentifier: mySupportDataCell)
        
        return collView
    }()
    //我的-运动数据
    func requestSupportInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/sport", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["sport"].dictionaryObject else { return }
                weakSelf?.dataModel = FSMineSupportModel.init(dict: data)
                weakSelf?.collectionView.reloadData()
            
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSMySupportDataVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else{
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mySupportDataCell, for: indexPath) as! FSMySupportDataCell
        
        if indexPath.section == 0 {
            cell.nameLab.font = k14Font
            if let model = dataModel {
                if indexPath.row == 0 {
                    cell.nameLab.text = "健身：\(model.fitness!)分钟"
                }else if indexPath.row == 1 {
                    cell.nameLab.text = "操课：\(model.lesson!)分钟"
                }else if indexPath.row == 2 {
                    cell.nameLab.text = "瑜伽：\(model.yoga!)分钟"
                }else if indexPath.row == 3 {
                    cell.nameLab.text = "理疗：\(model.physiotherapy!)分钟"
                }
            }
        }else{
            cell.nameLab.font = k16Font
            if let model = dataModel {
                cell.nameLab.text = "今日步数：\(model.step!)步"
            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    //MARK: UICollectionViewDelegateFlowLayout
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = floor((kScreenWidth - kMargin * 3)/2)
        let itemHeight = floor((kScreenWidth - kMargin * 4)/3)
        if indexPath.section == 0 {
            return CGSize(width: itemWidth, height: itemHeight)
        }else{
            return CGSize(width: kScreenWidth - kMargin * 2, height: itemHeight)
        }
    }
}
