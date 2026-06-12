import SwiftUI

struct ContentView: View {

    let situations = JSONLoader.loadSituations()

    var body: some View {

        List(situations) { situation in

            VStack(alignment: .leading, spacing: 8) {

                Text(situation.theme.rawValue)
                    .font(.headline)

                Text(situation.text)
            }
            .padding(.vertical, 4)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
