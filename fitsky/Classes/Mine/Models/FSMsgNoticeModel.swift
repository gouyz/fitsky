//
//  FSMsgNoticeModel.swift
//  fitsky
//  通知 消息model
//  Created by gouyz on 2019/12/4.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSMsgNoticeModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 推送标题
    var title : String? = ""
    /// 图片
    var material : String? = ""
    /// 推送内容
    var content : String? = ""
    /// 发送时间
    var send_time : String? = ""
    ///
    var display_send_time : String? = ""
}
