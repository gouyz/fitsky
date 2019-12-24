//
//  FSMyCourseDetailModel.swift
//  fitsky
//  我的课程详情 model
//  Created by gouyz on 2019/12/24.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSMyCourseDetailModel: LHSBaseModel {

    var formData: FSVenueServiceModel?
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 点赞、收藏、评论等数量
    var countModel: FSDynamicCountModel?
    /// 订单model
    var orderModel: FSCourseOrderModel?
    
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
        }else if key == "order"{
            guard let datas = value as? [String : Any] else { return }
            orderModel = FSCourseOrderModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
