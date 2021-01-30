//
//  PlayersViewController.swift
//  Pryanik
//
//  Created by Андрей Двойцов on 29.01.2021.
//

import UIKit

class PrynikViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var praniks: [Pranik] = []
    var views: [String] = []
    let apiClient: ApiClient = ApiClientImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        print(views)
    }
    
    @IBAction func onReloadButtonClick(_ sender: Any) {
        reload()
    }
    
    private func reload() { // функция для загрузки данных
        showloading()
        apiClient.getPryaniks(completion: { result in // получаем данные через протокол apiClient в дополнительном потоке
            DispatchQueue.main.async { // возвращаемся в основной поток
                switch result {
                case .success(let praniks):
                    self.praniks = praniks // в случае успеха - на выходе массив данных
                    self.showData()
                case .failure:
                    self.praniks = [] // в случае неудачи - пустой массив
                    self.showError()
                }
                
                
            }
        })
        
//        apiClient.getView(completion: { result in // получаем данные через протокол apiClient в дополнительном потоке
//            DispatchQueue.main.async { // возвращаемся в основной поток
//                switch result {
//                case .success(let views):
//                    self.views = views // в случае успеха - на выходе массив данных
//                    self.showData()
//                case .failure:
//                    self.views = [] // в случае неудачи - пустой массив
//                    self.showError()
//                }
//
//
//            }
//        })
    }
    
    private func showloading() {
        activityIndicatorView.startAnimating() // включаем крутилку-индикатор загрузки данных
        reloadButton.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func showData() {
        self.activityIndicatorView.stopAnimating() // выключаем круилку-индикатор загрузки данных
        reloadButton.isHidden = true
        errorLabel.isHidden = true
        self.tableView.reloadData() // перезагружаем tableView с новыми данными
    }
    
    private func showError() {
        self.activityIndicatorView.stopAnimating() // выключаем круилку-индикатор загрузки данных
        reloadButton.isHidden = false
        errorLabel.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return praniks.count // количество элементов массива praniks
        // сколько раз вызывается функция следующая
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PryanikCell", for: indexPath)
        let pranik = praniks[indexPath.row] // получаем элемент массива
        cell.textLabel?.text = pranik.name
        if let text = pranik.datta.text { cell.detailTextLabel?.text = text }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
// вызывается при нажатии
    }
    
    }
    

