//
//  AtomDetailView.swift
//  ARChemLab
//
//  Created by Dolapo Toki on 2017-09-30.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit

class AtomDetailView: UIView {

    @IBOutlet weak var electronLogo: UIImageView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var atomSymbol: UILabel!
    @IBOutlet weak var atomNumber: UILabel!
    @IBOutlet weak var atomNumber2: UILabel!
    @IBOutlet weak var atomName: UILabel!
    @IBOutlet weak var atomName2: UILabel!
    @IBOutlet weak var atomMass: UILabel!
    @IBOutlet weak var atomMass2: UILabel!
    @IBOutlet weak var excessElectrons: UILabel!
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
        roundedView.layer.borderColor = UIColor.gray.cgColor
        roundedView.layer.borderWidth = 0.5
        roundedView.layer.cornerRadius = 20
        roundedView.layer.masksToBounds = true
        electronLogo.tintColor = UIColor.black
    }
}
