
import SwiftUI

struct ResultsView: View {

    let ranking: [SituationResult]

    var body: some View {

        List(ranking) { item in

            Text(item.text)
        }
    }
}

#Preview {
    ResultsView(ranking: [])
}
