//
//  FSFindCourseCategoryModel.swift
//  fitsky
//  发现课程 分类model
//  Created by gouyz on 2019/11/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSFindCourseCategoryModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 属性名称
    var name : String? = ""
    ///
    var parent_id : String? = ""
    /// 参数名
    var attr_key : String? = ""
    /// 子分类列表
    var childList: [FSFindCourseCategoryModel] = [FSFindCourseCategoryModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "_child"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSFindCourseCategoryModel(dict: item)
                childList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
}
