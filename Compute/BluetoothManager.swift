//
//  BluetoothManager.swift
//  Compute
//
//  Created by Jason Barrie Morley on 28/09/2020.
//

import CoreBluetooth
import SwiftUI

extension CBPeripheral {

    var displayString: String {
        name ?? identifier.uuidString
    }

    var serviceSummary: String {
        let uuids: [String] = services?.map { $0.uuid.uuidString } ?? []
        return uuids.joined(separator: ", ")
    }

}

extension CBService {

    var characteristicSummary: String {
        let uuids: [String] = characteristics?.map { $0.uuid.uuidString } ?? []
        return uuids.joined(separator: ", ")
    }

}

class BluetoothManager: NSObject, ObservableObject {

    var peripheral: CBPeripheral?
    var central: CBCentralManager?
    var peripherals: Set<CBPeripheral> = Set()

    override init() {
        print("INIT!")
    }

    func start() {
        central = CBCentralManager(delegate: self, queue: .main)
    }

    func stop() {
        central?.stopScan()
    }

}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state as CBManagerState) {
        case .unknown:
            print("manager state: unknown")
        case .resetting:
            print("manager state: resetting")
        case .unsupported:
            print("manager state: unsupported")
        case .unauthorized:
            print("manager state: unauthorized")
        case .poweredOff:
            print("manager state: poweredOff")
        case .poweredOn:
            print("manager state: poweredOn")
            central.scanForPeripherals(withServices: [CBUUID(string: "1802"),
                                                      CBUUID(string: "1803"),
                                                      CBUUID(string: "2A06")],
                                       options: nil)
        @unknown default:
            print("manager state: default")
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        self.objectWillChange.send()
        peripherals.insert(peripheral)
        central.connect(peripheral, options: nil)
    }

    func connect(peripheral: CBPeripheral) {
        central?.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        print("manager did connect to peripheral \(peripheral.displayString)")
        peripheral.discoverServices([CBUUID(string: "1803")])
    }

    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("peripheral did update name to '\(peripheral.displayString)'")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("peripheral failed to discover services with error \(error!)")
            return
        }
        print("peripheral did discover services \(peripheral.serviceSummary)")
        guard let service = peripheral.services?.first(where: { $0.isPrimary }) else {
            print("failed to find required service")
            return
        }
        peripheral.discoverCharacteristics([CBUUID(string: "2A06")], for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("peripheral failed to discover characteristics with error \(error!)")
            return
        }
        print("peripheral did discover characteristics \(service.characteristicSummary)")
        guard let characteristic = service.characteristics?.first(where: { $0.uuid == CBUUID(string: "2A06") }) else {
            print("failed to find required characteristic")
            return
        }
        print("found characteristic")
        var data = Data()
        data.append(10)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        peripheral.setNotifyValue(true, for: characteristic)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("peripheral failed to update value for characteristic error \(error!)")
            return
        }
        print("peripheral did update value for characteristic")
        guard let value = characteristic.value else {
            print("failed to get value for characteristic")
            return
        }
        let values = [UInt8](value)
        print("\(values)")
    }

}
