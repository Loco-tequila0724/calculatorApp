//
//  ViewController.swift
//  calculatorApp
//
//  Created by 日高隼人 on 2021/01/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

//マスの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return numbers.count
    }
//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3 * 10) / 4
        return .init(width:width, height:width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier:"cellId",for:indexPath) as! CalculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]

        return cell
    }

    let numbers = [
        ["C","%","$","÷"],
        ["7","8","9","x"],
        ["4","5","6","-"],
        ["7","8","9","+"],
        ["0",".","=",],
]

    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var numberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: "cellId")
        calculatorHeightConstraint.constant = view.frame.width * 1.4
        calculatorCollectionView.backgroundColor = .clear

        view.backgroundColor = .black
    }
}

class CalculatorViewCell: UICollectionViewCell {

    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        label.clipsToBounds = true
        label.backgroundColor = .orange
        return label
    }()


    override init(frame:CGRect) {
        super.init(frame: frame)
        addSubview(numberLabel)
        //backgroundColor = .black

        numberLabel.frame.size = self.frame.size
        numberLabel.layer.cornerRadius = self.frame.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
