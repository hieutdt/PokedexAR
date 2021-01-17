//
//  HomeViewController.swift
//  PokeDexAR
//
//  Created by Trần Đình Tôn Hiếu on 1/16/21.
//

import UIKit

let kNumOfCellsInRow = 2

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(
            PokemonCollectionCell.self,
            forCellWithReuseIdentifier: PokemonCollectionCell.reuseId
        )
        
        // Load data and update view
        self.loadDataFromFile("pokemon_data")
        self.collectionView.reloadData()
    }
    
    private func loadDataFromFile(_ fileName: String) {
        if let dict = Dictionary<String, Any>.dictionaryFromJsonFile(fileName) {
            let dictArray = dict.dictionaryArrayForKey("pokemons")
            if !dictArray.isEmpty {
                for data in dictArray {
                    let pokemon = Pokemon(dictionary: data)
                    self.pokemons.append(pokemon)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate + FlowLayout

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width / CGFloat(kNumOfCellsInRow)) - 30
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let index = (indexPath.section * kNumOfCellsInRow) + indexPath.item;
        
        guard index < self.pokemons.count else {
            return
        }
        
        // Get pokemon from datasource.
        let pokemon = self.pokemons[index]
        
        // Present visualize screen.
        let visualizeVC = VisualizeViewController(pokemon: pokemon)
        visualizeVC.modalPresentationStyle = .fullScreen
        self.present(visualizeVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let num = ceil(Double(self.pokemons.count) / 2.0)
        return Int(num)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if (section + 1) * kNumOfCellsInRow > self.pokemons.count {
            let num = self.pokemons.count % kNumOfCellsInRow
            return num
        } else {
            return kNumOfCellsInRow
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = (indexPath.section * kNumOfCellsInRow) + indexPath.item;
        guard index < self.pokemons.count else {
            return UICollectionViewCell()
        }
        
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PokemonCollectionCell.reuseId,
            for: indexPath) as? PokemonCollectionCell {
            
            let pokemon = self.pokemons[index]
            
            // Set model for cell
            cell.pokemon = pokemon
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
