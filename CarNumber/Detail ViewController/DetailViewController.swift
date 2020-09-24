//
//  DetailViewController.swift
//  CarNumber
//
//  Created by Юрий Могорита on 11.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {
    
    //MARK: - "Outlets"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var markModelLabel: UILabel!
    @IBOutlet weak var stolenStatusLabel: UILabel!
    
    //MARK: - Properties
    
    var carNumber: String?
    var carInfo: Car?
    
    private let mainLink = "https://baza-gai.com.ua/nomer/"
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRequest()
        setUpUIElements()
    }
    
    //MARK: - SetUp Elements
    
    func setUpUIElements() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        tableView.backgroundColor = .clear
        viewBackground.layer.cornerRadius = 15
        carImage.layer.cornerRadius = 15
        backView.layer.cornerRadius = 15
        backView.alpha = 0.75
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = carNumber
        tableView.tableFooterView = UIView()
        
    }
    
    //MARK: - Request
    
    func getRequest() {
        guard let carNumber = carNumber else { return }
        AlamofireNetworkRequest.shared.sendRequest(url: mainLink + carNumber) { car in
            DispatchQueue.main.async {
                let car = car
                self.carInfo = car
                self.numberLabel.text = "   " + car.digits
                self.markModelLabel.text = "\(car.vendor)  \(car.model)  \(String(car.year))"
                self.setImage(url: car.photoUrl)
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Set Car image
    
    func setImage(url: String?) {
        guard let url = url else { return }
        let urlString = url.replacingOccurrences(of: " ", with: "%20")
        guard let imageUrl = URL(string: urlString) else { return }
        carImage.af.setImage(withURL: imageUrl)
    }
}

//MARK: - UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carInfo?.operations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        if let car = carInfo, car.stolen {
            stolenStatusLabel.text = "Авто числится в угоне"
        } else {
            stolenStatusLabel.text = "Авто не числится в угоне"
        }
        guard let car = carInfo?.operations[indexPath.row] else { return UITableViewCell() }
        if car.isLast {
        cell.dateLabel.text = "Последняя операция \(car.regAt)"
        } else {
        cell.dateLabel.text = "Предыдущая операция \(car.regAt)"
        }
        cell.markLabel.text = car.model + " " + car.vendor
        cell.descriptionLabel.text = car.notes
        cell.operationLabel.text = car.operation
        cell.adressLabel.text = car.address
        cell.backgroundColor = .clear
        cell.backCellView.layer.cornerRadius = 10
        cell.backCellView.alpha = 0.75
        cell.alpha = 0.5
        return cell
    }
}

