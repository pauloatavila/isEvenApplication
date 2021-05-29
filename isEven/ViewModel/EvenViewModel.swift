//
//  EvenViewModel.swift
//  isEven
//
//  Created by Paulo Atavila on 28/05/21.
//

class EvenViewModel: EvenViewModelProtocol {
    private let service: ServiceProtocol
    
    private (set) var result: EvenResult?
    weak var delegate: EvenViewDelegate?
    
    init(service: ServiceProtocol = EvenService()) {
        self.service = service
    }
    
    func getResult(for number: Int) {
        service.fetchIsEven(for: number){ result in
            switch result {
            case .success(let result):
                self.result = result
                self.delegate?.success(result: result)
            case .failure(let error):
                self.delegate?.error(message: error.localizedDescription)
            }
        }
    }
}

protocol EvenViewModelProtocol {
    var delegate: EvenViewDelegate? { get set }
    
    func getResult(for number: Int)
}

protocol EvenViewDelegate: AnyObject {
    func success(result: EvenResult)
    func error(message: String)
}
