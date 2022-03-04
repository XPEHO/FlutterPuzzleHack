//
//  WatchViewModel.swift
//  watch WatchKit Extension
//
//  Created by Piotr FLEURY on 20/02/2022.
//

import Foundation
import WatchConnectivity
import os

struct FlutterPuzzle: Encodable, Decodable {
    let values: Array<Int>
    let moves: Int
    let complexity: Int
}

class WatchViewModel: NSObject, ObservableObject {
    var session: WCSession
    @Published var counter = 0
    @Published var moves = 0
    @Published var data = [1, 2, 3, 4, 5, 6, 7, 8, 0]
    
    // Add more cases if you have more receive method
    enum WatchReceiveMethod: String {
        case sendPuzzleToNative
        case sendMovesToNative
    }
    
    // Add more cases if you have more sending method
    enum WatchSendMethod: String {
        case sendPuzzleToFlutter
        case sendMovesToFlutter
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func sendDataMessage(for method: WatchSendMethod, data: String) {
        sendMessage(for: method.rawValue, data: data)
    }
    
    func swap(value: Int) {
        let valueIndex: Int = data.firstIndex(of: value) ?? 0
        let zeroIndex: Int = data.firstIndex(of: 0) ?? 0
        
        data.swapAt(zeroIndex, valueIndex)
        moves+=1
        _sendToFlutter()
    }
    
    func shuffle() {
        data.shuffle()
        moves = 0
        _sendToFlutter()
    }
    
    func reset() {
        data = [1, 2, 3, 4, 5, 6, 7, 8, 0]
        moves = 0
        _sendToFlutter()
    }
    
    func _sendToFlutter() {
        let puzzleValues = self.data.map{String($0)}.joined(separator: ",")
        os_log("sending puzzle to Flutter \(puzzleValues)")
        sendDataMessage(for: .sendPuzzleToFlutter, data: puzzleValues)
        
        let moves = self.moves
        os_log("sending moves to Flutter \(moves)")
        sendDataMessage(for: .sendMovesToFlutter, data: String(moves))
        
    }
    
}

extension WatchViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // Receive message From AppDelegate.swift that send from iOS devices
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
                return
            }
            
            switch enumMethod {
            case .sendMovesToNative:
                let movesString = message["moves"] as? String ?? ""
                os_log("received moves from flutter \(movesString)")
                let moves = Int(movesString) ?? 0
                self.moves = moves
                break;
            case .sendPuzzleToNative:
                let puzzleString = message["puzzle"] as? String ?? ""
                os_log("received puzzle from flutter \(puzzleString)")
                let puzzleValues = puzzleString.split(separator: ",")
                self.data = puzzleValues.map{Int($0) ?? 0}
                break;
                
            }
        }
    }
    
    func sendMessage(for method: String, data: String) {
        guard session.isReachable else {
            return
        }
        let messageData: [String: Any] = ["method": method, "data": data]
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
}
