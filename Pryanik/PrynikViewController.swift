//
//  PlayersViewController.swift
//  Pryanik
//
//  Created by Андрей Двойцов on 29.01.2021.
//

import UIKit

class MyCell: UITableViewCell {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func onSegmentChange(_ sender: Any) {
        // по уму конечно тут надо конечно делегировать обработку классу, подписанному на протокол делегирования, но раз особо ничего делать не нужно с переключателем в тестовом задании, то просто покажу сообщение отсюда
        let alert = UIAlertController(title: "Внимание!", message: "Был выбран вариант: " + segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true)
        
    }
}

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
        
        apiClient.getView(completion: { result in // получаем данные через протокол apiClient в дополнительном потоке
            DispatchQueue.main.async { // возвращаемся в основной поток
                switch result {
                case .success(let views):
                    self.views = views // в случае успеха - на выходе массив данных
                    self.showData()
                case .failure:
                    self.views = [] // в случае неудачи - пустой массив
                    self.showError()
                }
            }
        })
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
        return views.count // количество элементов массива praniks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        func findPryanikIndexByName(name: String) -> Pranik {
            for index in 0...praniks.count {
                if praniks[index].name == view {
                    return praniks[index]
                }
            }
            return praniks[0] // если ничего не нашли, то возвращаем 0-й элемент (это надо потом переделать, прикрутить какой-нибудь пустой пряник
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PryanikCell", for: indexPath) as! MyCell
        
        let view = views[indexPath.row] // узнаем какой элемент сейчас отобразить
        
        let currentPryanik = findPryanikIndexByName(name: view) // ищем этот элемент среди загруженных
        
        // выводим его в таблицу
        
        // тип данных
        cell.detailTextLabel?.text = "Тип данных: " + currentPryanik.name
        
        // текст - если он есть
        if let text = currentPryanik.datta.text { cell.textLabel?.text = text }
        
        //изображение - если есть
        if let imageName = currentPryanik.datta.url {// имя картинки - из массива
            let url = URL(string: imageName) // URL изображения
        //    DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) // проверяем что изображение по ссылке существует
        //        DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data!) // загружаем его асинхронно
        //        }
        //    }
        }
        
        // переключатель - если есть
        if let segments = currentPryanik.datta.variants {
            cell.segmentControl.removeAllSegments()
            cell.segmentControl.isHidden = false
            for num in 0...segments.count-1 {
                cell.segmentControl.insertSegment(withTitle: currentPryanik.datta.variants![num].text, at: currentPryanik.datta.variants![num].id, animated: false)
            }
        }
        if let selectedID = currentPryanik.datta.selectedId { // выбираем элемент переключателя
            cell.segmentControl.selectedSegmentIndex = selectedID - 1
        } 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
// вызывается при нажатии
        let alert = UIAlertController(title: "Внимание!", message: "Был выбран объект: " + views[indexPath.row], preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    }
    

