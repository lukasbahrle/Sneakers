import SwiftUI

struct TitleView: View {
    let titles: [String]
    let containerSize: CGSize
    let scrollPercent: CGFloat
    
    var body: some View {
        let minSide = min(containerSize.width,containerSize.height)
        let transitionOffset: CGFloat = containerSize.width * 0.4
        let letterTransition: (Bool) -> AnyTransition  = { isMovingLeft in
                .asymmetric(insertion:
                        .offset(x: isMovingLeft ? -transitionOffset : transitionOffset).combined(with: .opacity),
                            removal:
                        .offset(x: isMovingLeft ? transitionOffset : -transitionOffset).combined(with: .opacity))
        }
        
        return ScrollingLetters(
            titles: titles,
            containerScrollPercent: scrollPercent) { letterTransition($0)}
            .font(.custom("AvenirNextCondensed-HeavyItalic",fixedSize: minSide * 0.24))
            .animation(.spring, value: scrollPercent)
    }
}
