//
//  NextMatch.swift
//  SeoulChants-SwiftUI
//
//  Created by Alfred Woo on 2021/01/30.
//

import SwiftUI

struct NextMatchView: View {
    @State var match: Match?
    
    var body: some View {
        VStack {
            if let match = match {
                ScrollView {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("다음 경기: \(match.competition) \(match.round)")
                                .font(.caption)
                            Spacer()
                            Text("vs \(match.vs)")
                                .font(.headline)
                            Text("@\(match.stadium!.name)")
                                .font(.subheadline)
                            Spacer()
                            Text("\(Common.dateString(from: match.date))")
                                .font(.caption2)
                        }
                        Spacer()
                    }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    
                    NextMatchSectionHeader(title: "이전 경기 결과")
                    
                    if match.previous.isEmpty {
                        Text("이전 경기 정보가 없습니다")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .frame(height: 120)
                    } else {
                        ForEach(match.previous) { item in
                            PreviousMatchRow(match: item)
                        }
                    }
                    
                    NextMatchSectionHeader(title: "라인업")
                    
                    if match.lineup.isEmpty {
                        Text("라인업 정보가 없습니다")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .frame(height: 120)
                    } else {
                        VStack(alignment: .leading) {
                            ZStack {
                                Image("lineup_bg")
                                    .resizable()
                                    .foregroundColor(Color(UIColor.systemGray3))
                                    .aspectRatio(contentMode: .fill)
                                VStack {
                                    ForEach(match.lineup, id: \.self) { line in
                                        Spacer()
                                        HStack {
                                            ForEach(line.split(separator: " ").map { String($0) }, id: \.self) { name in
                                                Spacer()
                                                Text(name)
                                                Spacer()
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            Text("교체명단: \(match.lineup_sub ?? "정보 없음")")
                                .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            } else {
                Text("다음 경기 정보가 없습니다")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
        }.onAppear {
            Network.shared.next { match in
                self.match = match
            }
        }
    }
}

struct NextMatchSectionHeader: View {
    let title: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.systemBackground))
                Spacer()
            }
            Spacer()
        }
        .background(Color(UIColor.systemGray))
        .frame(height: 44)
    }
}

struct PreviousMatchRow: View {
    let match: Match
    
    var body: some View {
        Button(action: {
            if let highlight = match.highlight, let url = URL(string: highlight) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }) {
            HStack {
                Text("\(match.result ?? "N/A")")
                    .foregroundColor({
                        if match.result?.contains("승") == true {
                            return Color(UIColor.systemBlue)
                        } else if match.result?.contains("무") == true {
                            return Color(UIColor.systemGray)
                        } else if match.result?.contains("패") == true {
                            return Color(UIColor.systemRed)
                        } else {
                            return Color(UIColor.label)
                        }
                        }()
                    )
                Text("(\(match.competition) \(match.round))")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                if match.highlight != nil {
                    Image(systemName: "play.circle")
                        .foregroundColor(Color(UIColor.systemGray))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .frame(height: 44)
        }
    }
}

struct NextMatch_Previews: PreviewProvider {
    static var previews: some View {
        NextMatchView(match: demoMatch())
    }
}
