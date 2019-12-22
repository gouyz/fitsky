//
//  FSCookBookDetailModel.swift
//  fitsky
//  食谱详情 model
//  Created by gouyz on 2019/11/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSCookBookDetailModel: LHSBaseModel {
    
    
    var formData: FSCookBookModel?
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    /// 食材列表
    var foodModelList: [FSFoodModel] = [FSFoodModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSCookBookModel(dict: datas)
        }else if key == "food"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSFoodModel(dict: item)
                foodModelList.append(model)
            }
        }else if key == "share"{
            guard let datas = value as? [String : Any] else { return }
            sharedModel = FSSharedModel(dict: datas)
        }else if key == "more"{
            guard let datas = value as? [String : Any] else { return }
            moreModel = FSDynamicMoreModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
