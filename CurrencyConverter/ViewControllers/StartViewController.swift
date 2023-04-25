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
    private let nationalBankExchangeRateButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpView()
        configBackgroundImageView()
        configAppNameLabel()
        configLastUpdatedLabel()
        configDateAndTimeLabel()
        configNationalBankExchangeRateButton()
        setConstraints()
    }
    
    private func setUpView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(appNameLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(dateAndTimeLabel)
        view.addSubview(nationalBankExchangeRateButton)
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
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    private func configLastUpdatedLabel() {
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.text = "Last Updated"
        lastUpdatedLabel.textColor = .systemGray
        lastUpdatedLabel.textAlignment = .left
        lastUpdatedLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    private func configDateAndTimeLabel() {
        dateAndTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateAndTimeLabel.textColor = .systemGray
        dateAndTimeLabel.textAlignment = .left
        dateAndTimeLabel.text = "dd.mm.yyyy hh:m"
        dateAndTimeLabel.font = UIFont.systemFont(ofSize: 20)
        
    }
    
    private func configNationalBankExchangeRateButton() {
        
        nationalBankExchangeRateButton.translatesAutoresizingMaskIntoConstraints = false
        nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
        nationalBankExchangeRateButton.setTitleColor(UIColor.systemBlue, for: .normal)
        nationalBankExchangeRateButton.layer.borderWidth = 1
        nationalBankExchangeRateButton.layer.cornerRadius = 15
        nationalBankExchangeRateButton.layer.borderColor = UIColor.systemBlue.cgColor
        
//        nationalBankExchangeRateButton.addTarget(self, action: #selector(), for: .touchUpInside)
        
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            appNameLabel.heightAnchor.constraint(equalToConstant: 40),
            appNameLabel.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            appNameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 20),
            
            lastUpdatedLabel.heightAnchor.constraint(equalToConstant: 30),
            lastUpdatedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: dateAndTimeLabel.topAnchor, constant: -1),
            
            dateAndTimeLabel.heightAnchor.constraint(equalToConstant: 30),
            dateAndTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateAndTimeLabel.bottomAnchor.constraint(equalTo: nationalBankExchangeRateButton.topAnchor, constant: -10),
            
            nationalBankExchangeRateButton.heightAnchor.constraint(equalToConstant: 40),
            nationalBankExchangeRateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nationalBankExchangeRateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nationalBankExchangeRateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)

        ])
    }
    
    
    
    
   
     


}

