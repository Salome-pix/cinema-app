//
//  SearchViewController.swift
//  VuduTV
//
//  Created by Mcbook Pro on 10.09.22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles = [Title]()
    
    
    //MARK: - Search Table

    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    //MARK: - Search Contoller
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    
    //MARK: -  VC LF methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
        fetchDiscoverMovies()

    }
    
    //MARK: - Private func
    
    private func setupView(){
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        view.addSubview(discoverTable)
        discoverTable.frame = view.bounds
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
        searchController.searchResultsUpdater = self

    }
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
                
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error ):
                print(error.localizedDescription)
            }
        }
    }
    
   
}

extension  SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown name", posterURL: title.poster_path ?? "")
        
        cell.configure(with: model)
        
        return cell
    }
    
   
}
extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        //MARK: - crearing query passing to API
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
              }
        resultsController.delegate = self

        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    

    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

