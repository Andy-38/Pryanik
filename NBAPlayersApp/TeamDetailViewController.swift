//
//  TeamDetailViewController.swift
//  NBAPlayersApp
//
//  Created by Андрей Двойцов on 04.01.2021.
//

import UIKit

class TeamDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var confLabel: UILabel!
    
    var player: Player?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "\(player!.teamCity) \(player!.teamName)"
        navigationController?.navigationBar.prefersLargeTitles = true // большие заголовки
        confLabel.text = player?.teamConference
        cityLabel.text = player?.teamCity
        nameLabel.text = player?.teamName
        //.text = player?.position
        //heightLabel.text = player?.height
        
        // Do any additional setup after loading the view.
    }
    


}
