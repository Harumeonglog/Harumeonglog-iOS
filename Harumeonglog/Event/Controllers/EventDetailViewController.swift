//
//  EventDetailViewController.swift
//  Harumeonglog
//
//  Created by Dana Lim on 6/14/25.
//

import UIKit
import Alamofire
import SnapKit

class EventDetailViewController: UIViewController {

    var event: EventDetailResult?  // 단일 일정 정보 모델
    
    private let addEventView = AddEventView()
    
    init(event: EventDetailResult) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bg
        setupLayout()
        configureData()
        print("EventDetailViewController - viewDidLoad 호출됨")
    }

    private func setupLayout() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(addEventView)
        addEventView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        addEventView.isEditable = false

        let navi = addEventView.navigationBar
        navi.configureTitle(title: "일정 상세")
        navi.configureRightButton(text: "수정")
        navi.rightButton.setTitleColor(.blue01, for: .normal)
        navi.rightButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 17)
        navi.leftArrowButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        navi.rightButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    private func configureData() {
        print(" configureData() 호출됨")
        
        guard let event = event else {
            print("❌ event가 nil입니다")
            return }
        
        addEventView.titleTextField.text = event.title
        addEventView.dateButton.setTitle(event.date, for: .normal)
        addEventView.timeButton.setTitle(event.time, for: .normal)
        addEventView.categoryButton.setTitle(event.category, for: .normal)
        addEventView.categoryButton.setTitleColor(.gray00, for: .normal)
        
        // 반복 요일 표시
        let weekdayMap: [String: String] = [
            "MON": "월", "TUE": "화", "WED": "수",
            "THU": "목", "FRI": "금", "SAT": "토", "SUN": "일"
        ]

        print("반복 요일 매핑 시작됨: \(event.repeatDays)")

        event.repeatDays.forEach { code in
            if let koreanDay = weekdayMap[code] {
                for button in addEventView.weekButtons {
                    let buttonTitle = button.titleLabel?.text ?? "nil"
                    print(" 현재 버튼 타이틀: \(buttonTitle), 매핑된 요일: \(koreanDay)")
                    if buttonTitle == koreanDay {
                        print("\(koreanDay) 버튼 색상 변경됨")
                        button.backgroundColor = .brown01
                        button.setTitleColor(.white, for: .normal)
                    }
                }
            } else {
                print("매핑되지 않은 요일 코드: \(code)")
            }
        }

        print("기본 정보와 반복 요일 세팅 완료됨")

        if let categoryType = CategoryType.fromServerValue(event.category) {
            print("CategoryType 변환 성공: \(categoryType)")
            addEventView.updateCategoryInputView(for: categoryType)
            print(" updateCategoryInputView 호출됨: \(categoryType)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let inputView = self.addEventView.categoryInputView {
                    print("categoryInputView 생성됨 및 추가됨: \(categoryType)")
                    inputView.isHidden = false
                    self.addEventView.setNeedsLayout()
                    self.addEventView.layoutIfNeeded()
                } else {
                    print("categoryInputView가 nil임: \(categoryType)")
                }
            }
        } else {
            print("CategoryType 변환 실패: \(event.category)")
        }

        switch event.category {
        case "HOSPITAL":
            if let view = addEventView.categoryInputView as? CheckupView {
                view.hospitalTextField.text = event.hospitalName
                view.departmentTextField.text = event.department
                view.costTextField.text = "\(event.cost ?? 0)"
            }
        case "MEDICINE":
            if let view = addEventView.categoryInputView as? MedicineView {
                view.medicineNameTextField.text = event.medicineName
            }
        case "WALK":
            if let view = addEventView.categoryInputView as? WalkView {
                view.distanceTextField.text = event.distance
                view.timeTextField.text = event.duration
            }
        case "BATH":
            if let view = addEventView.categoryInputView as? BathView {
                view.detailTextView.text = event.details
            }
        case "OTHER":
            if let view = addEventView.categoryInputView as? OtherView {
                view.detailTextView.text = event.details
            }
        default:
            break
        }
    }

    @objc private func editButtonTapped() {
        guard let event = event else { return }
        let editVC = EditEventViewController(event: event)
        navigationController?.pushViewController(editVC, animated: true)
    }
}
