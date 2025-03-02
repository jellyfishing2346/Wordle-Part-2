//
//  BoardController.swift
//  Wordle
//
//  Created by Mari Batilando on 2/20/23.
//

import Foundation
import UIKit

class GameCell: UICollectionViewCell {
    @IBOutlet weak var letterLabel: UILabel! // Connect this IBOutlet in your storyboard or XIB file
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initial setup (e.g., configure the cell's appearance)
    }
    
    func clearLetter() {
        // Reset the cell's UI (e.g., clear the letter and any styling)
        letterLabel.text = ""
        backgroundColor = .clear // Reset the background color
    }
}

class BoardController: NSObject,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout {
  
  // MARK: - Properties
  var numItemsPerRow = 5
  var numRows = 6
  let collectionView: UICollectionView
  var goalWord: [String]
  var currentGuess: Int = 0 // Tracks the current guess number
  var isGameOver: Bool = false // Tracks whether the game is over

  var numTimesGuessed = 0
  var isAlienWordle = false
  var currRow: Int {
    return numTimesGuessed / numItemsPerRow
  }
  
  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    let rawTheme = SettingsManager.shared.settingsDictionary[kWordThemeKey] as! String
    let theme = WordTheme(rawValue: rawTheme)!
    self.goalWord = WordGenerator.generateGoalWord(with: theme)
    super.init()
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  // MARK: - Public Methods
  func resetBoard(with settings: [String: Any]) {
    applyNumLettersSettings(with: settings)
    applyNumGuessesSettings(with: settings)
    applyThemeSettings(with: settings)
    applyIsAlienWordleSettings(with: settings)
    numTimesGuessed = 0
    collectionView.reloadData()
  }
  
  // Exercise 5 Pt. 2 (optional): This function only needs to be implemented if you decide to do the optional requirement (see Pt. 1 in ViewController.swift)
  // This function should reset the board with the current settings without changing the goalWord
  // Tip: Take a look at how resetBoard is implemented above. The only difference is that you don't want to change the settings
  func resetBoardWithCurrentSettings() {
    // START YOUR CODE HERE
      // Step 1: Clear the board
              clearBoard()
              
              // Step 2: Reset game state variables
              currentGuess = 0
              isGameOver = false
              
              // Step 3: Update the UI
              collectionView.reloadData()
              
              print("Board reset with current settings. Goal word remains: \(goalWord)")
    // ...
    // END YOUR CODE HERE
  }
    
    private func clearBoard() {
        class Constants {
            
        }
           // Clear all cells in the collection view
           for section in 0..<collectionView.numberOfSections {
               for row in 0..<collectionView.numberOfItems(inSection: section) {
                   let indexPath = IndexPath(row: row, section: section)
                   if let cell = collectionView.cellForItem(at: indexPath) as? GameCell {
                       cell.clearLetter() // Clear the letter in the cell
                   }
               }
           }
       }
  
  // Exercise 1: Implement applyNumLettersSettings to change the number of letters in the goal word
  // Tip 1: Use a breakpoint to inspect or print the `settings` argument
  // Tip 2: There is a constant `kNumLettersKey` in Constants.swift that you can use as the key to grab the value in the dictionary
  // Tip 3: Assign the correct value of the setting to the `numItemsPerRow` property.
  // Tip 4: You will need to cast the value to the correct type
  // Checkpoint: Correctly implementing this should allow you to change the number of letters in the goal word!
  private func applyNumLettersSettings(with settings: [String: Any]) {
    // START YOUR CODE HERE
      struct Constants {
          static let kNumLettersKey = "numLetters"
      }
      // Step 1: Retrieve the value from the settings dictionary using the key `kNumLettersKey`
          if let numLetters = settings[Constants.kNumLettersKey] as? Int {
              // Step 2: Assign the value to the `numItemsPerRow` property
              numItemsPerRow = numLetters
          } else {
              // Handle the case where the value is not found or is not of the expected type
              print("Error: Unable to retrieve or cast the number of letters from settings.")
          }
    // ...
    // END YOUR CODE HERE
  }
  
  // Exercise 2: Implement applyNumGuessesSettings to change the number of rows in the board
  // Tip 1: Use a breakpoint to inspect or print the `settings` argument
  // Tip 2: There is a constant `kNumGuessesKey` in Constants.swift that you can use as the key to grab the value in the dictionary
  // Tip 3: Assign the correct value of the setting to the `numRows` property.
  // Tip 4: You will need to cast the value to the correct type
  // Checkpoint: Correctly implementing this should allow you to change the number of rows in the board!
  private func applyNumGuessesSettings(with settings: [String: Any]) {
    // START YOUR CODE HERE
      struct Constants {
          static let kNumGuessesKey = "numGuesses"
      }
      // Step 1: Retrieve the value from the settings dictionary using the kNumGuessesKey
          if let numGuesses = settings[Constants.kNumGuessesKey] as? Int {
              // Step 2: Assign the value to the `numRows` property
              numRows = numGuesses
          } else {
              // Handle the case where the value is not found or is not of the expected type
              print("Error: Unable to retrieve or cast the number of guesses from settings.")
          }
    // ...
    // END YOUR CODE HERE
  }
  
  // Exercise 3: Implement applyThemeSettings to change the goal word according to the theme
  // Tip 1: There is a constant `kWordThemeKey` in Constants.swift that you can use as the key to grab the theme as a String in the dictionary
  // Tip 2: Pass-in the theme to `WordGenerator.generateGoalWord` (see WordGenerator.swift) and assign its result to the `goalWord` defined above
  //  - The value stored in the settings dictionary is a String, but `WordGenerator.generateGoalWord` expects a WordTheme type.
  //    Use the `WordTheme(rawValue:)` initializer to pass-in the string from the dictionary to get the correct type
  // Checkpoint: Correctly implementing this should allow you to change the theme of the goal word! Use breakpoints or print statements
  // to check the before/after value of goalWord and see if it changes to the correct theme
  private func applyThemeSettings(with settings: [String: Any]) {
    // START YOUR CODE HERE
      struct Constants {
          static let kWordThemeKey = "kWordThemeKey"
      }
      // Step 1: Retrieve the theme value from the settings dictionary using the kWordThemeKey
          if let rawTheme = settings[Constants.kWordThemeKey] as? String,
             // Step 2: Convert the theme string to the WordTheme enum type
             let theme = WordTheme(rawValue: rawTheme) {
              // Step 3: Generate the goal word using the theme and assign it to the goalWord property
              goalWord = WordGenerator.generateGoalWord(with: theme)
          } else {
              // Handle the case where the value is not found or is not of the expected type
              print("Error: Unable to retrieve or convert the theme from settings.")
          }
    // ...
    // END YOUR CODE HERE
  }
  
  // Exercise 4: Implement applyIsAlienWordleSettings to change the goal word after each guess
  // Tip 1: There is a constant `kIsAlienWordleKey` in Constants.swift that you can use as the key to grab the value in the dictionary
  // Tip 2: There is a corresponding property located in this file that you should assign the value of the setting to (look at the "Properties" section above).
  // Checkpoint: Correctly implementing this function should change the goal word each time the user inputs an entire row of letters
  private func applyIsAlienWordleSettings(with settings: [String: Any]) {
    // START YOUR CODE HERE
      struct Constants {
          static let kIsAlienWordleKey: String = "isAlienWordle"
      }
      // Step 1: Retrieve the value from the settings dictionary using the kIsAlienWordleKey
          if let isAlienWordle = settings[Constants.kIsAlienWordleKey] as? Bool {
              // Step 2: Assign the value to the corresponding property
              self.isAlienWordle = isAlienWordle
          } else {
              // Handle the case where the value is not found or is not of the expected type
              print("Error: Unable to retrieve or cast the Alien Wordle setting from settings.")
          }
    // ...
    // START YOUR CODE HERE
  }
}
