//
//  SearchViewModel.swift
//  MVVM
//
//  Created by 安井陸 on 2019/06/16.
//  Copyright © 2019 安井陸. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    private let disposeBag = DisposeBag()
    var resultArray: Observable<[Article]>
    var error: Observable<Error>
    var url: URL?
    
    init(searchText: Observable<String>) {
        let searchResult = searchText
            .distinctUntilChanged()
            //.debounce(0.5, scheduler: ConcurrentMainScheduler.instance)
            .flatMap {
                return SearchModel.getArticle($0).materialize()
            }
            .share()
        
        resultArray = searchResult
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .map { data in
                return data ?? []
        }
        
        error = searchResult
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
    }
    
}
