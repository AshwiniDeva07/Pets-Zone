//
//  HomeViewModel.swift
//  Pets Zone
//
//  Created by apple on 01/05/21.
//  Copyright © 2021 apple. All rights reserved.
//


import Foundation
import UIKit



class HomeViewModel {
    
    //Original Array from Core Data
    var petDetailsList: CategoryModelClass?
    
    //MARK:- readJsonFile
    //to get data from the raw json file
    func readJsonFile() -> CategoryModelClass{
        
        if let path = Bundle.main.path(forResource: "petsDetail", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    let decoder = JSONDecoder()
                    let valueData = try decoder.decode(CategoryModelClass.self, from: data)
                    self.petDetailsList = valueData
                   
                } catch {
                    print(error)
                }
            } catch {
                // handle error
            }
        }
        return petDetailsList!
    }
    
}
