// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimplePollingStation {
    struct Candidate {
        string name;      
        uint voteCount;
    }
    
    Candidate[] public candidates;

    mapping(address => uint) public voterChoice;
    mapping(address => bool) public hasVoted;
 
    function addCandidate(string memory _name) public {
        candidates.push(Candidate({
            name: _name,
            voteCount: 0
        }));
    }


    function vote(uint candidateIndex) public {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        require(!hasVoted[msg.sender], "You already voted!");

        hasVoted[msg.sender] = true;
        voterChoice[msg.sender] = candidateIndex;

        candidates[candidateIndex].voteCount += 1;
    }

    
    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }

    // Get details of a candidate
    function getCandidate(uint index) public view returns (string memory, uint) {
        require(index < candidates.length, "Invalid candidate index");
        Candidate storage c = candidates[index];
        return (c.name, c.voteCount);
    }
}
