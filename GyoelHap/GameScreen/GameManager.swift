//
//  PlayingStageManager.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/15.
//

import Foundation

class GameManager {
    
    let stage:Stage
    var answers: [[Int]] = []
    var tryList: [Int] = []
    var revealedAnswers: [[Int]] = []
    var sortedRevealedAnswers: [[Int]] = []
    
    
    
    init(stage: Stage) {
        self.stage = stage
        loadAnswerLists(stage:stage)
    }
    
    func loadAnswerLists(stage: Stage) {
        answers = solver(stage: stage)
    }
    
    func addToTryList(_ num: Int) {
        if self.tryList.contains(num) {
            self.tryList = self.tryList.filter{$0 != num}
        } else if self.tryList.count < 3 {
            self.tryList.append(num)
        }
    }
    
    func checkAnswer() -> (Bool) {
        var isAnswer = false
        
        if self.tryList.count < 3 {
            return true
        }
        if sortedRevealedAnswers.contains(tryList.sorted()) {
          print("제출했던 정답입니다.")
        } else if answers.contains(tryList.sorted()) {
            print("정답입니다")
            isAnswer = true
            revealedAnswers.append(tryList)
            sortedRevealedAnswers.append(tryList.sorted())
        } else {
            print("오답입니다")
        }
        tryList = []
        print("밝혀진 정답은 \(revealedAnswers)")
        return isAnswer
    }
    
    func printTryList() {
        print("현재 시도중: \(self.tryList)")
    }
    
    func solver(stage: Stage) -> [[Int]] {
        var answers: [[Int]] = []
        let colors: [Int] = getColors(array: stage.dataArray)
        let shapes: [Int] = getShapes(array: stage.dataArray)
        let BGColors: [Int] = getBGColors(array: stage.dataArray)
        
        for i in 0 ..< 9 {
            for j in i + 1 ..< 9 {
                for k in j + 1 ..< 9 {
                    if (colors[i] + colors[j] + colors[k]) % 3 != 0 { continue }
                    if (shapes[i] + shapes[j] + shapes[k]) % 3 != 0 { continue }
                    if (BGColors[i] + BGColors[j] + BGColors[k]) % 3 != 0 { continue }
                    var answer : [Int] = Array()
                    answer.append(i + 1)
                    answer.append(j + 1)
                    answer.append(k + 1)
                    answers.append(answer)
                }
            }
        }
        return answers
    }
    
    func getColors(array: [Int]) -> [Int] {
        //0: pink, 1: dark blue, 2: yellow
        var newArray: [Int] = []

        for raw in 0..<array.count {
            let color: Int = array[raw] % 3
            newArray.append(color)
        }
        return newArray
    }

    func getShapes(array: [Int]) -> [Int] {
        //0: star, 1: moon, 2: sun
        var newArray: [Int] = []

        for raw in 0..<array.count {
            let shape: Int = Int(floor(Double(array[raw] / 3))) % 3
            newArray.append(shape)
        }
        return newArray
    }

    func getBGColors(array: [Int]) -> [Int] {
        //0: red, 1: purple, 2: green
        var newArray: [Int] = []

        for raw in 0..<array.count {
            let BGColor: Int = Int(floor(Double(Int(floor(Double(array[raw] / 3))) / 3))) % 3
            newArray.append(BGColor)
        }
        return newArray
    }
}