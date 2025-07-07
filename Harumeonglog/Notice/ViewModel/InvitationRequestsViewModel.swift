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
        isLoading = true
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { print("no access token"); return }
        
        InvitationRequestsService.getInvitaionRequests(cursor: cursor, token: accessToken) { [weak self] result in
            switch result {
            case .success(let success):
                self?.invitations.append(contentsOf: success.result?.members ?? [])
                print("get invitations succeed", self?.invitations ?? ["nothing"])
                self?.isLoading = false
            case .failure(let failure):
                print("#getInvitationRequests error: ", failure)
                self?.isLoading = false
                return
            }
        }
        isLoading = false
    }
    
    func postInvitationResponse(request: InvitationRequest, mode: RequestReply) {
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { print("no access token"); return }
        
        InvitationRequestsService.postInvitationRequest(petId: request.petId, token: accessToken, mode: mode) { [weak self] result in
            switch result {
            case .success(_):
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
