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
    let atomicRadius = ["0.05" : Atom(name: "Hydrogen", symbol: "H", atomicMass: 1.008, atomicNumber: 1, excessElectrons: "1", mainTitle:"Hydrogen(H)"),
                        "0.1" : Atom(name: "Oxygen", symbol: "O", atomicMass: 15.999, atomicNumber: 8, excessElectrons: "2, 6",mainTitle:"Oxygen(O)"),
                        "0.15" : Atom(name: "Nitrogen", symbol: "N", atomicMass: 14.006, atomicNumber: 7, excessElectrons: "2, 5",mainTitle:"Nitrogen(N)"),
                        "0.2" : Atom(name: "Carbon", symbol: "C", atomicMass: 12.010, atomicNumber: 6, excessElectrons: "2, 4",mainTitle:"Carbon(C)"),]
    
    var atomDetailCard: AtomDetailView?
    @IBOutlet weak var sceneView: ARSCNView! {
        didSet{
            // Draging from source
            let panHandler = #selector(ViewController.connectAtoms(byReactingTo:))
            let panRecognizer = UIPanGestureRecognizer(target: self, action: panHandler)
            sceneView.addGestureRecognizer(panRecognizer)
            // Move in depth
            let pinchHandler = #selector(ViewController.moveInDepth(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: pinchHandler)
            sceneView.addGestureRecognizer(pinchRecognizer)
            // show info card
            let tapHandler = #selector(ViewController.selectAtom(byReactingTo:))
            let tapRecognizer = UITapGestureRecognizer(target: self, action: tapHandler)
            sceneView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    func addInfo(){
        let rect = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 120)
        atomDetailCard = AtomDetailView(frame: rect)
        atomDetailCard?.backgroundColor = UIColor.white
        self.view.addSubview(atomDetailCard!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        addInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    var activeAtom: SCNNode?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let oxygenNode = makeSphere(scale: 0.1, texturePath:  "art.scnassets/oxyTexture.png")
        oxygenNode.position = SCNVector3(-0.5, 0.0, -1.5)
        sceneView.scene.rootNode.addChildNode(oxygenNode)
        let h1Node = makeSphere(scale: 0.05, texturePath:  "art.scnassets/hydrogenTexture.png")
        h1Node.position = SCNVector3(0, 0.0, -1.5)
        sceneView.scene.rootNode.addChildNode(h1Node)
        let h2Node = makeSphere(scale: 0.05, texturePath:  "art.scnassets/hydrogenTexture.png")
        h2Node.position = SCNVector3(0.5, 0.0, -1.5)
        sceneView.scene.rootNode.addChildNode(h2Node)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//    }
    
    func getARObject(at location: CGPoint) -> SCNNode? {
        if let hit = sceneView.hitTest(location, options: nil).first{
            return hit.node
        }
        return nil
    }
    
    func makeSphere(scale: CGFloat, texturePath: String)->SCNNode{
        let sphereGeometry = SCNSphere(radius: scale)
        
        let material = SCNMaterial()
        let image = UIImage(named: texturePath)
        material.diffuse.contents = image
//        material.diffuse.contents = color
        
        sphereGeometry.materials = [material]
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position = SCNVector3(0.0, 0.0, -1.0)
        return sphereNode
    }
    
    func connectAtoms(from start: SCNNode, to end: SCNNode){
        // https://stackoverflow.com/questions/30827401/cylinder-orientation-between-two-points-on-a-sphere-scenekit-quaternions-ios
        // height of the cylinder should be the distance between points
        let height = GLKVector3Distance(
            SCNVector3ToGLKVector3(start.position),
            SCNVector3ToGLKVector3(end.position)
        )
        
        // add a container node for the cylinder to make its height run along the z axis
        let zAlignNode = SCNNode()
        zAlignNode.eulerAngles.x = Float.pi / 2
        
        // material
        let cylinderGeometry = SCNCylinder(radius: 0.03, height: CGFloat(height))
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.brown.withAlphaComponent(0.3)
        cylinderGeometry.materials = [material]
        // and position the zylinder so that one end is at the local origin
        let cylinder = SCNNode(geometry: cylinderGeometry)
        cylinder.position.y = -height / 2
        zAlignNode.addChildNode(cylinder)

        // put the container node in a positioning node at one of the points
        start.addChildNode(zAlignNode)
        // and constrain the positioning node to face toward the other point
        start.constraints = [ SCNLookAtConstraint(target: end) ]
    }
    
    var startAtom: SCNNode?
    @objc func connectAtoms(byReactingTo panRecognizer: UIPanGestureRecognizer){
        let location = panRecognizer.location(in: sceneView)
        switch panRecognizer.state {
        case .began:
            if let startNode = getARObject(at: location){
                startAtom = startNode
            }
        case .ended:
            if startAtom != nil, let endNode = getARObject(at: location) {
                connectAtoms(from: startAtom!, to: endNode)
            }
        default:
            break
        }
    }
    

    @objc func moveInDepth(byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
        switch pinchRecognizer.state{
        case .changed, .ended:
            activeAtom?.position.z /= Float(pinchRecognizer.scale)
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func moveToRootNode(_ node: SCNNode){
        let nodeWorldTransfrom = node.worldTransform
        node.removeFromParentNode()
        node.transform = nodeWorldTransfrom
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func moveToCameraNode(_ node: SCNNode){
        let newTransform = sceneView.scene.rootNode.convertTransform(node.worldTransform, to: sceneView.pointOfView)
        node.removeFromParentNode()
        sceneView.pointOfView?.addChildNode(node)
        node.transform = newTransform
    }
    
    @objc func selectAtom(byReactingTo tapRecognizer: UITapGestureRecognizer){
        let location = tapRecognizer.location(in: sceneView)
        switch tapRecognizer.state {
        case .ended:
            if let selectedObject = getARObject(at: location) {
                // remove cylinder
                if selectedObject.geometry != nil, selectedObject.geometry!.isKind(of: SCNCylinder.self){
                    selectedObject.removeFromParentNode()
                    break
                }
                activeAtom = selectedObject
                if let anyGeo = activeAtom?.geometry as? SCNSphere {
                    swapCardDetails(radius: "\(anyGeo.radius)");
                }
                 moveToCameraNode(activeAtom!)
            } else {
                if activeAtom != nil {
                    moveToRootNode(activeAtom!)
                    activeAtom = nil
                    swapAwayDetails()
                }

            }
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // swap the card details for the padded in atom
    var isDisplayed: Bool = false
    func swapAwayDetails(){
        UIView.animate(withDuration: 0.3, animations: {
            if let card = self.atomDetailCard{
                let newY = self.view.frame.height
                card.frame.origin = CGPoint(x: 0, y: newY)
            }
        })
        isDisplayed = false
    }
    
    func swapCardDetails(radius: String){
        if let atom = atomicRadius[radius] {
           atomDetailCard?.atomSymbol.text = atom.symbol
            atomDetailCard?.atomMass.text = "\(atom.atomicMass)"
            atomDetailCard?.atomMass2.text = "\(atom.atomicMass)"
            atomDetailCard?.atomName.text = atom.name
            atomDetailCard?.atomName2.text = atom.name
            atomDetailCard?.excessElectrons.text = atom.excessElectrons
            atomDetailCard?.atomNumber.text = "\(atom.atomicNumber)"
            atomDetailCard?.atomNumber2.text = "\(atom.atomicNumber)"
            atomDetailCard?.mainTitle.text = atom.mainTitle
            
        }
        UIView.animate(withDuration: 0.3, animations: {
            if let card = self.atomDetailCard{
                let newY = self.view.frame.height - card.frame.height
                card.frame.origin = CGPoint(x: 0, y: newY)
            }
        })
        isDisplayed = true
    }
}
