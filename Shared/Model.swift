//
//  Model.swift
//  SeoulChants-SwiftUI
//
//  Created by Alfred Woo on 2021/01/28.
//

import Foundation

protocol Model {
    init(_ map: [String: Any])
}

class ResponseModel: Model {
    let result: Bool
    let minVersion: Int
    
    required init(_ map: [String: Any]) {
        result = map["result"] as! Bool
        minVersion = Int(map["minVersion"] as! String)!
    }
}

class ChantsListResponse: ResponseModel {
    let list: [Chant]
    
    required init(_ map: [String : Any]) {
        list = (map["data"] as! [[String: Any]]).map { Chant($0) }
        super.init(map)
    }
}

class NextMatchResponse: ResponseModel {
    let match: Match
    
    required init(_ map: [String : Any]) {
        match = Match(map["data"] as! [String: Any])
        super.init(map)
    }
}

class MatchesListResponse: ResponseModel {
    let season: Int
    let matches: [Match]
    
    required init(_ map: [String : Any]) {
        let data = map["data"] as! [String: Any]
        season = data["season"] as! Int
        matches = (data["matches"] as! [[String: Any]]).map { Match($0) }
        super.init(map)

    }
}


struct Chant: Model, Identifiable {
    let id: UUID
    let name: String
    let lyrics: String
    let etc: String
    let youtube: String?
    let asset: String?
    let hot: Bool
    let new: Bool
    
    init(_ map: [String: Any]) {
        id = UUID()
        name = map["name"] as! String
        lyrics = map["lyrics"] as! String
        etc = map["etc"] as! String
        youtube = map["youtube"] as? String
        asset = map["asset"] as? String
        hot = map["hot"] as! Bool
        new = map["new"] as! Bool
    }
    
}

struct Match: Model, Identifiable {
    let id: UUID
    let vs: String
    let date: Date
    let result: String?
    let highlight: String?
    let competition: String
    let round: String
    let home: Bool
    let lineup: [String]
    let lineup_sub: String?
    let preview: Bool
    
    let previous: [Match]
    let stadium: Stadium?
    
    init(_ map: [String: Any]) {
        id = UUID()
        vs = map["vs"] as! String
        result = map["result"] as? String
        highlight = map["highlight"] as? String
        competition = map["competition"] as! String
        round = map["round"] as! String
        home = map["home"] as! Bool
        lineup_sub = map["lineup_sub"] as? String
        preview = map["preview_available"] as! Bool
        
        let _date = map["date"] as! String
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        date = df.date(from: _date)!
        
        let _lineup = map["lineup"] as? String
        if let _lineup = _lineup {
            lineup = _lineup.split(separator: "\n").map { String($0) }
        } else {
            lineup = []
        }
        
        let _previous = map["previous"] as? [[String: Any]]
        previous = _previous?.map { Match($0) } ?? []
        
        if let _stadium = map["stadium"] as? [String: Any] {
            stadium = Stadium(_stadium)
        } else {
            stadium = nil
        }
    }
    
}

struct Stadium: Model {
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(_ map: [String: Any]) {
        name = map["name"] as! String
        latitude = map["latitude"] as! Double
        longitude = map["longitude"] as! Double
    }
    
}


func demoMatch() -> Match {
    let json = """
    {"vs":"전북","abb":null,"date":"2021-02-27 14:00:00","result":null,"highlight":null,"competition":"K리그1 2021","round":"1R","home":false,"lineup":"유상훈\\n박주영\\n고광민 기성용 차두리\\n고요한","lineup_sub":null,"preview_available":false,"previous":[{"vs":"","abb":null,"date":"2020-07-26 19:00:00","result":"3:0 패","highlight":"https://m.sports.naver.com/video.nhn?id=689829","competition":"K리그1 2020","round":"13R","home":false,"lineup":null,"lineup_sub":null,"preview_available":false,"previous":null,"stadium":null},{"vs":"","abb":null,"date":"2020-06-06 16:30:00","result":"1:4 패","highlight":"https://m.sports.naver.com/video.nhn?id=668563","competition":"K리그1 2020","round":"5R","home":false,"lineup":null,"lineup_sub":null,"preview_available":false,"previous":null,"stadium":null},{"vs":"","abb":null,"date":"2019-10-26 16:00:00","result":"1:1 무","highlight":"https://m.sports.naver.com/video.nhn?id=601811","competition":"K리그1 2019","round":"35R","home":false,"lineup":null,"lineup_sub":null,"preview_available":false,"previous":null,"stadium":null},{"vs":"","abb":null,"date":"2019-09-01 19:00:00","result":"0:2 패","highlight":"https://m.sports.naver.com/video.nhn?id=578981","competition":"K리그1 2019","round":"28R","home":false,"lineup":null,"lineup_sub":null,"preview_available":false,"previous":null,"stadium":null},{"vs":"","abb":null,"date":"2019-07-20 19:00:00","result":"2:4 패","highlight":"https://m.sports.naver.com/video.nhn?id=563984","competition":"K리그1 2019","round":"22R","home":false,"lineup":null,"lineup_sub":null,"preview_available":false,"previous":null,"stadium":null}],"stadium":{"name":"전주월드컵경기장","latitude":35.868126,"longitude":127.064415}}
    """
    let serialized = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: []) as! [String: Any]
    return Match(serialized)
    
}

func demoChant() -> Chant {
    let json = """
    {"id":34,"name":"더 높은 곳을 향해","lyrics":"반짝이는 검은 눈동자\\r\\n그대 모습을 보라\\r\\n불타오르는 가슴엔\\r\\n붉은색 꿈이 있다\\r\\n\\r\\n때론 강하게, 때론 부드럽게\\r\\n초원을 달려간다\\r\\n그대 이름은 서울\\r\\n우린 세상의 중심\\r\\n\\r\\n거친 바람 불어도\\r\\n험한 파도가 와도\\r\\n앞을 막을 순 없으리오\\r\\n달리자 미래를 위해\\r\\n\\r\\n너와 나 모두 하나되어\\r\\n하늘 높이 날아올라\\r\\n불타는 가슴으로 외쳐라\\r\\n더 높은 곳을 향해","etc":"","youtube":"https://www.youtube.com/embed/kykG-23gz-0","asset":null,"hot":false,"new":false}
    """
    let serialized = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: []) as! [String: Any]
    return Chant(serialized)
}
