//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Елизавета Матвеева on 19.02.2024.
//

import UIKit

enum CalculationError: Error {
    case devidedByZero
}

enum Operation: String{
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double{
        switch self{
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .divide:
            if number2 == 0{
                throw CalculationError.devidedByZero
            }
            return number1/number2
        case .multiply:
            return number1 * number2
        }
    }
}

enum CalculationHistoryItem{
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    
    @IBAction func buttonPressed(_ sender: UIButton){
        guard let buttonText = sender.currentTitle else{return}
        
    
        if buttonText == "," && label.text?.contains(",") == true{
            return}
        
        let nums = ["1234567890"]
        for i in nums{
            if label.text == i && buttonText == ","{
                return label.text = label.text! + buttonText
            }
        }
        
        //чтобы не отображать ноль перед числами
        if (label.text == "0" || label.text == "Ошибка") && buttonText == "," {
            label.text = "0,"
        }else if label.text == "0" || label.text == "Ошибка"{
            label.text = buttonText
        }else{
            label.text?.append(buttonText)
        }
        
    }
    
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        resetLableText()
    }
    
    @IBAction func calculateButtonPressed() {
        guard let labelText = label.text, let labelNumber = numberFormatter.number(from: labelText)?.doubleValue else{return}
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Ошибка"
        }
        
        
//       calculationHistory.removeAll()
        
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        calculationHistory.removeAll()
        guard
            let buttonText = sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText) else{return}
        guard let labelText = label.text, let labelNumber = numberFormatter.number(from: labelText)?.doubleValue else{return}
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLableText()
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetLableText()
    }
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    func calculate() throws -> Double{
        guard case .number(let firstNumber) = calculationHistory[0] else {return 0}
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2){
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
            else {break}
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
//    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue){
//        
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        guard segue.identifier == "CALCULATIONS_LIST", 
//        let calculationsListVC = segue.destination as? CalculationsListViewController
//        else{return}
//        
//        calculationsListVC.result = label.text
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func showCalculationsList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationsListVC = sb.instantiateViewController(identifier: "CalculationsListViewController")
//        let vc = calculationsListVC as? CalculationsListViewController
//        vc?.result = label.text

        if calculationHistory.isEmpty == true{
            if let vc = calculationsListVC as? CalculationsListViewController{
                vc.result = "No data"
            }
        }else{
            if let vc = calculationsListVC as? CalculationsListViewController{
                vc.result = label.text
            }}
        navigationController?.pushViewController(calculationsListVC, animated: true)
//        show(calculationsListVC, sender: self)
    
    }
    func resetLableText(){
        label.text = "0"
    }


}

