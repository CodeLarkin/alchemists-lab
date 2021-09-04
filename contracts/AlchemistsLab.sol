//import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./Alchs.sol";
import "hardhat/console.sol";

contract AlchemistsLab {
    Alchs public alchemists;

    constructor(address alchemistsContract) {
        alchemists = Alchs(alchemistsContract);
    }
    function alchemistsForOwner(address owner) public view returns (uint256[] memory) {
        uint256 numOwned = alchemists.balanceOf(owner);
        //console.log("Owned: %s", numOwned);
        uint256[] memory results = new uint256[](numOwned);
        for (uint256 i = 0; i < numOwned; i++) {
            results[i] = alchemists.tokenOfOwnerByIndex(owner, i);
        }
        return results;
    }

}
