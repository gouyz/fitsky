//
//  FSFoodGuideModel.swift
//  fitsky
//  饮食指南model
//  Created by gouyz on 2019/11/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSFoodGuideModel: LHSBaseModel {

    /// id category_id_1 的值
    var id : String? = ""
    /// 分类名称
    var name : String? = ""
    /// 分类图片
    var material : String? = ""
    ///
    var alias : String? = ""
    ///
    var parent_id : String? = ""
    /// 蛋白质
    var thumb : String? = ""
    /// 饮食指南ID category_id_1
    var category_key : String? = ""
    /// 食谱list
    var cookBookList: [FSCookBookModel] = [FSCookBookModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "cookbook"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSCookBookModel(dict: item)
                cookBookList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
