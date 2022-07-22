// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

error NotOwner();

contract Elections {
    address public immutable OWNER;
    address[] public ElectionCommittee;
    

    struct candidate {
        bytes32 name;
        uint256 VoteCount;
    }

    candidate[] public ListOfCandidates;

    constructor(bytes32[] memory Candidates) {
        OWNER = msg.sender;
        ElectionCommittee[0] = OWNER;
        for(uint256 i=0; i< Candidates.length; i++){
            ListOfCandidates.push(candidate({
                name: Candidates[i],
                VoteCount: 0
            }));
        }
    }

    function AppointMemberOfElectionCommittee(address Member) public onlyOwner {
        ElectionCommittee.push(Member);
    }

    modifier onlyOwner {
        if( msg.sender != OWNER) { revert NotOwner();}
        _;
    }
}
