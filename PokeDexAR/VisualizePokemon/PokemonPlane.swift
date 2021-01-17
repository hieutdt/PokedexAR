//
//  PokemonPlane.swift
//  PokeDexAR
//
//  Created by Trần Đình Tôn Hiếu on 1/16/21.
//

import UIKit
import ARKit


class PokemonPlane: SCNNode {
    
    var pokemon: Pokemon
    let pokemonNode: SCNNode
    
    init(anchor: ARPlaneAnchor, in sceneView: ARSCNView, pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        let pokeScene = SCNScene(named: pokemon.arImageName)
        guard let pokeNode = pokeScene?.rootNode.childNode(
                withName: pokemon.arModelName,
                recursively: true
        ) else {
            self.pokemonNode = SCNNode()
            super.init()
            
            print("Pokemon model is not found!")
            return
        }
        
        pokeNode.position = SCNVector3(0, 0, -1)
        pokeNode.simdPosition = anchor.center
        self.pokemonNode = pokeNode
        
        super.init()
        
        addChildNode(pokemonNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
