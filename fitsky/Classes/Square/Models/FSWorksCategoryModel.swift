//
//  FSWorksCategoryModel.swift
//  fitsky
//  作品类别 model
//  Created by gouyz on 2019/9/1.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSWorksCategoryModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 分类名称
    var name : String? = ""
    ///
    var alias : String? = ""
    /// 图片地址
    var material : String? = ""
    /// 缩略图
    var thumb : String? = ""
    /// 作品数
    var opus_count : String? = "0"
    /// 阅读数
    var read_count : String? = "0"
}
