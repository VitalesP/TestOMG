//
//  ViewController.swift
//  TestOMG
//
//  Created by Vital on 3/11/24.
//

import UIKit

protocol CollectionViewCellUpdater {
    func updateRandomCellInCollectionView()
}

class ViewController: UIViewController {
    let tableView = UITableView()
    var updateTimer: Timer?
    private var cellNumbers: [Int] = []
    private var maxNumber = Int.random(in: 101...Int.max)
    var allDataLoaded = false
    let batchSize = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTimer()
        loadBatchSize()
    }
    
    func loadBatchSize() {
        DispatchQueue.global().async {
            let moreData = (1...self.batchSize).map { _ in Int.random(in: 1...100) }
            DispatchQueue.main.async {
                self.cellNumbers.append(contentsOf: moreData)
                self.tableView.reloadData()
                self.maxNumber -= self.batchSize
                self.allDataLoaded = self.maxNumber < self.batchSize
            }
        }
    }
    
    func setupTimer() {
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRandomCellInVisibleTableViewRows), userInfo: nil, repeats: true)
    }
    
    @objc func updateRandomCellInVisibleTableViewRows() {
        guard let visibleRows = tableView.indexPathsForVisibleRows, !visibleRows.isEmpty else { return }
        let randomIndexPath = visibleRows.randomElement()!
        if let cell = tableView.cellForRow(at: randomIndexPath) as? VerticalTableViewCell {
            cell.updateRandomCell()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VerticalTableViewCell.self, forCellReuseIdentifier: "VerticalCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VerticalCell", for: indexPath) as! VerticalTableViewCell
        cell.setupCollectionView()
        cell.updaterDelegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight * 2 && !allDataLoaded {
            loadBatchSize()
        }
    }
}

extension ViewController: CollectionViewCellUpdater {
    func updateRandomCellInCollectionView() {
        // Получаем индексы всех видимых ячеек UITableView
        guard let visibleRows = tableView.indexPathsForVisibleRows, !visibleRows.isEmpty else { return }

        // Выбираем случайный IndexPath из видимых ячеек таблицы
        let randomIndexPath = visibleRows.randomElement()!

        // Получаем случайную видимую ячейку таблицы по IndexPath
        if let verticalCell = tableView.cellForRow(at: randomIndexPath) as? VerticalTableViewCell {
            // В verticalCell должен быть метод для обновления случайной ячейки в его UICollectionView
            verticalCell.updateRandomVisibleCell()
        }
    }
}
