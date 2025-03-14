//
//  AddScheduleViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 3/13/25.
//

import UIKit

class AddScheduleViewController: UIViewController {

    private lazy var addScheduleView: AddScheduleView = {
        let view = AddScheduleView()
        view.delegate = self  // ✅ Delegate 설정
        return view
    }()

    private var categoryInputView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addScheduleView
    }
}

// Delegate 구현하여 선택된 카테고리에 따라 입력 필드 표시
extension AddScheduleViewController: AddScheduleViewDelegate {
    func categoryDidSelect(_ category: CategoryType) {
        updateCategoryInputView(for: category)
    }

    private func updateCategoryInputView(for category: CategoryType) {
        categoryInputView?.removeFromSuperview()
        
        switch category {
        case .bath:
            categoryInputView = BathView()
        case .walk:
            categoryInputView = WalkView()
        case .medicine:
            categoryInputView = MedicineView()
        case .checkup:
            categoryInputView = CheckupView()
        case .other:
            categoryInputView = nil
        }
        
        if let newView = categoryInputView {
            view.addSubview(newView)
            newView.snp.makeConstraints { make in
                make.top.equalTo(addScheduleView.categoryButton.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview()
            }
        }
        view.bringSubviewToFront(addScheduleView.dropdownTableView)
    }
}
