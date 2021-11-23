//
//  UIView+Constraints.swift
//  KumuChallenge
//
//  Created by Jc on 11/22/21.
//

import UIKit

// MARK: - NSLayout

extension UIView {
    
    /// Adds a subview, automatically adding constraints for top, left, right and bottom with 0 constants.
    /// - Parameter view: *UIView* instance to be added.
    func addConstrainedSubview(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: Any] = ["view": view]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
        addConstraints(vertical)
        addConstraints(horizontal)
    }
}

protocol Constraint {}

// MARK: - Anchors

extension UIView {
    
    enum SizeConstraints: Constraint {
        case width(constant: CGFloat)
        case height(constant: CGFloat)
        case widthHeight(constant: CGFloat)
    }
    
    enum EdgeConstraints: Constraint {
        case top(constant: CGFloat)
        case bottom(constant: CGFloat)
        case left(constant: CGFloat)
        case right(constant: CGFloat)
        case leading(constant: CGFloat)
        case trailing(constant: CGFloat)
    }
    
    enum CenteringConstraints: Constraint {
        case centerX(constant: CGFloat)
        case centerY(constant: CGFloat)
        case centerXY(constant: CGFloat)
    }
    
    func addConstraint(to view: UIView? = nil, constraints: [Constraint]) {
        for const in constraints {
//            if const.conf {
//                
//            }
        }
    }
    
    func addSizeConstraints(to view: UIView? = nil, constraints: [SizeConstraints]) {
        for const in constraints {
            switch const {
            case .width(let constant):
                guard let _view = view else {
                    widthAnchor.constraint(equalToConstant: constant).isActive = true
                    return
                }
                widthAnchor.constraint(equalTo: _view.widthAnchor, constant: constant).isActive = true
            case .height(let constant):
                guard let _view = view else {
                    heightAnchor.constraint(equalToConstant: constant).isActive = true
                    return
                }
                heightAnchor.constraint(equalTo: _view.heightAnchor, constant: constant).isActive = true
            case .widthHeight(let constant):
                guard let _view = view else {
                    widthAnchor.constraint(equalToConstant: constant).isActive = true
                    heightAnchor.constraint(equalToConstant: constant).isActive = true
                    return
                }
                widthAnchor.constraint(equalTo: _view.widthAnchor, constant: constant).isActive = true
                heightAnchor.constraint(equalTo: _view.heightAnchor, constant: constant).isActive = true
            }
        }
    }
    
    /// Adds a subview, at the same time adding a constraint to any location defined in constraints.
    /// - Parameters:
    ///   - view: *UIView* instance to be added.
    ///   - constraints: Array of constraint edges to where the added subview should anchor.
    func addSubview(_ view: UIView, withEdges constraints: [EdgeConstraints]) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        for const in constraints {
            switch const {
            case .top(let constant):
                topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
            case .bottom(let constant):
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
            case .left(let constant):
                leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant).isActive = true
            case .right(let constant):
                rightAnchor.constraint(equalTo: view.rightAnchor, constant: constant).isActive = true
            case .leading(let constant):
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
            case .trailing(let constant):
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
            }
        }
    }
    
    func addSubview(_ view: UIView, withCenter constraints: [CenteringConstraints]) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        for const in constraints {
            switch const {
            case .centerX(let constant):
                view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: constant).isActive = true
            case .centerY(let constant):
                view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: constant).isActive = true
            case .centerXY(let constant):
                view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: constant).isActive = true
                view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: constant).isActive = true
            }
        }
    }
    
    func addVerticalSpacing(_ constraint: EdgeConstraints, to view: UIView, at anchor: NSLayoutYAxisAnchor) {
        addSpacing(constraint, to: view, atVertical: anchor)
    }
    
    func addHorizontalSpacing(_ constraint: EdgeConstraints, to view: UIView, at anchor: NSLayoutXAxisAnchor) {
        addSpacing(constraint, to: view, atHorizontal: anchor)
    }
    
    private func addSpacing(_ constraint: EdgeConstraints, to view: UIView, atVertical vertAnchor: NSLayoutYAxisAnchor? = nil, atHorizontal horzAnchor: NSLayoutXAxisAnchor? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        switch constraint {
        case .top(let constant):
            topAnchor.constraint(equalTo: vertAnchor ?? view.topAnchor, constant: constant).isActive = true
        case .bottom(let constant):
            bottomAnchor.constraint(equalTo: vertAnchor ?? view.bottomAnchor, constant: constant).isActive = true
        case .left(let constant):
            leftAnchor.constraint(equalTo: horzAnchor ?? view.leftAnchor, constant: constant).isActive = true
        case .right(let constant):
            rightAnchor.constraint(equalTo: horzAnchor ?? view.rightAnchor, constant: constant).isActive = true
        case .leading(let constant):
            leadingAnchor.constraint(equalTo: horzAnchor ?? view.leadingAnchor, constant: constant).isActive = true
        case .trailing(let constant):
            trailingAnchor.constraint(equalTo: horzAnchor ?? view.trailingAnchor, constant: constant).isActive = true
        }
    }
}

