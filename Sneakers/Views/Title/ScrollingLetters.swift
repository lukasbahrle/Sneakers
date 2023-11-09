import SwiftUI

struct ScrollingLetters: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let titles: [String]
    let containerScrollPercent: CGFloat
    let transition: (Bool) -> AnyTransition
    
    private let allLetters: [String]
    @State private var isMovingLeft: Bool = false
    
    private var currentLetterIndices: (start: Int, end: Int) {
        guard !reduceMotion else {
            return reducedMotionLetterIndices
        }
        
        let index0 = max(0, Int(floor(containerScrollPercent)))
        let index1 = min(titles.count - 1, Int(ceil(containerScrollPercent)))
        let titlePercent = containerScrollPercent.truncatingRemainder(dividingBy: 1)
        let title0 = titles[index0]
        let title1 = titles[index1]
        
        let maxLetterCount = max(title0.count, title1.count)
        
        let letterIndex = Int((titlePercent * Double(maxLetterCount)).rounded())
        
        var startLetterIndex = 0
        
        for wordIndex in 0..<index0 {
            startLetterIndex += titles[wordIndex].count
        }
        
        var endLetterIndex = startLetterIndex
        endLetterIndex += title0.count - 1 + min(letterIndex, title1.count)
        
        startLetterIndex += min(letterIndex, title0.count)
        
        let validRange = 0...allLetters.count - 1
        
        return (startLetterIndex.clamped(to: validRange),
                endLetterIndex.clamped(to: validRange))
    }
    
    private var reducedMotionLetterIndices: (start: Int, end: Int) {
        let index = Int(round(containerScrollPercent))
        
        var startLetterIndex = 0
        
        for wordIndex in 0..<index {
            startLetterIndex += titles[wordIndex].count
        }
        
        return (startLetterIndex, startLetterIndex + titles[index].count - 1)
    }
    
    init(titles: [String], containerScrollPercent: CGFloat, transition: @escaping (Bool) -> AnyTransition = { _ in .opacity }) {
        self.titles = titles
        self.containerScrollPercent = containerScrollPercent
        self.transition = transition
        allLetters = titles.map { $0.map { String($0) } }.flatMap { $0 }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            let indices = currentLetterIndices
            
            ForEach(indices.start...indices.end, id: \.self) { index in
                let letter = allLetters[index]
                Text(verbatim: "\(letter.uppercased())")
                    .transition(reduceMotion ? .opacity : transition(isMovingLeft))
            }
        }
        .onChange(of: containerScrollPercent) { oldValue, newValue in
            isMovingLeft = newValue - oldValue < 0
        }
    }
}

private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#if DEBUG
private struct PreviewView: View {
    let titles = [
        "Title One",
        "Title Two",
        "Title Three"
    ]
    @State private var scrollPercent: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 60) {
            ScrollingLetters(titles: titles, containerScrollPercent: scrollPercent) { _ in
                    .scale
            }
           
            ScrollingLetters(titles: titles, containerScrollPercent: scrollPercent) { _ in
                    .move(edge: .bottom).combined(with: .opacity)
            }
            .animation(.spring(bounce: 0.6), value: scrollPercent)
            
            ScrollingLetters(titles: titles, containerScrollPercent: scrollPercent) { isMovingLeft in
                    .asymmetric(insertion: .move(edge: isMovingLeft ? .leading : .trailing), removal: .move(edge: isMovingLeft ? .trailing : .leading))
                    .combined(with: .opacity)
            }
            
            ScrollingLetters(titles: titles, containerScrollPercent: scrollPercent) { isMovingLeft in
                    .modifier(active: PreviewTransitionRotationViewModifier(
                        angle: .degrees(-90),
                        axis: (x: 0, y: 0, z: 1),
                        opacity: 0),
                              identity: PreviewTransitionRotationViewModifier(
                                angle: .zero,
                                axis: (x: 0, y: 0, z: 1),
                                opacity: 1)
                    )
            }
            
            ScrollingLetters(titles: titles, containerScrollPercent: scrollPercent) { isMovingLeft in
                    .modifier(active: PreviewTransitionRotationViewModifier(
                        angle: .degrees(-100),
                        axis: (x: 1, y: 0, z: 0),
                        opacity: 0),
                              identity: PreviewTransitionRotationViewModifier(
                                angle: .zero,
                                axis: (x: 1, y: 0, z: 0),
                                opacity: 1)
                    )
            }
            
            ScrollingLetters(titles: titles, containerScrollPercent: scrollPercent) { isMovingLeft in
                    .modifier(active: PreviewTransitionScaleViewModifier(
                        scale: 2,
                        opacity: 0),
                              identity: PreviewTransitionScaleViewModifier(
                                scale: 1,
                                opacity: 1)
                    )
            }
            
            Slider(value: $scrollPercent, in: 0...CGFloat(titles.count - 1))
                .padding()
        }
        .animation(.spring, value: scrollPercent)
        .font(.largeTitle)
        .fontWeight(.black)
    }
}

private struct PreviewTransitionRotationViewModifier: ViewModifier {
    let angle: Angle
    let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    let opacity: CGFloat
    
    func body(content: Content) -> some View {
        content
            .animation(.smooth.speed(2)) {
                $0.opacity(opacity)
            }
            .animation(.spring(bounce: 0.8)) {
                $0.rotation3DEffect(angle, axis: axis)
            }
    }
}

private struct PreviewTransitionScaleViewModifier: ViewModifier {
    let scale: CGFloat
    let opacity: CGFloat
    
    func body(content: Content) -> some View {
        content
            .animation(.smooth.speed(2)) {
                $0.opacity(opacity)
            }
            .animation(.spring(bounce: 0.8)) {
                $0.scaleEffect(scale)
            }
    }
}

#Preview {
    PreviewView()
}
#endif
