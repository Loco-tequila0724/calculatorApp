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

    let cellId = "cellId"

    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var numberLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setViews()
    }



    func setViews() {
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: cellId)
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
        //数字や記号を入れる

        let number = numbers[indexPath.section][indexPath.row]

        switch calculateStatus {

        case .none:

            handleNumberSelected(number: number)

//MARK: -数字を押した、その後
        case .plus, .minus, .multiplication, .division:
            switch number {
            case "0"..."9":
//０かつ０を２回目に押したら、発動しない
                if secondNumber.range(of: "0") != nil && secondNumber.count == 1 {
                    return
                }   else {
 //数字を代入//
                    secondNumber += number
                    numberLabel.text = secondNumber
                }
//最初に点を打てない　または、点がある場合は２度目を打てない
            case ".":
                if !confirmIncludeDecimalPoint(numberString: secondNumber){
                    secondNumber += number
                    numberLabel.text = secondNumber
                }



//イコールを押すと、計算して和を出す
            case "=":
                calculateResultNumber()

             case "AC":
                clear()
             default:
                break
            }
        }
    }

    private func handleNumberSelected (number:String){
        switch number {
        case "0"..."9":
            //数字を押したら、その数字が表示される
            if firstNumber.range(of: "0") != nil && firstNumber.count == 1 {
                return
            } else {
                firstNumber += number
                numberLabel.text = firstNumber
            }
        //点が押してあったら、連続で次は押せない。　カウント０の時は押せない（最初に押せない）
        case ".":
            //                if firstNumber.range(of: ".") != nil || firstNumber.count == 0 {
            //                    return
            //                } else {
            //                    firstNumber += number
            //                    numberLabel.text = firstNumber
            //                }

            if !confirmIncludeDecimalPoint(numberString: firstNumber) {
                firstNumber += number
                numberLabel.text = firstNumber
            }
        //記号を押すと、演算子を代入
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
    }

    private func calculateResultNumber() {

        let firstNum = Double(firstNumber) ?? 0
        let secondNum = Double(secondNumber) ?? 0

        var resultString : String?


        switch calculateStatus {

        case .plus:
            resultString = String(firstNum + secondNum)
        case .minus:
            resultString = String(firstNum - secondNum)
        case .multiplication:
            resultString = String(firstNum * secondNum)
        case .division:
            resultString = String(firstNum / secondNum)
        default:
            break
        }

        if let result = resultString, result.hasSuffix(".0") {
            resultString = result.replacingOccurrences(of: ".0", with: "")
        }

        numberLabel.text = resultString

        firstNumber = ""
        secondNumber = ""

        firstNumber += resultString ?? ""
        calculateStatus = .none

    }

    private func confirmIncludeDecimalPoint(numberString: String) -> Bool {
        if numberString.range(of:".") != nil || numberString.count == 0 {
            return true
        } else {
            return false
        }
    }
}
