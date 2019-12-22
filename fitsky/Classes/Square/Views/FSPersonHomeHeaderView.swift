//
//  FSPersonHomeHeaderView.swift
//  fitsky
//  个人主页header
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSPersonHomeHeaderView: UIView {

//    var imageViewFrame: CGRect!
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(bgImgView)
        bgImgView.addSubview(firstPageView)
        firstPageView.addSubview(boardView)
        firstPageView.addSubview(userImgView)
        firstPageView.addSubview(vipImgView)
        firstPageView.addSubview(nameBtn)
        firstPageView.addSubview(numLab)
        firstPageView.addSubview(confirmLab)
        firstPageView.addSubview(rightImgView)
        
        bgImgView.addSubview(secondPageView)
        secondPageView.addSubview(birthdayDesLab)
        secondPageView.addSubview(birthdayLab)
        secondPageView.addSubview(addressDesLab)
        secondPageView.addSubview(addressLab)
        secondPageView.addSubview(uidDesLab)
        secondPageView.addSubview(uidLab)
        secondPageView.addSubview(registerDesLab)
        secondPageView.addSubview(registerLab)
        secondPageView.addSubview(leftImgView)
        
        
        bgImgView.addSubview(leftBtn)
        bgImgView.addSubview(rightBtn)
        bgImgView.isUserInteractionEnabled = true
        firstPageView.isUserInteractionEnabled = true
        secondPageView.isUserInteractionEnabled = true
//        secondPageView.isHidden = true
        
        bgImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bgImgView)
            make.top.equalTo(kStateHeight)
            make.width.equalTo(kTitleHeight)
            make.height.equalTo(kTitleHeight)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bgImgView)
            make.top.height.width.equalTo(leftBtn)
        }
        firstPageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        boardView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleHeight)
            make.centerX.equalTo(firstPageView)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        userImgView.snp.makeConstraints { (make) in
//            make.top.equalTo(kTitleHeight)
            make.center.equalTo(boardView)
            make.size.equalTo(CGSize.init(width: 72, height: 72))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        rightImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(nameBtn)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        nameBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userImgView.snp.bottom)
            make.height.equalTo(30)
        }
        numLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameBtn)
            make.top.equalTo(nameBtn.snp.bottom)
            make.height.equalTo(20)
        }
        confirmLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameBtn)
            make.top.equalTo(numLab.snp.bottom)
            make.height.equalTo(numLab)
        }
        
        secondPageView.snp.makeConstraints { (make) in
            make.left.equalTo(kScreenWidth)
            make.top.bottom.equalTo(bgImgView)
            make.width.equalTo(kScreenWidth)
        }
        leftImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.size.equalTo(rightImgView)
        }
        birthdayDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(leftImgView.snp.right).offset(50)
            make.top.equalTo(70)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        birthdayLab.snp.makeConstraints { (make) in
            make.left.equalTo(birthdayDesLab.snp.right)
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(birthdayDesLab)
        }
        addressDesLab.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(birthdayDesLab)
            make.top.equalTo(birthdayDesLab.snp.bottom)
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(birthdayLab)
            make.top.equalTo(addressDesLab)
        }
        uidDesLab.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(birthdayDesLab)
            make.top.equalTo(addressDesLab.snp.bottom)
        }
        uidLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(birthdayLab)
            make.top.equalTo(uidDesLab)
        }
        registerDesLab.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(birthdayDesLab)
            make.top.equalTo(uidDesLab.snp.bottom)
        }
        registerLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(birthdayLab)
            make.top.equalTo(registerDesLab)
        }
    }
    ///
    lazy var bgImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_bg_homepage"))
    /// 左侧返回
    lazy var leftBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_back_black"), for: .normal)
        
        return btn
    }()
    lazy var firstPageView: UIView = {
        let firstView = UIView()
        
        return firstView
    }()
    lazy var boardView: UIView = {
        let firstView = UIView()
        firstView.backgroundColor = kWhiteColor
        firstView.borderColor = kOrangeFontColor
        firstView.borderWidth = 4
        firstView.cornerRadius = 40
        firstView.isHidden = true
        
        return firstView
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 36
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    ///名称
    /// 用户名称
    lazy var nameBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.setTitleColor(kGaryFontColor, for: .normal)
        return btn
    }()
    ///数量
    lazy var numLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.textColor = kGaryFontColor
        lab.textAlignment = .center
        lab.text = "关注 100 | 粉丝 1500"
        
        return lab
    }()
    ///认证
    lazy var confirmLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .center
        lab.text = "认证：瑜伽达人"
        
        return lab
    }()
    /// 右箭头
    lazy var rightImgView: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_right_double_arrow"), for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(onClickedChangeInfo(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 右侧按钮
    lazy var rightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_more_gray"), for: .normal)
        
        return btn
    }()
    
    lazy var secondPageView: UIView = {
        let secondView = UIView()
//        let swipeGestureLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(startSlide(sender:)))
//        swipeGestureLeft.direction = .right
//        secondView.addGestureRecognizer(swipeGestureLeft)
        
        return secondView
    }()
    
    ///生日
    lazy var birthdayDesLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textColor = kHeightGaryFontColor
        lab.text = "生日"
        
        return lab
    }()
    ///
    lazy var birthdayLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "1990-01-01"
        
        return lab
    }()
    ///地区
    lazy var addressDesLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textColor = kHeightGaryFontColor
        lab.text = "地区"
        
        return lab
    }()
    ///
    lazy var addressLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "江苏常州"
        
        return lab
    }()
    ///UID
    lazy var uidDesLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textColor = kHeightGaryFontColor
        lab.text = "UID"
        
        return lab
    }()
    ///
    lazy var uidLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "25360078"
        
        return lab
    }()
    ///注册
    lazy var registerDesLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textColor = kHeightGaryFontColor
        lab.text = "注册"
        
        return lab
    }()
    ///
    lazy var registerLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "2010-01-01"
        
        return lab
    }()
    /// 左箭头
    lazy var leftImgView: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_left_double_arrow"), for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(onClickedChangeInfo(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    /// 头部左右滑动
//    @objc func startSlide(sender: UISwipeGestureRecognizer){
//        if sender.direction == .left {
//            UIView.animate(withDuration: 0.5) {[unowned self] in
//
//                self.secondPageView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 200.0)
//                self.firstPageView.frame = CGRect.init(x: -kScreenWidth, y: 0, width: kScreenWidth, height: 200.0)
//            }
//        }else if sender.direction == .right{
//
//            UIView.animate(withDuration: 0.5) {[unowned self] in
//                self.firstPageView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 200.0)
//                self.secondPageView.frame = CGRect.init(x: kScreenWidth, y: 0, width: kScreenWidth, height: 200.0)
//            }
//        }
//    }
    /// 用户信息切换
    @objc func onClickedChangeInfo(sender: UIButton){
        let tag = sender.tag
        if tag == 102 {
            UIView.animate(withDuration: 0.5) {[unowned self] in
                self.firstPageView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 200.0)
                self.secondPageView.frame = CGRect.init(x: kScreenWidth, y: 0, width: kScreenWidth, height: 200.0)
            }
        }else{
            UIView.animate(withDuration: 0.5) {[unowned self] in

                self.secondPageView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 200.0)
                self.firstPageView.frame = CGRect.init(x: -kScreenWidth, y: 0, width: kScreenWidth, height: 200.0)
            }
        }
    }
}
