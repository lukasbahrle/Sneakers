import SwiftUI

struct SneakersImageSlider: View {
    let sneakers: [Sneaker]
    @Binding var sneakerID: Sneaker.ID?
    @Binding var scrollPercent: Double
    let containerSize: CGSize
    
    private func scrollOffsetBinding(width: CGFloat) -> Binding<CGPoint> {
        Binding(get: {
            CGPoint(x: scrollPercent * width, y: 0)
        }, set: {
            scrollPercent = $0.x / width
        })
    }
    
    var body: some View {
        let minContainerSide = min(containerSize.width, containerSize.height)
        WSScrollView(
            axes: .horizontal,
            showsIndicators: false,
            offset: scrollOffsetBinding(width: containerSize.width)) {
                HStack(spacing: 0) {
                    ForEach(sneakers) {
                        Image($0.imageName)
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(-36))
                            .shadow(color: .black.opacity(0.06), radius: minContainerSide * 0.07)
                            .shadow(color: .black.opacity(0.4), radius: minContainerSide * 0.08, y: minContainerSide * 0.12)
                            .padding(.top, minContainerSide * 0.25)
                            .containerRelativeFrame(
                                .horizontal)
                            .frame(maxHeight: .infinity)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $sneakerID)
    }
}
