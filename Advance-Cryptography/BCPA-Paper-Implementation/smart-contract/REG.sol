// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract REG {
    address public owner;
    uint256 public regLen;

    struct REGEntry {
        uint8       entityType;
        bytes32     pid;
        uint256[2]  publicKey;
        bool        tag;
    }

    REGEntry[] public regEntries;
    mapping(bytes32 => bool)    public pidExists;
    mapping(bytes32 => uint256) public pidToIndex;

    event EntityRegistered(uint8 entityType, bytes32 pid);
    event EntityRevoked(bytes32 pid);

    constructor() {
        owner  = msg.sender;
        regLen = 0;
    }

    function insertReg(
        uint8 entityType,
        bytes32 pid,
        uint256[2] memory pk
    ) public returns (uint8) {
        require(msg.sender == owner,
                "Only AO can register");
        if (pidExists[pid]) {
            return 0;
        }
        regEntries.push(REGEntry({
            entityType: entityType,
            pid:        pid,
            publicKey:  pk,
            tag:        true
        }));
        pidToIndex[pid] = regLen;
        pidExists[pid]  = true;
        regLen++;
        emit EntityRegistered(entityType, pid);
        return 1;
    }

    function retrieveReg(
        uint8   entityType,
        bytes32 pid
    ) public view returns (uint256[2] memory pk, bool found) {
        if (!pidExists[pid]) {
            return ([uint256(0), uint256(0)], false);
        }
        REGEntry storage entry = regEntries[pidToIndex[pid]];
        if (!entry.tag) {
            return ([uint256(0), uint256(0)], false);
        }
        return (entry.publicKey, true);
    }

    function disableReg(
        uint8   entityType,
        bytes32 pid
    ) public returns (uint8) {
        require(msg.sender == owner,
                "Only AO can revoke");
        if (!pidExists[pid]) {
            return 0;
        }
        regEntries[pidToIndex[pid]].tag = false;
        emit EntityRevoked(pid);
        return 1;
    }
}