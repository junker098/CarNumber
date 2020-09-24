//
//  ViewController.swift
//  CarNumber
//
//  Created by Юрий Могорита on 10.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchViewController: UIViewController {
    
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var tapButtonAction: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapButtonAction.layer.cornerRadius = 10
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @IBAction func tapButtonAction(_ sender: UIButton) {
        let number = carNumberTextField.text
        if let number = number, number.isEmpty {
            let alert = UIAlertController(title: "Ошибка", message: "Заполните поле", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
            detailVC.carNumber = number
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 8
    }
}
