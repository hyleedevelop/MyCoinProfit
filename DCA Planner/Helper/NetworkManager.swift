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
    
    /*
     
     https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h
     
     https://rest.coinapi.io/v1/assets/?apikey=D663702C-C70B-4FC7-87ED-4E72348F4657
     https://rest.coinapi.io/v1/assets/filter_asset_id=USD,BTC,ETH?apikey=D663702C-C70B-4FC7-87ED-4E72348F4657
     
     */
    
    // CoinMarketCap API 관련 상수
    struct URLConstant {
        static let baseURL = "https://rest.coinapi.io/v1/assets/filter_asset_id="
        static let kind = "USD,BTC,ETH,USDT,USDC,BNB,BUSD,XRP,DOGE,ADA,MATIC"
        static let apikey = "D663702C-C70B-4FC7-87ED-4E72348F4657"
    }
    
    // 네트워킹 요청을 통해 코인 데이터 가져오기
    func fetchCoinData(completion: @escaping (Result<[CoinData], NetworkError>) -> Void) {
        
        // 1) URL 설정
        guard let url = URL(string: URLConstant.baseURL + URLConstant.kind + "?apikey=" + URLConstant.apikey) else { return }
                
        // 2) 네트워킹을 위한 작업 설정
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 어떤 에러가 존재한다면 네트워킹 에러를 가지고 종료
            if error != nil {
                completion(.failure(.networkingError))
                return
            }
            
            // 네트워킹은 성공했으나 데이터를 담아오는데 문제가 있다면 에러를 가지고 종료
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            // JSON parsing
            do {
                let coinInfo = try JSONDecoder().decode([CoinData].self, from: data)
                completion(.success(coinInfo))
            } catch {
                completion(.failure(.parseError))
            }
            
        }
        
        // 3) 네트워킹 작업 시작
        task.resume()
        
    }
    
}
