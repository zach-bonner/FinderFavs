//
//  StatusBarFavoritesView.swift
//  FinderFavs
//
//  Created by Zachary Bonner on 3/29/25.
//

import SwiftUI

struct StatusBarFavoritesView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore

    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(favoritesStore.favorites) { item in
                    HStack(spacing: 8) {
                        let icon = NSWorkspace.shared.icon(forFile: item.url.path)
                        Image(nsImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .cornerRadius(4)
                        Button(action: {
                            NSWorkspace.shared.open(item.url)
                        }) {
                            Text(item.url.lastPathComponent)
                                .lineLimit(1)
                        }
                        Spacer()
                        Button(action: {
                            favoritesStore.removeFavorite(item: item)
                        }) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: favoritesStore.removeFavorites)
            }
            .listStyle(PlainListStyle())
        }
        .frame(width: 300, height: 400)
    }
}

struct StatusBarFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarFavoritesView()
            .environmentObject(FavoritesStore.shared)
    }
}
