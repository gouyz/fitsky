//
//  FSCreateIMCircleVC.swift
//  fitsky
//  创立社圈
//  Created by gouyz on 2020/3/1.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSCreateIMCircleVC: GYZWhiteNavBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "创立社圈"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("申请", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
    }
    
    func setUpUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImgView)
        contentView.addSubview(lineView)
        contentView.addSubview(categoryView)
        contentView.addSubview(rightIconView)
        contentView.addSubview(lineView1)
        contentView.addSubview(circlrNameView)
        contentView.addSubview(lineView2)
        contentView.addSubview(topDesLab)
        contentView.addSubview(switchTopView)
        contentView.addSubview(lineView3)
        contentView.addSubview(msgDesLab)
        contentView.addSubview(switchMsgView)
        contentView.addSubview(lineView4)
        contentView.addSubview(addressView)
        contentView.addSubview(mapTagView)
        contentView.addSubview(lineView5)
        contentView.addSubview(desLab)
        
        scrollView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo(view)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        headerImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(headerImgView.snp.bottom).offset(20)
            make.height.equalTo(klineDoubleWidth)
        }
        categoryView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(50)
            make.right.equalTo(rightIconView.snp.left)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(categoryView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 8, height: 14))
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(categoryView.snp.bottom)
        }
        circlrNameView.snp.makeConstraints { (make) in
            make.left.height.equalTo(categoryView)
            make.right.equalTo(contentView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(circlrNameView.snp.bottom)
        }
        topDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView2.snp.bottom)
            make.right.equalTo(switchTopView.snp.left).offset(-kMargin)
            make.height.equalTo(categoryView)
        }
        switchTopView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(topDesLab)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(topDesLab.snp.bottom)
        }
        msgDesLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(topDesLab)
            make.top.equalTo(lineView3.snp.bottom)
            make.right.equalTo(switchMsgView.snp.left).offset(-kMargin)
        }
        switchMsgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(msgDesLab)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(msgDesLab.snp.bottom)
        }
        addressView.snp.makeConstraints { (make) in
            make.left.height.equalTo(categoryView)
            make.top.equalTo(lineView4.snp.bottom)
            make.right.equalTo(mapTagView.snp.left)
        }
        mapTagView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(addressView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(addressView.snp.bottom).offset(kMargin)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView5.snp.bottom).offset(20)
            make.height.equalTo(24)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
    }
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    
    lazy var headerImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_btn_avatar_add"))
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectedHeader))
        imgView.cornerRadius = 40
        
        return imgView
        
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    
    lazy var categoryView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "分类", placeHolder: "请选择分类")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kHeightGaryFontColor
        nView.textFiled.font = k13Font
        
        return nView
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var circlrNameView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "社圈名称", placeHolder: "请输入社圈名称")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kHeightGaryFontColor
        nView.textFiled.font = k13Font
        
        return nView
    }()
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    ///
    lazy var topDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "置顶消息"
        
        return lab
    }()
    /// 开关
    lazy var switchTopView: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    lazy var lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    ///
    lazy var msgDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "消息免打扰"
        
        return lab
    }()
    /// 开关
    lazy var switchMsgView: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    lazy var lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 坐标
    lazy var addressView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "坐标", placeHolder: "")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kHeightGaryFontColor
        nView.textFiled.font = k13Font
        
        return nView
    }()
    /// 地图图标
    lazy var mapTagView : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_square_location"), for: .normal)
        btn.addTarget(self, action: #selector(onClickedSelectAddress), for: .touchUpInside)
        
        return btn
    }()
    lazy var lineView5: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "您好，该认证可申请创立学员社圈，还可申请一个"
        
        return lab
    }()
    
    /// 申请
    @objc func onClickRightBtn(){
        
    }
    /// 选择头像
    @objc func onClickedSelectedHeader(){
        
    }
    /// 选择坐标
    @objc func onClickedSelectAddress(){
        
    }
}
