//
//  FSEditPhotoPasterTagVC.swift
//  fitsky
//  编辑图片 加贴纸和标签
//  Created by iMac on 2020/4/30.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSEditPhotoPasterTagVC: GYZBaseVC {
    
    let defaultPasterViewW_H = 120
    // 选择的图片UIImage
    var selectCameraImgs: [UIImage] = [UIImage]()
    // 合成后图片UIImage
    var dealResultImgs: [UIImage] = [UIImage]()
    /// 合成的索引
    var currIndex: Int = 0
    var currPage: Int = 0
    var editViews: [UIImageView] = [UIImageView]()
    // 贴纸view
    var selectPasterViewDic: [Int:[YBPasterView]] = [:]
    // 贴纸列表
    var dataList:[FSFindQiCaiCategoryModel] = [FSFindQiCaiCategoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"app_next_normal")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedNextBtn))
        self.view.backgroundColor = kBlackColor
        self.navigationItem.title = "\((currPage + 1))/\(selectCameraImgs.count)"
        addSubviews()
        requestPasterList()
    }
    func addSubviews(){
        for index in 0..<selectCameraImgs.count {
            let scale = selectCameraImgs[index].size.width / selectCameraImgs[index].size.height
            let pasterImgView: UIImageView = UIImageView.init(frame:CGRect(x: self.view.frame.size.width * CGFloat(index), y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width / scale))
            pasterImgView.image = self.selectCameraImgs[index]
            pasterImgView.isUserInteractionEnabled = true
            editViews.append(pasterImgView)
            scrollView.addSubview(pasterImgView)
            selectPasterViewDic[index] = [YBPasterView]()
        }
        ///放到最底层
        self.view.insertSubview(scrollView, at: 0)
        self.view.addSubview(tagBtn)
        self.view.addSubview(pasterBtn)
        
        tagBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self.view)
            make.width.equalTo(pasterBtn)
            make.height.equalTo(54)
        }
        pasterBtn.snp.makeConstraints { (make) in
            make.left.equalTo(tagBtn.snp.right)
            make.right.equalTo(self.view)
            make.bottom.width.height.equalTo(tagBtn)
        }
    }
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 54))
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.scrollsToTop = false
        scroll.bounces = false
        scroll.contentOffset = CGPoint.zero
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(self.selectCameraImgs.count), height: self.view.bounds.height - 54)
        
        scroll.delegate = self
        
        return scroll
    }()
    /// 标签
    lazy var tagBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("标签", for: .normal)
        btn.backgroundColor = UIColor.ColorHex("#343434")
        return btn
    }()
    /// 贴纸
    lazy var pasterBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("贴纸", for: .normal)
        btn.backgroundColor = UIColor.ColorHex("#343434")
        btn.addTarget(self, action: #selector(onClickedPasterImgBtn), for: .touchUpInside)
        return btn
    }()
    /// 下一步
    @objc func clickedNextBtn(){
        dealResultImgs.removeAll()
        for key in self.selectPasterViewDic.keys {
            for item in self.selectPasterViewDic[key]! {
                item.hiddenBtn()
            }
            donePasterEdit(index: key)
        }
    }
    /// 贴纸
    @objc func onClickedPasterImgBtn(){
        showPasterView()
    }
    
    func showPasterView(){
        let pasterView: FSPasterImgView = FSPasterImgView()
        pasterView.pasterImageArray = dataList
        pasterView.didSelectItemBlock = {[unowned self] (image) in
            self.createPasterView(pasterImg: image)
        }
        pasterView.show()
    }
    func createPasterView(pasterImg: UIImage){
        var pasteArr: [YBPasterView]?
        if self.selectPasterViewDic.keys.contains(currPage) {
            pasteArr = selectPasterViewDic[currPage]
            for item in pasteArr! {
                item.hiddenBtn()
            }
        }else{
            pasteArr = [YBPasterView]()
        }
        
        let pasterView: YBPasterView = YBPasterView.init(frame: CGRect.init(x: 0, y: 0, width: defaultPasterViewW_H, height: defaultPasterViewW_H))
        pasterView.center = CGPoint.init(x: editViews[currPage].frame.size.width / 2, y: editViews[currPage].frame.size.height / 2)
        pasterView.pasterImage = pasterImg
        pasterView.delegate = self
        editViews[currPage].addSubview(pasterView)
        pasteArr?.append(pasterView)
        selectPasterViewDic[currPage] = pasteArr!
    }
    /**
    *  图片合成
    *
    *  @return 返回合成好的图片
    */
    func donePasterEdit(index: Int){
        let org_width: CGFloat = selectCameraImgs[index].size.width
        let org_height: CGFloat = selectCameraImgs[index].size.height
        let rateOfScreen: CGFloat = org_width / org_height
        let inScreenH: CGFloat = editViews[index].frame.size.width / rateOfScreen
        var rect: CGRect = CGRect.zero
        rect.size = CGSize.init(width: editViews[index].frame.size.width, height: inScreenH)
        rect.origin = CGPoint.init(x: 0, y: (editViews[index].frame.size.height - inScreenH) / 2)
        let imgTemp = UIImage.getImageFromView(theView: editViews[index])
        
        dealResultImgs.append(imgTemp)
//        return imgTemp
    }
    ///获取贴纸数据
    func requestPasterList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/Sticker/index",parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
            
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSFindQiCaiCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
        })
    }
}
// MARK: - UIScrollViewDelegate
extension FSEditPhotoPasterTagVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        currPage = Int(offset.x / view.bounds.width)
        self.navigationItem.title = "\((currPage + 1))/\(selectCameraImgs.count)"
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            if (t.view?.isKind(of: YBPasterView.self))!{
                self.scrollView.isScrollEnabled = false
                GYZLog("111")
                break
            }else{
                GYZLog("222")
                self.scrollView.isScrollEnabled = true
            }
        }
    }
}
// MARK: - YBPasterViewDelegate
extension FSEditPhotoPasterTagVC: YBPasterViewDelegate {
    func deleteThePaster(_ sender: YBPasterView!) {
        if self.selectPasterViewDic.keys.contains(currPage) {
            for (index,item) in selectPasterViewDic[currPage]!.enumerated() {
                if item == sender {
                    item.removeFromSuperview()
                    self.selectPasterViewDic[currPage]!.remove(at: index)
                    break
                }
            }
        }
    }
    func showEditThePaster(_ sender: YBPasterView!) {
        sender.showBtn()
        if self.selectPasterViewDic.keys.contains(currPage) {
            for item in selectPasterViewDic[currPage]! {
                if item != sender {
                    item.hiddenBtn()
                }
            }
        }
    }
}
