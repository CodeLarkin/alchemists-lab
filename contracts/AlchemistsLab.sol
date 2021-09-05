import "@openzeppelin/contracts/utils/Strings.sol";
import "./Alchs.sol";


contract AlchemistsLab {

    constructor(address alchemistsContract) {
        alchemists = Alchs(alchemistsContract);
    }

    Alchs public alchemists;

    uint256 constant public maxAlchemists = 69420;

    uint8 constant public numProperties = 20;

    string[numProperties] private propertyKeys = [
        "AFFI"  ,
        "INT"   ,
        "APT"   ,
        "STR"   ,
        "AGI"   ,
        "SPD"   ,
        "CHEM"  ,
        "AALT"  ,
        "DRAG"  ,
        "LHAND" ,
        "RHAND" ,
        "LARM"  ,
        "RARM"  ,
        "LPOCK" ,
        "RPOCK" ,
        "WALLET",
        "HAIR"  ,
        "EYES"  ,
        "SKINT" ,
        "SKIND"
    ];

    uint8 constant public numStats = 5;
    string[numStats] private statKeys = [
        "INT"   ,
        "APT"   ,
        "STR"   ,
        "AGI"   ,
        "SPD"
    ];
    uint8 constant public numComps = 3;
    string[numComps] private compKeys = [
        "CHEM" ,
        "AALT" ,
        "DRAG"
    ];
    uint8 constant public numBeauts = 4;
    string[numBeauts] private beautyKeys = [
        "HAIR"  ,
        "EYES"  ,
        "SKINT" ,
        "SKIND"
    ];
    uint8 constant public numEquips = 7;
    string[numEquips] private equipKeys = [
        "LHAND" ,
        "RHAND" ,
        "LARM"  ,
        "RARM"  ,
        "LPOCK" ,
        "RPOCK" ,
        "WALLET"
    ];

    struct Alchemist {
        uint256 tokenId;
        bool    owned;
        address owner;
        string  AFFI;
        string  INT;
        string  APT;
        string  STR;
        string  AGI;
        string  SPD;
        string  CHEM;
        string  AALT;
        string  DRAG;
        string  LHAND;
        string  RHAND;
        string  LARM;
        string  RARM;
        string  LPOCK;
        string  RPOCK;
        string  WALLET;
        string  HAIR;
        string  EYES;
        string  SKINT;
        string  SKIND;
        string  SKINC;
    }

    struct AlchemistTiers {
        string  AFFI;
        string  INT;
        string  APT;
        string  STR;
        string  AGI;
        string  SPD;
        string  CHEM;
        string  AALT;
        string  DRAG;
        string  LHAND;
        string  RHAND;
        string  LARM;
        string  RARM;
        string  LPOCK;
        string  RPOCK;
        string  WALLET;
        string  HAIR;
        string  EYES;
        string  SKINT;
        string  SKIND;
    }

    struct TierCounts {
        uint256 leg;
        uint256 epic;
        uint256 rare;
        uint256 base;
    }

    function alchemistsForOwner(address owner) public view returns (uint256[] memory) {
        uint256 numOwned = alchemists.balanceOf(owner);
        uint256[] memory results = new uint256[](numOwned);
        for (uint256 i = 0; i < numOwned; i++) {
            results[i] = alchemists.tokenOfOwnerByIndex(owner, i);
        }
        return results;
    }

    function alchemistOwned(uint256 tokenId) public view returns (bool, address) {
        try alchemists.ownerOf(tokenId) returns (address owner) {
            return (true, owner);
        } catch Error(string memory /*reason*/) {
            return (false, address(0));
        }
    }

    function fullSolidityAlchemist(uint256 tokenId) public view returns (Alchemist memory) {
        // ... Full Solidity Alchemist ...
        (bool owned, address owner) = alchemistOwned(tokenId);
        return Alchemist(
                         tokenId ,
                         owned   ,
                         owner   ,
                         alchemists.getAffinity(tokenId)              ,
                         alchemists.getStat(tokenId, 'INT')           ,
                         alchemists.getStat(tokenId, 'APT')           ,
                         alchemists.getStat(tokenId, 'STR')           ,
                         alchemists.getStat(tokenId, 'AGI')           ,
                         alchemists.getStat(tokenId, 'SPD')           ,
                         alchemists.getComprehension(tokenId, "CHEM") ,
                         alchemists.getComprehension(tokenId, "AALT") ,
                         alchemists.getComprehension(tokenId, "DRAG") ,
                         alchemists.getHand(tokenId, true)            ,
                         alchemists.getHand(tokenId, false)           ,
                         alchemists.getArm(tokenId, true)             ,
                         alchemists.getArm(tokenId, false)            ,
                         alchemists.getPocket(tokenId, true)          ,
                         alchemists.getPocket(tokenId, false)         ,
                         alchemists.getWallet(tokenId)                ,
                         alchemists.getHairColor(tokenId)             ,
                         alchemists.getEyeColor(tokenId)              ,
                         alchemists.getSkinTone(tokenId)              ,
                         alchemists.getSkinDarkness(tokenId)          ,
                         alchemists.getSkinColor(tokenId)
                        );
    }

    // DUPLICATE of function in Alchemists.sol
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    // DUPLICATE of function in Alchemists.sol
    function getGreatness(uint256 tokenId, string memory keyPrefix) internal pure returns (uint256) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
        uint256 greatness = rand % 21;
        return(greatness);
    }
    // DUPLICATE of function in Alchemists.sol
    function getTier (uint tokenId, string memory keyPrefix) internal pure returns (string memory) {
        uint256 greatness = getGreatness(tokenId, keyPrefix);
        if (greatness > 19) {
            return "leg";
        } else {
            if (greatness > 18) {
                return "epic";
            } else {
                if (greatness > 14) {
                    return "rare";
                } else {
                    return "base";
                }
            }
        }
    }

    function tiers(uint256 tokenId) public view returns (AlchemistTiers memory) {
        return AlchemistTiers(
            getTier(tokenId, "AFFI"),
            getTier(tokenId, "INT"),
            getTier(tokenId, "APT"),
            getTier(tokenId, "STR"),
            getTier(tokenId, "AGI"),
            getTier(tokenId, "SPD"),
            getTier(tokenId, "CHEM"),
            getTier(tokenId, "AALT"),
            getTier(tokenId, "DRAG"),
            getTier(tokenId, "LHAND"),
            getTier(tokenId, "RHAND"),
            getTier(tokenId, "LARM"),
            getTier(tokenId, "RARM"),
            getTier(tokenId, "LPOCK"),
            getTier(tokenId, "RPOCK"),
            getTier(tokenId, "WALLET"),
            getTier(tokenId, "HAIR"),
            getTier(tokenId, "EYES"),
            getTier(tokenId, "SKINT"),
            getTier(tokenId, "SKIND")
        );
    }

    function isLegendary(string memory tier) private view returns (bool) {
        return keccak256(abi.encodePacked((tier))) == keccak256(abi.encodePacked(("leg")));
    }

    function isEpic(string memory tier) private view returns (bool) {
        return keccak256(abi.encodePacked((tier))) == keccak256(abi.encodePacked(("epic")));
    }

    function isRare(string memory tier) private view returns (bool) {
        return keccak256(abi.encodePacked((tier))) == keccak256(abi.encodePacked(("rare")));
    }

    function affinityTier(uint256 tokenId) public view returns (string memory) {
        string memory tier = getTier(tokenId, "AFFI");
        return tier;
    }
    function tierCounts(uint256 tokenId) public view returns (TierCounts memory) {
        uint8 legs  = 0;
        uint8 epics = 0;
        uint8 rares = 0;
        uint8 bases = 0;

        for (uint8 i = 0; i < numProperties; i++) {
            string memory tier = getTier(tokenId, propertyKeys[i]);
            if (isLegendary(tier)) {
                legs++;
            } else if (isEpic(tier)) {
                epics++;
            } else if (isRare(tier)) {
                rares++;
            } else {
                bases++;
            }
        }
        return TierCounts(legs, epics, rares, bases);
    }
    function statTierCounts(uint256 tokenId) public view returns (TierCounts memory) {
        uint8 legs  = 0;
        uint8 epics = 0;
        uint8 rares = 0;
        uint8 bases = 0;

        for (uint8 i = 0; i < numStats; i++) {
            string memory tier = getTier(tokenId, statKeys[i]);
            if (isLegendary(tier)) {
                legs++;
            } else if (isEpic(tier)) {
                epics++;
            } else if (isRare(tier)) {
                rares++;
            } else {
                bases++;
            }
        }
        return TierCounts(legs, epics, rares, bases);
    }
    function compTierCounts(uint256 tokenId) public view returns (TierCounts memory) {
        uint8 legs  = 0;
        uint8 epics = 0;
        uint8 rares = 0;
        uint8 bases = 0;

        for (uint8 i = 0; i < numComps; i++) {
            string memory tier = getTier(tokenId, compKeys[i]);
            if (isLegendary(tier)) {
                legs++;
            } else if (isEpic(tier)) {
                epics++;
            } else if (isRare(tier)) {
                rares++;
            } else {
                bases++;
            }
        }
        return TierCounts(legs, epics, rares, bases);
    }
    function beautyTierCounts(uint256 tokenId) public view returns (TierCounts memory) {
        uint8 legs  = 0;
        uint8 epics = 0;
        uint8 rares = 0;
        uint8 bases = 0;

        for (uint8 i = 0; i < numBeauts; i++) {
            string memory tier = getTier(tokenId, beautyKeys[i]);
            if (isLegendary(tier)) {
                legs++;
            } else if (isEpic(tier)) {
                epics++;
            } else if (isRare(tier)) {
                rares++;
            } else {
                bases++;
            }
        }
        return TierCounts(legs, epics, rares, bases);
    }
    function equipmentTierCounts(uint256 tokenId) public view returns (TierCounts memory) {
        uint8 legs  = 0;
        uint8 epics = 0;
        uint8 rares = 0;
        uint8 bases = 0;

        for (uint8 i = 0; i < numEquips; i++) {
            string memory tier = getTier(tokenId, equipKeys[i]);
            if (isLegendary(tier)) {
                legs++;
            } else if (isEpic(tier)) {
                epics++;
            } else if (isRare(tier)) {
                rares++;
            } else {
                bases++;
            }
        }
        return TierCounts(legs, epics, rares, bases);
    }
}
