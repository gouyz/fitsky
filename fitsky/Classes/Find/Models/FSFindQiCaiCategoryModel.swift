//
//  FSFindQiCaiCategoryModel.swift
//  fitsky
//  器材分类model
//  Created by gouyz on 2020/1/15.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSFindQiCaiCategoryModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 属性名称
    var name : String? = ""
    ///
    var alias : String? = ""
    ///
    var material : String? = ""
    ///
    var thumb : String? = ""
    /// 描述
    var desContent : String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description"{
            super.setValue(value, forKey: "desContent")
        }else{
            super.setValue(value, forKey: key)
        }
    }
}
