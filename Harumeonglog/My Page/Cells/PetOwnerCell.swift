//
//  PetOwnerCell.swift
//  Harumeonglog
//
//  Created by 이승준 on 3/29/25.
//

import UIKit
import SnapKit
import Combine

protocol PetOwnerCellDelegate: AnyObject {
    func didTapInviteButton(petID: Int)
    func didTapExitButton(petID: Int)
    func didTapEditButton(pet: Pet)
    func didTapDeleteMemberButton()
}

class PetOwnerCell: UICollectionViewCell {
    private var pet: Pet?
    private var members: [PetMember] = []
    private var overlayView: UIView?
    private weak var delegate: PetOwnerCellDelegate?
    private weak var petListViewModel: PetListViewModel? // ViewModel 의존성 추가
    private var cancellables = Set<AnyCancellable>()
    private var tableViewHeightConstraint: Constraint?
    
    static let identifier = "PetOwnerCell"
    
    private lazy var profileImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray02
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.body
        $0.textColor = .black
    }
    
    private lazy var genderLabel = commonLabel()
    private lazy var divider = UIView().then {
        $0.backgroundColor = .gray01
    }
    private lazy var dogSizeLabel = commonLabel()
    private lazy var birthdayLabel = commonLabel()
    
    private lazy var accessLevelTagImageView = UIImageView().then {
        $0.image = .ownerTag
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    public lazy var meatballButton = UIButton().then {
        $0.setImage(.meatballsMenu, for: .normal)
    }
    
    private lazy var editMenuFrameView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }
    
    private lazy var editMenuFrameLine = UIView().then {
        $0.backgroundColor = .gray04
        $0.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    public lazy var exitButton = UIButton().then {
        $0.setTitle("나가기", for: .normal)
        $0.setTitleColor(.red00, for: .normal)
        $0.titleLabel?.font = UIFont.description
    }
    
    public lazy var editPuppyInfoButton = UIButton().then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.description
    }
    
    public lazy var memberTableView = UITableView().then {
        $0.backgroundColor = .brown02
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    public lazy var sendInviationButton = UIButton().then {
        $0.setImage(.sendInvitation, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    public func configure(_ pet: Pet, delegate: PetOwnerCellDelegate?, petListViewModel: PetListViewModel?) {
            self.pet = pet
            self.delegate = delegate
            self.petListViewModel = petListViewModel
            self.members = pet.people ?? []
            
            setDefaultConstraints()
            profileImage.kf.setImage(with: URL(string: pet.mainImage ?? ""))
            nameLabel.text = pet.name
            genderLabel.text = pet.gender
            dogSizeLabel.text = pet.size
            birthdayLabel.text = "🎂 " + (pet.birth ?? "")
            
            setupTableView()
            setupViewModelBinding()
    }
        
    private func setupTableView() {
        memberTableView.dataSource = self
        memberTableView.delegate = self
        memberTableView.register(MemberInPetCell.self, forCellReuseIdentifier: MemberInPetCell.identifier)
        memberTableView.separatorStyle = .none
        memberTableView.isScrollEnabled = false
        memberTableView.reloadData()
        updateTableViewHeight()
    }
    
    private func setupViewModelBinding() {
        guard let petListViewModel = petListViewModel else { return }
        
        petListViewModel.$petList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedPets in
                guard let self = self, let pet = self.pet else { return }
                
                // 현재 펫의 업데이트된 정보 찾기
                if let updatedPet = updatedPets.first(where: { $0.petId == pet.petId }) {
                    self.members = updatedPet.people ?? []
                    self.memberTableView.reloadData()
                    self.updateTableViewHeight()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateTableViewHeight() {
            let cellHeight: CGFloat = 52
            let tableHeight = CGFloat(members.count) * cellHeight
            let finalHeight = min(tableHeight, 157)
            
            // updateConstraints 사용하여 기존 제약 조건 업데이트
            tableViewHeightConstraint?.update(offset: finalHeight)
            
            // 또는 updateConstraints 메서드 사용
            memberTableView.snp.updateConstraints { make in
                make.height.equalTo(finalHeight)
            }
            
            // 레이아웃 업데이트
            self.layoutIfNeeded()
            
            // 부모 컬렉션뷰에 레이아웃 업데이트 알림
            if let collectionView = self.superview as? UICollectionView {
                DispatchQueue.main.async {
                    collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    private func setDefaultConstraints() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        self.addSubview(genderLabel)
        self.addSubview(divider)
        self.addSubview(dogSizeLabel)
        self.addSubview(birthdayLabel)
        self.addSubview(accessLevelTagImageView)
        self.addSubview(meatballButton)
        self.addSubview(memberTableView)
        self.addSubview(sendInviationButton)
        self.addSubview(editMenuFrameView)
        editMenuFrameView.addSubview(editMenuFrameLine)
        editMenuFrameView.addSubview(exitButton)
        editMenuFrameView.addSubview(editPuppyInfoButton)
        
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.leading.top.equalToSuperview().offset(20)
        }
        
        editMenuFrameView.isHidden = true
        editMenuFrameView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(100)
            make.top.equalTo(meatballButton.snp.centerY)
            make.trailing.equalTo(meatballButton.snp.centerX)
        }
        
        editMenuFrameLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        editPuppyInfoButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(editMenuFrameLine.snp.top)
        }
        
        exitButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(editMenuFrameLine.snp.bottom)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.top.equalTo(profileImage.snp.top).offset(10)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.centerY.equalTo(profileImage.snp.centerY)
        }
        
        divider.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.leading.equalTo(genderLabel.snp.trailing).offset(7)
            make.centerY.equalTo(genderLabel)
            make.height.equalTo(15)
        }
        
        dogSizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderLabel.snp.trailing).offset(16)
            make.centerY.equalTo(genderLabel)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.leading.equalTo(genderLabel)
            make.top.equalTo(dogSizeLabel.snp.bottom).offset(7)
        }
        
        meatballButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.top.equalTo(profileImage.snp.top).inset(-10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        accessLevelTagImageView.snp.makeConstraints { make in
            make.centerY.equalTo(meatballButton)
            make.trailing.equalTo(meatballButton.snp.leading)
            make.height.equalTo(25)
            make.width.equalTo(70)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(birthdayLabel.snp.bottom).offset(16)
            // 초기 높이 설정 시 constraint 참조 저장
            self.tableViewHeightConstraint = make.height.equalTo(52).constraint
        }
        
        sendInviationButton.snp.makeConstraints { make in
            make.top.equalTo(memberTableView.snp.bottom).offset(11)
            make.trailing.equalToSuperview().inset(21)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.meatballButton.addTarget(self, action: #selector(didTapMeatballButton), for: .touchUpInside)
        self.exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        self.editPuppyInfoButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        self.sendInviationButton.addTarget(self, action: #selector(showInvitaionVC), for: .touchUpInside)
    }
    
    @objc
    private func showInvitaionVC() {
        delegate?.didTapInviteButton(petID: pet!.petId)
    }
    
    @objc
    private func didTapEditButton() {
        guard let pet = pet else {
            print("cell 안의 pet이 비어있습니다.")
            return
        }
        delegate?.didTapEditButton(pet: pet)
    }
    
    @objc
    private func didTapExitButton() {
        guard let pet = pet else {
            print("cell 안의 pet이 비어있습니다.")
            return
        }
        delegate?.didTapExitButton(petID: pet.petId)
    }
    
    // EditMenuFrameView 관련 동작
    @objc
    private func didTapMeatballButton() {
        editMenuFrameView.isHidden = false
        showOverlay()
    }
    
    private func showOverlay() {
        guard overlayView == nil else { return }
        
        let overlay = UIView(frame: self.bounds)
        overlay.backgroundColor = .clear
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.isUserInteractionEnabled = true
        
        self.insertSubview(overlay, belowSubview: editMenuFrameView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOverlayTap(_:)))
        overlay.addGestureRecognizer(tapGesture)
        self.overlayView = overlay
    }
    
    @objc
    private func handleOverlayTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        if editMenuFrameView.frame.contains(location) {
            return
        }
        hideEditMenuFrameView()
    }
    
    @objc
    private func hideEditMenuFrameView() {
        editMenuFrameView.isHidden = true
        overlayView?.removeFromSuperview()
        overlayView = nil
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonLabel() -> UILabel {
        return UILabel().then {
            $0.textColor = .gray01
            $0.font = UIFont.body
        }
    }
    
}

extension PetOwnerCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberInPetCell.identifier, for: indexPath) as! MemberInPetCell
        let member = members[indexPath.row]
        cell.configure(with: member, at: indexPath, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension PetOwnerCell: MemberInPetCellDelegate {
    
    func didTapEditMemberButton(for member: PetMember, at indexPath: IndexPath) {
        showMemberEditMenu(for: member, at: indexPath)
    }
    
    func didTapDeleteMember(member: PetMember, petId: Int) {
        petListViewModel?.deletePetMember(memberId: member.id, petId: petId) { [weak self] result in
            DispatchQueue.main.async {
                self?.delegate?.didTapDeleteMemberButton()
                print("멤버 삭제 완료")
            }
        }
    }
    
    private func showMemberEditMenu(for member: PetMember, at indexPath: IndexPath) {
        guard let pet = pet else { return }
        
        let alert = UIAlertController(title: "\(member.name)", message: "작업을 선택하세요", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.didTapDeleteMember(member: member, petId: pet.petId)
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        // 현재 뷰컨트롤러 찾기
        if let viewController = self.findViewController() {
            viewController.present(alert, animated: true)
        }
    }
}


import SwiftUI
import SnapKit
#Preview {
    PetListViewController()
}
