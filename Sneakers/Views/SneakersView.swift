import SwiftUI

struct SneakersView: View {
    let sneakers: [Sneaker]
    
    @State private var scrollPercent: Double = 0
    @State private var sneakerID: Sneaker.ID? = nil
    
    private var selectedIndex: Int {
        Int(round(scrollPercent))
    }
    
    private var isCTAVisible: Bool {
        let scrollPercentRemainder = scrollPercent.truncatingRemainder(dividingBy: 1)
        return scrollPercentRemainder < 0.1
    }
    
    var body: some View {
        GeometryReader { reader in
            let minSide = min(reader.size.width, reader.size.height)
            ZStack {
                TitleView(titles: sneakers.map { $0.title },
                          containerSize: reader.size,
                          scrollPercent: scrollPercent)
                .frame(maxHeight: .infinity)
                .offset(y: -minSide * 0.22)
                
                SneakersImageSlider(sneakers: sneakers,
                                    sneakerID: $sneakerID,
                                    scrollPercent: $scrollPercent,
                                    containerSize: reader.size)
                
                VStack {
                    logo
                        .padding(.top, reader.safeAreaInsets.top + 30)
                    
                    Spacer()
                    
                    CTAButton(isVisible: isCTAVisible) {
                        goToShop()
                    }
                    .padding(.bottom, reader.safeAreaInsets.bottom + 20)
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
        .accessibilityRepresentation {
            SneakersAccessibility(sneakers: sneakers,
                                  sneakerID: $sneakerID,
                                  selectedIndex: selectedIndex,
                                  goToShop: goToShop)
        }
        .onAppear {
            sneakerID = sneakers.first?.id
        }
    }
    
    private var logo: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 70)
    }
    
    private func goToShop() {
        print("shop \(sneakers[selectedIndex].title)")
    }
}

#Preview {
    SneakersView(sneakers: .data)
}
