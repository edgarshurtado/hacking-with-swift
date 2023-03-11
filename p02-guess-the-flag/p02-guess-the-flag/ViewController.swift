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
    let maxNumberOfGuesses = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        newGame()
    }
    
    func askQuestion(something: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased()). Score: \(score)"
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    func newGame(alertAction: UIAlertAction! = nil) {
        score = 0
        numberOfGuesses = 0
        askQuestion()
    }
    
    func showEndGameAlertModal() -> Void {
        let ac = UIAlertController(title: "Final Score", message: "Yoy obtained a final score of: \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "New game", style: .default, handler: newGame))
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
        
        let ac = UIAlertController(title: title, message: additionalMessage + "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
        if numberOfGuesses == maxNumberOfGuesses {
            showEndGameAlertModal()
        }
    }
}

