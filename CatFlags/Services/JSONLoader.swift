import Foundation
import UIKit

final class JSONLoader {
    static func loadSituations() -> [Situation] {
        guard let url = Bundle.main.url(
            forResource: "situations" ,
            withExtension: "json"
        ) else {
            print("Arquivo não encontrado")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let situations = try JSONDecoder()
                .decode([Situation].self, from: data)
            return situations
        } catch {
            print("Erro ao carregar o JSON:", error)
            
            return[]
        }
    }
}
