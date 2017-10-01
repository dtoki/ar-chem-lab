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
    
    var deepNode: SCNNode?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deepNode = makeCube()
        sceneView.pointOfView?.addChildNode(deepNode!)
    }
    
    func getARObject(at location: CGPoint) -> SCNNode? {
        if let hit = sceneView.hitTest(location, options: nil).first{
            return hit.node
        }
        return nil
    }
    
    func makeCube(_ scale: CGFloat = 0.3, color: UIColor = UIColor.blue.withAlphaComponent(0.3))->SCNNode{
        let cubeGeometry = SCNBox(width: scale, height: scale, length: scale, chamferRadius: 0.0)
        
        let greenMaterial = SCNMaterial()
        greenMaterial.diffuse.contents = color
        cubeGeometry.materials = [greenMaterial]
        let cubeNode = SCNNode(geometry: cubeGeometry)
        cubeNode.position = SCNVector3(0.0, 0.0, -1.0)
        return cubeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    }
    
    @objc func connectAtoms(byReactingTo panRecognizer: UIPanGestureRecognizer){
        let location = panRecognizer.location(in: sceneView)
        switch panRecognizer.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        default:
            break
        }
    }
    
    var depth: CGFloat = 1.0 {
        didSet {
            deepNode?.position = SCNVector3(0.0, 0.0, -depth)
        }
    }
    @objc func moveInDepth(byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
        switch pinchRecognizer.state{
        case .changed, .ended:
            depth /= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    @objc func selectAtom(byReactingTo tapRecognizer: UITapGestureRecognizer){
        let location = tapRecognizer.location(in: sceneView)
        switch tapRecognizer.state {
        case .ended:
            if deepNode != nil {
                let deepNodeTransform = deepNode!.worldTransform
                deepNode!.removeFromParentNode()
                deepNode!.transform = deepNodeTransform
                sceneView.scene.rootNode.addChildNode(deepNode!)
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

