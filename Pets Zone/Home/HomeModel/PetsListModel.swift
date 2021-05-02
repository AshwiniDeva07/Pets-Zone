//
//  PetsListModel.swift
//  Pets Zone
//
//  Created by apple on 01/05/21.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import RealmSwift


class CategoryModelClass : Object,Codable {
    var categoriesList : List<CategoryList> = List<CategoryList>()
}


class CategoryList : Object,Codable {
    @objc dynamic var url : String?
    @objc dynamic var name : String?
    var petList : List<PetList> = List<PetList>()
}

class PetList : Object,Codable {
    @objc dynamic var id : String?
    @objc dynamic var pet_name : String?
    @objc dynamic var breed_type : String?
    var  photoArray: List<String> = List<String>()
    @objc dynamic var age : String?
    @objc dynamic var distance : String?
    @objc dynamic var address : String?
    @objc dynamic var owner_name : String?
    @objc dynamic var owner_type : String?
    @objc dynamic var owner_url : String?
    @objc dynamic var post_date : String?
    @objc dynamic var notes : String?
}

