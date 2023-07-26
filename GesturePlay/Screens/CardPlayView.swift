//
//  CardPlayView.swift
//  GesturePlay
//
//  Created by Martin Wiingaard on 31/10/2020.
//


import SwiftUI

struct Card: View {
    static let aspectRatio: CGFloat = 319/204
    
    var color: UIColor = .systemYellow
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .aspectRatio(Card.aspectRatio, contentMode: .fit)
            .foregroundColor(Color(color))
    }
}

struct CardPlayView: View {
    static let restSpacing: CGFloat = 60
    
    enum CardType {
        case yellow
        case red
        
        var not: CardType {
            switch self {
            case .yellow: return .red
            case .red: return .yellow
            }
        }
        
        var name: String {
            switch self {
            case .yellow: return "Yellow"
            case .red: return "Red"
            }
        }
    }
    
    @State private var yellowOffset: CGFloat = 0
    @State private var yellowRestOffset: CGFloat = 0
    @State private var yellowIndex: Double = 0
    
    @State private var redOffset: CGFloat = restSpacing
    @State private var redRestOffset: CGFloat = restSpacing
    @State private var redIndex: Double = 1
    
    @State private var topCard: CardType = .red
    @State private var flipEnabled = true
    
    func setOffset(for cardType: CardType, to value: CGFloat) {
        switch cardType {
        case .yellow: yellowOffset = value
        case .red: redOffset = value
        }
    }
    
    func offset(for cardType: CardType) -> CGFloat {
        switch cardType {
        case .yellow: return yellowOffset
        case .red: return redOffset
        }
    }
    
    func index(for cardType: CardType) -> Double {
        switch cardType {
        case .yellow: return yellowIndex
        case .red: return redIndex
        }
    }
    
    func restPosition(for cardType: CardType) -> CGFloat {
        switch cardType {
        case .red: return redRestOffset
        case .yellow: return yellowRestOffset
        }
    }
    
    func updateRestPositions() {
        yellowRestOffset = topCard == .yellow ? CardPlayView.restSpacing : 0
        redRestOffset = topCard == .red ? CardPlayView.restSpacing : 0
    }
    
    func flipOnce() {
        if flipEnabled {
            flipEnabled = false
            topCard = topCard.not
            yellowIndex = topCard == .yellow ? 1 : 0
            redIndex = topCard == .red ? 1 : 0
            HapticsHelper.shared.singleTap()
        }
    }
    
    func enableFlip() {
        if !flipEnabled {
            flipEnabled = true
        }
    }
    
    func checkFlip(for cardType: CardType) {
        
        let overFlipPoint = offset(for: cardType) > offset(for: cardType.not) + height
        let overFlipPoint2 = offset(for: cardType) + height < offset(for: cardType.not)
        let cardsOverlapping = !overFlipPoint && !overFlipPoint2
        
        if overFlipPoint && flipEnabled {
            flipOnce()
        }
        
        if cardsOverlapping  && !flipEnabled {
            enableFlip()
        }

        if overFlipPoint2 && flipEnabled {
            flipOnce()
        }

        if cardsOverlapping && !flipEnabled {
            enableFlip()
        }
    }
    
    func updateOffsets(dragging: CardType?, offset: CGFloat) {
        
    }
    
    func dragGesture(_ card: CardType) -> some Gesture {
        let rest = restPosition(for: card)
        let oppositeRest = restPosition(for: card.not)
        return DragGesture(minimumDistance: 0).onChanged { gesture in
            let offset = gesture.translation.height
            let slowOffset = offset * 0.3
            let fastOffset = offset * 1
            
            checkFlip(for: card)
            if offset < 0 {
                setOffset(for: card, to: rest + fastOffset)
                setOffset(for: card.not, to: oppositeRest - offset)
            } else {
                setOffset(for: card, to: rest + offset)
                setOffset(for: card.not, to: oppositeRest - slowOffset)
            }
        }.onEnded { gesture in
            updateReport?(.init(offset: 0, oppositeOffset: 0, dragging: nil))
            
            updateRestPositions()
            withAnimation {
                setOffset(for: card, to: restPosition(for: card))
                setOffset(for: card.not, to: restPosition(for: card.not))
            }
        }
    }
    
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat {
        width / Card.aspectRatio
    }
    
    struct UpdateValues {
        let offset: CGFloat
        let oppositeOffset: CGFloat
        let dragging: CardType?
    }
    
    var updateReport: ((UpdateValues) -> ())?
    
    var body: some View {
        ZStack {
            Card(color: .systemYellow)
                .frame(width: width)
                .zIndex(yellowIndex)
                .offset(y: yellowOffset)
                .gesture(dragGesture(.yellow))
            
            Card(color: .systemRed)
                .frame(width: width)
                .zIndex(redIndex)
                .offset(y: redOffset)
                .gesture(dragGesture(.red))
            
        }
    }
}

struct CardPlayContentView: View {
    @State private var updateValues: CardPlayView.UpdateValues? = nil
    
    var body: some View {
        let dragging = updateValues?.dragging?.name ?? "-"
        let offset = Int(updateValues?.offset ?? 0)
        let opposite = Int(updateValues?.oppositeOffset ?? 0)
        
        ZStack {
            CardPlayView(updateReport: { updateValues = $0 })
            SettingsView {
                Text("\(dragging) Offset: \(offset), Opposite: \(opposite)")
            }
        }
    }
}

struct CardPlayView_Previews: PreviewProvider {
    static var previews: some View {
        CardPlayView()
    }
}
