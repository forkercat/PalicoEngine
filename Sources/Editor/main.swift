//
//  main.swift
//  Editor
//
//  Created by Junhao Wang on 12/17/21.
//

import Palico
import MathLib

// Log
Log.registerLogger(name: "Editor", level: .trace)

let app = Editor(name: "Palico Engine", arguments: CommandLine.arguments)
app.run()

Log.info("Exit(0)")
