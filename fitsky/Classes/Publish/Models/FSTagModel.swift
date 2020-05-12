//
//  FSTagModel.swift
//  fitsky
//  图片标签model
//  Created by gouyz on 2020/5/12.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSTagModel: LHSBaseModel {
    /// x轴坐标
    var tag_x : String? = "0"
    /// y轴坐标
    var tag_y : String? = "0"
    /// 标签类型（0-自定义文字 1-场馆）
    var tag_type : String? = "0"
    /// 标签内容ID（tag_type = 1-表示场馆ID
    var tag_content_id : String? = ""
    /// 标签显示内容
    var tag_content_text : String? = ""
}
