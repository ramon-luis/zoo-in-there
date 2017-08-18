//
//  Animal.swift
//  It's a Zoo in There
//
//  Created by Ramon RODRIGUEZ on 1/27/17.
//  Copyright © 2017 Ramon Rodriguez. All rights reserved.
//

import UIKit

class Animal {
    
    // constants: do not change once object created
    let name: String
    let species: String
    let origin: String
    let designer: String
    let image: UIImage
    let soundPath: String
    
    init(name: String, species: String, origin: String, designer: String, image: UIImage, soundPath: String) {
        self.name = name
        self.species = species
        self.origin = origin
        self.designer = designer
        self.image = image
        self.soundPath = soundPath
    }
    
    
    // print to console: suggested for debugging
    func dumpAnimalObject() {
        print("Animal Object: name=\(name), species=\(species), designer=\(designer), image=\(image), soundPath=\(soundPath)")
    }
    
    
}
