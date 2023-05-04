//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-04-24.
//

import UIKit

class StartViewController: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let lastUpdatedLabel = UILabel()
    private let dateAndTimeLabel = UILabel()
    private let nationalBankExchangeRateButton = UIButton(type: .system)
    private let currencyView = CurrencyMainView()
    private var currensiesArrayFromNet: [Currency] = []
    
    private var currensiesArray: [Currency] = [] {
        didSet {
            currencyView.reloadTable()
        }
    }

//MARK: - live cycle App:

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpView()
        configBackgroundImageView()
        configAppNameLabel()
        configLastUpdatedLabel()
        configDateAndTimeLabel()
        configNationalBankExchangeRateButton()
        configCurrencyView()
        addTargetsForButtons()
        setConstraints()
        fetchDataFromNet()
    }
    
//MARK: - objc Function:
    
    @objc func openCurrencyListVC() {
        let currencyListVC = CurrencyListViewController()
        let navContrroler = UINavigationController(rootViewController: currencyListVC)
        currencyListVC.completionChooseCurrency = {[weak self] currencyChoose in
            self?.currensiesArray.append(currencyChoose)
        }
        currencyListVC.currencyArrayFromNet = currensiesArrayFromNet
        navigationController?.present(navContrroler, animated: true)
    }
    
//MARK: - Function:

    private func setUpView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(appNameLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(dateAndTimeLabel)
        view.addSubview(nationalBankExchangeRateButton)
        view.addSubview(currencyView)
    }
    
    func addTargetsForButtons() {
        currencyView.addCurrencyButton.addTarget(self, action: #selector(openCurrencyListVC), for: .touchUpInside)
        
    }
    
    private func configBackgroundImageView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named:  "image_background")
    }
    
    private func configAppNameLabel() {
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.text = "Currency Converter"
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .left
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    private func configLastUpdatedLabel() {
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.text = "Last Updated"
        lastUpdatedLabel.textColor = .systemGray
        lastUpdatedLabel.textAlignment = .left
        lastUpdatedLabel.font = UIFont(name: "Regular", size: 12)
    }
    
    private func configDateAndTimeLabel() {
        dateAndTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateAndTimeLabel.textColor = .systemGray
        dateAndTimeLabel.textAlignment = .left
        dateAndTimeLabel.text = "dd.mm.yyyy hh:m"
        dateAndTimeLabel.font = UIFont(name: "Regular", size: 12)
        
    }
    
    private func configNationalBankExchangeRateButton() {
        
        nationalBankExchangeRateButton.translatesAutoresizingMaskIntoConstraints = false
        nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
        nationalBankExchangeRateButton.setTitleColor(UIColor.systemBlue, for: .normal)
        nationalBankExchangeRateButton.layer.borderWidth = 1
        nationalBankExchangeRateButton.layer.cornerRadius = 15
        nationalBankExchangeRateButton.layer.borderColor = UIColor.systemBlue.cgColor
        nationalBankExchangeRateButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
        //        nationalBankExchangeRateButton.addTarget(self, action: #selector(), for: .touchUpInside)
        
    }
    
    private func configCurrencyView() {
        currencyView.translatesAutoresizingMaskIntoConstraints = false
        currencyView.currencyTableView.delegate = self
        currencyView.currencyTableView.dataSource = self
    }
    
    func fetchDataFromNet(){
        NetworkFetchManager().fetchCurrences(date: Date()) { model in
            guard let model = model else {return}
            self.currensiesArrayFromNet = model.currences
            self.currensiesArrayFromNet.sort {$0.currency < $1.currency}
            }
        }
}

//MARK: - UITableViewDelegate

extension StartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: - UITableViewDataSource

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currensiesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyMainView.idMainTableViewCell, for: indexPath) as? CurrencyMainCell else {return UITableViewCell()}
        cell.currancy = currensiesArray[indexPath.row]
        cell.configCell()
        return cell
    }
}

//MARK: - UITextFieldDelegate:

extension StartViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

//MARK: - Set constraints:

extension StartViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            
            appNameLabel.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -20),
            appNameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16),
            
            lastUpdatedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: dateAndTimeLabel.topAnchor, constant: -1),
            
            dateAndTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateAndTimeLabel.bottomAnchor.constraint(equalTo: nationalBankExchangeRateButton.topAnchor, constant: -30),
            
            nationalBankExchangeRateButton.heightAnchor.constraint(equalToConstant: 40),
            nationalBankExchangeRateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nationalBankExchangeRateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nationalBankExchangeRateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            currencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currencyView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 20),
            currencyView.bottomAnchor.constraint(equalTo: lastUpdatedLabel.topAnchor, constant: -20)
        ])
    }
}



