import SwiftUI

struct CardView: View {

    let situation: Situation

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("FundoCard1"))

            Text("\"\(situation.text)\"")
                .foregroundColor(Color("TextoPrincipal"))
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding(24)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
    }
}
