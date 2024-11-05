// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.27;
import "forge-std/console.sol";

// Base State
contract BaseStateD {

	//		C0  C1  ..  Cn
	// R0 | _ | _ | _ | _ | 
	// R1 | _ | _ | _ | _ |
	// .. |   |   |   |	  |
	// Rn | _ | _ | _ | _ |

	struct State {
		uint256[][] v;
	}

	// State (Slot1)
	State board;

	// Updates the base state data to the callers
	// context when delegated
	function copyState(State memory _state) public virtual returns(bool success) {
		assembly {
			let d
			// Fetch dimension
			let ptr := mload(_state)
			let len := mload(ptr)

			// Revert if length is not 9 for Level 1
			// Revert if length is not 81 for Level 2
			switch len
			case 3 { d := 3 }
			case 9 { d := 9 }
			default {
				revert(0, 0)
			}

			ptr := add(ptr, 0x20)

			// Find length of next 3 arrays
			// and compare with dimension,
			// all should be 3 
			for { let i := 0 } lt(i, d) { i := add(i, 1) } {

				ptr := mload(add(ptr, mul(i, 0x20)))			
				len := mload(ptr)
				if iszero(eq(len, d)) {
					revert (0, 0)
				}

				ptr := add(ptr, 0x20)

				for { let j := 0 let v := 0 let s := 0 let p := 0 let q := 0 } 
					lt(j, d) { j := add(j, 1) } {

					 // Calculate the slot and store					
					 v := mload(add(ptr, mul(j, 0x20)))
					 p := mload(0x40)
					 mstore(p, board.slot)
					 q := mload(0x40)
					 mstore(q, add(keccak256(p, 0x20), i))
					 s := add(keccak256(q, 0x20), j)
					 sstore(s, v)
				}
			}
		}
		success = true;
	}

    function getState(uint8 row, uint8 col) internal view returns (uint256 val) {

        assembly {
            let ptr := mload(0x40)
            mstore(ptr, board.slot)
            let s := mload(0x40)
            mstore(s, add(keccak256(ptr, 0x20), row))
            val := sload(add(keccak256(s, 0x20), col))
        }
    }

	// To be overriden by level
    function supportedStates() public pure virtual returns (bytes memory) {
	}
}
