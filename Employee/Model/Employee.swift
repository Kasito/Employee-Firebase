//
//  Employee.swift
//  Employee
//
//  Created by Kasito on 16.11.2020.
//

import Foundation
import FirebaseDatabase

class Employee {
    var name: String?
    var dateOfBirth: Double?
    var foto: String?
    var developer: Bool?
    
    init(snapShot: DataSnapshot) {
        let value = snapShot.value as? [String : Any]
        self.name = value?["username"] as? String
        self.dateOfBirth = value?["dateOfBirth"] as? Double
        self.foto = value?["foto"] as? String
        self.developer = value?["developer"] as? Bool
    }
}
