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

import UIKit

// MARK: Struct

public struct DataOfferRequiredDataDefinitionBundleFiltersV2: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case `operator`
        case field
        case transformation
    }
        
    // MARK: - Variables
    
    /// the field to filter
    public var field: String = ""
    /// The transformation to be done on the field
    public var transformation: Dictionary<String, String>?
    /// The operator of the filter
    public var `operator`: HATOperator?
    
    public init(from decoder: Decoder) throws {
        
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.field = try container.decode(String.self, forKey: .field)
        do {
            
            self.transformation = try container.decode(Dictionary<String, String>?.self, forKey: .transformation)
        } catch {
            
            self.transformation = nil
        }
        
        do {
            
            let test: HATOperator? = try container.decode(HATOperator?.self, forKey: .`operator`)
            
            switch test?.operator {
                
            case .find?:
                
                do {
                    
                    self.operator = try container.decode(OperatorFind.self, forKey: .`operator`)

                } catch {
                    
                    self.operator = nil
                }
            case .between?:
                
                do {
                    
                    self.operator = try container.decode(OperatorBetween.self, forKey: .`operator`)
                } catch {
                    
                    self.operator = nil
                }
            case .contains?:
                
                do {
                    
                    self.operator = try container.decode(OperatorContains.self, forKey: .`operator`)
                } catch {
                    
                    self.operator = nil
                }
            case .`in`?:
                
                do {
                    
                    self.operator = try container.decode(OperatorIn.self, forKey: .`operator`)
                } catch {
                    
                    self.operator = nil
                }
            case .none:
                
                self.operator = nil
            }
        } catch {
            
            self.operator = nil
        }
    }
}
