//===--- IntegerPrinting.swift --------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2025 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// This test verifies the performance of generating a text description
// from integer values.

import TestsUtils 

public let benchmarks = [
  BenchmarkInfo(
    name: "IntegerPrinting_Int8",
    runFunction: IntegerPrinting_Int8,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupInt8),
  
  BenchmarkInfo(
    name: "IntegerPrinting_Int8_hex",
    runFunction: IntegerPrinting_Int8_hex,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupInt8),

  BenchmarkInfo(
    name: "IntegerPrinting_Int_smol",
    runFunction: IntegerPrinting_Int_smol,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupIntSmol),
  
  BenchmarkInfo(
    name: "IntegerPrinting_Int_hex",
    runFunction: IntegerPrinting_Int_hex,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupIntSmol),

  BenchmarkInfo(
    name: "IntegerPrinting_Int_full",
    runFunction: IntegerPrinting_Int,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupInt),

  BenchmarkInfo(
    name: "IntegerPrinting_Int128",
    runFunction: IntegerPrinting_Int128,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupInt128),
  
  BenchmarkInfo(
    name: "IntegerPrinting_Int128_hex",
    runFunction: IntegerPrinting_Int128_hex,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupInt128),
  
  BenchmarkInfo(
    name: "IntegerPrinting_UInt8",
    runFunction: IntegerPrinting_UInt8,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupUInt8),
  
  BenchmarkInfo(
    name: "IntegerPrinting_UInt8_hex",
    runFunction: IntegerPrinting_UInt8_hex,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupUInt8),
  
  BenchmarkInfo(
    name: "IntegerPrinting_UInt_smol",
    runFunction: IntegerPrinting_UInt_smol,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupUIntSmol),
  
  BenchmarkInfo(
    name: "IntegerPrinting_UInt_hex",
    runFunction: IntegerPrinting_UInt_hex,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupUIntSmol),
  
  BenchmarkInfo(
    name: "IntegerPrinting_UInt_full",
    runFunction: IntegerPrinting_UInt,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupUInt),
  
  BenchmarkInfo(
    name: "IntegerPrinting_UInt128",
    runFunction: IntegerPrinting_UInt128,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupUInt128),
  
  BenchmarkInfo(
    name: "IntegerPrinting_UInt128_hex",
    runFunction: IntegerPrinting_UInt128_hex,
    tags: [.validation, .api, .runtime, .String],
    setUpFunction: setupUInt128)
]

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
struct Lehmer: RandomNumberGenerator, Sendable {
  
  var state: UInt128
  
  public init(seed: some BinaryInteger) {
    state = UInt128(truncatingIfNeeded: seed) | 1
  }
  
  mutating func next() -> UInt64 {
    state &*= 0xda942042e4dd58b5
    return UInt64(state >> 64)
  }
}

let count = 1_000
var int8: [Int8] = []

public func setupInt8() {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    var g = Lehmer(seed: 314159265358979)
    int8 = (0 ..< count).map { _ in
      Int8.random(in: .min ... .max, using: &g)
    }
  }
}

@inline(never)
public func IntegerPrinting_Int8(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(int8[i].description)
      }
    }
  }
}

@inline(never)
public func IntegerPrinting_Int8_hex(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(String(int8[i], radix: 16))
      }
    }
  }
}

var IntSmol: [Int] = []

public func setupIntSmol() {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    var g = Lehmer(seed: 314159265358979)
    IntSmol = (0 ..< count).map { _ in
// TODO: pickup smol string bounds from stdlib itself
#if _pointerBitWidth(_32) || _pointerBitWidth(_16)
      Int.random(in: -9_9999_9999...99_9999_9999, using: &g)
#elseif os(Android) && arch(arm64)
      Int.random(in: -9_9999_9999_9999...99_9999_9999_9999, using: &g)
#elseif _pointerBitWidth(_64)
      Int.random(in: -99_9999_9999_9999...999_9999_9999_9999, using: &g)
#else
#error("New platform needs smol string bounds")
#endif
    }
  }
}

@inline(never)
public func IntegerPrinting_Int_smol(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(IntSmol[i].description)
      }
    }
  }
}

@inline(never)
public func IntegerPrinting_Int_hex(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(String(int[i], radix: 16))
      }
    }
  }
}

var int: [Int] = []

public func setupInt() {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    var g = Lehmer(seed: 314159265358979)
    int = (0 ..< count).map { _ in
      Int.random(in: .min ... .max, using: &g)
    }
  }
}

@inline(never)
public func IntegerPrinting_Int(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(int[i].description)
      }
    }
  }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
var int128: [Int128] = []

public func setupInt128() {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    var g = Lehmer(seed: 314159265358979)
    int128 = (0 ..< count).map { _ in
      Int128.random(in: .min ... .max, using: &g)
    }
  }
}

@inline(never)
public func IntegerPrinting_Int128(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(int128[i].description)
      }
    }
  }
}

@inline(never)
public func IntegerPrinting_Int128_hex(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(String(int128[i], radix: 16))
      }
    }
  }
}

var uint8: [UInt8] = []

public func setupUInt8() {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    var g = Lehmer(seed: 314159265358979)
    uint8 = (0 ..< count).map { _ in
      UInt8.random(in: .min ... .max, using: &g)
    }
  }
}

@inline(never)
public func IntegerPrinting_UInt8(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(uint8[i].description)
      }
    }
  }
}

@inline(never)
public func IntegerPrinting_UInt8_hex(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(String(uint8[i], radix: 16))
      }
    }
  }
}

var uIntSmol: [UInt] = []

public func setupUIntSmol() {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    var g = Lehmer(seed: 314159265358979)
    uIntSmol = (0 ..< count).map { _ in
      // TODO: pickup smol string bounds from stdlib itself
#if _pointerBitWidth(_32) || _pointerBitWidth(_16)
      UInt.random(in: 0 ... 99_9999_9999, using: &g)
#elseif os(Android) && arch(arm64)
      UInt.random(in: 0 ... 99_9999_9999_9999, using: &g)
#elseif _pointerBitWidth(_64)
      UInt.random(in: 0 ... 999_9999_9999_9999, using: &g)
#else
#error("New platform needs smol string bounds")
#endif
    }
  }
}

@inline(never)
public func IntegerPrinting_UInt_smol(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(uIntSmol[i].description)
      }
    }
  }
}

var uint: [UInt] = []

public func setupUInt() {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    var g = Lehmer(seed: 314159265358979)
    uint = (0 ..< count).map { _ in
      UInt.random(in: .min ... .max, using: &g)
    }
  }
}

@inline(never)
public func IntegerPrinting_UInt_hex(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(String(uint[i], radix: 16))
      }
    }
  }
}

@inline(never)
public func IntegerPrinting_UInt(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(uint[i].description)
      }
    }
  }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
var uint128: [UInt128] = []

public func setupUInt128() {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    var g = Lehmer(seed: 314159265358979)
    uint128 = (0 ..< count).map { _ in
      UInt128.random(in: .min ... .max, using: &g)
    }
  }
}

@inline(never)
public func IntegerPrinting_UInt128(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(uint128[i].description)
      }
    }
  }
}

@inline(never)
public func IntegerPrinting_UInt128_hex(_ n: Int) {
  if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
    for _ in 0..<n {
      for i in 0..<count {
        blackHole(String(uint128[i], radix: 16))
      }
    }
  }
}


/*
 BASED:
 500 IntegerPrinting_Int128             1 2553.668 2553.668 2553.668
 501 IntegerPrinting_Int128_hex         1 3216.688 3216.688 3216.688
 502 IntegerPrinting_Int8               1   53.142   53.142   53.142
 503 IntegerPrinting_Int8_hex           1   51.361   51.361   51.361
 504 IntegerPrinting_Int_full           1  118.685  118.685  118.685
 505 IntegerPrinting_Int_smol           1   64.597   64.597   64.597
 506 IntegerPrinting_Int_hex            1  117.698  117.698  117.698
 507 IntegerPrinting_UInt128            1 2517.550 2517.550 2517.550
 508 IntegerPrinting_UInt128_hex        1 3201.834 3201.834 3201.834
 509 IntegerPrinting_UInt8              1   53.675   53.675   53.675
 510 IntegerPrinting_UInt8_hex          1   48.964   48.964   48.964
 511 IntegerPrinting_UInt_full          1  128.625  128.625  128.625
 512 IntegerPrinting_UInt_smol          1   68.047   68.047   68.047
 513 IntegerPrinting_UInt_hex           1  115.260  115.260  115.260

 */
