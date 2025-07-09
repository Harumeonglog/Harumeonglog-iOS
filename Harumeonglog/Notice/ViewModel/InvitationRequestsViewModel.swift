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
    var hasNext: Bool = true
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        getInvitationRequests()
    }
    
    func getInvitationRequests() {
        isLoading = true
        guard let accessToken = KeychainService.get(key: K.Keys.accessToken) else { print("no access token"); return }
        guard hasNext else { print("has no next"); return }
        
        InvitationRequestsService.getInvitaionRequests(cursor: cursor, token: accessToken) { [weak self] result in
            switch result {
            case .success(let success):
                self?.invitations.append(contentsOf: success.result?.invitations ?? [])
                print("get invitations requests succeed", self?.invitations ?? ["nothing"])
                guard let nextCursor = success.result?.nextCursor else {
                    self?.hasNext = false
                    break
                }
                self?.cursor = nextCursor
            case .failure(let failure):
                print("#get Invitation Requests error: ", failure)
                break
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
