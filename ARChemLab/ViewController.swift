//
//  ViewController.swift
//  ARChemLab
//
//  Created by Alireza Alidousti on 2017-09-30.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var atomCardDetails: AtomDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let hydrogenAtom = Atom(name: "shipMesh", atomicMass: 1, atomicNumber: 1, excessElectrons: -1)
        let H = AtomVis(path: "art.scnassets/ship.scn", atom: hydrogenAtom)
        H.loadNode()
        sceneView.scene.rootNode.addChildNode(H.node!)
        addAtomCardDetails(for: hydrogenAtom)
    }
    
    func addAtomCardDetails(for atom:Atom){
        let atomCardDetails: AtomDetailView
        
        if let existingAtomCardView = self.atomCardDetails{
            atomCardDetails = existingAtomCardView
        }else{
            // init the atom card
            atomCardDetails = AtomDetailView()
            self.atomCardDetails = atomCardDetails
            self.view.addSubview(atomCardDetails)
            
            atomCardDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            atomCardDetails.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
}

