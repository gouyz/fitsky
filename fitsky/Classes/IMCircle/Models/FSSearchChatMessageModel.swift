//
//  FSSearchChatMessageModel.swift
//  fitsky
//  搜索聊天记录
//  Created by gouyz on 2020/3/29.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSSearchChatMessageModel: LHSBaseModel {
    /// 会话id
    var targetId : String? = ""
    /// 会话类型
    var conversationType : RCConversationType = .ConversationType_PRIVATE
    /// 发送时间
    var sentTime : Int64 = 0
    /// 消息的类型名
    var objectName : String? = ""
    /// 用户昵称
    var name : String? = ""
    /// 头像
    var portraitUri : String? = ""
    /// 内容
    var otherInformation : String? = ""
}
