//
/**
 * Copyright (C) 2018 HAT Data Exchange Ltd
 *
 * SPDX-License-Identifier: MPL2
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

import Foundation

public class HATOperator: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case `operator`
    }
    
    enum HATOperatorTypes: String, Codable {
        
        case find
        case contains
        case between
        case `in`
    }
    
    var `operator`: HATOperatorTypes
    
    public required init(from decoder: Decoder) throws {
        
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.operator = try container.decode(HATOperatorTypes.self, forKey: .`operator`)
    }
}

public class OperatorIn: HATOperator {
    
    var value: Dictionary<String, String> = [:]
}

public class OperatorContains: HATOperator {
    
    var value: Bool = false
}

public class OperatorBetween: HATOperator {
    
    var upper: Int = 0
    var lower: Int = 0
}

public class OperatorFind: HATOperator {
    
    private enum CodingKeys: String, CodingKey {
        
        case `operator`
        case search
    }
    var search: String = ""
    
    public required init(from decoder: Decoder) throws {
        
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.search = try container.decode(String.self, forKey: .search)
        try super.init(from: decoder)
    }
}
