//
//  HorizontalCollectionViewCell.swift
//  TestOMG
//
//  Created by Vital on 3/11/24.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    var numberLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNumberLabel()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNumberLabel() {
        numberLabel = UILabel()
        contentView.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setupGesture() {
        // распознаватель долгого нажатия
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressRecognizer.minimumPressDuration = 0.2 // если 0 то скрол не работает при тапе на ячейку
        contentView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began: // уменьшаем view
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        case .ended, .cancelled: // возвращаем к исходному размеру
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        default:
            break
        }
    }
    
    func configure(with number: Int) {
        let borderColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor.white
                default:
                    return UIColor.black
                }
            }
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        
        numberLabel.text = "\(number)"
        
    }
}
