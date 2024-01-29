//
//  ResultViewController.swift
//  PersonalQuizApp
//
//  Created by Никита on 29.01.2024.
//

import UIKit

final class ResultViewController: UIViewController {
    
    
    @IBOutlet weak var headResultLabel: UILabel!
    @IBOutlet weak var definitionResultLabel: UILabel!
    
    var answers: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        resultCalculate()

        }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}

extension ResultViewController {
    private func resultCalculate() {
        var result: [Animal:Int] = [:]
        let animals = answers.map { $0.animal }
        
        for animal in animals {
            if let animalTypeCount = result[animal] {
                result.updateValue(animalTypeCount + 1, forKey: animal)
            } else {
                result[animal] = 1
            }
        }
        let sortedResult = result.sorted { $0.value > $1.value }
        guard let winner = sortedResult.first?.key else { return }
        
        updateUI(with: winner)
    }
    
    private func updateUI(with animal: Animal) {
        headResultLabel.text = "Вы - \(animal.rawValue)"
        definitionResultLabel.text = animal.definition
    }
}
    
    
