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
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpView()
        configBackgroundImageView()
        configAppNameLabel()
        configLastUpdatedLabel()
        configDatePicker()
        setConstraints()
    }

    @objc func refreshDade(sender: UIDatePicker) {
        print(self.datePicker.date)
        
        
        
    }
    
    private func setUpView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(appNameLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(datePicker)
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
    
    private func configDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(refreshDade), for: .valueChanged)
        
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
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -10),
            
            datePicker.heightAnchor.constraint(equalToConstant: 30),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)

        ])
    }
    
    
    
    
   
     


}

