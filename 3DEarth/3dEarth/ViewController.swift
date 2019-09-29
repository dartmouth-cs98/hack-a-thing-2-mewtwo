//
//  ViewController.swift
//  3dEarth
//
//  Created by Kiron on 9/26/19.
//  Copyright © 2019 Qirong Li. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        
        // set camera and camera location
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x:0, y: 0, z: 5)
        
        scene.rootNode.addChildNode(cameraNode)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
        
        scene.rootNode.addChildNode(lightNode)
        
        // use star particles
        let stars = SCNParticleSystem(named: "StarsParticles.scnp", inDirectory: nil)!
        scene.rootNode.addParticleSystem(stars)
        
        let earthNode = EarthNode()
        scene.rootNode.addChildNode(earthNode)
        
        
        let sceneView = self.view as! SCNView
        sceneView.scene = scene
        
        // show statistics and background color
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
        
        
    }

    override var prefersStatusBarHidden: Bool {
        // to get rid of battery percentage
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

