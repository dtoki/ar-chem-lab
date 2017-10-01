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
    let symbol: String
    let atomicMass: Double
    let atomicNumber: Int
    let excessElectrons: String
    let mainTitle: String
    
    init(name: String, symbol: String, atomicMass: Double, atomicNumber: Int, excessElectrons: String, mainTitle: String){
        self.name = name
        self.symbol = symbol
        self.atomicMass = atomicMass
        self.atomicNumber = atomicNumber
        self.excessElectrons = excessElectrons
        self.mainTitle = mainTitle
    }
}
