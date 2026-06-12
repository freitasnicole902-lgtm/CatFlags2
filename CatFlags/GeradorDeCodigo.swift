import Foundation
import CryptoKit


struct Code {
    
    static func generate() -> String {
        
        let itens = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        
        let cod = (0..<6).map {_ in String(itens.randomElement()!)}.joined()
        
        return "\(cod)"
    }
    
    static func hash (_ code: String) -> String{
        
        let data = Data(code.uppercased().utf8)
        
        return SHA256.hash(data: data).compactMap{String(format: "%02x", $0)}.joined()
    }
    
}
