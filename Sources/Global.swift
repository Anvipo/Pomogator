//
//  Global.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

func executeIfDebug(_ closure: () -> Void) {
	#if DEBUG
	closure()
	#endif
}
