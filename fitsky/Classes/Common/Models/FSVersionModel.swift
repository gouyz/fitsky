//
//  FSVersionModel.swift
//  fitsky
//  app 版本更新model
//  Created by gouyz on 2019/12/10.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSVersionModel: LHSBaseModel {
    /// 标题
    var title : String? = ""
    /// 描述
    var des : String? = ""
    /// 版本号
    var version : String? = ""
    /// 更新地址
    var url : String? = ""
    /// 类型（1-iOS 2-安卓）
    var type : String? = ""
    /// 是否更新（0-不需要 1-需要）
    var is_update : String? = ""
    /// 是否强制更新（0-否 1-是）
    var is_must : String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description"{
            super.setValue(value, forKey: "des")
        }else{
            super.setValue(value, forKey: key)
        }
    }
}
