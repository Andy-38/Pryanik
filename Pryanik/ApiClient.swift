//
//  ApiClient.swift
//  Pryanik
//
//  Created by Андрей Двойцов on 29.01.2021.
//
// Клиент для получения данных с сервера

import Foundation

enum ApiError: Error { //перечисление возможных ошибок
    case noData // возможна лишь одна ошибка - данные не получены
}

protocol ApiClient {
    func getPryaniks(completion: @escaping (Result<[Pranik], Error>) -> Void) // после выполнения функции вызывается замыкание, у него на входе result - массив данных либо ошибка (при отсутствии данных), на выходе ничего (void)
    func getView(completion: @escaping (Result<[String], Error>) -> Void) // после выполнения функции вызывается замыкание, у него на входе result - массив данных либо ошибка (при отсутствии данных), на выходе ничего (void)
}

class ApiClientImpl: ApiClient { // класс реализует протокол, объявленный ранее
    
    // тестовый JSON - сетевая заглушка на время теста приложения
    let testJson = """
    {
        "data": [{
                "name": "hz",
                "data": {
                    "text": "Текстовый блок"
                }
            }, {
                "name": "picture",
                "data": {
                    "url": "https://pryaniky.com/static/img/logo-a-512.png",
                    "text": "Пряники"
                }
            }, {
                "name": "selector",
                "data": {
                    "selectedId": 1,
                    "variants": [{
                            "id": 1,
                            "text": "Вариант раз"
                        }, {
                            "id": 2,
                            "text": "Вариант два"
                        }, {
                            "id": 3,
                            "text": "Вариант три"
                        }
                    ]
                }
            }
        ],
        "view": ["hz", "selector", "picture", "hz"]
    }
    """.data(using: .utf8)
    
    func getPryaniks(completion: @escaping (Result<[Pranik], Error>) -> Void) {
        let session = URLSession.shared // создаем URL-сессию
        let url = URL(string: "https://pryaniky.com/static/json/sample.json")! // адрес сервера в инете, откуда берем данные
        let urlRequest = URLRequest(url: url) // создаем запрос на основе URL-адреса
        //создаем задачу для загрузки данных:
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else { // проверяем получены ли данные
                completion(.failure(ApiError.noData)) // выдаем ошибку если данных нет
                return
            }
        // данные получены
            do { // если в блоке do происходит ошибка, то выполняется блок catch
                let jsonDecoder = JSONDecoder() // создаем расшифровщик принятых даных типа JSON
                let response = try jsonDecoder.decode(PryanikResponse.self, from: data) // декодируем из data нужные нам данные типа PryanikResponse
//                let response = try jsonDecoder.decode(PryanikResponse.self, from: self.testJson!/* data */) // декодируем из testJson нужные нам данные типа PryanikResponse
                completion(.success(response.data))
            } catch(let error) { // если поймали ошибку то:
                completion(.failure(error))
            }
        })
        
        dataTask.resume() //запускаем задачу по загрузке данных
    }
    
    func getView(completion: @escaping (Result<[String], Error>) -> Void) {
        let session = URLSession.shared // создаем URL-сессию
        let url = URL(string: "https://pryaniky.com/static/json/sample.json")! // адрес сервера в инете, откуда берем данные
        let urlRequest = URLRequest(url: url) // создаем запрос на основе URL-адреса
        //создаем задачу для загрузки данных:
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else { // проверяем получены ли данные
                completion(.failure(ApiError.noData)) // выдаем ошибку если данных нет
                return
            }
        // данные получены
            do { // если в блоке do происходит ошибка, то выполняется блок catch
                let jsonDecoder = JSONDecoder() // создаем расшифровщик принятых даных типа JSON
                let response = try jsonDecoder.decode(PryanikResponse.self, from: data) // декодируем из data нужные нам данные типа PryanikResponse
                completion(.success(response.view))
            } catch(let error) { // если поймали ошибку
                completion(.failure(error))
            }
        })
        
        dataTask.resume() //запускаем задачу по загрузке данных
    }
}
