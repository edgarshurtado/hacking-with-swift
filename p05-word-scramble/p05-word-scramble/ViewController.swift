//
//  ViewController.swift
//  p05-word-scramble
//
//  Created by Edgar Sánchez Hurtado on 18/4/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
           let startWords = try? String(contentsOf: startWordsURL)
        {
            allWords = startWords.components(separatedBy: "\n")
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    showErrorMessage(
                        errorTitle: "Word not recognised",
                        errorMessage: "We can't made things up!"
                    )
                }
            } else {
                showErrorMessage(
                    errorTitle: "Word already used",
                    errorMessage: "You can't use the same word 2 times"
                )
            }
        } else {
            showErrorMessage(
                errorTitle: "Word not possible",
                errorMessage: "You can't spell the word \(answer) from \(title!.lowercased())"
            )
        }
        
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.description.localizedCaseInsensitiveContains(word) && word.lowercased() != title?.lowercased()
    }
    
    func isReal(word: String) -> Bool {
        guard word.count >= 3 else { return false}
        let checker = UITextChecker()
        let range = NSRange(location:0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorTitle:String, errorMessage:String) {
        let alertControllerInstance = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertControllerInstance.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertControllerInstance, animated: true)
    }
    
    
    // MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.text = usedWords[indexPath.row]
        cell.contentConfiguration = cellConfig
        return cell
    }
}

