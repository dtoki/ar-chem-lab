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
    
    var activeAtom: SCNNode?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for i in 0...2 {
            let childNode = makeSphere()
            childNode.position = SCNVector3((-1.0 + Double(i))/2, 0.0, -1.5)
            sceneView.scene.rootNode.addChildNode(childNode)
        }
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//    }
    
    func getARObject(at location: CGPoint) -> SCNNode? {
        if let hit = sceneView.hitTest(location, options: nil).first{
            return hit.node
        }
        return nil
    }
    
    func makeSphere(_ scale: CGFloat = 0.1, color: UIColor = UIColor.blue.withAlphaComponent(0.3))->SCNNode{
        let sphereGeometry = SCNSphere(radius: scale)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        sphereGeometry.materials = [material]
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position = SCNVector3(0.0, 0.0, -1.0)
        return sphereNode
    }
    
    func getLink(from start: SCNNode, to end: SCNNode) -> SCNNode{
        
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
                let connection = getLink(from: startAtom!, to: endNode)
                sceneView.scene.rootNode.addChildNode(connection)
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
            if let selectedAtom = getARObject(at: location) {
                activeAtom = selectedAtom
                moveToCameraNode(activeAtom!)
            } else {
                if activeAtom != nil {
                    moveToRootNode(activeAtom!)
                    activeAtom = nil
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
}
