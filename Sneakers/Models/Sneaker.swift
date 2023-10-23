import SwiftUI

struct Sneaker {
    let id = UUID()
    let title: String
    let imageName: String
    let backgroundColor: Color
}

extension Array where Element == Sneaker {
    static var data: [Sneaker] {
        [Sneaker(title: "Giannis",
                imageName: "giannis",
                backgroundColor: Color(red: 0.11, green: 0.49, blue: 0.49)),
        Sneaker(title: "LeBron",
                imageName: "lebron",
                backgroundColor: Color(red: 0.35, green: 0.28, blue: 0.51)),
        Sneaker(title: "Luka",
                imageName: "luka",
                backgroundColor: Color(red: 0.28, green: 0.45, blue: 0.67)),
        Sneaker(title: "KD",
                imageName: "kd",
                backgroundColor: Color(red: 0.92, green: 0.4, blue: 0.44))]
    }
}
