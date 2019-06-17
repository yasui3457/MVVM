//
//  SearchModel.swift
//  MVC
//
//  Created by 安井陸 on 2019/06/16.
//  Copyright © 2019 安井陸. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Article {
    var title: String
    var body: String
    var url: String
    
    init() {
        self.title = ""
        self.body = ""
        self.url = ""
    }
}

class SearchModel {
    
    //QiitaのAPI
    private static let QIITA_API = "https://qiita.com/api/v2/items?page=1"
    
    enum SearchError: Error {
        case parseError
        case apiError(Int)
        
        var localizedDescription: String {
            switch self {
            case .parseError:
                return "Parse Error"
            case .apiError(let errorCode):
                return "API Error: \(errorCode)"
            }
        }
    }
    
    public static func getArticle(_ text: String) -> Observable<[Article]?> {
        guard !text.isEmpty else { return Observable.just(nil)}
        let query = "&query=tag%3A" + text
        let url: URL = URL(string: SearchModel.QIITA_API + query)!
        return URLSession.shared.rx.response(request: URLRequest(url: url))
            .retry(3)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .flatMap { pair -> Observable<[Article]?> in
                print(pair)
                if pair.0.statusCode == 403 {
                    return Observable.error(SearchError.apiError(pair.0.statusCode))
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: pair.1, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                    var parseList: [Article] = []
                    let datas: [[String: Any]] = json.map { (article) -> [String: Any] in
                        return article as! [String: Any]
                    }
                    for i in 0..<datas.count {
                        let data = datas[i]
                        var article: Article = Article()
                        article.title = data["title"] as? String ?? ""
                        article.body = data["body"] as? String ?? ""
                        article.url = data["url"] as? String ?? ""
                        parseList.append(article)
                    }
                    return Observable.just(parseList)
                }
                catch {
                    return Observable.error(SearchError.parseError)
                }
            }
    }

}
