//
//  PlayersViewController.swift
//  NBAPlayersApp
//
//  Created by Андрей Двойцов on 04.01.2021.
//

import UIKit

class PlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let players: [Player] = []
    let apiClient: ApiClient = ApiClientImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Players"
        navigationController?.navigationBar.prefersLargeTitles = true // большие заголовки
        
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
    

