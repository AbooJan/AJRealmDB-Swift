//
//  FSDBConfig.swift
//  RealmDB
//
//  Created by zhongbaojian on 2017/9/29.
//  Copyright © 2017年 heshidai. All rights reserved.
//

import UIKit
import RealmSwift

public class AJDBConfig: NSObject {
    
    //MARK:-
    public static let shared = AJDBConfig();
    
    
    /// 自定义数据库配置，如果不配置，即使用默认
    ///
    /// - Parameter config: 数据库配置
    public func customConfig(_ config:Realm.Configuration) {
        self.realmConfig = config;
    }
    
    
    /// 数据库版本合并，默认不做处理
    ///
    /// - Parameters:
    ///   - m: 数据库合并信息
    ///   - newVersion: 新版本号，等于当前app的build num加1000
    ///   - oldVersion: 旧版本号，等于上一个app的build num加1000
    public func dbVersionMerge(_ m:Migration, newVer:UInt64, oldVer:UInt64) {
        
        Log.info(content: "版本合并");
        
        // 数据迁移
//        m.enumerateObjects(ofType: DogBean.className(), { (oldObj, newObj) in
//
//            if oldVer < newVer {
//
//                if oldObj != nil && newObj != nil {
//                    if let oldVal = oldObj!["gender"] as? Bool {
//                        newObj!["gender"] = oldVal ? 10:20;
//                    }
//                }
//            }
//        })
        
        
        if oldVer < newVer {
            // 旧->新数据迁移
            
        }else {
            //
        }
    }
    
    
    //MARK:-
    internal var realmConfig:Realm.Configuration? = nil;
    private override init() {
        
        super.init();
        
        var sourceKey:String = "";
        for i in 0...9 {
            sourceKey += "\(i)";
        }
        sourceKey += "fOzACGGgRu";
        for i in (0...9).reversed() {
            sourceKey += "\(i)"
        }
        sourceKey += "tVidwjUQn9q6TfkyHtBXWj5sHEeGh6nIYe";
        
        // 64 位加密key
        let key:Data = sourceKey.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        let keyStr:String = String(format: "%@", key as CVarArg)
        Log.info(content: "#KEY#"+keyStr)
        
        
        var schemaVersion:UInt64 = UInt64(1);
        if let bundleInfo = Bundle.main.infoDictionary {
            if let buildVersion = bundleInfo["CFBundleVersion"] as? String, let num = UInt64(buildVersion) {
                schemaVersion = num+1000;
            }
        }
        
        let filePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/FSDB.realm");
        
        
        self.realmConfig = Realm.Configuration(fileURL: URL(string:filePath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: key, readOnly: false, schemaVersion: schemaVersion, migrationBlock: {[unowned self] (m:Migration, oldSchemaVersion:UInt64) in
            
            self.dbVersionMerge(m, newVer: schemaVersion, oldVer: oldSchemaVersion);
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch:nil, objectTypes: nil);
        
        /// 发生版本合并时会清理本地数据，防止崩溃
        self.realmConfig?.deleteRealmIfMigrationNeeded = true;
    }
    
}
