//
//  UpcomingViewController.swift
//  VuduTV
//
//  Created by Mcbook Pro on 08.09.22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    
    
    var titles: [Title] =  [Title]()
    
 //MARK: - View
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        return table
    }()
    
    //MARK: - vc lifesycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

    //MARK: - private methods
     
    private func fetchUpcoming(){
        APICaller.shared.getUpcommingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                
                DispatchQueue.main.async {
                    self?.titles = titles
                    self?.upcomingTable.reloadData()
                }
            case .failure(let errors):
                print(errors.localizedDescription)
            }
        }
    }

    //MARK: - setup View
    
    private func setupView() {
        upcomingTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        view.backgroundColor = .systemGray
        self.title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    
    }
    
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
             return UITableViewCell()
         }
         
         let title = titles[indexPath.row]
         cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
         return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}
    
    

