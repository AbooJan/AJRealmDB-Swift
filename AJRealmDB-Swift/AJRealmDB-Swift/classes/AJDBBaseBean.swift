//
//  FSDBBaseBean.swift
//  RealmDB
//
//  Created by zhongbaojian on 2017/6/23.
//  Copyright © 2017年 zbj. All rights reserved.
//
//

/*
 * Bool\Int\Float\Double 类型参数定义，为 ` dynamic var `，然后要加默认值；
   如果它是可选类型，这样定义 ` let value = RealmOptional<Bool\Int\Float\Double>() `。
 
 * String\Data\Date 类型参数定义，为 ` dynamic var `，然后加默认值；
   如果它是可选类型，则定义为 `dynamic var value: String\Data\Date? = nil`
 
 * 对于继承自 FSDBBaseBean 类型参数，定义必须为可选类型 `dynamic var value: ClassName?`
 * 对于数组，只能存放 FSDBBaseBean 类型变量，定义 `let value = List<ClassName>()`

 */

import UIKit
import RealmSwift

open class AJDBBaseBean: Object {

    override open class func ignoredProperties() -> [String] {
        return [];
    }
}


