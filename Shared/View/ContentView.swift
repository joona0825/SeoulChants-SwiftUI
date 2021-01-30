//
//  ContentView.swift
//  Shared
//
//  Created by Alfred Woo on 2021/01/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                NextMatchView(match: nil)
                    .tabItem { Text("매치 센터") }
                SongListView(list: [], of: .chants)
                    .tabItem { Text("응원가") }
                SongListView(list: [], of: .playercall)
                    .tabItem { Text("선수 콜") }
            }
            .navigationTitle("Seoul Chants")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
