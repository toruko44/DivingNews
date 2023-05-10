//
//  func.swift
//  DivingNews
//
//  Created by 中道徹 on 2023/04/30.
//

import Foundation
import SwiftSoup
import CoreData
import SwiftUI
import WebKit






func MarinDiveLinks(context: NSManagedObjectContext) {
    for i in 2...13 {
        let urlString = "https://marinediving.com/topicscat/type" + String(i)

        if let url = URL(string: urlString) {
            loadHTMLFromURL(url: url) { result in
                switch result {
                case .success(let html):
                    do {
                        let doc = try SwiftSoup.parse(html)
                        let elements = try doc.select("div.infoBox")
                        for element in elements {
                            let newArticle = Article(context: context)
                            newArticle.id = UUID()
                            let newdate = try element.select("span.date")
                            let date = try newdate.text()
                            newArticle.date = setDate(dateString: date)
                            let data = try element.select("p.infoTitle")
                            let info = try data.select("a")
                            newArticle.link = try info.attr("href")
                            newArticle.title = try info.text()
                            do {
                                try context.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}


func PADILinks1(context: NSManagedObjectContext) {
    for i in 1...7 {
        let urlString = "https://marinediving.com/topicscat/type" + String(i)

        if let url = URL(string: urlString) {
            loadHTMLFromURL(url: url) { result in
                switch result {
                case .success(let html):
                    do {
                        let doc = try SwiftSoup.parse(html)
                        let elements = try doc.select("div.hidden-xs")
                        for element in elements {
                            let newArticle = Article(context: context)
                            newArticle.id = UUID()
                            let  newdate = try element.select("span.gray")
                            let  date = try newdate.text()
                            newArticle.date = setDate(dateString: date)
                            let data = try element.select("div.mt5")
                            let info = try data.select("a")
                            newArticle.link = try info.attr("href")
                            newArticle.title = try info.text()
                            do {
                                try context.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}

func PADILinks2(context: NSManagedObjectContext) {
    for i in 1...7 {
        let urlString = "https://marinediving.com/topicscat/type" + String(i)

        if let url = URL(string: urlString) {
            loadHTMLFromURL(url: url) { result in
                switch result {
                case .success(let html):
                    do {
                        let doc = try SwiftSoup.parse(html)
                        let elements = try doc.select("div.visible-xs")
                        for element in elements {
                            let newArticle = Article(context: context)
                            newArticle.id = UUID()
                            let  newdate = try element.select("span.gray")
                            let  date = try newdate.text()
                            newArticle.date = setDate(dateString: date)
                            let info = try element.select("a")
                            newArticle.link = try info.attr("href")
                            let title = try element.select("span.b")
                            newArticle.title = try title.text()
                            do {
                                try context.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}


func setDate(dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd" // 日付のフォーマット

    if let date = dateFormatter.date(from: dateString) {
        return date
    } else {
        print("Invalid date format")
        return Date()
    }
}

struct ArticleWebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            // プリロードのためにWebページを非同期で読み込む
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // エラーハンドリング
                if let error = error {
                    print("Error loading web page: \(error.localizedDescription)")
                    return
                }
                
                // ページが正常に読み込まれた場合に表示する
                DispatchQueue.main.async {
                    uiView.load(request)
                }
            }
            
            task.resume()
        }
    }
}

struct ArticleDetailView: View {
    let site: String
    
    var body: some View {
        ArticleWebView(urlString: site)
    }
}

func loadHTMLFromURL(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        if let data = data, let html = String(data: data, encoding: .utf8) {
            completion(.success(html))
        } else {
            let unknownError = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(unknownError))
        }
    }
    task.resume()
}


