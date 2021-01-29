//
//  Player.swift
//  Pryanik
//
//  Created by Андрей Двойцов on 29.01.2021.
//

import Foundation

struct PlayersResponse: Decodable {
    let data: [Player]
}
struct Player: Decodable {
    let team: Team
    let firstName: String
    let lastName: String
    let heightFeet: Int?
    let heightInches: Int?
    //let teamCity: String
    //let teamName: String
    //let teamConference: String
    let position: String
    
    var name: String {
        firstName + " " + lastName
    }
    var height: String {
        if let heightFeet = heightFeet, let heightInches = heightInches {
            return "\(heightFeet)'\(heightInches)''" // если есть рост в футах и дюймах возвращаем его
        } else {
            return "Unknown" // иначе пишем unknown
        }
        
    }
    
    enum CodingKeys: String, CodingKey { // для преобразования имени поля first_name на сервере в имя firstName в массиве
        case team //поля которые совпадают и на сервере и в массиве - не трогаем
        case firstName = "first_name" // которые не совпадают - указываем соответствие
        case lastName = "last_name"
        case heightFeet = "height_feet"
        case heightInches = "height_inches"
        case position
    }
}

struct Team: Decodable {
    let name: String
    let city: String
    let conference: String
    
    var fullName: String {
        city + " " + name
    }
}
