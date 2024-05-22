//
//  ViewController.swift
//  p02-guess-the-flag
//
//  Created by Edgar Sánchez Hurtado on 26/2/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfGuesses = 0
    let maxNumberOfGuesses = 3
    var maxScore = 0
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showCurrentScore))
        countries += [
            "estonia",
            "france",
            "germany",
            "ireland",
            "italy",
            "monaco",
            "nigeria",
            "poland",
            "russia",
            "spain",
            "uk",
            "us",
        ]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        maxScore = defaults.integer(forKey: "maxScore")

        newGame()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased()). Score: \(score)"
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    func newGame() {
        if score > maxScore {
            defaults.set(score, forKey: "maxScore")
        }
        score = 0
        numberOfGuesses = 0
        askQuestion()
    }

    func endGame() -> Void {
        if score > maxScore {
            defaults.set(score, forKey: "maxScore")
            showNewMaxScoreModal()
            return
        }

        showEndGameAlertModal()
    }

    func showEndGameAlertModal() -> Void {
        let ac = UIAlertController(title: "Final Score", message: "Yoy obtained a final score of: \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "New game", style: .default, handler: { _ in self.newGame() } ))
        present(ac, animated: true)
    }

    func showNewMaxScoreModal() -> Void {
        defaults.set(score, forKey: "maxScore")
        let ac = UIAlertController(title: "New Max Score!", message: "Congratulations. You obtained a new max score of \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: { _ in  self.newGame() }))
        present(ac, animated: true)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var additionalMessage = ""
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            additionalMessage = "That's the flag of \(countries[sender.tag].uppercased())\n"
            score -= 1
        }
        
        numberOfGuesses += 1
        
        let ac = createCurrentScoreAlertController()
        ac.title = title
        ac.message = additionalMessage + (ac.message ?? "")
        
        if numberOfGuesses >= maxNumberOfGuesses {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in self.endGame() }))
        } else {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in self.askQuestion() }))
        }
        
        present(ac, animated: true)
    }
    
    func createCurrentScoreAlertController() -> UIAlertController {
        return UIAlertController(title: nil, message: "Your score is \(score)", preferredStyle: .alert)
    }
    
    @objc func showCurrentScore() {
        let ac = createCurrentScoreAlertController()
        ac.addAction(UIAlertAction(title: "Close", style: .default))
        present(ac, animated: true)
    }
}

