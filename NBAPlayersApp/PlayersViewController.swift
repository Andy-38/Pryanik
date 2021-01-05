//
//  PlayersViewController.swift
//  NBAPlayersApp
//
//  Created by Андрей Двойцов on 04.01.2021.
//

import UIKit

class PlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var players: [Player] = []
    let apiClient: ApiClient = ApiClientImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Players"
        navigationController?.navigationBar.prefersLargeTitles = true // большие заголовки
        reload()
    }
    
    @IBAction func onReloadButtonClick(_ sender: Any) {
        reload()
        reloadButton.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func reload() { // функция для загрузки данных
        activityIndicatorView.startAnimating() // включаем крутилку-индикатор загрузки данных
        apiClient.getPlayers(completion: { result in // получаем игроков через протокол apiClient в дополнительном потоке
            DispatchQueue.main.async { // возвращаемся в основной поток
                switch result {
                case .success(let players):
                    self.players = players // в случае успеха - на выходе массив игроков
                    self.reloadButton.isHidden = true
                    self.errorLabel.isHidden = true
                case .failure:
                    self.players = [] // в случае неудачи - пустой массив
                    self.reloadButton.isHidden = false
                    self.errorLabel.isHidden = false
                }
                self.tableView.reloadData() // перезагружаем tableView с новыми данными
                self.activityIndicatorView.stopAnimating() // выключаем круилку-индикатор загрузки данных
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count // количество элементов массива players
        // сколько раз вызывается функция следующая
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        let player = players[indexPath.row] // получаем элемент массива
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text = player.team.fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let playerDetailsViewController = storyboard.instantiateViewController(identifier: "PlayerDetails") as! PlayerDetailsViewController
        
        let player = players[indexPath.row] // получаем элемент массива
        
        playerDetailsViewController.player = player // передаем его на новый экран
        
        navigationController?.pushViewController(playerDetailsViewController, animated: true)
    }
    
    }
    

