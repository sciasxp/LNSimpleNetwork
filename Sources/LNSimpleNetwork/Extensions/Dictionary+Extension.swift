//
//  Dictionary+Extension.swift
//  
//
//  Created by Luciano Nunes on 13/06/22.
//

import Foundation

public extension Dictionary {
    
    /**
     Returns a JSON string representation.
     
     - returns: If the dictionary conforms to a JSON returns a string representation of JSON.
     In case the dictionary is not a valid JSON representation, returns nil.
     */
    func jsonString() -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8)
            
        } catch { return nil }
        
    }
    
    /**
     Returns an JSON object.
     
     - returns: If the dictionary conforms to a JSON returns a JSON object.
     In case the dictionary iso not a vlid JSON representation, returns nil.
     */
    func json() -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: self, options: [])
            return postData
            
        } catch(let error) {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}
