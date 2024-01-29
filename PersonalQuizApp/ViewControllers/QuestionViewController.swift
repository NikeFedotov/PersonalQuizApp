//
//  QuestionViewController.swift
//  PersonalQuizApp
//
//  Created by Никита on 29.01.2024.
//

import UIKit

final class QuestionViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet weak var multipleStackView: UIStackView!
    
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet var rangedLables: [UILabel]!
    @IBOutlet weak var rangedSlider: UISlider!
    
    
    //MARK: - Private properties
    private let question = Question.getQuestions()
    private var questionIndex = 0
    private var answerChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        question[questionIndex].answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let answersCount = Float(currentAnswers.count)
        rangedSlider.maximumValue = answersCount
        rangedSlider.value = answersCount / 2
        updateUI()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        resultVC.answers = answerChosen
    }
    
    //MARK: - IB Actions
    @IBAction func singleActionButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        
        let currentAnswer = currentAnswers[buttonIndex]
        
        answerChosen.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answerChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answerChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
}

//MARK: - Extension Question VC
extension QuestionViewController {
    /// Update UI
    ///
    /// Refreshing the user interface after the next user responce and when the application is launched
    private func updateUI() {
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        let currentQuestion = question[questionIndex]
        questionLabel.text = currentQuestion.title
        let totalProgress = Float(questionIndex) / Float(question.count)
        questionProgressView.setProgress(totalProgress, animated: true)
        title = "Вопрос № \(questionIndex + 1) из \(question.count)"
        
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single:
            showSingleStackView(with: currentAnswers)
        case .multiple:
            showMultipleStackView(with: currentAnswers)
        case .ranged:
            showRangedStackView(with: currentAnswers)
        }
    }
    
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden = false
        
        rangedLables.first?.text = answers.first?.title
        rangedLables.last?.text = answers.last?.title
    }
}

extension QuestionViewController {
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < question.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
}
