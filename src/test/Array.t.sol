// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "../Array.sol";

contract ArrayTest is DSTest {
    using ArrayLib for Array;
    function setUp() public {}

    function testArray() public {
        Array pa = ArrayLib.newArray(5);
        // safe pushes
        pa.unsafe_push(125);
        pa.unsafe_push(126);
        pa.unsafe_push(127);
        pa.unsafe_push(128);
        pa.unsafe_push(129);
        pa = pa.push(130);
        pa = pa.push(131);
        pa = pa.push(132);
        pa = pa.push(133);
        pa = pa.push(134);
        pa = pa.push(135);
        for (uint256 i; i < 11; i++) {
            assertEq(pa.get(i), 125 + i);
        }
    }

    function testMemoryInterruption() public {
        Array pa = ArrayLib.newArray(5);
        // safe pushes
        pa.unsafe_push(125);
        pa.unsafe_push(126);
        pa.unsafe_push(127);
        pa.unsafe_push(128);
        pa.unsafe_push(129);

        ArrayLib.newArray(5);

        pa = pa.push(130);
        pa = pa.push(131);
        pa = pa.push(132);
        pa = pa.push(133);
        pa = pa.push(134);
        pa = pa.push(135);
        for (uint256 i; i < 11; i++) {
            assertEq(pa.get(i), 125 + i);
        }
    }

    // unsafe pushes are cheaper than standard assigns
    function testUnsafeGasEfficiency() public {
        uint256 g0 = gasleft();
        Array pa = ArrayLib.newArray(1);
        pa.unsafe_push(125);
        uint256 g1 = gasleft();
        uint256[] memory a = new uint256[](1);
        a[0] = 125;
        uint256 g2 = gasleft();
        emit log_named_uint("Array gas", g0 - g1);
        emit log_named_uint("builtin gas", g1 - g2);
        emit log_named_uint("delta", (g1 - g2) - (g0 - g1));
    }

    function testUnsafeGasEfficiencyGet() public {
        Array pa = ArrayLib.newArray(1);
        pa.unsafe_push(125);
        uint256 g0 = gasleft();
        uint256 b = pa.unsafe_get(0);
        uint256 g1 = gasleft();
        
        uint256[] memory a = new uint256[](1);
        a[0] = 125;
        uint256 g2 = gasleft();
        uint256 c = a[0];
        uint256 g3 = gasleft();
        emit log_named_uint("Array gas", g0 - g1);
        emit log_named_uint("builtin gas", g2 - g3);
    }

    function testSafeGasEfficiencyGet() public {
        Array pa = ArrayLib.newArray(1);
        pa.unsafe_push(125);
        uint256 g0 = gasleft();
        uint256 b = pa.get(0);
        uint256 g1 = gasleft();
        
        uint256[] memory a = new uint256[](1);
        a[0] = 125;
        uint256 g2 = gasleft();
        uint256 c = a[0];
        uint256 g3 = gasleft();
        emit log_named_uint("Array gas", g0 - g1);
        emit log_named_uint("builtin gas", g2 - g3);
    }

    function testSafeGasEfficiency() public {
        uint256 g0 = gasleft();
        Array pa = ArrayLib.newArray(1);
        pa = pa.push(125);
        uint256 g1 = gasleft();
        uint256[] memory a = new uint256[](1);
        a[0] = 125;
        uint256 g2 = gasleft();
        emit log_named_uint("Array gas", g0 - g1);
        emit log_named_uint("builtin gas", g1 - g2);
    }
}

contract RefArrayTest is DSTest {
    using RefArrayLib for Array;
    function setUp() public {}

    function testArray() public {
        Array pa = RefArrayLib.newArray(5);
        // safe pushes
        pa.unsafe_push(125);
        pa.unsafe_push(126);
        pa.unsafe_push(127);
        pa.unsafe_push(128);
        pa.unsafe_push(129);
        pa.push(130);
        pa.push(131);
        pa.push(132);
        pa.push(133);
        pa.push(134);
        pa.push(135);
        for (uint256 i; i < 11; i++) {
            assertEq(pa.get(i), 125 + i);
        }
    }

    function testMemoryInterruption() public {
        Array pa = RefArrayLib.newArray(5);
        // safe pushes
        pa.unsafe_push(125);
        pa.unsafe_push(126);
        pa.unsafe_push(127);
        pa.unsafe_push(128);
        pa.unsafe_push(129);

        RefArrayLib.newArray(5);

        pa.push(130);
        pa.push(131);
        pa.push(132);
        pa.push(133);
        pa.push(134);
        pa.push(135);
        for (uint256 i; i < 11; i++) {
            assertEq(pa.get(i), 125 + i);
        }
    }

    // unsafe pushes are cheaper than standard assigns
    function testUnsafeGasEfficiency() public {
        uint256 g0 = gasleft();
        Array pa = RefArrayLib.newArray(1);
        pa.unsafe_push(125);
        uint256 g1 = gasleft();
        uint256[] memory a = new uint256[](1);
        a[0] = 125;
        uint256 g2 = gasleft();
        emit log_named_uint("Array gas", g0 - g1);
        emit log_named_uint("builtin gas", g1 - g2);
    }

    function testUnsafeGasEfficiencyGet() public {
        Array pa = RefArrayLib.newArray(1);
        pa.unsafe_push(125);
        uint256 g0 = gasleft();
        uint256 b = pa.unsafe_get(0);
        uint256 g1 = gasleft();
        
        uint256[] memory a = new uint256[](1);
        a[0] = 125;
        uint256 g2 = gasleft();
        uint256 c = a[0];
        uint256 g3 = gasleft();
        emit log_named_uint("Array gas", g0 - g1);
        emit log_named_uint("builtin gas", g2 - g3);
    }

    function testSafeGasEfficiencyGet() public {
        Array pa = RefArrayLib.newArray(1);
        pa.unsafe_push(125);
        uint256 g0 = gasleft();
        uint256 b = pa.get(0);
        uint256 g1 = gasleft();
        
        uint256[] memory a = new uint256[](1);
        a[0] = 125;
        uint256 g2 = gasleft();
        uint256 c = a[0];
        uint256 g3 = gasleft();
        emit log_named_uint("Array gas", g0 - g1);
        emit log_named_uint("builtin gas", g2 - g3);
    }

    function testSafeGasEfficiency() public {
        uint256 g0 = gasleft();
        Array pa = RefArrayLib.newArray(1);
        pa.push(125);
        uint256 g1 = gasleft();
        uint256[] memory a = new uint256[](1);
        a[0] = 125;
        uint256 g2 = gasleft();
        emit log_named_uint("Array gas", g0 - g1);
        emit log_named_uint("builtin gas", g1 - g2);
    }
}