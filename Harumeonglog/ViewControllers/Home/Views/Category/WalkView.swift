//
//  WalkView.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/14/25.
//
import UIKit
import SnapKit

class WalkView: UIView {
    
    private let locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "산책 장소 입력"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let distanceSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["0-3 km", "3-5 km", "5 km 이상"])
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [locationTextField, distanceSegmentedControl])
        stackView.axis = .vertical
        stackView.spacing = 12
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
}
