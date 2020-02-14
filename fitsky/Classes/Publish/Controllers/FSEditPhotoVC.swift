//
//  FSEditPhotoVC.swift
//  fitsky
//  编辑图片
//  Created by gouyz on 2020/1/3.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSEditPhotoVC: GYZWhiteNavBaseVC {
    
    var numOfPages: Int = 4
    var currPage: Int = 0
    //初始输出分辨率，此值切换画幅的时候用到
    var outputSize: CGSize = CGSize.init(width: 720, height: 1280)
    /// 视频配置参数
    var quVideo: AliyunMediaConfig = AliyunMediaConfig.default()
    /// 多个资源的本地存放文件夹路径 - 从相册选择界面进入传这个值
    var taskPath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kBlackColor
        outputSize = quVideo.fixedSize()
        quVideo.outputSize = outputSize
        quVideo.videoQuality = .medium
        quVideo.encodeMode = .hardH264
        //初始化动图资源
        AliyunEffectPrestoreManager.init().insertInitialData()
        ///放到最底层
//        self.view.insertSubview(scrollView, at: 0)
        
        addSubviews()
    }
    
    func addSubviews(){
        let factor: CGFloat = outputSize.height / outputSize.width
        movieView.frame = CGRect.init(x: 0, y: kTitleAndStateHeight, width: kScreenWidth, height: kScreenWidth * factor)
        
        self.view.addSubview(movieView)
    }
    var movieView: UIView = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView.init(frame: self.view.bounds)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.scrollsToTop = false
        scroll.bounces = false
        scroll.contentOffset = CGPoint.zero
        
        scroll.delegate = self
        
        return scroll
    }()

}
// MARK: - UIScrollViewDelegate
extension FSEditPhotoVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        //        pageControl.currentPage = Int(offset.x / view.bounds.width)
        currPage = Int(offset.x / view.bounds.width)
        // 因为currentPage是从0开始，所以numOfPages减1
//        if currPage == numOfPages - 1 {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.startButton.alpha = 1.0
//            })
//        } else {
//            UIView.animate(withDuration: 0.2, animations: {
//                self.startButton.alpha = 0.0
//            })
//        }
    }
}
