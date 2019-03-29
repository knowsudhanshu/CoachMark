//
//  CoachMarkView.swift
//  CoachMark
//
//  Created by Sudhanshu Sudhanshu on 27/03/19.
//  Copyright © 2019 Sudhanshu Sudhanshu. All rights reserved.
//

import UIKit

class CoachMarkContainerView: UIView {
    weak var dataSource: CoachMarkDataSource?
    weak var delegate: CoachMarkDelegate?
    
    
    var currentCoachMarkView: CoachMarkView?
    var currentCoachMark: CoachMark? {
        return coachMarks?[currentIndex]
        //        return dataSource?.coachMark(at: currentIndex)
    }
    
    var currentIndex: Int = -1
    
    var coachMarks: [CoachMark]?
    
    var numberOfItems: Int {
        return coachMarks?.count ?? 0
        //        return dataSource?.numberOfCoachMarks() ?? 0
    }
    
    convenience init(coachMarks: [CoachMark]) {
        self.init(frame: UIScreen.main.bounds)
        self.coachMarks = coachMarks
        showNextCoachMarkView()
    }
    
    private func showNextCoachMarkView() {
        
        currentIndex += 1
        
        if currentIndex < numberOfItems {
            currentCoachMarkView?.removeFromSuperview()
            if let currentCoachMark = currentCoachMark {
                currentCoachMarkView = CoachMarkView(coachMark: currentCoachMark, orientation: .up)
                currentCoachMarkView?.tapActionHandler = {
                    self.showNextCoachMarkView()
                }
                addSubview(currentCoachMarkView!)
            }
        }else {
            removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum CoachMarkOrientation {
    case up, down, left, right
}

protocol CoachMarkDelegate: NSObjectProtocol {
    func coachMarkActionPerformed()
}

protocol CoachMarkDataSource: NSObjectProtocol {
    func numberOfCoachMarks() -> Int
    func coachMark(at index: Int) -> CoachMark
}

struct CoachMark {
    var message: String
    var sourceRect: CGRect
}

extension UIColor {
    static let HIGHLIGHT_BORDER_COLOR: UIColor = #colorLiteral(red: 0.8823529412, green: 0.3215686275, blue: 0.1176470588, alpha: 1) //UIColor(hex: 0xE1521E)
}

let INSET_MARGIN: CGFloat = 16

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
        label.numberOfLines = 0
        return label
    }()
    
    let gotItButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("GOT IT", for: .normal)
        button.setTitleColor(.HIGHLIGHT_BORDER_COLOR, for: .normal)
        return button
    }()
    
    var tapActionHandler: (() -> ())?
    
    var coachMark: CoachMark!
    
    convenience init(coachMark: CoachMark, orientation: CoachMarkOrientation) {
        self.init(frame: UIScreen.main.bounds)
        self.coachMark = coachMark
        
        let sourceRect = coachMark.sourceRect
        let cornerRadius = min(20, sourceRect.height / 2)
        let offset: CGFloat = 8
        let rectWithOffset = CGRect(x: sourceRect.origin.x - offset, y: sourceRect.origin.y - offset, width: sourceRect.width + (2*offset), height: sourceRect.height + (2*offset))
        
        setupHighlightLayer(rectWithOffset, cornerRadius)
        
        setupMessageContainerView()
        
        setupPointerImageView(sourceRect, rectWithOffset)
        
        setupMessageLabel()
        
        setupGotItButton()
        
    }

    fileprivate func setupGotItButton() {
        messageContainerView.addSubview(gotItButton)
        gotItButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gotItButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: INSET_MARGIN/4),
            gotItButton.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -INSET_MARGIN),
            gotItButton.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -INSET_MARGIN/2),
            gotItButton.heightAnchor.constraint(equalToConstant: 40),
            gotItButton.widthAnchor.constraint(equalToConstant: 80)]
        )
        
        gotItButton.addTarget(self, action: #selector(gotItAction), for: .touchUpInside)
    }
    
    fileprivate func setupMessageLabel() {
        messageContainerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.vertical)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: INSET_MARGIN),
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: INSET_MARGIN),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -INSET_MARGIN)]
        )
        
        messageLabel.text = coachMark.message
    }
    
    fileprivate func setupPointerImageView(_ sourceRect: CGRect, _ rectWithOffset: CGRect) {
        self.addSubview(pointerImageView)
        pointerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pointerImageView, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: sourceRect.origin.y + sourceRect.height).isActive = true
        NSLayoutConstraint.activate([
            pointerImageView.bottomAnchor.constraint(equalTo: messageContainerView.topAnchor),
            pointerImageView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -(self.frame.width - rectWithOffset.origin.x - rectWithOffset.width)),
            pointerImageView.heightAnchor.constraint(equalToConstant: 26),
            pointerImageView.widthAnchor.constraint(equalToConstant: 26)
            ])
    }
    
    fileprivate func setupMessageContainerView() {
        addSubview(messageContainerView)
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ])
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
    
    // Mark: - Actions
    @objc private func gotItAction() {
        tapActionHandler?()
    }
}
