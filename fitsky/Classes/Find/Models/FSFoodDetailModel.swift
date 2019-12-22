//
//  FSFoodDetailModel.swift
//  fitsky
//  食材详情 model
//  Created by gouyz on 2019/11/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSFoodDetailModel: LHSBaseModel {

    var formData: FSFoodModel?
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSFoodModel(dict: datas)
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
