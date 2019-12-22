//
//  FSCookBookCategoryModel.swift
//  fitsky
//  菜谱分类 model
//  Created by gouyz on 2019/11/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSCookBookCategoryModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 属性名称
    var name : String? = ""
    ///
    var parent_id : String? = ""
    ///
    var material : String? = ""
    ///
    var thumb : String? = ""
    /// 参数名
    var category_key : String? = ""
    /// 子分类列表
    var childList: [FSCookBookCategoryModel] = [FSCookBookCategoryModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "_child"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSCookBookCategoryModel(dict: item)
                childList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
