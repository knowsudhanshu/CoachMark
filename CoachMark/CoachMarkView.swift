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

extension UIColor {
    static let APP_THEME_ORANGE_COLOR: UIColor = #colorLiteral(red: 0.8823529412, green: 0.3215686275, blue: 0.1176470588, alpha: 1) //UIColor(hex: 0xE1521E)
}

class CoachMarkView: UIView {
    
    let pointerImageView: UIView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "pointer")
        return imageView
    }()
    
    let messageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap this button for action. And see the magic happening."
        label.numberOfLines = 0
        return label
    }()
    
    let gotItButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Got it!", for: .normal)
        button.setTitleColor(.APP_THEME_ORANGE_COLOR, for: .normal)
        return button
    }()
    
    convenience init(sourceRect: CGRect, orientation: CoachMarkOrientation = .up, coachMark: CoachMark) {
        self.init(frame: UIScreen.main.bounds)
        
        let cornerRadius = min(20, sourceRect.height / 2)
        let offset: CGFloat = 8
        let rectWithOffset = CGRect(x: sourceRect.origin.x - offset, y: sourceRect.origin.y - offset, width: sourceRect.width + (2*offset), height: sourceRect.height + (2*offset))
        
        setupHighlightLayer(rectWithOffset, cornerRadius)

        
        addSubview(messageContainerView)
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ])
        
        self.addSubview(pointerImageView)
        pointerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pointerImageView, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: sourceRect.origin.y + sourceRect.height).isActive = true
        NSLayoutConstraint.activate([
            pointerImageView.bottomAnchor.constraint(equalTo: messageContainerView.topAnchor),
            pointerImageView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -(self.frame.width - rectWithOffset.origin.x - rectWithOffset.width)),
            pointerImageView.heightAnchor.constraint(equalToConstant: 26),
            pointerImageView.widthAnchor.constraint(equalToConstant: 26)
            ])
        
        
        messageContainerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.vertical)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -16)]
            )
        
        messageContainerView.addSubview(gotItButton)
        gotItButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gotItButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            gotItButton.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -16),
            gotItButton.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -16),
            gotItButton.heightAnchor.constraint(equalToConstant: 40),
            gotItButton.widthAnchor.constraint(equalToConstant: 80)]
        )

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
        higlightingBorderLayer.strokeColor = UIColor.APP_THEME_ORANGE_COLOR.cgColor
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
