//
//  ViewController.swift
//  isEven
//
//  Created by Paulo Atavila on 28/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBAction func okButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.loading.startAnimating()
            self.view.endEditing(true)
            self.resultLabel.text = " "
        }
        guard let number = Int(numberTextField.text ?? "")  else {
            updateView(with: .error("Type a number to start"))
            return
        }
        viewModel.getResult(for: number)
    }
    
    private enum ResultType {
        case even(String), odd(String), error(String)
    }
    
    private var viewModel: EvenViewModelProtocol = EvenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }

    private func updateView(with type: ResultType) {
        updateBackground(with: type)
        updateLabels(with: type)
    }
    
    private func updateBackground(with type: ResultType) {
        let color: UIColor
        switch type {
        case .even:
            color = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        case .odd:
            color = UIColor(red: 236/255, green: 99/255, blue: 84/255, alpha: 1.0)
        case .error:
            color = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        }
        DispatchQueue.main.async {
            self.view.backgroundColor = color
            self.loading.stopAnimating()
        }
    }
    
    private func updateLabels(with type: ResultType) {
        let resultText: String
        let adText: String
        switch type {
        case .even(let advertising):
            resultText = "Yes, it's"
            adText = advertising
        case .odd(let advertising):
            resultText = "No, it isn't"
            adText = advertising
        case .error(let error):
            resultText = ":("
            adText = error
        }
        DispatchQueue.main.async {
            self.resultLabel.text = resultText
            self.adLabel.text = adText
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ViewController: EvenViewDelegate {
    
    func success(result: EvenResult) {
        updateView(with: result.isEven ? .even(result.advertising) : .odd(result.advertising))
        
    }
    
    func error(message: String) {
        updateView(with: .error(message))
    }
    
}
