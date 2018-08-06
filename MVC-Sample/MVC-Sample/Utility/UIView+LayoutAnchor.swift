//
//  UIView+LayoutAnchor.swift
//  MVC-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

extension UIView {
    
    func constraint(with identifier:String) -> NSLayoutConstraint? {
        return self.constraints.filter{ $0.identifier == identifier }.first
    }
    
    func allDirectionsAnchor(to view: UIView) {
        self.topAnchor(to: view.topAnchor)
            .leadingAnchor(to: view.leadingAnchor)
            .bottomAnchor(to: view.bottomAnchor)
            .trailingAnchor(to: view.trailingAnchor)
            .activateAnchors()
    }
    
    func allDirectionsAnchorContentsView(to view: UIView, isVerticalScroll: Bool = true) {
        _ = self.topAnchor(to: view.topAnchor)
            .leadingAnchor(to: view.leadingAnchor)
            .trailingAnchor(to: view.trailingAnchor)
            .bottomAnchor(to: view.bottomAnchor)
        
        if isVerticalScroll {
            _ = self.equalWidthAnchor(to: view.widthAnchor)
                .equalHeightAnchorContentsView(to: view.heightAnchor)
        } else {
            _ = self.equalWidthAnchorContentsView(to: view.widthAnchor)
                .equalHeightAnchor(to: view.heightAnchor)
        }
        self.activateAnchors()
    }
    
    func topAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func leadingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, identifier: String? = nil) -> Self {
        let constraint = leadingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        constraint.isActive = true
        return self
    }
    
    func bottomAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func trailingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func equalWidthAnchor(to anchor: NSLayoutDimension, ratio: CGFloat? = nil) -> Self {
        if let ratio = ratio  {
            widthAnchor.constraint(equalTo: anchor, multiplier: ratio).isActive = true
        } else {
            widthAnchor.constraint(equalTo: anchor, constant: 0).isActive = true
        }
        return self
    }
    
    func equalHeightAnchor(to anchor: NSLayoutDimension, ratio: CGFloat? = nil) -> Self {
        if let ratio = ratio  {
            heightAnchor.constraint(equalTo: anchor, multiplier: ratio).isActive = true
        } else {
            heightAnchor.constraint(equalTo: anchor, constant: 0).isActive = true
        }
        return self
    }
    
    func equalDimensionAnchor() -> Self {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0).isActive = true
        return self
    }
    
    func equalWidthAnchorContentsView(to anchor: NSLayoutDimension) -> Self {
        let anchor = widthAnchor.constraint(equalTo: anchor, constant: 0)
        anchor.priority = UILayoutPriority(1)
        anchor.isActive = true
        return self
    }
    
    func equalHeightAnchorContentsView(to anchor: NSLayoutDimension) -> Self {
        let anchor = heightAnchor.constraint(equalTo: anchor, constant: 0)
        anchor.priority = UILayoutPriority(1)
        anchor.isActive = true
        return self
    }
    
    func widthAnchor(constant: CGFloat, relation: NSLayoutRelation = .equal) -> Self {
        let _anchor: NSLayoutConstraint
        switch relation {
        case .equal:
            _anchor = widthAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            _anchor = widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqual:
            _anchor = widthAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        _anchor.isActive = true
        return self
    }
    
    func heightAnchor(constant: CGFloat, relation: NSLayoutRelation = .equal) -> Self {
        let _anchor: NSLayoutConstraint
        switch relation {
        case .equal:
            _anchor = heightAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            _anchor = heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqual:
            _anchor = heightAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        _anchor.isActive = true
        return self
    }
    
    func dimensionAnchors(width widthConstant: CGFloat, height heightConstant: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        return self
    }
    
    func dimensionAnchors(size: CGSize) -> Self {
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self
    }
    
    func centerYAnchor(to anchor: NSLayoutYAxisAnchor) -> Self {
        centerYAnchor.constraint(equalTo: anchor).isActive = true
        return self
    }
    
    func centerXAnchor(to anchor: NSLayoutXAxisAnchor) -> Self {
        centerXAnchor.constraint(equalTo: anchor).isActive = true
        return self
    }
    
    func activateAnchors() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
