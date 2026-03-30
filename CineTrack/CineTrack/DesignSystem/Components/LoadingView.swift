//
//  LoadingView.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .foregroundStyle(.secondary)
        }
    }
}
