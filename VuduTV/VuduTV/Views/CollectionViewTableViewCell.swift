//
//  CollectionViewsTableViewCell.swift
//  VuduTV
//
//  Created by Mcbook Pro on 02.09.22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewsTableViewCell"
    
    var titles :[Title] = [Title]()
    
    let label = UILabel()
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - setupCell
    
    private func setupCell(){
        contentView.addSubview(self.collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
    }
    
    // MARK: - Methods
    
    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            
        }
    }
    
    // MARK: -persistence
    
    private func downloadTitleAt(indexPath: IndexPath ){
        
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Collection View Delegate, DataSource

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        guard let model = titles[indexPath.row].poster_path else {return UICollectionViewCell()}
        cell.configure(with: model)
        return cell
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    
    //MARK: - context view
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
    //MARK: - Youtube  view
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let videoElement):
                    
                    let title = self?.titles[indexPath.row]
                    guard let titleOverview = title?.overview else {
                        return
                    }
                    let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                    self?.delegate?.collectionViewTableViewCellDidTapCell( viewModel: viewModel)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}
