//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Елизавета Матвеева on 01.03.2024.
//

import UIKit

class CalculationsListViewController: UIViewController{
    
    var result: String?
    
    @IBOutlet weak var calculationLabel: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize(){
        modalPresentationStyle = .fullScreen
    }
    
    @IBAction func dismissVC(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        calculationLabel.text = result
//        if let result = result{
//            calculationLabel.text = result
//        }else{
//            calculationLabel.text = "No data"
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
