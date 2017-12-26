//
//  ViewController.swift
//  AJRealmDB-Swift
//
//  Created by zhongbaojian on 2017/12/26.
//  Copyright © 2017年 zbj. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("main: \(Thread.current)")
        
//        testInsert();
        
        testQuery();
        
//        testUpdate();
        
//        testDelete()

//        self.testClean();
    }
    
    func testClean() {
        AJDBManager.cleanDB();
    }

}

//MARK:- Delete
extension ViewController {

    func testDelete() {
        insertObjs();
        
//        delete1();
//        delete2();
        
        
        DispatchQueue.global().async {
            self.delete3()
        }
    }
    
    func insertObjs() {
        let book1:BookBean = BookBean();
        book1.id = 123226;
        book1.name = "从0到1";
        book1.type = "创业";
        
        let book2:BookBean = BookBean();
        book2.id = 123227;
        book2.name = "跨界";
        book2.type = "创业";
        
        let book3:BookBean = BookBean();
        book3.id = 123228;
        book3.name = "乔布斯传";
        book3.type = "传记";
        
        AJDBManager.write([book1, book2, book3]);
    }
    
    func delete1() {
        
        print("#删除前#：")
        checkChanges();
        
        
        AJDBManager.delete(BookBean.self, withPrimaryKey: 123457);
        print("#删除后#：")
        checkChanges();
        
    }
    
    func delete2() {
        print("#删除前#：")
        checkChanges();
        
        
        let filter:NSPredicate = NSPredicate(format: "type=%@", "创业")
        let objs = AJDBManager.query(BookBean.self, filter:filter);
        AJDBManager.delete(objs);
        
        print("#删除后#：")
        checkChanges();
    }
    
    func delete3() {
        print("#删除前#：")
        checkChanges();
        
        
        let filter:NSPredicate = NSPredicate(format: "type=%@", "创业")
        AJDBManager.delete(BookBean.self, filter: filter)
        
        print("#删除后#：")
        checkChanges();
    }
    
    func checkChanges() {
        let books = AJDBManager.query(BookBean.self);
        print("\(books)");
    }
}

//MARK:- Update
extension ViewController {
    func testUpdate() {
//        update1()
        update2()
    }
    
    func update1() {
        if let person = AJDBManager.query(PersonBean.self, withPrimaryKey: 8688) {
            
            print("#修改前#: \(person)")
            
            AJDBManager.update {
                
                person.name = "买金呗";
                person.age = 10;
            
            }
            
            //--
            let after = DispatchTime.now()+2.0;
            DispatchQueue.main.asyncAfter(deadline: after, execute: {
                print("#修改后#");
                self.query1();
            })
        }
    }
    
    func update2() {
        let tmp:String = String(format: "height>%.2f AND height<%.2f", 32.0, 50.0)
        let filter:NSPredicate = NSPredicate(format: tmp);
        let sort:SortOption = SortOption(propertyName: "height", isAscending: false)
        let dogs = AJDBManager.query(DogBean.self, filter: filter, sort: sort)
        
        print("#修改前#：\(dogs)");
        
        
        AJDBManager.update {
            for i in dogs {
                i.name = "长大的🐶";
            }
        }
        
        let after = DispatchTime.now()+2.0;
        DispatchQueue.main.asyncAfter(deadline: after, execute: {
            let dogs2 = AJDBManager.query(DogBean.self, filter: filter, sort: sort)
            print("#修改后# \(dogs2)")
        })
    }
}

//MARK:- Query
extension ViewController {
    
    func testQuery() {
        query1();
        query2();
        query3();
    }
    
    func query1() {
        
        let key:Int64 = 8688;
        if let obj = AJDBManager.query(PersonBean.self, withPrimaryKey: key) {
            print("$\(key)$: \(obj)")
            
            
            
            
            
        }
    }
    
    func query2() {
        
        let objs = AJDBManager.query(DogBean.self);
        print("$ALL$: \(objs)")
    }
    
    func query3() {
        let tmp:String = String(format: "height>%.2f AND height<%.2f", 32.0, 50.0)
        let filter:NSPredicate = NSPredicate(format: tmp);
        let sort:SortOption = SortOption(propertyName: "height", isAscending: false)
        let objs = AJDBManager.query(DogBean.self, filter: filter, sort: sort)
        print("$FILTER$: \(objs)")
    }
}

//MARK:- Insert
extension ViewController {
    func testInsert() {
        
        DispatchQueue.global().async {
            print("1: \(Thread.current)")
            self.insert1();
        }
        
        DispatchQueue.main.async {
            print("2: \(Thread.current)")
            self.insert2();
        }
        
    }
    
    func insert2() {
        
        let dog3:DogBean = DogBean();
        dog3.id = 1003;
        dog3.name = "编号003";
        dog3.height = 40.66;
        dog3.tmp = true;
        
        
        //---
        let user1:PersonBean = PersonBean();
        user1.id = 8688;
        user1.name = "用户66";
        user1.height = 175.8;
        user1.weight = 62.99;
        user1.age = 30;
        user1.gender = false;
        user1.dog = dog3;
        
        AJDBManager.write([user1])
    }
    
    func insert1() {
        let dog1:DogBean = DogBean();
        dog1.id = 1001;
        dog1.name = "编号001";
        dog1.height = 30.66;
        dog1.tmp = true;
        
        let dog2:DogBean = DogBean();
        dog2.id = 1002;
        dog2.name = "编号002";
        dog2.height = 35.66;
        dog2.tmp = false;
        
        let dog:DogBean = DogBean();
        dog.id = 11006;
        dog.name = "编号66";
        dog.height = 60.66;
        dog.tmp = true;
        dog.childs.append(dog1)
        dog.childs.append(dog2)
        
        
        AJDBManager.write([dog]);
    }
}


//MARK:--

class DogBean:AJDBBaseBean {
    
    @objc dynamic var id:Int64 = 0;
    @objc dynamic var name:String = "";
    @objc dynamic var height:Double = 0.0;
    @objc dynamic var age:Int = 0;
    @objc dynamic var gender:Int = 10;
    let childs:List = List<DogBean>();
    
    @objc dynamic var tmp:Bool = false;
    
    override class func primaryKey() -> String? {
        return "id";
    }
    
    override class func ignoredProperties() -> [String] {
        return ["tmp"];
    }
}

class PersonBean:AJDBBaseBean {
    
    @objc dynamic var id:Int64 = 0;
    @objc dynamic var name:String = "";
    @objc dynamic var height:Double = 0.0;
    @objc dynamic var weight:Double = 0.0;
    @objc dynamic var age:Int = 0;
    @objc dynamic var gender:Bool = true;
    
    @objc dynamic var dog:DogBean? = nil;
    
    override class func primaryKey() -> String? {
        return "id";
    }
}

class BookBean:AJDBBaseBean {
    @objc dynamic var id:Int64 = 0;
    @objc dynamic var name:String = "";
    @objc dynamic var type:String = "";
    
    override class func primaryKey() -> String? {
        return "id";
    }
}



