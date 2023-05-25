//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-04-30.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    static let cellID = "currencyCell"
    
    var tableCurrencies = UITableView()
    let searchController = UISearchController()
    
    var currencyArrayFromNet: [Currency]?
    var currencyTransformer = TransformCurrencyToListArray()
    var filteredDataToSections: [Currency] = []
    var arrayCurrencyForTableWithSection: [[Currency]] = []
    var headerTitlesArray: [String]?
    
    var completionChooseCurrency: ((Currency)->())?
    
    //MARK: - live cycle App:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        transformArrayForTableWithSections(model: currencyArrayFromNet)
    }
    
    //MARK: - objc Function:
    
    @objc func backToStartViewController() {
        dismiss(animated: true)
    }
    
    //MARK: -  Transform Function:
    
    private func transformArrayForTableWithSections(model: [Currency]?) {
        guard let models = model else {return}
        self.currencyTransformer.createDataSourceHeaderAndSectionsArray(model: models)
        self.headerTitlesArray = self.currencyTransformer.headerArray
        self.arrayCurrencyForTableWithSection = self.currencyTransformer.sectionsArray
        DispatchQueue.main.async {
            self.tableCurrencies.reloadData()
        }
    }
}

//MARK: - Set UIConfiguration:

extension CurrencyListViewController {
    
    private func configView() {
        setView()
        setupTable()
        setupLeftBarButton()
        setupSearchController()
    }
    
    private func setView() {
        view.backgroundColor = .secondarySystemBackground
        title = "Currencies List"
    }
    
    private func setupTable() {
        tableCurrencies = UITableView(frame: view.bounds, style: .insetGrouped)
        tableCurrencies.delegate = self
        tableCurrencies.dataSource = self
        view.addSubview(tableCurrencies)
        tableCurrencies.register(CurrencyListCell.self, forCellReuseIdentifier: CurrencyListViewController.cellID)
        
        tableCurrencies.backgroundColor = .clear
        tableCurrencies.layer.shadowColor = UIColor.black.cgColor
        tableCurrencies.layer.shadowOffset = .init(width: 0, height: 3)
        tableCurrencies.layer.shadowRadius = 1
        tableCurrencies.layer.shadowOpacity = 0.3
    }
    
    private func setupLeftBarButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Currency", for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backToStartViewController), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
}

//MARK: - Table Delegate DataSource:
extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currency: Currency?
        if searchController.isActive && searchController.searchBar.text != "" {
            currency = filteredDataToSections[indexPath.row]
            dismiss(animated: false)
        } else {
            currency = arrayCurrencyForTableWithSection[indexPath.section][indexPath.row]
        }
        guard let currency = currency else {return}
        completionChooseCurrency?(currency)
        backToStartViewController()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        return arrayCurrencyForTableWithSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredDataToSections.count
        }
        return arrayCurrencyForTableWithSection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListViewController.cellID, for: indexPath) as? CurrencyListCell else {return UITableViewCell()}
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.setLabel(currency: filteredDataToSections[indexPath.row])
        } else {
            cell.setLabel(currency: arrayCurrencyForTableWithSection[indexPath.section][indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return "Find:"
        }
        return headerTitlesArray?[section]
    }
}

//MARK: - Search Controller Configuration

extension CurrencyListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        guard let currencies = currencyArrayFromNet else {return}
        filteredDataToSections = currencies.filter({$0.fullCurrensyName.lowercased().contains(searchText.lowercased())})
        tableCurrencies.reloadData()
    }
}
