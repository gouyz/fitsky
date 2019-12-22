//
//  ViewController.swift
//  fitsky
//
//  Created by gouyz on 2019/7/9.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var scrollView: UIScrollView!
    
    fileprivate let numOfPages = 4
    fileprivate var currPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.view.bounds
        
        scrollView = UIScrollView(frame: frame)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages), height: frame.size.height)
        
        scrollView.delegate = self
        
        for index  in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "icon_guide\(index)"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, width: frame.size.width, height: frame.size.height)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
        }
        ///放到最底层
        self.view.insertSubview(scrollView, at: 0)
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-40)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 160, height: 80))
        }
        
        // 隐藏开始按钮
        startButton.alpha = 0.0
    }
    
    /// 登录按钮
    fileprivate lazy var startButton : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.clear
        
        btn.addTarget(self, action: #selector(clickedStartBtn), for: .touchUpInside)
        return btn
    }()
    ///进入主页
    @objc func clickedStartBtn(){
        /// 获取当前版本号
        let currentVersion = GYZUpdateVersionTool.getCurrVersion()
        userDefaults.set(currentVersion, forKey: LHSBundleShortVersionString)
        if userDefaults.bool(forKey: kIsLoginTagKey) { //如果未登录进入登录界面，登录后进入首页
            KeyWindow.rootViewController = GYZMainTabBarVC()
        }else{
            KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: FSLoginVC())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        //        pageControl.currentPage = Int(offset.x / view.bounds.width)
        currPage = Int(offset.x / view.bounds.width)
        // 因为currentPage是从0开始，所以numOfPages减1
        if currPage == numOfPages - 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.startButton.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.startButton.alpha = 0.0
            })
        }
    }
}

