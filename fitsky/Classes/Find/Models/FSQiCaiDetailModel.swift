//
//  FSQiCaiDetailModel.swift
//  fitsky
//  器械详情 model
//  Created by gouyz on 2019/11/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSQiCaiDetailModel: LHSBaseModel {

    var formData: FSFindCourseModel?
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSFindCourseModel(dict: datas)
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
