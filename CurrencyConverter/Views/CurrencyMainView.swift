//
//  CorrencyView.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-04-25.
//

import UIKit

class CurrencyMainView: UIView {
    
    let exchangeRateSegmentedControl = UISegmentedControl(items: ["Sell", "Buy"])
    let addCurrencyButton = UIButton(type: .system)
    let shareButton = UIButton(type: .system)
    let currencyTableView = UITableView()
    
    static let idMainTableViewCell = "currencyTableViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setSettingsView()
        setUpView()
        configExchangeRateSegmentedControl()
        configAddCurrencyButton()
        configShareButton()
        configCurrencyTableView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  setSettingsView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    private func setUpView() {
        addSubview(exchangeRateSegmentedControl)
        addSubview(addCurrencyButton)
        addSubview(shareButton)
        addSubview(currencyTableView)
    }
    
    private func configExchangeRateSegmentedControl() {
        exchangeRateSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        exchangeRateSegmentedControl.backgroundColor = .white
        exchangeRateSegmentedControl.selectedSegmentTintColor = .systemBlue
        exchangeRateSegmentedControl.layer.cornerRadius = 10
        exchangeRateSegmentedControl.selectedSegmentIndex = 0
        exchangeRateSegmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        exchangeRateSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
    }
    
    private func configAddCurrencyButton() {
        addCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        addCurrencyButton.setTitle("Add Currency", for: .normal)
        addCurrencyButton.setImage(UIImage(named: "blue_plus"), for: .normal)
        addCurrencyButton.setTitleColor(UIColor.systemBlue, for: .normal)
        addCurrencyButton.titleLabel?.font = .systemFont(ofSize: 13)
    }
    
    private func configShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setBackgroundImage(UIImage(named: "square.and.arrow.up"), for: .normal)
    }
    
    private func configCurrencyTableView() {
        currencyTableView.register(CurrencyMainCell.self, forCellReuseIdentifier: CurrencyMainView.idMainTableViewCell)
        currencyTableView.translatesAutoresizingMaskIntoConstraints = false
        currencyTableView.rowHeight = 70
        currencyTableView.separatorStyle = .none
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            exchangeRateSegmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            exchangeRateSegmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            exchangeRateSegmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            exchangeRateSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            addCurrencyButton.heightAnchor.constraint(equalToConstant: 30),
            addCurrencyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addCurrencyButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            addCurrencyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            
            shareButton.heightAnchor.constraint(equalToConstant: 25),
            shareButton.widthAnchor.constraint(equalToConstant: 20),
            shareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            shareButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            currencyTableView.topAnchor.constraint(equalTo: exchangeRateSegmentedControl.bottomAnchor, constant: 10),
            currencyTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            currencyTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            currencyTableView.bottomAnchor.constraint(equalTo: addCurrencyButton.topAnchor, constant: -5)
        ])
    }
}


