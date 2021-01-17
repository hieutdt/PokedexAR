//
//  VisualizeViewController.swift
//  PokeDexAR
//
//  Created by Trần Đình Tôn Hiếu on 1/16/21.
//

import UIKit
import ARKit

let kBackButtonSize: CGFloat = 30

class VisualizeViewController: UIViewController {

    var sceneView = ARSCNView()
    var infoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Infomation", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.alpha = 0.6
        button.setBackgroundColor(color: .lightBlackColor, forState: .normal)
        button.setBackgroundColor(color: .black, forState: .highlighted)
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "close")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = .white
        button.layer.cornerRadius = kBackButtonSize / 2
        button.clipsToBounds = true
        button.alpha = 0.6
        button.setBackgroundColor(color: .lightBlackColor, forState: .normal)
        button.setBackgroundColor(color: .black, forState: .highlighted)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var pokemon: Pokemon!
    var pokemonPlane: PokemonPlane?
    
    var canAddPokemonNode = true
    
    //Store The Rotation Of The CurrentNode
    var currentAngleY: Float = 0.0
    
    init(pokemon: Pokemon) {
        super.init(nibName: nil, bundle: nil)
        self.pokemon = pokemon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.loops = true
    }

    private func setUpUI() {
        self.view.addSubview(sceneView)
        sceneView.mas_makeConstraints { make in
            make?.edges.equalTo()(self.view)
        }
        
        self.view.addSubview(infoButton)
        infoButton.mas_makeConstraints { make in
            make?.height.equalTo()(60)
            make?.width.equalTo()(150)
            make?.bottom.equalTo()(self.view.mas_bottom)?.with()?.offset()(-60)
            make?.trailing.equalTo()(self.view.mas_trailing)?.with()?.offset()(-15)
        }
        
        self.view.addSubview(dismissButton)
        dismissButton.mas_makeConstraints { make in
            make?.size.equalTo()(kBackButtonSize)
            make?.top.equalTo()(self.view.mas_top)?.with()?.offset()(50)
            make?.leading.equalTo()(self.view.mas_leading)?.with()?.offset()(15)
        }
        
        let rotateGesture = UIPanGestureRecognizer(target: self, action: #selector(rotateNode(_:)))
        self.view.addGestureRecognizer(rotateGesture)
    }
    
    /// - Tag: StartARSession
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Start the view's AR session with a configuration that uses the rear camera,
        // device position and orientation tracking, and plane detection.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)

        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Show debug UI to view performance metrics (e.g. frames per second).
        sceneView.showsStatistics = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's AR session.
        sceneView.session.pause()
    }
    
    // MARK: - Actions
    
    @objc private func infoButtonTapped() {
        let infoVC = PokemonInfoViewController()
        infoVC.pokemon = self.pokemon
        self.presentPanModal(infoVC)
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Rotates An SCNNode Around It's YAxis
    ///
    /// - Parameter gesture: UIRotationGestureRecognizer
    @objc func rotateNode(_ gesture: UIPanGestureRecognizer){

        if let pokemonPlane = self.pokemonPlane {
            
            //1. Get The Current Rotation From The Gesture
            let rotation = Float(gesture.translation(in: self.view).x) * .pi/180
            
            //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
            if gesture.state == .changed{
                pokemonPlane.eulerAngles.y = currentAngleY + rotation
            }
            
            //3. If The Gesture Has Ended Store The Last Angle Of The Cube
            if(gesture.state == .ended) {
                currentAngleY = pokemonPlane.eulerAngles.y
            }
        }
    }
}

// MARK: - ARSCNViewDelegate

extension VisualizeViewController: ARSCNViewDelegate {
    
}

// MARK: - ARSessionDelegate

extension VisualizeViewController: ARSessionDelegate {
    
    /// - Tag: PlaceARContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if self.pokemonPlane != nil {
            return
        }
        
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a Pokemon node.
        self.pokemonPlane = PokemonPlane(anchor: planeAnchor, in: sceneView, pokemon: self.pokemon)
        self.pokemonPlane?.scale = SCNVector3(0.5, 0.5, 0.5)
        self.pokemonPlane?.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        currentAngleY = self.pokemonPlane!.eulerAngles.y
        
        // Add the visualization to the ARKit-managed node so that it tracks
        // changes in the plane anchor as plane estimation continues.
        node.addChildNode(self.pokemonPlane!)
    }
}
