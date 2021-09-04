import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

abstract contract Alchs is ERC721Enumerable, ReentrancyGuard, Ownable {

    //mapping (string => string[6]) darknessToHexArray;

    function getStat(uint256 tokenId, string memory stat) public view virtual returns (string memory);

    function getComprehension(uint256 tokenId, string memory comprehension) public view virtual returns (string memory);

    function getAffinity(uint256 tokenId) public view virtual returns (string memory);

    function getHand(uint256 tokenId, bool isLeft) public view virtual returns (string memory);

    function getArm(uint256 tokenId, bool isLeft) public view virtual returns (string memory);

    function getPocket(uint256 tokenId, bool isLeft) public view virtual returns (string memory);

    function getWallet(uint256 tokenId) public view virtual returns (string memory);

    function getHairColor(uint256 tokenId) public view virtual returns (string memory);

    function getEyeColor(uint256 tokenId) public view virtual returns (string memory);

    function getSkinTone(uint256 tokenId) public view virtual returns (string memory);

    function getSkinDarkness(uint256 tokenId) public view virtual returns (string memory);

    //mapping (string => string) compKeyToName;


    function getSkinDarknessPrePlucked(uint256 tokenId) public view virtual returns (string memory);

    function getSkinTonePrePlucked(uint256 tokenId) public view virtual returns (uint256);

    function getSkinColor(uint256 tokenId) public view virtual returns (string memory);

    //function tokenURI(uint256 tokenId) override public view virtual returns (string memory);

    //function claimFree(uint256 tokenId) public nonReentrant;

    //function claimPaid(uint256 tokenId) public nonReentrant payable;
}
