//
//  ViewController.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 06/02/26.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private let searchProfileUsecase: SearchProfileUsecase
    private var cancellables = Set<AnyCancellable>()
    
    init(searchProfileUsecase: SearchProfileUsecase) {
        self.searchProfileUsecase = searchProfileUsecase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchProfileUsecase.execute(query: "rizkisiraj", page: 1)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error:", error)
                }
            } receiveValue: { [weak self] profiles in
                guard let self else { return }
                
                print(profiles)
                
                print("dipanggil")
            }
            .store(in: &cancellables)
    }


}

