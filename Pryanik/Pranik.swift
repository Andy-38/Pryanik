//
//  Player.swift
//  Pryanik
//
//  Created by Андрей Двойцов on 29.01.2021.
//
//  Типы данных получаемых с сервера

import Foundation

struct PryanikResponse: Decodable { // структура получаемых из интернета данных
    let data: [Pranik] // data - массив объектов типа Pranik
    let view: [String] // view - массив строк
}

struct Pranik: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey { // для преобразования имен
        case name //поля которые совпадают и на сервере и в массиве - не трогаем
//        case name = "first_name" //поля которые совпадают и на сервере и в массиве - не трогаем
//        case firstName = "first_name" // которые не совпадают - указываем соответствие
    }
}
