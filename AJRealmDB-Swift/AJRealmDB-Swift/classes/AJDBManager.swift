//
//  FSDBManager.swift
//  RealmDB
//
//  Created by zhongbaojian on 2017/6/23.
//  Copyright © 2017年 zbj. All rights reserved.
//

import UIKit
import RealmSwift

public struct SortOption {
    /// 排序根据的参数名
    var propertyName:String
    /// 是否升序
    var isAscending:Bool
}


public class AJDBManager<T:AJDBBaseBean>: NSObject {
    
    //MARK:- Public
    
    
    /// Insert single obj or many objs to database
    ///
    /// - Parameter objs: target objs
    public class func write(_ objs:[T]) {
        
        guard objs.count > 0 else {
            return;
        }

        let realm = realmInstance();

        do {
            try realm?.write {
                if objs.count == 1 {
                    if let item = objs.first {
                        realm?.add(item, update: true);
                    }
                }else {
                    realm?.add(objs, update:true);
                }
            }
        }catch let err as NSError{
            print("fail to write transaction: \(err.description)");
        }
    }
    
    
    /// update single obj or many objs, the update session need to do in closure
    ///
    /// - Parameter session: update session
    public class func update(_ session:(()->Void)) {
        let realm = realmInstance();
        do {
            realm?.beginWrite();
            session();
            try realm?.commitWrite();
            
        }catch let err as NSError {
            print("fail to update transaction: \(err.description)");
        }
    }
    
    
    /// query objs in database
    ///
    /// - Parameters:
    ///   - type: target obj type
    ///   - filter: query filter
    ///   - sort: query result sort option
    /// - Returns: query result objs
    public class func query(_ type:T.Type, filter:NSPredicate? = nil, sort:SortOption? = nil) -> [T] {
        
        let realm = realmInstance();
        var results = realm?.objects(type);
        
        if filter != nil {
            results = results?.filter(filter!);
        }
        
        if sort != nil {
            results = results?.sorted(byKeyPath: sort!.propertyName, ascending: sort!.isAscending);
        }
        
        if results != nil {
            
            var convertResult:[T] = [];
            for i in 0..<results!.count {
                let item = results![i];
                convertResult.append(item);
            }
            
            return convertResult;
            
        }else{
            return [];
        }
    }
    
    
    /// query obj with its primary key
    ///
    /// - Parameters:
    ///   - type: target obj type
    ///   - key: primary key
    /// - Returns: query result
    public class func query<K>(_ type:T.Type, withPrimaryKey key:K) -> T? {
        
        let realm = realmInstance();
        let target = realm?.object(ofType: type, forPrimaryKey: key);
        
        return target;
    }
    
    
    /// delete target objs
    ///
    /// - Parameter objs: target
    public class func delete(_ objs:[T]) {
        
        guard objs.count > 0 else {
            return;
        }
        
        let realm = realmInstance();
        
        do {
            try realm?.write {
                
                if objs.count == 1 {
                    if let item = objs.first {
                        realm?.delete(item);
                    }
                }else{
                    realm?.delete(objs);
                }
            }
        }catch let err as NSError {
            print("fail to delete transaction: \(err.description)")
        }
    }
    
    
    /// delete target objs, if filter is nil, it will delete all target type objs
    ///
    /// - Parameters:
    ///   - type: target obj type
    ///   - filter: filter the target objs need to delete
    public class func delete(_ type:T.Type, filter:NSPredicate? = nil) {
        let targetObjs = self.query(type, filter: filter);
        self.delete(targetObjs);
    }
    
    
    /// delete target obj
    ///
    /// - Parameters:
    ///   - type: target obj type
    ///   - key: target obj primary key
    public class func delete<K>(_ type:T.Type, withPrimaryKey key:K) {
        
        if let target = self.query(type, withPrimaryKey: key) {
            self.delete([target]);
        }else {
            print("delete fail, obj is not exist");
        }
    }
    
    
    /// delete all objs in database
    public class func cleanDB() {
        let realm = realmInstance();
        
        do {
            try realm?.write {
                realm?.deleteAll();
            }
        }catch let err as NSError {
            print("fail to clean transaction: \(err.description)")
        }
    }
    
    
    //MARK:- Private
    fileprivate class func realmInstance() -> Realm? {
        
        if let config = AJDBConfig.shared.realmConfig {
            
            var instance:Realm? = nil;
            do {
                
                instance = try Realm(configuration: config);
                
            }catch let err as NSError {
                Log.info(content:"init realm db fail: \(err.description)")
            }
            
            return instance;
        }else {
            
            Log.warn(content: "init realm db fail: !!!config is nil!!!")
            
            return nil;
        }
    }
    
}
