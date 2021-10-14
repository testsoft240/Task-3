//
//  userModel.swift
//  usersLayout
//
//  Created by MAC240 on 06/10/21.
//

import Foundation


 class modelusersData:  NSObject{
    public var users = [Users]()
    public var has_more : Bool?
    
    
    override init() {
        super.init()
    }
    
    init(dictionary:[String:Any]) {
        
        if (dictionary["users"] != nil) {
            if let arr = dictionary["users"] as? [[String:Any]] {
                users = arr.map(Users.init)
            }
            has_more = dictionary["has_more"] as? Bool
        }
    }
}

 class Users {
    public var name : String?
    public var image : String?
    public var items : Array<String>?
    
    init(dictionary:[String:Any]) {
        
        name = dictionary["name"] as? String
        image = dictionary["image"] as? String
        if (dictionary["items"] != nil) {
            items = dictionary["items"] as? [String]
        }
    
     
    }
}
