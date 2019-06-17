//
//  SearchViewController.swift
//  FatViewController
//
//  Created by 安井陸 on 2019/06/15.
//  Copyright © 2019 安井陸. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultView: UICollectionView! {
        didSet {
            searchResultView.register(UINib(nibName: "SearchResultViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultViewCell")
        }
    }
    
    lazy var viewModel: SearchViewModel = {
        return SearchViewModel(searchText: searchBar.rx.text.orEmpty.asObservable())
    }()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    func bindViewModel() {
        searchResultView.rx.modelSelected(Article.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] article in
                self!.viewModel.url =  URL(string: article.url)
                self!.moveToBrowserViewController()
            }).disposed(by: disposeBag)
        viewModel.resultArray
            .bind(to: searchResultView.rx.items(cellIdentifier: "SearchResultViewCell", cellType: SearchResultViewCell.self)) { [weak self] _, element, cell in
            cell.result = element
            }.disposed(by: disposeBag)
    }
    
    func moveToBrowserViewController() {
        performSegue(withIdentifier: "ToBrowser", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToBrowser" {
            guard let bvc:BrowserViewController = segue.destination as? BrowserViewController else { return }
            bvc.url = viewModel.url
        }
    }
}


