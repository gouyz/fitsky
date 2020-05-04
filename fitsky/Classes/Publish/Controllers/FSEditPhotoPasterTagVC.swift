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
    
    // 选择的图片UIImage
    var selectCameraImgs: [UIImage] = [UIImage]()
    /// 合成的索引
    var currIndex: Int = 0
    var currPage: Int = 0
    var editViews: [UIImageView] = [UIImageView]()
    // 贴纸列表
    var dataList:[FSFindQiCaiCategoryModel] = [FSFindQiCaiCategoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"app_next_normal")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedNextBtn))
        self.view.backgroundColor = kBlackColor
        
        addSubviews()
        requestPasterList()
    }
    func addSubviews(){
        for index in 0..<selectCameraImgs.count {
            let pasterImgView: UIImageView = UIImageView.init(frame:CGRect(x: self.view.frame.size.width * CGFloat(index), y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            pasterImgView.image = self.selectCameraImgs[index]
            editViews.append(pasterImgView)
            scrollView.addSubview(pasterImgView)
        }
        ///放到最底层
        self.view.insertSubview(scrollView, at: 0)
    }
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView.init(frame: self.view.bounds)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.scrollsToTop = false
        scroll.bounces = false
        scroll.contentOffset = CGPoint.zero
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(self.selectCameraImgs.count), height: self.view.frame.size.height)
        
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
        
    }
    /// 贴纸
    @objc func onClickedPasterImgBtn(){
        
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
    }
}
