//
//  UDHelper.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation

class UDHelper {
    
    func saveUserData(username: String, id: Int) {
        let preferences = UserDefaults.standard
    
        preferences.set(username, forKey: "username")
        preferences.set(id, forKey: "id")
        
        didSave(preferences: preferences)
    }
    
    func saveSessionId(session_id: String){
        let preferences = UserDefaults.standard
        
        preferences.set(session_id, forKey: "session_id")
       
        // Checking the preference is saved or not
        didSave(preferences: preferences)
    }
    
    func getSessionId() -> String{
        let preferences = UserDefaults.standard
        if preferences.string(forKey: "session_id") != nil{
            let access_token = preferences.string(forKey: "session_id")
            return access_token!
        } else {
            return ""
        }
    }
    
    func getAccountId() -> Int{
        let preferences = UserDefaults.standard
        let id = preferences.integer(forKey: "id")
        return id
    }
    
    func getUsername() -> String {
        let preferences = UserDefaults.standard
        if preferences.string(forKey: "username") != nil {
            let username = preferences.string(forKey: "username")
            return username!
        } else {
            return ""
        }
    }
    
    // Checking the UserDefaults is saved or not
    func didSave(preferences: UserDefaults){
        let didSave = preferences.synchronize()
        if !didSave{
            // Couldn't Save
            print("Preferences could not be saved!")
        }
    }
    
    // Clearing UserDefaults!
    func clearUDM(){
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
}
