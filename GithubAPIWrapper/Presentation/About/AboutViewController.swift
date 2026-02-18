//
//  AboutViewController.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 18/02/26.
//

import UIKit
import Combine

final class AboutViewController: UIViewController {
    
    private let contentView = AboutView()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Detail"
        
        contentView.render()
        contentView.imageView.image = UIImage(named: "myphoto")
    }
    
}
