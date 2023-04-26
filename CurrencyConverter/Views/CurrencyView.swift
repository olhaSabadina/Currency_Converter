//
//  CorrencyView.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-04-25.
//

import UIKit

class CurrencyView: UIView {

//    private let exchangeRateSegmentedControl = UISegmentedControl()
    private let label = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setSettingsView()
        self.setUpView()
        self.configExchangeRateSegmentedControl()
        self.setConstraints()

    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  setSettingsView() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    private func setUpView() {
       addSubview(label)
    }
    

    private func configExchangeRateSegmentedControl() {
//        exchangeRateSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "f,dfljslfjlsjf"
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
//            exchangeRateSegmentedControl.centerXAnchor.constraint(equalTo: UIView().centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 30),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor)

        ])
    }
    
    
}
