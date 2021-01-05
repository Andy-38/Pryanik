//
//  PlayerDetailsViewController.swift
//  NBAPlayersApp
//
//  Created by Андрей Двойцов on 04.01.2021.
//

import UIKit

class PlayerDetailsViewController: UIViewController {

    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var teamButton: UIButton!
    
    var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = player?.name
        navigationController?.navigationBar.prefersLargeTitles = true // большие заголовки
        positionLabel.text = player?.position
        heightLabel.text = player?.height
    }
    
    @IBAction func onTeamButtonClick(_ sender: Any) {
    // реализовать переход на экран с детальной информацией о команде
    // город, название, конференция
    // Los Angeles, Lakers, West
    // Miami, Heat, East
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let teamDetailsViewController = storyboard.instantiateViewController(identifier: "TeamDetails") as! TeamDetailViewController
        
        teamDetailsViewController.player = player // передаем его на новый экран
        
        navigationController?.pushViewController(teamDetailsViewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
