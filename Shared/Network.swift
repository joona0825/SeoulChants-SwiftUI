//
//  Network.swift
//  SeoulChants-SwiftUI
//
//  Created by Alfred Woo on 2021/01/28.
//

import Foundation
import Alamofire
#if os(iOS)
import UIKit
#endif

class Network: NSObject {
    
    let destination = "https://go.alfr.kr/seoulchants"
    
    enum APIPath: String {
        case list = "/list/(of)"
        case register = "/register/"
        case matches = "/matches/"
        case next = "/matches/next/"
    }
    
    static let shared = Network()
    
    private func request<T: ResponseModel>(path: APIPath, replacePath:[String: String] = [:], parameter: [String: String] = [:], method: HTTPMethod = .get, model: T.Type, completion: @escaping (T?) -> Void) {
        
        var url = destination + path.rawValue
        
        
        // url 대치
        for r in replacePath {
            url = url.replacingOccurrences(of: r.key, with: r.value)
        }
        
        NSLog("requesting \(url), parameter: \(parameter)")
        
        // request
        AF.request(url, method: method, parameters: parameter, encoding: URLEncoding(destination: .methodDependent)).responseJSON { response in
            
            switch response.result {
            case .success(let data):
                guard let data = data as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                let result = T(data)
                
                #if os(iOS)
                if let _currentVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
                   let currentVersion = Int(_currentVersion) {
                    if (result.minVersion > currentVersion) {
                        let alert = UIAlertController(title: "업데이트 필요", message: "새로운 기능 이용을 위해 앱을 업데이트 해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/id1476223185")!, options: [:]) { _ in
                                exit(0)
                            }
                        }))
                        return
                    }
                } else {
                    return
                }
                #endif
                
                completion(result)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
        
    }
    
    /// 응원가 리스트 불러오기
    func list(of: String, completion: @escaping ([Chant]) -> Void) {
        self.request(path: .list, replacePath: ["(of)": of], model: ChantsListResponse.self) { model in
            completion(model?.list ?? [])
        }
    }
    
    /// 푸시 토큰 등록
    func register() {
        guard let token = Common.loadUserDefault(forKey: .pushToken) as? String else {
            NSLog("token not defined")
            return
        }
        
        #if targetEnvironment(simulator)
        #else
        self.request(path: .register, parameter: ["token": token], method: .post, model: ResponseModel.self) { model in
            NSLog("token registration \((model?.result ?? false) ? "success" : "failure")")
        }
        #endif
    }
    
    /// 다음 경기 정보 가져오기
    func next(completion: @escaping (Match?) -> Void) {
        self.request(path: .next, model: NextMatchResponse.self) { model in
            completion(model?.match)
        }
    }
    
    /// 이번 시즌의 경기 목록 가져오기
    func matches(completion: @escaping (MatchesListResponse?) -> Void) {
        self.request(path: .matches, model: MatchesListResponse.self) { model in
            completion(model)
        }
    }
    
}
