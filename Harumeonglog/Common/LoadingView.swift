//
//  LoadingView.swift
//  Harumeonglog
//
//  Created by 김민지 on 9/14/25.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    
    private let indicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.4)

        addSubview(indicator)
        indicator.center = center
        indicator.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    func showLoadingView() {
        let loadingView = LoadingView(frame: view.bounds)
        loadingView.tag = 999 
        view.addSubview(loadingView)
    }

    func hideLoadingView() {
        view.viewWithTag(999)?.removeFromSuperview()
    }
}
