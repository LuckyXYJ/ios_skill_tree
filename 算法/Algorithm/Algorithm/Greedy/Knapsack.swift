//
//  CoinChange.swift
//  Algorithm
//
//  Created by xingyajie on 2022/11/29.
//

import Foundation

struct Article: CustomStringConvertible {
    let weight: Int
    let value:  Int
    
    let valueDensity: Double
    
    init(_ weight: Int, _ value: Int) {
        self.weight = weight
        self.value = value
        self.valueDensity = Double(value) / Double(weight)
    }
    
    var description: String {
        return "Article [weight= \(weight), value= \(value), valueDensity= \(valueDensity)]"
    }
}

class Knapsack {
    static func run(cmp: (Article, Article) -> Bool) {
        
        var articles = [
            Article(35, 10),
            Article(30, 40),
            Article(60, 30),
            Article(50, 50),
            Article(40, 35),
            Article(10, 40),
            Article(25, 30)
        ]
        
        
        articles = articles.sorted(by: cmp)
        
        let capacity = 150
        var weight = 0
        var value = 0
        var selectedArticles: [Article] = [];
        
        for i in 0..<articles.count {
            if weight >= capacity { break }
            
            let newWeight = weight + articles[i].weight
            
            if newWeight <= capacity {
                weight = newWeight
                value += articles[i].value
                selectedArticles.append(articles[i])
            }
        }
        
        print("总价值：", value)
        
        for i in 0..<selectedArticles.count {
            print(selectedArticles[i])
        }
        
    }
}
