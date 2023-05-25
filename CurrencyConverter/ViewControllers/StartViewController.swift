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
    let lastUpdatedLabel = UILabel()
    private let nationalBankExchangeRateButton = UIButton(type: .system)
    private var datePicker: DatePickerView!
    
    private let numberRowsInMainTable = 6
    private var valueTF: Double = 1
    
    private let networkFetchManager = NetworkFetchManager()
    private let coreData = CoreDataManager.instance
    private var arrayCurrencysFromCoreData = [String]()
    private let currencyView = CurrencyMainView()
    private var currenciesFromInternet: [Currency]?
    private var currensItemToReSave: Currency?
    
    var currenсyArray: [Currency] = [] {
        didSet {
            DispatchQueue.main.async {
                self.currencyView.addCurrencyButton.isHidden = self.currenсyArray.count >= self.numberRowsInMainTable ? true : false
            }
            reloadTable()
        }
    }
    
    private var saleCourse = true {
        didSet{
            reloadTable()
        }
    }
    
    private var nbuCourse = false
    
    private var dateFetchToLabel: Date! {
        didSet{
            updateDateLabel(dateUpdate: dateFetchToLabel)
        }
    }
    
    //MARK: - live cycle App:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        addTargetsForButtons()
        setConstraints()
        fetchDataFromCoreData(Date())
    }
    
    //MARK: - objc Function:
    
    @objc func segmentAction(sender: UISegmentedControl) {
        saleCourse = sender.selectedSegmentIndex == 0 ? true : false
    }
    
    @objc func closeDatePicker() {
        datePicker.removeFromSuperview()
    }
    
    @objc func pushDateFromPicker() {
        nationalBankExchangeRateButton.setTitle("Return to course PB", for: .normal)
        nbuCourse = true
        fetchDataFromCoreData(datePicker.datePicker.date)
        closeDatePicker()
    }
    
    @objc func openCurrencyListVC() {
        let currencyListVC = CurrencyListViewController()
        let navContrroler = UINavigationController(rootViewController: currencyListVC)
        currencyListVC.completionChooseCurrency = {[weak self] currencyChoose in
            guard let self = self else {return}
            if self.currenсyArray.count < self.numberRowsInMainTable {
                self.currenсyArray.append(currencyChoose)
                self.coreData.newCurrencyCore(currencyChoose)
            }
        }
        currencyListVC.currencyArrayFromNet = currenciesFromInternet
        navigationController?.present(navContrroler, animated: true)
    }
    
    @objc func NationalBankExchangeRateButtonAction() {
        if !nbuCourse {
            datePicker = DatePickerView(frame: self.view.frame)
            datePicker.cancelButton.addTarget(self, action: #selector(closeDatePicker), for: .touchUpInside)
            datePicker.okButton.addTarget(self, action: #selector(pushDateFromPicker), for: .touchUpInside)
            view.addSubview(datePicker)
        } else {
            nbuCourse = false
            nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
            fetchDataFromCoreData(Date())
        }
    }
    
    @objc private func selectItemToShare() {
        let alert = UIAlertController(title: "Choose what you want to share", message: nil, preferredStyle: .actionSheet)
        
        let textAction = UIAlertAction(title: "Share text", style: .default){_ in
            self.shareText()
        }
        let imageAction = UIAlertAction(title: "Share image", style: .default){_ in
            self.shareScreenShotImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(textAction)
        alert.addAction(imageAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - private Function:
    
    private func addTargetsForButtons() {
        currencyView.addCurrencyButton.addTarget(self, action: #selector(openCurrencyListVC), for: .touchUpInside)
        currencyView.exchangeRateSegmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        nationalBankExchangeRateButton.addTarget(self, action: #selector(NationalBankExchangeRateButtonAction), for: .touchUpInside)
        currencyView.shareButton.addTarget(self, action: #selector(selectItemToShare), for: .touchUpInside)
    }
    
    private func updateDateLabel(dateUpdate: Date) {
        DispatchQueue.main.async {
            self.lastUpdatedLabel.text = "Last Updated\n\(dateUpdate.formateDateToUpdateLabel())"
        }
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.currencyView.currencyTableView.reloadData()
        }
    }
    
    //MARK: - Function to fetch Data:
    
    private func fetchDataFromNet(_ date: Date) {
        networkFetchManager.fetchCurrences(for: date) { data, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.alertNoInternet()
                }
                return
            }
            self.coreData.newjsonCurrencys(jsonCurrencyData: data, date: date)
            self.transformDataToCurrencyModelAndRecordCurrencyArrayFromInternet(data)
            self.addStoreCurrencystoCurrencyArrayForTable(self.arrayCurrencysFromCoreData)
            self.dateFetchToLabel = date
        }
    }
    
    private func alertNoInternet() {
        let alert = UIAlertController(title: "Attention\nData not received.", message: "Please check your internet connection", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel){_ in
            self.lastUpdatedLabel.text = "Not internet\nConnection"
            self.currenсyArray = []
        }
        alert.addAction(actionOk)
        present(alert, animated: true)
    }
    
    private func fetchDataFromCoreData(_ dateToFetch: Date) {
        let jsonCurrencys = coreData.getJsonCurrencysForDate(date: dateToFetch)
        arrayCurrencysFromCoreData = coreData.getCurrencyFromCore()
        
        guard let jsonData = jsonCurrencys?.jsonData else {
            fetchDataFromNet(dateToFetch)
            return}
        
        dateFetchToLabel = jsonCurrencys?.dateFetch
        transformDataToCurrencyModelAndRecordCurrencyArrayFromInternet(jsonData)
        addStoreCurrencystoCurrencyArrayForTable(arrayCurrencysFromCoreData)
    }
    
    private func transformDataToCurrencyModelAndRecordCurrencyArrayFromInternet(_ jsonData: Data?) {
        networkFetchManager.parseCurrency(jsonData) { model in
            self.currenciesFromInternet = model?.currences
        }
    }
    
    private func addStoreCurrencystoCurrencyArrayForTable(_ arrayCurrencysFromCoreData:[String]) {
        guard let fullArrayCurrency = currenciesFromInternet else {return}
        var tempCurrencysArray = [Currency]()
        arrayCurrencysFromCoreData.forEach{ item in
            for currency in fullArrayCurrency {
                if currency.currency == item {
                    tempCurrencysArray.append(currency)
                }
            }
        }
        currenсyArray = tempCurrencysArray
    }
}

//MARK: - UITableViewDelegate

extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CurrencyMainCell else {return}
        cell.selectionStyle = .none
        currensItemToReSave = cell.currency
        cell.currencyTextField.becomeFirstResponder()
        cell.currencyTextField.delegate = self
        cell.currencyTextField.blueLayerTF()
        cell.contentView.isUserInteractionEnabled = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let cellCurrency = (tableView.cellForRow(at: indexPath) as! CurrencyMainCell).currency else {return}
        if editingStyle == .delete {
            currenсyArray.remove(at: indexPath.row)
            coreData.deleteCurrencyCore(currencyToDelete: cellCurrency)
        }
    }
}

//MARK: - UITableViewDataSource

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenсyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyMainView.idMainTableViewCell, for: indexPath) as? CurrencyMainCell else {return UITableViewCell()}
        cell.currency = currenсyArray[indexPath.row]
        cell.currencyTextField.tag = indexPath.row
        cell.setupLabel(sell: saleCourse, nbu: nbuCourse, valueFromTF: valueTF)
        return cell
    }
}

//MARK: - UITextFieldDelegate:

extension StartViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let value = textField.text,
              let valueTFDouble = Double(value),
              let currensValue = currensItemToReSave
        else {return true}
        currenсyArray.indices.forEach { item in
            currenсyArray[item].textFieldDoubleValue = nil
        }
        if let i = currenсyArray.firstIndex(where: { $0.currency == currensValue.currency}) {
            currenсyArray[i].textFieldDoubleValue = valueTFDouble
        }
        valueTF = textField.tag == 0 ? valueTFDouble : valueTFDouble * (currensValue.saleRateNB ?? 0)
        reloadTable()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.onlyDigits()
    }
}

//MARK: - Set UIConfiguration & constraints:

extension StartViewController {
    
    private func configView() {
        setUpView()
        configBackgroundImageView()
        configAppNameLabel()
        configLastUpdatedLabel()
        configNationalBankExchangeRateButton()
        configCurrencyView()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(appNameLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(nationalBankExchangeRateButton)
        view.addSubview(currencyView)
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
        lastUpdatedLabel.text = "Last Updated\ndd.mm.yyyy hh:m"
        lastUpdatedLabel.textColor = .systemGray
        lastUpdatedLabel.numberOfLines = 2
        lastUpdatedLabel.textAlignment = .left
        lastUpdatedLabel.font = UIFont(name: "Regular", size: 12)
    }
    
    private func configNationalBankExchangeRateButton() {
        nationalBankExchangeRateButton.translatesAutoresizingMaskIntoConstraints = false
        nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
        nationalBankExchangeRateButton.setTitleColor(UIColor.systemBlue, for: .normal)
        nationalBankExchangeRateButton.layer.borderWidth = 1
        nationalBankExchangeRateButton.layer.cornerRadius = 15
        nationalBankExchangeRateButton.layer.borderColor = UIColor.systemBlue.cgColor
        nationalBankExchangeRateButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
    }
    
    private func configCurrencyView() {
        currencyView.translatesAutoresizingMaskIntoConstraints = false
        currencyView.currencyTableView.delegate = self
        currencyView.currencyTableView.dataSource = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            
            appNameLabel.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -20),
            appNameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16),
            
            lastUpdatedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: nationalBankExchangeRateButton.topAnchor, constant: -30),
            
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



