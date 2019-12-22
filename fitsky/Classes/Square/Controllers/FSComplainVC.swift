//
//  FSComplainVC.swift
//  fitsky
//  投诉评论
//  Created by gouyz on 2019/8/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let complainCell = "complainCell"
private let complainFooter = "complainFooter"

class FSComplainVC: GYZWhiteNavBaseVC {
    
    ///txtView 提示文字
    let placeHolder = "投诉理由："
    // 内容id
    var contentId: String = ""
    // 举报类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复 11-用户）
    var type: String = ""
    // 内容
    var content: String = ""
    var currSel:Int = -1
    var dataList: [FSCompainCategoryModel] = [FSCompainCategoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "投诉评论"
        self.view.backgroundColor = kWhiteColor
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestComplainReasonData()
    }
    
    lazy var collectionView: UICollectionView = {
        
        let itemWidth = floor((kScreenWidth - kMargin * 4)/3)
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: itemWidth, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.alwaysBounceHorizontal = false
        collView.backgroundColor = kBackgroundColor
        
        collView.register(FSComplainCell.classForCoder(), forCellWithReuseIdentifier: complainCell)
        collView.register(FSComplainFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: complainFooter)
        
        return collView
    }()
    
    ///举报（投诉）分类
    func requestComplainReasonData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/MemberReport/category", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCompainCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.collectionView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 提交
    @objc func onClickRightBtn(){
        if currSel == -1 {
            MBProgressHUD.showAutoDismissHUD(message: "请选择举报类别")
            return
        }
        if content.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "举报内容不能为空")
            return
        }
        
        requestComplain()
    }
    ///举报（投诉）
    func requestComplain(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/MemberReport/add", parameters: ["content_id":contentId,"type": type,"category_id":dataList[currSel].id!,"content":content],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSComplainVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: complainCell, for: indexPath) as! FSComplainCell
        
        cell.nameLab.text = dataList[indexPath.row].name
        if indexPath.row == currSel {
            cell.nameLab.textColor = kWhiteColor
            cell.nameLab.backgroundColor = kBlueFontColor
        }else{
            cell.nameLab.textColor = kGaryFontColor
            cell.nameLab.backgroundColor = kGrayLineColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionView.elementKindSectionFooter{
            
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: complainFooter, for: indexPath) as! FSComplainFooterView
            
            
                (reusableview as! FSComplainFooterView).contentTxtView.text = placeHolder
            (reusableview as! FSComplainFooterView).contentTxtView.delegate = self
        }
        
        return reusableview
    }
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currSel = indexPath.row
        self.collectionView.reloadData()
    }
    //MARK: UICollectionViewDelegateFlowLayout
    // 返回HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth, height: 160)
    }
}
extension FSComplainVC : UITextViewDelegate
{
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
            textView.textColor = kBlackFontColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = kHeightGaryFontColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        content = textView.text
    }
}
