//
//  Atom.swift
//  ARChemLab
//
//  Created by Alireza Alidousti on 2017-09-30.
//  Copyright © 2017 ARTris. All rights reserved.
//

import Foundation

class  Atom  {
    let name: String
    let atomicMass: Int
    let atomicNumber: Int
    let excessElectrons: Int
    
    init(name: String, atomicMass: Int, atomicNumber: Int, excessElectrons: Int){
        self.name = name
        self.atomicMass = atomicMass
        self.atomicNumber = atomicNumber
        self.excessElectrons = excessElectrons
    }
}
