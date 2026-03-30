//
//  CastCardView.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import SwiftUI

struct CastCardView: View {
    let member: CastMember
    
    var body: some View {
        VStack(spacing: 6) {
            AsyncImage(url: member.profileURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.fill")
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .background(Circle().fill(Color.secondary.opacity(0.15)))
            
            Text(member.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Text(member.character)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}

#Preview {
    CastCardView(member: CastMember(id: 0, name: "Carlos", character: "Marcos", profilePath: nil))
}
