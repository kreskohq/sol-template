import { stdMath } from 'forge-std/StdMath.sol';

pragma solidity ^0.8.0;

// solhint-disable event-name-camelcase
// solhint-disable private-vars-leading-underscore

library LibTest {
  event log(string);
  event logs(bytes);

  event log_address(address);
  event log_bytes32(bytes32);
  event log_int(int);
  event log_uint(uint);
  event log_bytes(bytes);
  event log_string(string);

  event log_named_address(string key, address val);
  event log_named_bytes32(string key, bytes32 val);
  event log_named_decimal_int(string key, int val, uint decimals);
  event log_named_decimal_uint(string key, uint val, uint decimals);
  event log_named_int(string key, int val);
  event log_named_uint(string key, uint val);
  event log_named_bytes(string key, bytes val);
  event log_named_string(string key, string val);

  event log_array(uint256[] val);
  event log_array(int256[] val);
  event log_array(address[] val);
  event log_named_array(string key, uint256[] val);
  event log_named_array(string key, int256[] val);
  event log_named_array(string key, address[] val);

  address constant HEVM_ADDRESS = address(bytes20(uint160(uint256(keccak256('hevm cheat code')))));
  bool constant IS_TEST = true;

  // defining state variables
  struct Store {
    bool _failed;
    // ... any number of other state variables
  }

  // return a struct storage pointer for accessing the state variables
  function s() internal pure returns (Store storage ds) {
    bytes32 position = keccak256('lib.test.store');
    assembly {
      ds.slot := position
    }
  }

  modifier mayRevert() {
    _;
  }
  modifier testopts(string memory) {
    _;
  }

  function failed() public returns (bool) {
    if (s()._failed) {
      return s()._failed;
    } else {
      bool globalFailed = false;
      if (hasHEVMContext()) {
        (, bytes memory retdata) = HEVM_ADDRESS.call(
          abi.encodePacked(
            bytes4(keccak256('load(address,bytes32)')),
            abi.encode(HEVM_ADDRESS, bytes32('failed'))
          )
        );
        globalFailed = abi.decode(retdata, (bool));
      }
      return globalFailed;
    }
  }

  function fail() internal {
    if (hasHEVMContext()) {
      (bool status, ) = HEVM_ADDRESS.call(
        abi.encodePacked(
          bytes4(keccak256('store(address,bytes32,bytes32)')),
          abi.encode(HEVM_ADDRESS, bytes32('failed'), bytes32(uint256(0x01)))
        )
      );
      status; // Silence compiler warnings
    }
    s()._failed = true;
  }

  function hasHEVMContext() internal view returns (bool) {
    uint256 hevmCodeSize = 0;
    assembly {
      hevmCodeSize := extcodesize(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D)
    }
    return hevmCodeSize > 0;
  }

  modifier logs_gas() {
    uint startGas = gasleft();
    _;
    uint endGas = gasleft();
    emit log_named_uint('gas', startGas - endGas);
  }

  function assertTrue(bool condition) internal {
    if (!condition) {
      emit log('Error: Assertion Failed');
      fail();
    }
  }

  function assertTrue(bool condition, string memory err) internal {
    if (!condition) {
      emit log_named_string('Error', err);
      assertTrue(condition);
    }
  }

  function equals(address a, address b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [address]');
      emit log_named_address('      Left', a);
      emit log_named_address('     Right', b);
      fail();
    }
  }

  function equals(address a, address b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  function equals(bytes32 a, bytes32 b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [bytes32]');
      emit log_named_bytes32('      Left', a);
      emit log_named_bytes32('     Right', b);
      fail();
    }
  }

  function equals(bytes32 a, bytes32 b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  function equals32(bytes32 a, bytes32 b) internal {
    equals(a, b);
  }

  function equals32(bytes32 a, bytes32 b, string memory err) internal {
    equals(a, b, err);
  }

  function equals(int a, int b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [int]');
      emit log_named_int('      Left', a);
      emit log_named_int('     Right', b);
      fail();
    }
  }

  function equals(int a, int b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  function equals(uint a, uint b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [uint]');
      emit log_named_uint('      Left', a);
      emit log_named_uint('     Right', b);
      fail();
    }
  }

  function equals(uint a, uint b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  function equalsDecimal(int a, int b, uint decimals) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [decimal int]');
      emit log_named_decimal_int('      Left', a, decimals);
      emit log_named_decimal_int('     Right', b, decimals);
      fail();
    }
  }

  function equalsDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      equalsDecimal(a, b, decimals);
    }
  }

  function equalsDecimal(uint a, uint b, uint decimals) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [decimal uint]');
      emit log_named_decimal_uint('      Left', a, decimals);
      emit log_named_decimal_uint('     Right', b, decimals);
      fail();
    }
  }

  function equalsDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      equalsDecimal(a, b, decimals);
    }
  }

  function notEqual(address a, address b) internal {
    if (a == b) {
      emit log('Error: a != b not satisfied [address]');
      emit log_named_address('      Left', a);
      emit log_named_address('     Right', b);
      fail();
    }
  }

  function notEqual(address a, address b, string memory err) internal {
    if (a == b) {
      emit log_named_string('Error', err);
      notEqual(a, b);
    }
  }

  function notEqual(bytes32 a, bytes32 b) internal {
    if (a == b) {
      emit log('Error: a != b not satisfied [bytes32]');
      emit log_named_bytes32('      Left', a);
      emit log_named_bytes32('     Right', b);
      fail();
    }
  }

  function notEqual(bytes32 a, bytes32 b, string memory err) internal {
    if (a == b) {
      emit log_named_string('Error', err);
      notEqual(a, b);
    }
  }

  function notEqual32(bytes32 a, bytes32 b) internal {
    notEqual(a, b);
  }

  function notEqual32(bytes32 a, bytes32 b, string memory err) internal {
    notEqual(a, b, err);
  }

  function notEqual(int a, int b) internal {
    if (a == b) {
      emit log('Error: a != b not satisfied [int]');
      emit log_named_int('      Left', a);
      emit log_named_int('     Right', b);
      fail();
    }
  }

  function notEqual(int a, int b, string memory err) internal {
    if (a == b) {
      emit log_named_string('Error', err);
      notEqual(a, b);
    }
  }

  function notEqual(uint a, uint b) internal {
    if (a == b) {
      emit log('Error: a != b not satisfied [uint]');
      emit log_named_uint('      Left', a);
      emit log_named_uint('     Right', b);
      fail();
    }
  }

  function notEqual(uint a, uint b, string memory err) internal {
    if (a == b) {
      emit log_named_string('Error', err);
      notEqual(a, b);
    }
  }

  function notEqualDecimal(int a, int b, uint decimals) internal {
    if (a == b) {
      emit log('Error: a != b not satisfied [decimal int]');
      emit log_named_decimal_int('      Left', a, decimals);
      emit log_named_decimal_int('     Right', b, decimals);
      fail();
    }
  }

  function notEqualDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a == b) {
      emit log_named_string('Error', err);
      notEqualDecimal(a, b, decimals);
    }
  }

  function notEqualDecimal(uint a, uint b, uint decimals) internal {
    if (a == b) {
      emit log('Error: a != b not satisfied [decimal uint]');
      emit log_named_decimal_uint('      Left', a, decimals);
      emit log_named_decimal_uint('     Right', b, decimals);
      fail();
    }
  }

  function notEqualDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a == b) {
      emit log_named_string('Error', err);
      notEqualDecimal(a, b, decimals);
    }
  }

  function isGt(uint a, uint b) internal {
    if (a <= b) {
      emit log('Error: a > b not satisfied [uint]');
      emit log_named_uint('  Value a', a);
      emit log_named_uint('  Value b', b);
      fail();
    }
  }

  function isGt(uint a, uint b, string memory err) internal {
    if (a <= b) {
      emit log_named_string('Error', err);
      isGt(a, b);
    }
  }

  function isGt(int a, int b) internal {
    if (a <= b) {
      emit log('Error: a > b not satisfied [int]');
      emit log_named_int('  Value a', a);
      emit log_named_int('  Value b', b);
      fail();
    }
  }

  function isGt(int a, int b, string memory err) internal {
    if (a <= b) {
      emit log_named_string('Error', err);
      isGt(a, b);
    }
  }

  function isGtDecimal(int a, int b, uint decimals) internal {
    if (a <= b) {
      emit log('Error: a > b not satisfied [decimal int]');
      emit log_named_decimal_int('  Value a', a, decimals);
      emit log_named_decimal_int('  Value b', b, decimals);
      fail();
    }
  }

  function isGtDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a <= b) {
      emit log_named_string('Error', err);
      isGtDecimal(a, b, decimals);
    }
  }

  function isGtDecimal(uint a, uint b, uint decimals) internal {
    if (a <= b) {
      emit log('Error: a > b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Value a', a, decimals);
      emit log_named_decimal_uint('  Value b', b, decimals);
      fail();
    }
  }

  function isGtDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a <= b) {
      emit log_named_string('Error', err);
      isGtDecimal(a, b, decimals);
    }
  }

  function gte(uint a, uint b) internal {
    if (a < b) {
      emit log('Error: a >= b not satisfied [uint]');
      emit log_named_uint('  Value a', a);
      emit log_named_uint('  Value b', b);
      fail();
    }
  }

  function gte(uint a, uint b, string memory err) internal {
    if (a < b) {
      emit log_named_string('Error', err);
      gte(a, b);
    }
  }

  function gte(int a, int b) internal {
    if (a < b) {
      emit log('Error: a >= b not satisfied [int]');
      emit log_named_int('  Value a', a);
      emit log_named_int('  Value b', b);
      fail();
    }
  }

  function gte(int a, int b, string memory err) internal {
    if (a < b) {
      emit log_named_string('Error', err);
      gte(a, b);
    }
  }

  function gteDecimal(int a, int b, uint decimals) internal {
    if (a < b) {
      emit log('Error: a >= b not satisfied [decimal int]');
      emit log_named_decimal_int('  Value a', a, decimals);
      emit log_named_decimal_int('  Value b', b, decimals);
      fail();
    }
  }

  function gteDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a < b) {
      emit log_named_string('Error', err);
      gteDecimal(a, b, decimals);
    }
  }

  function gteDecimal(uint a, uint b, uint decimals) internal {
    if (a < b) {
      emit log('Error: a >= b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Value a', a, decimals);
      emit log_named_decimal_uint('  Value b', b, decimals);
      fail();
    }
  }

  function gteDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a < b) {
      emit log_named_string('Error', err);
      gteDecimal(a, b, decimals);
    }
  }

  function lt(uint a, uint b) internal {
    if (a >= b) {
      emit log('Error: a < b not satisfied [uint]');
      emit log_named_uint('  Value a', a);
      emit log_named_uint('  Value b', b);
      fail();
    }
  }

  function lt(uint a, uint b, string memory err) internal {
    if (a >= b) {
      emit log_named_string('Error', err);
      lt(a, b);
    }
  }

  function lt(int a, int b) internal {
    if (a >= b) {
      emit log('Error: a < b not satisfied [int]');
      emit log_named_int('  Value a', a);
      emit log_named_int('  Value b', b);
      fail();
    }
  }

  function lt(int a, int b, string memory err) internal {
    if (a >= b) {
      emit log_named_string('Error', err);
      lt(a, b);
    }
  }

  function ltDecimal(int a, int b, uint decimals) internal {
    if (a >= b) {
      emit log('Error: a < b not satisfied [decimal int]');
      emit log_named_decimal_int('  Value a', a, decimals);
      emit log_named_decimal_int('  Value b', b, decimals);
      fail();
    }
  }

  function ltDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a >= b) {
      emit log_named_string('Error', err);
      ltDecimal(a, b, decimals);
    }
  }

  function ltDecimal(uint a, uint b, uint decimals) internal {
    if (a >= b) {
      emit log('Error: a < b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Value a', a, decimals);
      emit log_named_decimal_uint('  Value b', b, decimals);
      fail();
    }
  }

  function ltDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a >= b) {
      emit log_named_string('Error', err);
      ltDecimal(a, b, decimals);
    }
  }

  function lte(uint a, uint b) internal {
    if (a > b) {
      emit log('Error: a <= b not satisfied [uint]');
      emit log_named_uint('  Value a', a);
      emit log_named_uint('  Value b', b);
      fail();
    }
  }

  function lte(uint a, uint b, string memory err) internal {
    if (a > b) {
      emit log_named_string('Error', err);
      lte(a, b);
    }
  }

  function lte(int a, int b) internal {
    if (a > b) {
      emit log('Error: a <= b not satisfied [int]');
      emit log_named_int('  Value a', a);
      emit log_named_int('  Value b', b);
      fail();
    }
  }

  function lte(int a, int b, string memory err) internal {
    if (a > b) {
      emit log_named_string('Error', err);
      lte(a, b);
    }
  }

  function lteDecimal(int a, int b, uint decimals) internal {
    if (a > b) {
      emit log('Error: a <= b not satisfied [decimal int]');
      emit log_named_decimal_int('  Value a', a, decimals);
      emit log_named_decimal_int('  Value b', b, decimals);
      fail();
    }
  }

  function lteDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a > b) {
      emit log_named_string('Error', err);
      lteDecimal(a, b, decimals);
    }
  }

  function lteDecimal(uint a, uint b, uint decimals) internal {
    if (a > b) {
      emit log('Error: a <= b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Value a', a, decimals);
      emit log_named_decimal_uint('  Value b', b, decimals);
      fail();
    }
  }

  function lteDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a > b) {
      emit log_named_string('Error', err);
      lteDecimal(a, b, decimals);
    }
  }

  function equals(string memory a, string memory b) internal {
    if (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b))) {
      emit log('Error: a == b not satisfied [string]');
      emit log_named_string('      Left', a);
      emit log_named_string('     Right', b);
      fail();
    }
  }

  function equals(string memory a, string memory b, string memory err) internal {
    if (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b))) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  function notEqual(string memory a, string memory b) internal {
    if (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b))) {
      emit log('Error: a != b not satisfied [string]');
      emit log_named_string('      Left', a);
      emit log_named_string('     Right', b);
      fail();
    }
  }

  function notEqual(string memory a, string memory b, string memory err) internal {
    if (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b))) {
      emit log_named_string('Error', err);
      notEqual(a, b);
    }
  }

  function checkEq0(bytes memory a, bytes memory b) internal pure returns (bool ok) {
    ok = true;
    if (a.length == b.length) {
      for (uint i = 0; i < a.length; i++) {
        if (a[i] != b[i]) {
          ok = false;
        }
      }
    } else {
      ok = false;
    }
  }

  function equals0(bytes memory a, bytes memory b) internal {
    if (!checkEq0(a, b)) {
      emit log('Error: a == b not satisfied [bytes]');
      emit log_named_bytes('      Left', a);
      emit log_named_bytes('     Right', b);
      fail();
    }
  }

  function equals0(bytes memory a, bytes memory b, string memory err) internal {
    if (!checkEq0(a, b)) {
      emit log_named_string('Error', err);
      equals0(a, b);
    }
  }

  function notEqual0(bytes memory a, bytes memory b) internal {
    if (checkEq0(a, b)) {
      emit log('Error: a != b not satisfied [bytes]');
      emit log_named_bytes('      Left', a);
      emit log_named_bytes('     Right', b);
      fail();
    }
  }

  function notEqual0(bytes memory a, bytes memory b, string memory err) internal {
    if (checkEq0(a, b)) {
      emit log_named_string('Error', err);
      notEqual0(a, b);
    }
  }

  function assertFalse(bool data) internal {
    assertTrue(!data);
  }

  function assertFalse(bool data, string memory err) internal {
    assertTrue(!data, err);
  }

  function equals(bool a, bool b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [bool]');
      emit log_named_string('      Left', a ? 'true' : 'false');
      emit log_named_string('     Right', b ? 'true' : 'false');
      fail();
    }
  }

  function equals(bool a, bool b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  function equals(bytes memory a, bytes memory b) internal {
    equals0(a, b);
  }

  function equals(bytes memory a, bytes memory b, string memory err) internal {
    equals0(a, b, err);
  }

  function equals(uint256[] memory a, uint256[] memory b) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log('Error: a == b not satisfied [uint[]]');
      emit log_named_array('      Left', a);
      emit log_named_array('     Right', b);
      fail();
    }
  }

  function equals(int256[] memory a, int256[] memory b) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log('Error: a == b not satisfied [int[]]');
      emit log_named_array('      Left', a);
      emit log_named_array('     Right', b);
      fail();
    }
  }

  function equals(address[] memory a, address[] memory b) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log('Error: a == b not satisfied [address[]]');
      emit log_named_array('      Left', a);
      emit log_named_array('     Right', b);
      fail();
    }
  }

  function equals(uint256[] memory a, uint256[] memory b, string memory err) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  function equals(int256[] memory a, int256[] memory b, string memory err) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  function equals(address[] memory a, address[] memory b, string memory err) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log_named_string('Error', err);
      equals(a, b);
    }
  }

  // Legacy helper
  function equalsUint(uint256 a, uint256 b) internal {
    equals(uint256(a), uint256(b));
  }

  function closeTo(uint256 a, uint256 b, uint256 maxDelta) internal {
    uint256 delta = stdMath.delta(a, b);

    if (delta > maxDelta) {
      emit log('Error: a ~= b not satisfied [uint]');
      emit log_named_uint('      Left', a);
      emit log_named_uint('     Right', b);
      emit log_named_uint(' Max Delta', maxDelta);
      emit log_named_uint('     Delta', delta);
      fail();
    }
  }

  function closeTo(uint256 a, uint256 b, uint256 maxDelta, string memory err) internal {
    uint256 delta = stdMath.delta(a, b);

    if (delta > maxDelta) {
      emit log_named_string('Error', err);
      closeTo(a, b, maxDelta);
    }
  }

  function closeToDecimal(uint256 a, uint256 b, uint256 maxDelta, uint256 decimals) internal {
    uint256 delta = stdMath.delta(a, b);

    if (delta > maxDelta) {
      emit log('Error: a ~= b not satisfied [uint]');
      emit log_named_decimal_uint('      Left', a, decimals);
      emit log_named_decimal_uint('     Right', b, decimals);
      emit log_named_decimal_uint(' Max Delta', maxDelta, decimals);
      emit log_named_decimal_uint('     Delta', delta, decimals);
      fail();
    }
  }

  function closeToDecimal(
    uint256 a,
    uint256 b,
    uint256 maxDelta,
    uint256 decimals,
    string memory err
  ) internal {
    uint256 delta = stdMath.delta(a, b);

    if (delta > maxDelta) {
      emit log_named_string('Error', err);
      closeToDecimal(a, b, maxDelta, decimals);
    }
  }

  function closeTo(int256 a, int256 b, uint256 maxDelta) internal {
    uint256 delta = stdMath.delta(a, b);

    if (delta > maxDelta) {
      emit log('Error: a ~= b not satisfied [int]');
      emit log_named_int('       Left', a);
      emit log_named_int('      Right', b);
      emit log_named_uint(' Max Delta', maxDelta);
      emit log_named_uint('     Delta', delta);
      fail();
    }
  }

  function closeTo(int256 a, int256 b, uint256 maxDelta, string memory err) internal {
    uint256 delta = stdMath.delta(a, b);

    if (delta > maxDelta) {
      emit log_named_string('Error', err);
      closeTo(a, b, maxDelta);
    }
  }

  function closeToDecimal(int256 a, int256 b, uint256 maxDelta, uint256 decimals) internal {
    uint256 delta = stdMath.delta(a, b);

    if (delta > maxDelta) {
      emit log('Error: a ~= b not satisfied [int]');
      emit log_named_decimal_int('      Left', a, decimals);
      emit log_named_decimal_int('     Right', b, decimals);
      emit log_named_decimal_uint(' Max Delta', maxDelta, decimals);
      emit log_named_decimal_uint('     Delta', delta, decimals);
      fail();
    }
  }

  function closeToDecimal(
    int256 a,
    int256 b,
    uint256 maxDelta,
    uint256 decimals,
    string memory err
  ) internal {
    uint256 delta = stdMath.delta(a, b);

    if (delta > maxDelta) {
      emit log_named_string('Error', err);
      closeToDecimal(a, b, maxDelta, decimals);
    }
  }

  function closeToRel(
    uint256 a,
    uint256 b,
    uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
  ) internal {
    if (b == 0) return equals(a, b); // If the left is 0, right must be too.

    uint256 percentDelta = stdMath.percentDelta(a, b);

    if (percentDelta > maxPercentDelta) {
      emit log('Error: a ~= b not satisfied [uint]');
      emit log_named_uint('        Left', a);
      emit log_named_uint('       Right', b);
      emit log_named_decimal_uint(' Max % Delta', maxPercentDelta * 100, 18);
      emit log_named_decimal_uint('     % Delta', percentDelta * 100, 18);
      fail();
    }
  }

  function closeToRel(
    uint256 a,
    uint256 b,
    uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
    string memory err
  ) internal {
    if (b == 0) return equals(a, b, err); // If the left is 0, right must be too.

    uint256 percentDelta = stdMath.percentDelta(a, b);

    if (percentDelta > maxPercentDelta) {
      emit log_named_string('Error', err);
      closeToRel(a, b, maxPercentDelta);
    }
  }

  function closeToRelDecimal(
    uint256 a,
    uint256 b,
    uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
    uint256 decimals
  ) internal {
    if (b == 0) return equals(a, b); // If the left is 0, right must be too.

    uint256 percentDelta = stdMath.percentDelta(a, b);

    if (percentDelta > maxPercentDelta) {
      emit log('Error: a ~= b not satisfied [uint]');
      emit log_named_decimal_uint('        Left', a, decimals);
      emit log_named_decimal_uint('       Right', b, decimals);
      emit log_named_decimal_uint(' Max % Delta', maxPercentDelta * 100, 18);
      emit log_named_decimal_uint('     % Delta', percentDelta * 100, 18);
      fail();
    }
  }

  function closeToRelDecimal(
    uint256 a,
    uint256 b,
    uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
    uint256 decimals,
    string memory err
  ) internal {
    if (b == 0) return equals(a, b, err); // If the left is 0, right must be too.

    uint256 percentDelta = stdMath.percentDelta(a, b);

    if (percentDelta > maxPercentDelta) {
      emit log_named_string('Error', err);
      closeToRelDecimal(a, b, maxPercentDelta, decimals);
    }
  }

  function closeToRel(int256 a, int256 b, uint256 maxPercentDelta) internal {
    if (b == 0) return equals(a, b); // If the left is 0, right must be too.

    uint256 percentDelta = stdMath.percentDelta(a, b);

    if (percentDelta > maxPercentDelta) {
      emit log('Error: a ~= b not satisfied [int]');
      emit log_named_int('        Left', a);
      emit log_named_int('       Right', b);
      emit log_named_decimal_uint(' Max % Delta', maxPercentDelta * 100, 18);
      emit log_named_decimal_uint('     % Delta', percentDelta * 100, 18);
      fail();
    }
  }

  function closeToRel(int256 a, int256 b, uint256 maxPercentDelta, string memory err) internal {
    if (b == 0) return equals(a, b, err); // If the left is 0, right must be too.

    uint256 percentDelta = stdMath.percentDelta(a, b);

    if (percentDelta > maxPercentDelta) {
      emit log_named_string('Error', err);
      closeToRel(a, b, maxPercentDelta);
    }
  }

  function closeToRelDecimal(
    int256 a,
    int256 b,
    uint256 maxPercentDelta,
    uint256 decimals
  ) internal {
    if (b == 0) return equals(a, b); // If the left is 0, right must be too.

    uint256 percentDelta = stdMath.percentDelta(a, b);

    if (percentDelta > maxPercentDelta) {
      emit log('Error: a ~= b not satisfied [int]');
      emit log_named_decimal_int('        Left', a, decimals);
      emit log_named_decimal_int('       Right', b, decimals);
      emit log_named_decimal_uint(' Max % Delta', maxPercentDelta * 100, 18);
      emit log_named_decimal_uint('     % Delta', percentDelta * 100, 18);
      fail();
    }
  }

  function closeToRelDecimal(
    int256 a,
    int256 b,
    uint256 maxPercentDelta,
    uint256 decimals,
    string memory err
  ) internal {
    if (b == 0) return equals(a, b, err); // If the left is 0, right must be too.

    uint256 percentDelta = stdMath.percentDelta(a, b);

    if (percentDelta > maxPercentDelta) {
      emit log_named_string('Error', err);
      closeToRelDecimal(a, b, maxPercentDelta, decimals);
    }
  }

  function equalsCall(address target, bytes memory callDataA, bytes memory callDataB) internal {
    equalsCall(target, callDataA, target, callDataB, true);
  }

  function equalsCall(
    address targetA,
    bytes memory callDataA,
    address targetB,
    bytes memory callDataB
  ) internal {
    equalsCall(targetA, callDataA, targetB, callDataB, true);
  }

  function equalsCall(
    address target,
    bytes memory callDataA,
    bytes memory callDataB,
    bool strictRevertData
  ) internal {
    equalsCall(target, callDataA, target, callDataB, strictRevertData);
  }

  function equalsCall(
    address targetA,
    bytes memory callDataA,
    address targetB,
    bytes memory callDataB,
    bool strictRevertData
  ) internal {
    (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);
    (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);

    if (successA && successB) {
      equals(returnDataA, returnDataB, 'Call return data does not match');
    }

    if (!successA && !successB && strictRevertData) {
      equals(returnDataA, returnDataB, 'Call revert data does not match');
    }

    if (!successA && successB) {
      emit log('Error: Calls were not equal');
      emit log_named_bytes('  Left call revert data', returnDataA);
      emit log_named_bytes(' Right call return data', returnDataB);
      fail();
    }

    if (successA && !successB) {
      emit log('Error: Calls were not equal');
      emit log_named_bytes('  Left call return data', returnDataA);
      emit log_named_bytes(' Right call revert data', returnDataB);
      fail();
    }
  }

  function and(string memory a, string memory b) internal pure returns (string memory) {
    return string.concat(a, b);
  }

  function clg(string memory str, int256 val) internal {
    emit log_named_decimal_int(str, (val), 18);
  }

  function clg(string memory str, uint256 val) internal {
    emit log_named_decimal_uint(str, (val), 18);
  }

  function clg(int256 val, string memory str) internal {
    emit log_named_decimal_int(str, (val), 18);
  }

  function clg(uint256 val, string memory str) internal {
    emit log_named_decimal_uint(str, (val), 18);
  }

  function clg(uint256 val, string memory str, uint8 dec) internal {
    emit log_named_decimal_uint(str, (val), dec);
  }
}
