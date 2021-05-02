//
//  DB.swift
//  RealmSwift
//
//  Created by apple on 01/05/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    
    private var database:Realm
    static let sharedInstance = DBManager()
    
    private init() {
        
        database = try! Realm()
        
    }
    
    //MARK:- filterData
    func filterData(searchText:String) -> Results<PetList> {
        
        let data = database.objects(PetList.self).filter("pet_name CONTAINS [c]%@",searchText)
        if data.count > 0 {
            return data
        }else{
            let breedData = database.objects(PetList.self).filter("breed_type CONTAINS [c]%@",searchText)
            return breedData
        }
    }
    
    //MARK:- getDataFromDB
    func getDataFromDB() -> Results<CategoryModelClass> {
        
        let results: Results<CategoryModelClass> = database.objects(CategoryModelClass.self)
        return results
    }
    
    //MARK:- addData
    func addData(object: CategoryModelClass) {
        
        try! database.write {
            database.add(object)
            //add(object, update: true)
            print("Added new object")
        }
    }
    
    //MARK:- deleteAllDatabase
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
     //MARK:- deleteFromDb
    func deleteFromDb(object: CategoryModelClass) {
        
        try! database.write {
            
            database.delete(object)
        }
    }
    
}
