//
//  CardView.swift
//  CatFlags
//
//  Created by academy on 12/06/26.
//

import SwiftUI

struct CardView: View {

    let situation: Situation

    var body: some View {

        VStack(spacing: 20) {

            Text(situation.text)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()

            Button("Iniciar votação") {

            }
        }
    }
}
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            situation: Situation(
                id: 1,
                theme: .love,
                text: "Meu parceiro(a) lê minhas mensagens sem permissão."
            )
        )
    }
}
