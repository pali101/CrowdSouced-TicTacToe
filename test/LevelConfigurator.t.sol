// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import "src/LevelConfigurator.sol";

contract TestLevelConfigurator is Test {

    function setUp() public {
        //levelConfig = new LevelConfigurator();
    }

    // Test if the contract was created properly
    function test_levelCofigurator() external {

    }

    // Generates sample level code
    function _generateLevelCode(uint8 _num) internal 
        returns (bytes memory _levelCode) {

        // Level 1 contract init code (w/o constructore arguments)
        if (_num == 1) {
            _levelCode = hex"600460030160005260206000f3"; 
        }
        else if (_num == 2) {
            _levelCode = hex"600460030160005260206000f3"; 
        }        
    }

    // Generates level number
    function _generateLevelNum(uint8 _num) internal 
        returns (bytes memory _levelNum) {

        if (_num == 1)
            _levelNum = abi.encode(_num);
        else if (_num == 2) 
            _levelNum = abi.encode(_num);
    }

    // Generates state for a level
    function _generateState(uint8 _num) internal 
        returns (bytes memory _levelState) {

    if (_num == 1)
            _levelState = hex"010000000000000002";
        else if (_num == 2)
            _levelState = hex"020000000000000003"
                          hex"000300000000000001"
                          hex"010200000000000000"
                          hex"000001000000000200"
                          hex"000000000200010000"            
                          hex"000000020001000000"
                          hex"000002000100000000"
                          hex"000000010002000000"
                          hex"000000000000020100";
    }

    // Generates symbols for a level
    function _generateSymbols(uint8 _num) internal 
        returns (bytes memory _levelSymbols) {
        bytes4 X = unicode"❌";
        bytes4 O = unicode"⭕";            
        bytes4 Star = unicode"⭐";
        bytes4 Bomb = unicode"💣";

        if (_num == 1) {
            _levelSymbols = abi.encodePacked(X, O);
        }
        else if (_num == 2) {
            _levelSymbols = abi.encodePacked(X, O, Star, Bomb);
        }
    }

    // Test the level proposal submitted by Bidder
    function test_initLevel() external {

        // Should clears initial checks for code, level number, 
        // state length and state symbol length for Level 1
        LevelConfigurator levelConfig1 = new LevelConfigurator();
        bytes memory code1 = _generateLevelCode(1);
        bytes memory levelNum1 = _generateLevelNum(1);
        bytes memory levelState1 = _generateState(1);
        bytes memory levelSymbols1 = _generateSymbols(1);

        levelConfig1.initLevel(code1, levelNum1, levelState1, levelSymbols1);


        // Should clears initial checks for code, level number, 
        // state length and state symbol length for Level 2
        LevelConfigurator levelConfig2 = new LevelConfigurator();
        bytes memory code2 = _generateLevelCode(2);
        bytes memory levelNum2 = _generateLevelNum(2);
        bytes memory levelState2 = _generateState(2);
        bytes memory levelSymbols2 = _generateSymbols(2);

        levelConfig2.initLevel(code2, levelNum2, levelState2, levelSymbols2);


       // Should fail initial checks for code, level number, 
        // state length and state symbol length for Level 1 if
        // state length is wrong
        LevelConfigurator levelConfig3 = new LevelConfigurator();
        bytes memory code3 = _generateLevelCode(1);
        bytes memory levelNum3 = _generateLevelNum(1);
        bytes memory levelState3 = _generateState(2);
        bytes memory levelSymbols3 = _generateSymbols(1);

        vm.expectRevert();
        levelConfig3.initLevel(code3, levelNum3, levelState3, levelSymbols3);


        // Should fail initial checks for code, level number, 
        // state length and state symbol length for Level 2 if
        // state symbols is wrong
        LevelConfigurator levelConfig4 = new LevelConfigurator();
        bytes memory code4 = _generateLevelCode(2);
        bytes memory levelNum4 = _generateLevelNum(2);
        bytes memory levelState4 = _generateState(2);
        bytes memory levelSymbols4 = _generateSymbols(3);

        vm.expectRevert();
        levelConfig4.initLevel(code4, levelNum4, levelState4, levelSymbols4);

    }

    // Test State contents
    function test__checkStateValidity() external {

        // Should clear check for level 1 with X and O
/*        bytes memory state1 = _generateState(1);
        bytes memory symbols1 = _generateSymbols(1);

        LevelConfigurator levelConfig1 = new LevelConfigurator();
        levelConfig1._checkStateValidity(1, state1, symbols1);


        // Should clear check for level 2 with X and O
        bytes memory state2 = _generateState(2);
        bytes memory symbols2 = _generateSymbols(1);

        LevelConfigurator levelConfig2 = new LevelConfigurator();
        levelConfig2._checkStateValidity(2, state2, symbols2);
*/
        // Should clear check for level 2 with X and O
        bytes memory state2 = _generateState(2);
        bytes memory symbols2 = _generateSymbols(2);

        LevelConfigurator levelConfig2 = new LevelConfigurator();
        levelConfig2._checkStateValidity(2, state2, symbols2);        
    }
}