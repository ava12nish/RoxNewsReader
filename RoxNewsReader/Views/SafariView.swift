//
//  SafariView.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}
