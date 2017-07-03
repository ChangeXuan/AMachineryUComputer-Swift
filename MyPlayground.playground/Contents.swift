//: Playground - noun: a place where people can play

import UIKit

let one = [1,2,3,4,5,6]
var two:[Int] = []

for index in 1...4 {
    two.append(one[6-index])
}
print(two)

