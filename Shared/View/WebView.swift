//
//  WebView.swift
//  SeoulChants-SwiftUI
//
//  Created by Alfred Woo on 2021/01/30.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    
    let url: String?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ view: WKWebView, context: Context) {
        guard var url = self.url else { return }
        
        if url.contains("?") {
            url += "&playsinline=1"
        } else {
            url += "?playsinline=1"
        }
        
        let htmlString = "<html style='height:100%;width:100%'><head><meta name='viewport'content='width=device-width,initial-scale=1'></head><body style='margin:0;height:100%;width:100%'><iframe style='height:100%;width:100%'src='\(url)'frameborder='0'allow='accelerometer; autoplay;encrypted-media;gyroscope' allowfullscreen;></iframe></body></html>"
        view.loadHTMLString(htmlString, baseURL: nil)
    }
    
}
