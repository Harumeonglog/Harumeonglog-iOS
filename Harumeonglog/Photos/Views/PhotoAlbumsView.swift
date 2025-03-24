//
//  PhotoAlbumsView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/17/25.
//
import UIKit
import SnapKit

class PhotoAlbumsView: UIView {
    
    var albums: [Album] = [] 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bg
        addComponents()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var albumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    private func addComponents(){
        self.addSubview(albumCollectionView)
        
        albumCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(142)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    private func setupCollectionView() {
        // Set up layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 362, height: 90)
        layout.minimumLineSpacing = 13
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        albumCollectionView.collectionViewLayout = layout
        
        albumCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.showsVerticalScrollIndicator = false
    }
}

extension PhotoAlbumsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let album = albums[indexPath.row]
        cell.configure(with: album)
        return cell
    }
}
