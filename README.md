# AJRealmDB-Swift
Realm 数据库封装


## 数据Bean定义
 * 所有Bean类需要继承自 `AJDBBaseBean` ，然后重写 `primaryKey()` 方法;
 * Bool\Int\Float\Double 类型参数定义，为 ` dynamic var `，然后要加默认值；
   如果它是可选类型，这样定义 ` let value = RealmOptional<Bool\Int\Float\Double>() `。
 
 * String\Data\Date 类型参数定义，为 ` dynamic var `，然后加默认值；
   如果它是可选类型，则定义为 `dynamic var value: String\Data\Date? = nil`
 
 * 对于继承自 `AJDBBaseBean` 类型参数，定义必须为可选类型 `dynamic var value: ClassName?`
 * 对于数组，只能存放 `AJDBBaseBean` 类型变量，定义 `let value = List<ClassName>()`
 
 
 ---
 
 所有的数据操作方法通过类 `AJDBManager` 类来调用.
 
 ## 数据插入
 * 方法: `class func write(_ objs:[T])`
  
 * 说明: `T` 为 `AJDBBaseBean` 类型，可以插入一条或多条数据。
 
 ## 数据查询
 * 方法1 - 通过主键查询: `class func query<K>(_ type:T.Type, withPrimaryKey key:K) -> T?` 
 
 * 方法2 - 通用查询: `class func query(_ type:T.Type, filter:NSPredicate? = nil, sort:SortOption? = nil) -> [T]`
 
 * 说明: 通用查询方法，返回结果可能有多个；可以通过 `NSPredicate` 来筛选查询；`SortOption` 可以对查询结果根据某个字段进行排序，升序或者降序。
 
 * 示例:

  
 ## 数据更新
 * 方法: `class func update(_ session:(()->Void))` 
  
 * 说明: 要更新数据Bean，直接对Bean的成员变量重新赋值，这个赋值过程在 `update` 闭包里面实现，这样既可更新到数据库。
  
 * 示例:
  ```
          if let userModel = readUserInfo() {
            AJDBManager.update({
                
                // 刷新本地用户数据
                if let authToken = model.authToken {
                    userModel.authToken = authToken;
                }
                
                userModel.phone = model.mobilePhone;
            });
          }
  ```
 
 ## 数据删除
 * 方法1 - 删除一个或多个: `class func delete(_ objs:[T])` 
 
 * 方法2 - 条件筛选删除: `class func delete(_ type:T.Type, filter:NSPredicate? = nil)`
 
 * 方法3 - 根据主键删除： `class func delete<K>(_ type:T.Type, withPrimaryKey key:K)`
  
 * 说明: 入参类型跟查询一样
 
 ## 清除数据库
 * 方法: `class func cleanDB()` 
 
 * 说明: 这个方法会清理本地所有数据，谨慎使用。
 
 ---
 
 ## 数据库合并
 数据库版本发生变化时，会发生数据库版本合并，这时可以对数据库的字段进行合并处理。
 
 数据库合并的方法在类 `AJDBConfig` 的方法 `func dbVersionMerge(_ m:Migration, newVer:UInt64, oldVer:UInt64)` 里面。
 
 * 示例:
 ```
  // 数据迁移
  m.enumerateObjects(ofType: GYUserModel.className(), { (oldObj, newObj) in
          
    if oldVer < newVer {
                
        if oldObj != nil && newObj != nil {
             let oldVal = oldObj!["phone_old"] as! String;
              newObj!["phone_new"] = Int64(oldVal);
         }
     }
  })
 ```
 
 ## 数据加密
 数据库的加密配置也在类 `AJDBConfig` 里面定义。
 
 更多可以查看Realm官网文档
