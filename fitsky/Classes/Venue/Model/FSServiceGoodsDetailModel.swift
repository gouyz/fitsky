//
//  FSServiceGoodsDetailModel.swift
//  fitsky
//  服务课程详情 model
//  Created by gouyz on 2019/9/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSServiceGoodsDetailModel: LHSBaseModel {
    
    var formData: FSVenueServiceModel?
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 点赞、收藏、评论等数量
    var countModel: FSDynamicCountModel?
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSVenueServiceModel(dict: datas)
        }else if key == "count"{
            guard let datas = value as? [String : Any] else { return }
            countModel = FSDynamicCountModel(dict: datas)
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

