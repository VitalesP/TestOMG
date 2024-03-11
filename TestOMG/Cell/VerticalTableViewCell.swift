//
//  VerticalTableViewCell.swift
//  TestOMG
//
//  Created by Vital on 3/11/24.
//

import UIKit

class VerticalTableViewCell: UITableViewCell {
    var collectionView: UICollectionView!
    var updaterDelegate: CollectionViewCellUpdater?
    private var cellNumbers: [Int] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
        setupCollectionViewData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRandomCell() {
            updaterDelegate?.updateRandomCellInCollectionView()
        }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalCell")
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func updateRandomVisibleCell() {
        let visibleItems = self.collectionView.indexPathsForVisibleItems
        if visibleItems.isEmpty { return }
        // Выбираем случайный IndexPath из видимых ячеек коллекции
        let randomIndexPath = visibleItems.randomElement()!
        // Обновляем число для выбранного индекса
        cellNumbers[randomIndexPath.row] = Int.random(in: 1...100)
        self.collectionView.reloadItems(at: [randomIndexPath])
    }
    
    func setupCollectionViewData() {
        // горизонтальный список на рандомное количество элементов (больше 10)
        let randomeNumber = Int.random(in: 11...50)
        cellNumbers = (0...randomeNumber).map { _ in Int.random(in: 1...100) }
        collectionView.reloadData()
    }
    
    
}

extension VerticalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! HorizontalCollectionViewCell
        let number = cellNumbers[indexPath.row]
        cell.configure(with: number)
        return cell
    }
}

extension VerticalTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = collectionView.frame.height - 20
        return CGSize(width: sideLength, height: sideLength)
    }
}
