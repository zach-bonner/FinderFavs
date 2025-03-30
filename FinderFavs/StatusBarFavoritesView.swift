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
            Text("Favorites")
                .font(.headline)
                .padding([.top, .horizontal])
            Divider()
            List {
                ForEach(favoritesStore.favorites) { item in
                    HStack {
                        let icon = NSWorkspace.shared.icon(forFile: item.url.path)
                        Image(nsImage: icon)
                            .resizable()
                            .frame(width: 24, height: 24)
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
