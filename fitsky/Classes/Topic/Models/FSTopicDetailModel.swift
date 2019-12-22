//
//  FSTopicDetailModel.swift
//  fitsky
//  话题详情model
//  Created by gouyz on 2019/9/9.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSTopicDetailModel: LHSBaseModel {
    /// 话题model
    var formData: FSTalkModel?
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 话题麦克风model
    var topicAdminModel: FSTopicAdminModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSTalkModel(dict: datas)
        }else if key == "topic_admin"{
            guard let datas = value as? [String : Any] else { return }
            topicAdminModel = FSTopicAdminModel(dict: datas)
        }else if key == "share"{
            guard let datas = value as? [String : Any] else { return }
            sharedModel = FSSharedModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
/// 话题麦克风model
@objcMembers
class FSTopicAdminModel: LHSBaseModel {
    ///
    var id : String? = ""
    /// 话题id
    var topic_id : String? = ""
    /// 麦克风ID
    var member_id : String? = ""
    /// 麦克风用户名
    var member_name : String? = ""
    /// 麦克风昵称
    var nick_name : String? = ""
    /// 麦克风头像
    var avatar : String? = ""
    /// 麦克风性别（0-女 1-男 2-保密）
    var sex : String? = ""
    /// 麦克风状态（0-待审核 1-已审核 2-被驳回 3-退出）
    var status : String? = ""
    ///
    var create_time : String? = ""
    ///
    var update_time : String? = ""
    /// 退出时间
    var exit_time : String? = ""
}

/// 分享model
@objcMembers
class FSSharedModel: LHSBaseModel {
    /// 分享标题
    var title : String? = ""
    /// 分享描述
    var desc : String? = ""
    /// 分享图片
    var img_url : String? = ""
    /// 分享链接
    var link : String? = ""
}
