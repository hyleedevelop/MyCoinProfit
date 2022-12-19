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
     
     https://rest-sandbox.coinapi.io/v1/assets/?apikey=D663702C-C70B-4FC7-87ED-4E72348F4657
     
     */
    
    // CoinMarketCap API 관련 상수
    struct Constant {
        static let baseURL = "https://rest-sandbox.coinapi.io/v1/assets/"
        static let apikey = "D663702C-C70B-4FC7-87ED-4E72348F4657"
    }
    
    // 네트워킹 요청을 통해 코인 데이터 가져오기
    func fetchCoinData(completion: @escaping (Result<[CoinData], NetworkError>) -> Void) {
        
        // 1) URL 설정
        guard let url = URL(string: Constant.baseURL + "?apikey=" + Constant.apikey) else { return }
        
        // 1-2) 특정 코인만 검색하는 경우
        //guard let url = URL(string: Constant.baseURLForOneCoin + "?apikey=" + Constant.apikey)
        
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
