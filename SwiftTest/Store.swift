//
//  store.swift
//  SwiftTest
//
//  Created by llf on 2023/12/14.
//

import Foundation

struct User {
    
    let name: String!
    let password: String!
    
    init(name: String!, password: String!) {
        self.name = name
        self.password = password
    }
    
}

class AccountStore {
    
    var filePath: String = ""
    init(){
       
        let homeDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask , true)[0] ;
        let plistfile = homeDir + "/user.plist";
        let fm = FileManager.default
        if(!fm.fileExists(atPath: plistfile)){
            let dic = NSDictionary()
            dic.write(toFile: plistfile, atomically: true)
        }
        self.filePath = plistfile
        print("homedir==",plistfile)
        
    }
  
   
    func registerUser(user: User) -> Bool?{
        
        let savedDic = NSMutableDictionary(contentsOfFile: self.filePath)
        savedDic?.setValue(user.password, forKey: user.name)
        let ret = savedDic?.write(toFile: self.filePath, atomically: true)
    
        return ret
    }
    
     func isUserExist(user: User) -> Bool{
        
        let d = NSDictionary(contentsOfFile: self.filePath)
        let keys = d?.allKeys as! Array<String>
        let objUser = user.name
        let ret =  keys.filter { item in
            return item == objUser
        }
        
        if(ret.count > 0){
             return true
        }
       
        return false
        
    }
    func checkNameAndPassword(user: User) -> Bool{
        let d = NSDictionary(contentsOfFile: self.filePath)
        let objPass = d?.value(forKey: user.name) as? String
        
        if let localPwd = objPass{
            if(localPwd == user.password){
                return true
            }
        }
        return false
       
    }
    
    
    
    
    
}
