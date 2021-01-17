//
//  Pokemon.swift
//  PokeDexAR
//
//  Created by Trần Đình Tôn Hiếu on 1/16/21.
//

import Foundation
import UIKit

public enum PokemonType: String {
    case normal = "normal"
    case fire = "fire"
    case water = "water"
    case grass = "grass"
    case electric = "electric"
    case ice = "ice"
    case dark = "dark"
    case ghost = "ghost"
    case fairy = "fairy"
    case dragon = "dragon"
    case poison = "poison"
    case fly = "fly"
    case bug = "bug"
}

public struct Pokemon: Identifiable, Hashable {
    
    public var id = UUID().uuidString
    
    var name: String = ""
    var type: PokemonType = .normal
    var thumbUrl: String = ""
    var arImageName: String = ""
    var arModelName: String = ""
    var desc: String = ""
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(dictionary: [String: Any]) {
        if dictionary.isNotEmpty() {
            self.name = dictionary.stringValueForKey("name")
            self.type = PokemonType(rawValue: dictionary.stringValueForKey("type")) ?? .normal
            self.thumbUrl = dictionary.stringValueForKey("thumbImageUrl")
            self.arImageName = dictionary.stringValueForKey("3DModelFileName")
            self.arModelName = dictionary.stringValueForKey("3DModelName")
            self.desc = dictionary.stringValueForKey("description")
        }
    }
    
    public static func textColorByType(_ type: PokemonType) -> UIColor {
        switch type {
        case .fly, .normal:
            return .black
        default:
            return .white
        }
    }
    
    public static func colorByType(_ type: PokemonType) -> UIColor {
        switch type {
        case .fire:
            return .systemRed
            
        case .normal:
            return .init(red: 242/255, green: 243/255, blue: 244/255, alpha: 1)
            
        case .water:
            return .systemBlue
        
        case .electric:
            return .systemYellow
            
        case .ice:
            return .systemTeal
            
        case .grass:
            return .systemGreen
            
        case .poison:
            return .systemPurple
            
        case .bug:
            return .init(red: 106/255, green: 200/255, blue: 163/255, alpha: 1)
            
        case .fly:
            return .init(red: 197/255, green: 254/255, blue: 250/255, alpha: 1)
        
        default:
            return .white
        }
    }
}
