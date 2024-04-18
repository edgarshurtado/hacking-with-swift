//
//  Person.swift
//  p10-names-to-faces
//
//  Created by Edgar Sánchez Hurtado on 1/3/24.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
