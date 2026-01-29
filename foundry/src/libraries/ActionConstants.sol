// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title Action Constants
/// @notice アクションで使用される共通の定数
/// @dev 定数はリテラル値に比べてガス効率が良い代替手段です
library ActionConstants {
    /// @notice プールマネージャーのopen deltaの入力値、またはコントラクトが保持する残高を使用することを示すために使用されます
    uint128 internal constant OPEN_DELTA = 0;
    /// @notice アクションがコントラクトの通貨の全残高を使用することを示すために使用されます
    /// この値は1<<255に相当し、最上位ビットに単一の1があります
    uint256 internal constant CONTRACT_BALANCE =
        0x8000000000000000000000000000000000000000000000000000000000000000;

    /// @notice アクションの受取人がmsgSenderであることを示すために使用されます
    address internal constant MSG_SENDER = address(1);

    /// @notice アクションの受取人がaddress(this)であることを示すために使用されます
    address internal constant ADDRESS_THIS = address(2);
}
