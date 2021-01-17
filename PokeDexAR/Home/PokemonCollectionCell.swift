//
//  PokemonCollectionCell.swift
//  PokeDexAR
//
//  Created by Trần Đình Tôn Hiếu on 1/16/21.
//

import UIKit
import AlamofireImage
import Masonry


class PokemonCollectionCell: UICollectionViewCell {
    
    static let reuseId = "PokemonCollectionCellReuseId"
    
    /// Data model for present.
    var pokemon: Pokemon? {
        didSet {
            if let pokemon = self.pokemon {
                self.nameLabel.text = pokemon.name
                if let url = URL(string: pokemon.thumbUrl) {
                    self.thumbImgView.af.setImage(withURL: url)
                }
                self.background.backgroundColor = Pokemon.colorByType(pokemon.type)
            }
        }
    }
    
    /// UI properties
    private var background = UIView()
    private var backgroundImgView = UIImageView()
    private var thumbImgView = UIImageView()
    private var nameLabel = UILabel()
    private var typeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        //-----------------------------------------
        //  Background
        //-----------------------------------------
        self.contentView.addSubview(background)
        background.layer.cornerRadius = 10
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 0.3
        background.layer.shadowOffset = CGSize(width: 1, height: 1)
        background.clipsToBounds = true
        background.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentView.mas_top)?.with().offset()(4)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.with()?.offset()(-4)
            make?.leading.equalTo()(self.contentView.mas_leading)
            make?.trailing.equalTo()(self.contentView.mas_trailing)
        }
        
        //-----------------------------------------
        //  Background Image View
        //-----------------------------------------
        self.background.addSubview(backgroundImgView)
        backgroundImgView.backgroundColor = .clear
        backgroundImgView.image = UIImage(named: "pokeball_front")
        backgroundImgView.alpha = 0.3
        backgroundImgView.layer.masksToBounds = true
        backgroundImgView.mas_makeConstraints { make in
            make?.size.equalTo()(70)
            make?.leading.equalTo()(background.mas_leading)?.with()?.offset()(-20)
            make?.bottom.equalTo()(background.mas_bottom)?.with()?.offset()(20)
        }
        
        //-----------------------------------------
        //  Thumb Image View
        //-----------------------------------------
        self.contentView.addSubview(thumbImgView)
        thumbImgView.backgroundColor = .clear
        thumbImgView.mas_makeConstraints { make in
            make?.size.equalTo()(70)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.with()?.offset()(-15)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.with()?.offset()(-15)
        }
        
        //-----------------------------------------
        //  Name Label
        //-----------------------------------------
        self.contentView.addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 17)
        nameLabel.numberOfLines = 1
        nameLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentView.mas_top)?.with()?.offset()(15)
            make?.leading.equalTo()(self.contentView.mas_leading)?.with()?.offset()(15)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.with()?.offset()(-15)
        }
    }
}
