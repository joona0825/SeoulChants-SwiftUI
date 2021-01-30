//
//  Song.swift
//  SeoulChants-SwiftUI
//
//  Created by Alfred Woo on 2021/01/30.
//

import SwiftUI

struct SongListView: View {
    
    enum Of: String {
        case chants = "chants"
        case playercall = "playercall"
    }
    
    @State var list: [Chant]
    let of: Of
    
    var body: some View {
        List(list) { item in
            NavigationLink(destination: SongDetailView(chant: item)) {
                HStack {
                    Text(item.name)
                }
            }
        }.onAppear {
            if self.list.isEmpty {
                Network.shared.list(of: of.rawValue) { list in
                    self.list = list
                }
            }
        }
    }
    
}

struct SongDetailView: View {
    let chant: Chant
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                        
                        if let youtube = chant.youtube {
                            WebView(url: youtube)
                        } else {
                            Text("영상 정보가 없습니다")
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                    }
                    .frame(width: geometry.size.width,
                           height: geometry.size.width * 0.5625,
                           alignment: .center)
                        
                    Text(chant.lyrics)
                        .frame(width: geometry.size.width)
                    Text(chant.etc)
                        .font(.caption)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Spacer()
                }
            }
        }
        .navigationTitle(chant.name)
    }
}

struct Song_Previews: PreviewProvider {
    static var previews: some View {
        SongListView(list: [], of: .chants)
    }
}
