//
//  AtomDetailView.swift
//  ARChemLab
//
//  Created by Dolapo Toki on 2017-09-30.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit

class AtomDetailView: UIView {

    @IBOutlet var contentView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init (frame: CGRect){
        super.init(frame: frame)
        comonInit()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        comonInit()
    }
    private func comonInit(){
        Bundle.main.loadNibNamed("AtomDetailView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
