//
//  GSDBSchema.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 27/11/20.
//

import Foundation
import GRDB

// Database Schema
let gifColumns = [["columnName": "id", "columnType": Database.ColumnType.text, "isPrimaryKey": true],
                     ["columnName": "type", "columnType": Database.ColumnType.text, "isPrimaryKey": false],
                     ["columnName": "images", "columnType": Database.ColumnType.blob, "isPrimaryKey": false],
                     ["columnName": "url", "columnType": Database.ColumnType.text, "isPrimaryKey": false]]

let gifTable = ["tableName": "GifModel", "columns": gifColumns, "primaryKeys": ["id"], "foreignKey": []] as [String: Any]
