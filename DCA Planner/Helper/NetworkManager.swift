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
    
    typealias NetworkCompletion = (Result<[Coin], NetworkError>) -> Void
    
    /*
     
     https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest?slug=bitcoin&CMC_PRO_API_KEY=8bccdb3f-7970-4cd0-8896-96e7500a02cd
     
     */
    
    // CoinMarketCap API 관련 상수
    struct Constant {
        static let baseURL = "https://pro-api.coinmarketcap.com/v2/"
        static let endpoint = "cryptocurrency/quotes/latest?symbol="
        static let bitcoin = "BTC"
        static let apikeyHeader = "BTC&CMC_PRO_API_KEY="
        static let apikey = "7ef8dc66-ebec-4bc9-bda3-dd52643ea0d9"
    }
    
    // 네트워킹 요청을 통해 코인 데이터 가져오기
    func fetchCoinData(searchCoin: String, completion: @escaping NetworkCompletion) {
        
    }
}
