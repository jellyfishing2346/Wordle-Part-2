//
//  ViewController.swift
//  Wordle
//
//  Created by Mari Batilando on 2/12/23.
//

import UIKit

class ViewController: UIViewController, SettingsViewControllerDelegate {
  
    @IBOutlet weak var wordsCollectionView: UICollectionView!
    @IBOutlet weak var keyboardCollectionView: UICollectionView!
    
    private var boardController: BoardController!
    private var keyboardController: KeyboardController!
    
    private let segueIdentifier = "SettingsViewControllerSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        boardController = BoardController(collectionView: wordsCollectionView)
        keyboardController = KeyboardController(collectionView: keyboardCollectionView)
        keyboardController.didSelectString = { [unowned self] string in
            if string == kDeleteKey {
                self.boardController.deleteLastCharacter()
            } else {
                self.boardController.enter(string)
            }
        }
        
        // Add Settings button to the right side of the navigation bar
        let rightBarButtonItem = UIBarButtonItem(title: "Settings",
                                                style: .plain,
                                                target: self,
                                                action: #selector(didTapSettingsButton))
        rightBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // Add Reset button to the left side of the navigation bar
        let resetButton = UIBarButtonItem(title: "Reset",
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapResetButton))
        resetButton.tintColor = .white
        navigationItem.leftBarButtonItem = resetButton
    }
    
    @objc private func didTapSettingsButton() {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    // Define the didTapResetButton method
    @objc private func didTapResetButton() {
        // Call the reset method in BoardController
        boardController.resetBoardWithCurrentSettings()
        
        // Optional: Print a message to confirm the reset
        print("Game reset with current settings!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == segueIdentifier else { return }
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
    }
    
    func didChangeSettings(with settings: [String: Any]) {
        boardController.resetBoard(with: settings)
    }
}
