//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-04-28.
//

import UIKit

class CurrencyMainCell: UITableViewCell {
    
    let currencyTextField = UITextField()
    let currencyLabel = UILabel()
    var stack = UIStackView()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        configLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.frame = CGRect(x: 10, y: 10, width: contentView.frame.width - 20, height: contentView.frame.height - 20)
    }

    func setupStackView() {
        stack = UIStackView(arrangedSubviews: [currencyLabel,currencyTextField])
        stack.axis = .horizontal
        currencyTextField.borderStyle = .roundedRect
        currencyTextField.backgroundColor = .secondarySystemBackground
        currencyTextField.setContentHuggingPriority(.init(200), for: .horizontal)
        stack.distribution = .fill
        stack.spacing = 30
        addSubview(stack)
    }
    
    func configLable() {
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.text = "UAH" + " >"
        currencyLabel.textAlignment = .left
    }
    
}


