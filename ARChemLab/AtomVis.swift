//
//  AtomVis.swift
//  ARChemLab
//
//  Created by Alireza Alidousti on 2017-09-30.
//  Copyright © 2017 ARTris. All rights reserved.
//

import SceneKit

class AtomVis{
    let path: String
    let atom: Atom
    var node: SCNNode?
    
    init(path: String, atom: Atom){
        self.path = path
        self.atom = atom
    }
    
    func loadNode(){
        let scene = SCNScene(named: path)!
        let atomNode = scene.rootNode.childNode(withName: atom.name, recursively: true)
        node = atomNode
    }
}
