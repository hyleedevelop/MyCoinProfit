//
//  NetworkManager.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/15.
//

import Foundation

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

final class NetworkManager {
    
    // 싱글톤으로 만들기
    static let shared = NetworkManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    //MARK: - Coingecko API에서 네트워킹 요청을 통해 코인의 현재 가격 데이터 가져오기 (코인시세 탭)
    func fetchCurrentPrice(completion: @escaping (Result<[CurrentPriceData], NetworkError>) -> Void) {
        
        /*
         https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h
         */
        
        // 1) URL 설정
        let baseURL = "https://api.coingecko.com/api/v3/"
        let categoryURL = "coins/markets?"
        let parameterURL = "vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h"
        
        guard let url = URL(string: baseURL + categoryURL + parameterURL) else { return }
                
        // 2) 네트워킹을 위한 작업 설정
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 어떤 에러가 존재한다면 네트워킹 에러를 가지고 종료
            if let error = error {
                print("[DEBUG] Error \(error.localizedDescription)")
                completion(.failure(.networkingError))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("[DEBUG] Response code \(response.statusCode)")
            }
            
            // 네트워킹은 성공했으나 데이터를 담아오는데 문제가 있다면 에러를 가지고 종료
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            //let dataAsString = String(data: data, encoding: .utf8)
            //print("[DEBUG]: Data \(dataAsString ?? "does not exist!")")
            
            // JSON parsing
            do {
                let coinInfo = try JSONDecoder().decode([CurrentPriceData].self, from: data)
                //print("[DEBUG]: Coins \(coinInfo)")
                completion(.success(coinInfo))
            } catch {
                print("[DEBUG]: Failed to decode with error: \(error)")
                completion(.failure(.parseError))
            }
            
        }
        
        // 3) 네트워킹 작업 시작
        task.resume()
    }
    
    //MARK: - Coingecko API에서 특정 기간에 해당하는 특정 코인의 가격 히스토리 데이터 가져오기 (수익계산 탭)
    func fetchPriceHistory(with coinType: String, howManyDays numberOfDays: Int, completion: @escaping (Result<[[Double]], NetworkError>) -> Void) {
        
        /*
         https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=30&interval=daily
         */
        
        // 1) URL 설정
        //var startDate = String(firstDate)
        //var endDate = String(lastDate)
        let baseURL = "https://api.coingecko.com/api/v3/"
        let categoryURL = "coins/" + coinType + "/market_chart?"
        let parameterURL = "vs_currency=usd&days=" + String(numberOfDays) + "&interval=daily"
        
        guard let url = URL(string: baseURL + categoryURL + parameterURL) else { return }
                
        //2) 네트워킹을 위한 작업 설정
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 어떤 에러가 존재한다면 네트워킹 에러를 가지고 종료
            if let error = error {
                print("[DEBUG] Error \(error.localizedDescription)")
                completion(.failure(.networkingError))
                return
            }
            
            //if let response = response as? HTTPURLResponse {
            //    print("[DEBUG] Response code \(response.statusCode)")
            //}
            
            // 네트워킹은 성공했으나 데이터를 담아오는데 문제가 있다면 에러를 가지고 종료
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            //let dataAsString = String(data: data, encoding: .utf8)
            //print("[DEBUG] Data \(dataAsString ?? "does not exist!")")
            
            // JSON parsing
            do {
                let historyInfo = try JSONDecoder().decode(PriceHistoryData.self, from: data).prices
                
                //print("[DEBUG]: Coins \(historyInfo)")
                completion(.success(historyInfo))
            } catch {
                print("[DEBUG] Failed to decode with error: \(error)")
                completion(.failure(.parseError))
            }
            
        }
        
        // 3) 네트워킹 작업 시작
        task.resume()
    }
    
    //MARK: - ExchangeRate API에서 환율(USD-KRW) 데이터 가져오기
//    func fetchCurrentCurrency(completion: @escaping (Result<[String: Rate], NetworkError>) -> Void) {
//
//        /*
//         https://v6.exchangerate-api.com/v6/68f93027ced1e80c1f32336a/latest/USD
//         */
//
//        // 1) URL 설정
//        let baseURL = "https://v6.exchangerate-api.com/v6/"
//        let APIKeyURL = "68f93027ced1e80c1f32336a/"
//        let parameterURL = "latest/USD"
//        guard let url = URL(string: baseURL + APIKeyURL + parameterURL) else { return }
//
//        // 2) 네트워킹을 위한 작업 설정
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            // 어떤 에러가 존재한다면 네트워킹 에러를 가지고 종료
//            if let error = error {
//                print("[DEBUG] Error \(error.localizedDescription)")
//                completion(.failure(.networkingError))
//                return
//            }
//
//            //if let response = response as? HTTPURLResponse {
//            //    print("[DEBUG] Response code \(response.statusCode)")
//            //}
//
//            // 네트워킹은 성공했으나 데이터를 담아오는데 문제가 있다면 에러를 가지고 종료
//            guard let data = data else {
//                completion(.failure(.dataError))
//                return
//            }
//            //let dataAsString = String(data: data, encoding: .utf8)
//            //print("[DEBUG] Data \(dataAsString ?? "does not exist!")")
//
//            // JSON parsing
//            do {
//                let currencyInfo = try JSONDecoder().decode(CurrencyData.self, from: data).rates
//
//                //print("[DEBUG]: Coins \(currencyInfo)")
//                completion(.success(currencyInfo))
//            } catch {
//                print("[DEBUG] Failed to decode with error: \(error)")
//                completion(.failure(.parseError))
//            }
//
//        }
//
//        // 3) 네트워킹 작업 시작
//        task.resume()
//    }
    
    
}
