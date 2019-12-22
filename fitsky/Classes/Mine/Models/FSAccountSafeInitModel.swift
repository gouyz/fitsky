//
//  FSAccountSafeInitModel.swift
//  fitsky
//  账户安全 初始化model
//  Created by gouyz on 2019/11/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSAccountSafeInitModel: LHSBaseModel {

    /// 密码状态（0-设置密码 1-修改密码）
    var is_password : String? = "0"
    /// 手机号
    var mobile : String? = ""
    /// 手机号 186****8833
    var mobile_text : String? = ""
    /// 微信账号是否设置（0-未设置 1-已设置）
    var is_wx : String? = "0"
    /// QQ账号是否设置（0-未设置 1-已设置）
    var is_qq : String? = ""
    /// 微博账号是否设置（0-未设置 1-已设置）
    var is_weibo : String? = ""
}
