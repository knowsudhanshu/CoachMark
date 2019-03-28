//
//  CoachMarkView.swift
//  CoachMark
//
//  Created by Sudhanshu Sudhanshu on 27/03/19.
//  Copyright © 2019 Sudhanshu Sudhanshu. All rights reserved.
//

import UIKit

enum CoachMarkOrientation {
    case up, down, left, right
}

protocol CoachMarkDelegate {
    // Button tap etc
}

protocol CoachMarkDataSource {
    func numberOfCoachMarks() -> Int
}

struct CoachMark {
    var message: String
}

class CoachMarkView: UIView {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "Tap this button for action."
        return label
    }()
    
    let gotItButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Got it!", for: .normal)
        
        button.backgroundColor = .red
        return button
    }()
    
    convenience init(sourceRect: CGRect, orientation: CoachMarkOrientation = .up, coachMark: CoachMark) {
        self.init(frame: UIScreen.main.bounds)
        
        let cornerRadius = min(20, sourceRect.height / 2)
        let offset: CGFloat = 8
        let rectWithOffset = CGRect(x: sourceRect.origin.x - offset, y: sourceRect.origin.y - offset, width: sourceRect.width + (2*offset), height: sourceRect.height + (2*offset))
        
        setupHighlightLayer(rectWithOffset, cornerRadius)

        addSubview(gotItButton)
        gotItButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gotItButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gotItButton.heightAnchor.constraint(equalToConstant: 80),
            gotItButton.widthAnchor.constraint(equalToConstant: 80)]
        )
        
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: messageLabel, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: rectWithOffset.origin.y + rectWithOffset.height).isActive = true
        
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: gotItButton.leadingAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 80)]
            )
        
        
        gotItButton.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor, constant: 0).isActive = true
    }

    
    // MARK: - BezierPath
    fileprivate func setupHighlightLayer(_ rectWithOffset: CGRect, _ cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0)
        let highlightingPath = UIBezierPath(roundedRect: rectWithOffset, cornerRadius: cornerRadius)
        highlightingPath.lineWidth = 1
        path.append(highlightingPath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.init(white: 0, alpha: 0.3).cgColor
        
        let higlightingBorderLayer = CAShapeLayer()
        higlightingBorderLayer.path = highlightingPath.cgPath
        higlightingBorderLayer.fillColor = UIColor.clear.cgColor
        higlightingBorderLayer.strokeColor = UIColor.orange.cgColor
        higlightingBorderLayer.lineWidth = 4
        higlightingBorderLayer.frame = CGRect(x: 0, y: 0, width: rectWithOffset.width, height: rectWithOffset.height)
        
        fillLayer.addSublayer(higlightingBorderLayer)
        
        self.layer.addSublayer(fillLayer)
    }
    // MARK: -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
