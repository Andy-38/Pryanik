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
   // let datta: Datta
    let datta: Datta
    
    enum CodingKeys: String, CodingKey { // для преобразования имен
        case name //поля которые совпадают и на сервере и в массиве - не трогаем
        case datta = "data" // которые не совпадают - указываем соответствие
    }
}

struct Datta: Decodable {
    let text: String
  //  let url:  String
  //  let selectedId: Int
  //  let variants: Variants
}

struct Variants: Decodable {
    let id: Int
    let text: String
}
