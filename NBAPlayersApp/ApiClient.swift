//
//  ApiClient.swift
//  NBAPlayersApp
//
//  Created by Andy Dvoytsov on 05.01.2021.
//
// Клиент для получения данных с сервера

import Foundation

enum ApiError: Error { //перечисление возможных ошибок
    case noData // возможна лишь одна ошибка - данные не получены
}
// protocol - это то, что должен уметь делать API Client
protocol ApiClient {
    func getPlayers(completion: @escaping (Result<[Player], Error>) -> Void) // после выполнения функции вызывается замыкание, у него на входе result - массив игроков либо ошибка (при отсутствии данных), на выходе ничего (void)
}

class ApiClientImpl: ApiClient {
    // класс реализует протокол, объявленный ранее
    func getPlayers(completion: @escaping (Result<[Player], Error>) -> Void) {
        let session = URLSession.shared // создаем URL-сессию
        let url = URL(string: "https://www.balldontlie.io/api/v1/players")! // адрес сервера в инете, откуда берем данные
        let urlRequest = URLRequest(url: url) // создаем запрос на основе URL-адреса
        //создаем задачу для загрузки данных:
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            //sleep(5) //задержка 5 секунд
            //completion(.failure(ApiError.noData))
            //return
            
            guard let data = data else { // проверяем получены ли данные
                completion(.failure(ApiError.noData)) // выдаем ошибку если данных нет
                return
            }
        // данные получены
            do { // если в блоке do происходит ошибка, то выполняется блок catch
                let jsonDecoder = JSONDecoder() // создаем расшифровщик принятых даных типа JSON
                let response = try jsonDecoder.decode(PlayersResponse.self, from: data) // декодируем из data нужные нам данные типа PlayersResponse
                completion(.success(response.data))
            } catch(let error) { // если поймали ошибку то:
                print(error)
                completion(.failure(error))
            }
        })
        
        dataTask.resume() //запускаем задачу по загрузке данных
    }
}
