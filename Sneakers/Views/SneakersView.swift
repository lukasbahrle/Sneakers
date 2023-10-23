import SwiftUI

struct SneakersView: View {
    let sneakers: [Sneaker]
    
    @State private var scrollPercent: Double = 0
    
    private var isCTAVisible: Bool {
        let scrollPercentRemainder = scrollPercent.truncatingRemainder(dividingBy: 1)
        return scrollPercentRemainder < 0.1
    }
    
    private func scrollOffsetBinding(width: CGFloat) -> Binding<CGPoint> {
        Binding(get: {
            CGPoint(x: scrollPercent * width, y: 0)
        }, set: {
            scrollPercent = $0.x / width
        })
    }
    
    var body: some View {
        GeometryReader { reader in
            let minSide = min(reader.size.width, reader.size.height)
            ZStack {
                titleView(reader: reader)
                    .frame(maxHeight: .infinity)
                    .offset(y: -minSide * 0.22)
                
                WSScrollView(
                    axes: .horizontal,
                    showsIndicators: false,
                    offset: scrollOffsetBinding(width: reader.size.width)) {
                        HStack(spacing: 0) {
                            ForEach(sneakers, id: \.id) {  sneaker in
                                sneakerImage(sneaker.imageName)
                                    .padding(.top, minSide * 0.25)
                                    .containerRelativeFrame(
                                        .horizontal,
                                        count: 1,
                                        span: 1,
                                        spacing: 0)
                                    .frame(maxHeight: .infinity)
                                
                            }
                        }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                
                VStack {
                    logo
                        .padding(.top, reader.safeAreaInsets.top + 30)
                    
                    Spacer()
                    
                    ctaButton
                        .opacity(isCTAVisible ? 1 : 0)
                        .offset(y: isCTAVisible ? 0 : 30)
                        .padding(.bottom, reader.safeAreaInsets.bottom + 20)
                        .animation(.spring.speed(1.5), value: isCTAVisible)
                }
            }
            .foregroundColor(.white)
            .background(
                ScrollingColors(
                    colors: sneakers.map { $0.backgroundColor },
                    containerScrollPercent: scrollPercent))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }
    
    private var logo: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 70)
    }
    
    private func titleView(reader: GeometryProxy) -> some View {
        let minSide = min(reader.size.width, reader.size.height)
        let transitionOffset: CGFloat = reader.size.width * 0.4
        let letterTransition: (Bool) -> AnyTransition  = { isMovingLeft in
                .asymmetric(insertion:
                        .offset(x: isMovingLeft ? -transitionOffset : transitionOffset).combined(with: .opacity),
                            removal:
                        .offset(x: isMovingLeft ? transitionOffset : -transitionOffset).combined(with: .opacity))
        }
        
        return ScrollingLetters(
            titles: sneakers.map { $0.title },
            containerScrollPercent: scrollPercent) { letterTransition($0)}
            .font(.custom("AvenirNextCondensed-HeavyItalic",fixedSize: minSide * 0.24))
    }
    
    private var ctaButton: some View {
        Button {
            print("Show now")
        } label: {
            Label {
                Text("Shop")
            } icon: {
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(.ctaButton)
    }
    
    private func sneakerImage(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(-36))
            .shadow(radius: 5)
    }
}

#Preview {
    SneakersView(sneakers: .data)
}
