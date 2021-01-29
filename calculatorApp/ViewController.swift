//
//  ViewController.swift
//  calculatorApp
//
//  Created by 日高隼人 on 2021/01/25.
//

import UIKit

class ViewController: UIViewController {

    enum CalculateStatus {
        case none, plus, minus, multiplication, division
    }

    var firstNumber = ""
    var secondNumber = ""
    var calculateStatus: CalculateStatus = .none

    let numbers = [
        ["AC","%","$","÷"],
        ["7","8","9","x"],
        ["4","5","6","-"],
        ["1","2","3","+"],
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
        calculatorCollectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
        numberLabel.text = "0"
        view.backgroundColor = .black
    }

    func clear() {
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
}

extension  ViewController:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        var width: CGFloat = 0
        width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let height = width
        if indexPath.section == 4 && indexPath.row == 0 {
            width = width * 2 + 14 + 9
        }

        return .init(width:width, height:height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier:"cellId",for:indexPath) as! CalculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        numbers[indexPath.section][indexPath.row].forEach { (numbersString) in
            if "0"..."9" ~= numbersString || numbersString.description == "." {
                cell.numberLabel.backgroundColor = .darkGray
            } else if numbersString == "C" ||  numbersString == "%" || numbersString == "$" {
                cell.numberLabel.backgroundColor = UIColor.init(white:1, alpha:0.7)
                cell.numberLabel.textColor = .black
            } else if numbersString == "-" || numbersString == "+" || numbersString == "✕" || numbersString == "÷" ||  numbersString == "=" {
                cell.numberLabel.font = .boldSystemFont(ofSize: 40)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]

        switch calculateStatus {
        case .none:
            switch number {
            case "0"..."9":
                firstNumber += number
                numberLabel.text = firstNumber

            case ".":
                if firstNumber.range(of: ".") != nil {
                    return
                } else if firstNumber.count == 0 {
                    return
                } else {
                    firstNumber += number
                    numberLabel.text = firstNumber
                }


            case "+":
                calculateStatus = .plus
            case "-":
                calculateStatus = .minus
            case "x":
                calculateStatus = .multiplication
            case "÷":
                calculateStatus = .division
            case "AC":
                clear()
            default:
                break
            }

        case .plus, .minus, .multiplication, .division:
            switch number {
            case "0"..."9",".":
                secondNumber += number
                numberLabel.text = secondNumber
            case "=":

                let firstNum = Double(firstNumber) ?? 0
                let secondNum = Double(secondNumber) ?? 0

                switch calculateStatus {

                case .plus:
                    numberLabel.text = String(firstNum + secondNum)
                case .minus:
                    numberLabel.text = String(firstNum - secondNum)
                case .multiplication:
                    numberLabel.text = String(firstNum * secondNum)
                case .division:
                    numberLabel.text = String(firstNum / secondNum)
                default:
                    break
                }

            case "AC":
                clear()
            default:
                break
            }
        }
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



