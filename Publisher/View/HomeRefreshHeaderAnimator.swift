//
//  HomeRefreshHeaderAnimator.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import Foundation
import ESPullToRefresh
import QuartzCore
import UIKit

open class HomeRefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol, ESRefreshImpactProtocol {
    open var pullToRefreshDescription = NSLocalizedString("Pull down to refresh", comment: "") {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription;
            }
        }
    }
    open var releaseToRefreshDescription = NSLocalizedString("Release to refresh", comment: "")
    open var loadingDescription = NSLocalizedString("Loading...", comment: "")
    open var lastUpdateDescription = NSLocalizedString("Last Updated:", comment: "")


    open var view: UIView { return self }
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 60.0
    open var executeIncremental: CGFloat = 60.0
    open var state: ESRefreshViewState = .pullToRefresh

    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView.init()
        let frameworkBundle = Bundle(for: ESRefreshAnimator.self)
        if /* CocoaPods static */ let path = frameworkBundle.path(forResource: "ESPullToRefresh", ofType: "bundle"),let bundle = Bundle(path: path) {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        }else if /* Carthage */ let bundle = Bundle.init(identifier: "com.eggswift.ESPullToRefresh") {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        } else if /* CocoaPods */ let bundle = Bundle.init(identifier: "org.cocoapods.ESPullToRefresh") {
            imageView.image = UIImage(named: "ESPullToRefresh.bundle/icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        } else /* Manual */ {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow")
        }
        return imageView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 12)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let dateLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 12)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.text = "Last Updated: " + getCurrentTime()
        return label
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .medium)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(indicatorView)
        self.addSubview(dateLabel)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshAnimationBegin(view: ESRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        imageView.isHidden = true
        titleLabel.text = loadingDescription
        imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
        
    }
  
    open func refreshAnimationEnd(view: ESRefreshComponent) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        imageView.isHidden = false
        titleLabel.text = pullToRefreshDescription
        imageView.transform = CGAffineTransform.identity
        
        if #available(iOS 13.0, *) {
            let nowString = getCurrentTime()
            dateLabel.text = "Last Updated: " + nowString
        } else {
            let dateString = getCurrentTime()
            dateLabel.text = "Last Updated: " + dateString
        }
    }
        
    open func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // Do nothing
        
    }
    
    open func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing:
            titleLabel.text = loadingDescription
            self.setNeedsLayout()
            break
        case .releaseToRefresh:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
            self.impact()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
            }) { (animated) in }
            break
        case .pullToRefresh:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform.identity
            }) { (animated) in }
            break
        default:
            break
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        
        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            dateLabel.sizeToFit()
            dateLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0 + 20)
            indicatorView.center = CGPoint.init(x: titleLabel.frame.origin.x - 16.0, y: h / 2.0)
            imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - 28.0, y: (h - 18.0) / 2.0, width: 18.0, height: 18.0)
        }
    }
    
}

func getCurrentTime() -> String {
    let now = Date()

    if #available(iOS 13.0, *) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: now)

    } else {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "EEEE HH:mm"
        return formatter.string(from: now)
    }
}
