//
//  ContentView.swift
//  DivingNews
//
//  Created by 中道徹 on 2023/04/27.
//

import SwiftUI
import CoreData
import SwiftSoup

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Article.date, ascending: false)],
        animation: .default)
    private var articles: FetchedResults<Article>
    private var filteredArticles: [Article] {
        var filtered: [Article] = []
        var titles: Set<String> = []
        
        for article in articles {
            if let title = article.title, !titles.contains(title) {
                filtered.append(article)
                titles.insert(title)
            }
        }
        return filtered
    }
    var body: some View {
        ZStack{
            Color.clear
              .edgesIgnoringSafeArea(.all)
              .background(LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.cyan]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ))
            NavigationView {
                List {
                    ForEach(filteredArticles) { article in
                        NavigationLink(
                            destination: ArticleDetailView(site: article.link!),
                            label: {
                                HStack{
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.blue)
                                    Text("\(article.title!)")
                                }
                            }
                        )
                    }
                }
                .refreshable {
                    MarinDiveLinks(context: viewContext)
                    PADILinks1(context: viewContext)
                    PADILinks2(context: viewContext)
                }
                .navigationBarTitle("記事リスト")
                
            }
            .frame(width: 400, height: 800, alignment: .center)

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


