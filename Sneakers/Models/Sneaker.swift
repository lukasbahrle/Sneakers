import SwiftUI

struct Sneaker: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let backgroundColor: Color
}

extension Array where Element == Sneaker {
    static var data: [Sneaker] {
        [Sneaker(title: "Giannis",
                 imageName: "giannis",
                 backgroundColor: Color(.giannis)),
         Sneaker(title: "Lebron",
                 imageName: "lebron",
                 backgroundColor: Color(.lebron)),
         Sneaker(title: "Luka",
                 imageName: "luka",
                 backgroundColor: Color(.luka)),
         Sneaker(title: "KD",
                 imageName: "kd",
                 backgroundColor: Color(.kd))]
    }
}
