import React from "react";
import { useState, useEffect } from "react";
import { Link } from 'react-router-dom';
import { web3, signer, GameContract, Connected, Connect } from "./Connect.jsx";
import BN from "bn.js";
import Popup from 'reactjs-popup';

function NewGame({ onData, gameState, levelInfo, gState, players }) {

	const [newGame, setNewGame] = useState({"set":false, "get":false, 
								  "level": null, "code": null, "data": null});

	useEffect(() => {
		if (Connected == true) {
		}
	}, [Connected]);

	useEffect(() => {
		if (Connected == true) {
			console.log("In EFFECT:level", levelInfo.levelNum);
			console.log("levelCODE:", levelInfo.levelCode);
			console.log("levelDATA:", levelInfo.levelData);
			console.log("gameState:",gameState);
			console.log("newGame:", newGame);

			if (levelInfo.levelNum && (newGame.set == true) &&
				(gameState == gState.newGameStarted)) {
				setNewGame({...newGame, "set": true, 
							"level": parseInt(levelInfo.levelNum),
							"code": levelInfo.levelCode, 
							"data": levelInfo.levelData});
				requestLevelData(levelInfo.levelCode);
			}
		}
	}, [levelInfo]);	


	async function startNewGame(num, bidder) {
		console.log("startNewGame:", bidder);

		await GameContract.methods.newGame(num, bidder)
			.send({from: signer, gas: 300000})
			.then((result) => {
				console.log("result:", result);
			});
	}

	async function requestLevelData(addr) {
		// Call "fetchLevelData()returns(bytes memory)" in Level 1
		const fetchLevelData = web3.eth.abi.encodeFunctionCall({
		    name: 'fetchLevelData',
		    type: 'function',
		    inputs: []
		}, []);

		console.log("in Request data:", typeof(addr));
		// Level Contract address + Encoded Function
		const callData = web3.eth.abi.encodeParameters(['address','bytes'], 
			[addr, fetchLevelData]);
		
		await GameContract.methods.callLevel(callData)
			.call({from: signer, gas: 100000})
			.then((data) => {
				data.data = data.data.split("0x")[1];
				let len = parseInt(data.data.slice(126,128), 16);
				let dataArr = new BN(data.data.slice(128, 128+2*len), 16).toArray();
				let levelNum = parseInt(dataArr.slice(0, 1), 16);
				let state, symbols;
				if (levelNum == 1) {
					state = dataArr.slice(1, 10);
					symbols = [new BN(dataArr.slice(10, 14), 16).toNumber(),
									new BN(dataArr.slice(14, 18), 16).toNumber()];					
					onData({levelNum, state, symbols});
				} else if (levelNum == 2) {
					state = dataArr.slice(1, 82);
					symbols = [new BN(dataArr.slice(82, 86), 16).toNumber(),
									new BN(dataArr.slice(86, 90), 16).toNumber(),
									new BN(dataArr.slice(90, 94), 16).toNumber(),
									new BN(dataArr.slice(94, 100), 16).toNumber()];					
					onData({levelNum, state, symbols});
				}
			});
	}

    function displayLevel() {
        window.open("https://remix.ethereum.org/");
    }

    async function loadLevel (bidder) {
        setNewGame({...newGame, "get": false, "set": true});
        setTimeout(async () => await startNewGame(1, bidder), 500);
    }

;	return (<div>
				<button className='newgame-button'
				onClick={(newGame.set == true) ? displayLevel :
				async () => { if (Connected == true) { setNewGame({...newGame, "get": true}) }}}>
				{(newGame.set == true)? `Level ${newGame.level}`:"NewGame"}
		    	</button>
			    <Popup open={(newGame.get == true)} modal>
			    	{() => (<h1><input className='loadlevel-popup' type="text"
			    		placeholder="Level proposer's address"
			    		onChange={async(event) => {
			    			loadLevel(event.target.value)
			    		}}/></h1>)}
			    </Popup>
		    </div>
	);
}

export default NewGame;
