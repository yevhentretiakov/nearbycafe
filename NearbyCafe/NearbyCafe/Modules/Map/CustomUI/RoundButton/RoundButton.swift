//
//  RoundButton.swift
//  NearbyCafe
//
//  Created by user on 19.08.2022.
//

import UIKit

final class RoundButton: UIButton {
    // MARK: - Life Cycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configure() {
        backgroundColor = .white
        makeRounded()
        setShadow()
    }
}
