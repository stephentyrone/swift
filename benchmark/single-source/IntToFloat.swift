//===--- IntToFloat.swift -------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// This test checks performance of integer to floating-point conversion.
import TestsUtils

public let benchmarks =
BenchmarkInfo(
  name: "IntToFloat",
  runFunction: run_IntToFloat,
  tags: [.api],
  setUpFunction: { blackHole(inputs) }
)

let inputs = (0 ..< 4000).map { _ in Int64.random(in: .min ... .max) }

@inline(never)
public func run_IntToFloat(_ n: Int) {
  for _ in 0 ..< n {
    blackHole(inputs.reduce(into: 0) {
      $0 += Double($1)
    })
  }
}
 
