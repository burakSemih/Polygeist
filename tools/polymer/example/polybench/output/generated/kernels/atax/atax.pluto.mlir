#map0 = affine_map<()[s0] -> ((s0 - 1) floordiv 32 + 1)>
#map1 = affine_map<(d0) -> (d0 * 32)>
#map2 = affine_map<(d0)[s0] -> (s0, d0 * 32 + 32)>
module  {
  func @kernel_atax(%arg0: i32, %arg1: i32, %arg2: memref<1900x2100xf64>, %arg3: memref<2100xf64>, %arg4: memref<2100xf64>, %arg5: memref<1900xf64>) {
    %0 = index_cast %arg1 : i32 to index
    %1 = alloca() : memref<1xf64>
    call @S0(%1) : (memref<1xf64>) -> ()
    affine.for %arg6 = 0 to %0 {
      call @S1(%arg4, %arg6, %1) : (memref<2100xf64>, index, memref<1xf64>) -> ()
    }
    %2 = index_cast %arg0 : i32 to index
    affine.for %arg6 = 0 to %2 {
      call @S2(%arg5, %arg6) : (memref<1900xf64>, index) -> ()
      %3 = alloca() : memref<1xf64>
      call @S3(%3, %arg5, %arg6) : (memref<1xf64>, memref<1900xf64>, index) -> ()
      affine.for %arg7 = 0 to %0 {
        call @S4(%arg5, %arg6, %arg3, %arg7, %arg2, %3) : (memref<1900xf64>, index, memref<2100xf64>, index, memref<1900x2100xf64>, memref<1xf64>) -> ()
      }
      %4 = alloca() : memref<1xf64>
      call @S5(%4, %arg5, %arg6) : (memref<1xf64>, memref<1900xf64>, index) -> ()
      affine.for %arg7 = 0 to %0 {
        call @S6(%arg4, %arg7, %4, %arg2, %arg6) : (memref<2100xf64>, index, memref<1xf64>, memref<1900x2100xf64>, index) -> ()
      }
    }
    return
  }
  func @S0(%arg0: memref<1xf64>) attributes {scop.stmt} {
    %c0_i32 = constant 0 : i32
    %0 = sitofp %c0_i32 : i32 to f64
    affine.store %0, %arg0[0] : memref<1xf64>
    return
  }
  func @S1(%arg0: memref<2100xf64>, %arg1: index, %arg2: memref<1xf64>) attributes {scop.stmt} {
    %0 = affine.load %arg2[0] : memref<1xf64>
    affine.store %0, %arg0[symbol(%arg1)] : memref<2100xf64>
    return
  }
  func @S2(%arg0: memref<1900xf64>, %arg1: index) attributes {scop.stmt} {
    %cst = constant 0.000000e+00 : f64
    affine.store %cst, %arg0[symbol(%arg1)] : memref<1900xf64>
    return
  }
  func @S3(%arg0: memref<1xf64>, %arg1: memref<1900xf64>, %arg2: index) attributes {scop.stmt} {
    %0 = affine.load %arg1[symbol(%arg2)] : memref<1900xf64>
    affine.store %0, %arg0[0] : memref<1xf64>
    return
  }
  func @S4(%arg0: memref<1900xf64>, %arg1: index, %arg2: memref<2100xf64>, %arg3: index, %arg4: memref<1900x2100xf64>, %arg5: memref<1xf64>) attributes {scop.stmt} {
    %0 = affine.load %arg5[0] : memref<1xf64>
    %1 = affine.load %arg4[symbol(%arg1), symbol(%arg3)] : memref<1900x2100xf64>
    %2 = affine.load %arg2[symbol(%arg3)] : memref<2100xf64>
    %3 = mulf %1, %2 : f64
    %4 = addf %0, %3 : f64
    affine.store %4, %arg0[symbol(%arg1)] : memref<1900xf64>
    return
  }
  func @S5(%arg0: memref<1xf64>, %arg1: memref<1900xf64>, %arg2: index) attributes {scop.stmt} {
    %0 = affine.load %arg1[symbol(%arg2)] : memref<1900xf64>
    affine.store %0, %arg0[0] : memref<1xf64>
    return
  }
  func @S6(%arg0: memref<2100xf64>, %arg1: index, %arg2: memref<1xf64>, %arg3: memref<1900x2100xf64>, %arg4: index) attributes {scop.stmt} {
    %0 = affine.load %arg0[symbol(%arg1)] : memref<2100xf64>
    %1 = affine.load %arg3[symbol(%arg4), symbol(%arg1)] : memref<1900x2100xf64>
    %2 = affine.load %arg2[0] : memref<1xf64>
    %3 = mulf %1, %2 : f64
    %4 = addf %0, %3 : f64
    affine.store %4, %arg0[symbol(%arg1)] : memref<2100xf64>
    return
  }
  func @kernel_atax_new(%arg0: i32, %arg1: i32, %arg2: memref<1900x2100xf64>, %arg3: memref<2100xf64>, %arg4: memref<2100xf64>, %arg5: memref<1900xf64>) {
    %0 = alloca() : memref<1xf64>
    %1 = index_cast %arg1 : i32 to index
    %2 = index_cast %arg0 : i32 to index
    affine.for %arg6 = 0 to #map0()[%2] {
      affine.for %arg7 = #map1(%arg6) to min #map2(%arg6)[%2] {
        call @S2(%arg5, %arg7) : (memref<1900xf64>, index) -> ()
      }
    }
    affine.for %arg6 = 0 to %2 {
      %3 = alloca() : memref<1xf64>
      call @S3(%3, %arg5, %arg6) : (memref<1xf64>, memref<1900xf64>, index) -> ()
      affine.for %arg7 = 0 to %1 {
        call @S4(%arg5, %arg6, %arg3, %arg7, %arg2, %3) : (memref<1900xf64>, index, memref<2100xf64>, index, memref<1900x2100xf64>, memref<1xf64>) -> ()
      }
    }
    call @S0(%0) : (memref<1xf64>) -> ()
    affine.for %arg6 = 0 to #map0()[%2] {
      affine.for %arg7 = #map1(%arg6) to min #map2(%arg6)[%2] {
        call @S1(%arg4, %arg7, %0) : (memref<2100xf64>, index, memref<1xf64>) -> ()
      }
    }
    affine.for %arg6 = 0 to %2 {
      %3 = alloca() : memref<1xf64>
      call @S5(%3, %arg5, %arg6) : (memref<1xf64>, memref<1900xf64>, index) -> ()
      affine.for %arg7 = 0 to #map0()[%1] {
        affine.for %arg8 = #map1(%arg7) to min #map2(%arg7)[%1] {
          call @S6(%arg4, %arg6, %3, %arg2, %arg8) : (memref<2100xf64>, index, memref<1xf64>, memref<1900x2100xf64>, index) -> ()
        }
      }
    }
    return
  }
}
