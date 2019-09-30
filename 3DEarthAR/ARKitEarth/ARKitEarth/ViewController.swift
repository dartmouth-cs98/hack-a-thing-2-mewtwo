//
//  ViewController.swift
//  ARKitEarth
//
//  Created by Xinchen Zhao on 9/28/19.
//  Copyright © 2019 Unown. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planeGeometry:SCNPlane!
    let planeIdentifiers = [UUID]()
    var anchors = [ARAnchor]()
    var sceneLight: SCNLight!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = false
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        // create a node so that we can add to scene
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3(x:0,y:10,z:2)
        
        sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    // where we're actually configuring the AR session
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        
        addNodeAtLocation(location: location!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    // this is where we can continously do updates
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let estimate = self.sceneView.session.currentFrame?.lightEstimate{
            sceneLight.intensity = estimate.ambientIntensity
        }
    }

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node:SCNNode?
        
        //this is for the first time that we find a node for a specific anchor
        
        if let planeAnchor = anchor as? ARPlaneAnchor{
            node = SCNNode()
            planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y:0,z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            updateMaterial()
            
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
        
            
        }
     
        return node
    }
    
    // deal with updates
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // check if we get a plane anchor
        if let planeAnchor = anchor as? ARPlaneAnchor{
            
            // check if our achors array already containst this plane anchor
            if anchors.contains(planeAnchor){
                
                // we already have a plane node in this area of plane anchor
                if node.childNodes.count>0{
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(x:planeAnchor.center.x, y:0, z: planeAnchor.center.z)
                    
                    // change the geometry of our plane, update the detected surface
                    if let plane = planeNode.geometry as? SCNPlane{
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.height = CGFloat(planeAnchor.extent.z)
                        
                        updateMaterial()
                        
                    }
                }
            }
        }
    }
    
    func updateMaterial(){
        let material = self.planeGeometry.materials.first!
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
    }
    
    func addNodeAtLocation(location:CGPoint){
        
        // check if we already have anchors in place that we can use
        guard anchors.count>0 else {print("anchors are not created yet");return}
        
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if hitResults.count>0{
            let result = hitResults.first!
            let newLocation = SCNVector3(x:result.worldTransform.columns.3.x, y:result.worldTransform.columns.3.y+0.15,z:result.worldTransform.columns.3.z)
            
            let earthNode = EarthNode()
            earthNode.position = newLocation
            
            sceneView.scene.rootNode.addChildNode(earthNode)
        }
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
