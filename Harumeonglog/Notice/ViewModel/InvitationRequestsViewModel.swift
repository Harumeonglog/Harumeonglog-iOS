//
//  InvitationRequestsViewModel.swift
//  Harumeonglog
//
//  Created by 이승준 on 7/7/25.
//

import Alamofire
import Combine

final class InvitationRequestsViewModel: ObservableObject {
    
    @Published var invitations = [InvitationRequest]()
    @Published var isLoading = false
    var cursor: Int = 0
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        getInvitationRequests()
    }
    
    func getInvitationRequests() {
        guard !isLoading else { return }
        self.isLoading = true
        print("GET 초대 요청 : cursor: \(cursor), isLoading: \(isLoading)")
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { print("no access token"); return }
        InvitationRequestsService.getInvitaionRequests(cursor: cursor, token: accessToken) { [weak self] result in
            switch result {
            case .success(let success):
                guard let invitations = success.result?.invitations else {
                    return
                }
                print("초대 요청 불러오기 성공 \(invitations)")
                if invitations.count == 0 {
                    return
                } else {
                    self?.invitations.append(contentsOf: invitations)
                    self?.cursor = invitations.last!.invitationId
                    print("last is \(invitations.last!.invitationId)")
                }
            case .failure(let failure):
                print("#get Invitation Requests error: ", failure)
                break
            }
        }
        self.isLoading = false
    }
    
    func postInvitationResponse(request: InvitationRequest, mode: RequestReply) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { print("no access token"); return }
        
        InvitationRequestsService.postInvitationRequest(petId: request.petId, token: accessToken, mode: mode) { [weak self] result in
            switch result {
            case .success(let response):
                self?.invitations.removeAll(where: { $0.invitationId == request.invitationId })
                print("\(mode.rawValue) invitation \(request.petName) succeed", self?.invitations ?? ["nothing"])
            case .failure(let failure):
                print("#postInvitationResponse error: ", failure)
                return
            }
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
    
}
