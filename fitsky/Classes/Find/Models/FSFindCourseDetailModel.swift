//
//  FSFindCourseDetailModel.swift
//  fitsky
//  发现课程详情 model
//  Created by gouyz on 2019/11/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSFindCourseDetailModel: LHSBaseModel {

    var formData: FSFindCourseModel?
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 推荐课程list
    var recommendList: [FSFindCourseModel] = [FSFindCourseModel]()
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    /// 已学习人数列表（默认显示最新4个）
    var userList:[FSStudyUserModel] = [FSStudyUserModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSFindCourseModel(dict: datas)
        }else if key == "course_recommend"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSFindCourseModel(dict: item)
                recommendList.append(model)
            }
        }else if key == "course_member"{
            guard let datas = value as? [[String : Any]] else { return }
            for item in datas {
                let model = FSStudyUserModel(dict: item)
                userList.append(model)
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
/// 发现课程 已学习人数 model
@objcMembers
class FSStudyUserModel: LHSBaseModel {
    ///
    var member_id : String? = ""
    ///
    var member_type : String? = ""
    ///
    var nick_name : String? = ""
    ///
    var sex : String? = ""
    ///
    var avatar : String? = ""
    ///
    var sex_text : String? = ""
}
