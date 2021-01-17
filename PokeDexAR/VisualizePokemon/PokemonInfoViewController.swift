//
//  PokemonInfoViewController.swift
//  PokeDexAR
//
//  Created by Trần Đình Tôn Hiếu on 1/16/21.
//

import UIKit
import PanModal
import Masonry

class PokemonInfoViewController: UIViewController {
    
    var pokemon: Pokemon?
    
    var descriptionTextView = UITextView()
    var nameLabel = UILabel()
    var typeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(nameLabel)
        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.textColor = .black
        nameLabel.text = pokemon?.name
        nameLabel.textAlignment = .center
        nameLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.view.mas_top)?.with()?.offset()(15)
            make?.leading.equalTo()(self.view.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.view.mas_trailing)?.with()?.offset()(-10)
        }
        
        self.view.addSubview(typeLabel)
        typeLabel.font = .systemFont(ofSize: 15)
        typeLabel.textColor = .darkGray
        typeLabel.text = "Pokemon Type: \(pokemon?.type.rawValue ?? "")"
        typeLabel.textAlignment = .center
        typeLabel.mas_makeConstraints { make in
            make?.top.equalTo()(nameLabel.mas_bottom)?.with()?.offset()(10)
            make?.leading.equalTo()(self.view.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.view.mas_trailing)?.with()?.offset()(-10)
        }
        
        self.view.addSubview(descriptionTextView)
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.isEditable = false
        descriptionTextView.textColor = .black
        descriptionTextView.backgroundColor = .white
        descriptionTextView.text = pokemon?.desc
        descriptionTextView.mas_makeConstraints { make in
            make?.top.equalTo()(typeLabel.mas_bottom)?.with()?.offset()(10)
            make?.leading.equalTo()(self.view.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.view.mas_trailing)?.with()?.offset()(-10)
            make?.bottom.equalTo()(self.view.mas_bottom)?.with()?.offset()(-10)
        }
        
        panModalSetNeedsLayoutUpdate()
    }
}

extension PokemonInfoViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var springDamping: CGFloat {
        return 1.0
    }

    var transitionDuration: Double {
        return 0.4
    }

    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.allowUserInteraction, .beginFromCurrentState]
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(55)
    }
    
    var longFormHeight: PanModalHeight {
        let width = UIScreen.main.bounds.width - 20
        let boundingBox = CGSize(width: width, height: 10000)
        let estimatedSize = self.descriptionTextView.sizeThatFits(boundingBox)
        
        return .contentHeight(estimatedSize.height + 60)
    }
}
