const { expect } = require("chai");

const { ethers, waffle } = hre;
const { BigNumber, utils } = ethers;
const { constants, expectRevert } = require('@openzeppelin/test-helpers')


/******************************************************************************
 * Logging functions, log-level EnumS, and LOG_LEVEL setting
 ******************************************************************************/
const WARN  = 1
const INFO  = 2
const DEBUG = 3
const ULTRA = 4

// SET LOG_LEVEL HERE - Change log level to control verbosity
const LOG_LEVEL = DEBUG

const logging = {
    warn: function(...args) {
        if (LOG_LEVEL >= WARN) {
            console.log(...args)
        }
    },
    info: function(...args) {
        if (LOG_LEVEL >= INFO) {
            console.log(...args)
        }
    },
    debug: function(...args) {
        if (LOG_LEVEL >= DEBUG) {
            console.log(...args)
        }
    },
    ultra: function(...args) {
        if (LOG_LEVEL >= ULTRA) {
            console.log(...args)
        }
    },
}


/******************************************************************************
 * Hardhat Tests for the AlchemistsLab
 ******************************************************************************/
describe("AlchemistsLab", function () {
    let alice;
    let bobby;
    let carly;

    it("Alchemists blahhh", async function () {
        [alice, bobby, carly, dobby, erkle] = await ethers.getSigners()
        const wallets = [alice, bobby, carly, dobby, erkle];

        // Deploy Alchemists
        const Alchemists = await ethers.getContractFactory("Alchemists", alice)
        const alchemists = await Alchemists.deploy()
        await alchemists.deployed()

        const AlchemistsLab = await ethers.getContractFactory("AlchemistsLab", bobby)
        const alchemistsLab = await AlchemistsLab.deploy(alchemists.address)
        await alchemistsLab.deployed()

        const maxFree = 10;
        const maxPerWallet = 10;
        // TODO confirm 0 is supposed to be invalid ID
        for (let w = 0; w < wallets.length; w++) {
            const wallet = wallets[w]
            for (let i = 0; i < maxPerWallet; i++) {
                const tokenId = (w * maxPerWallet) + i + 1;
                logging.ultra("Wallet %s is minting tokenId %s", w, tokenId)
                await alchemists.connect(wallet).claimFree(tokenId)
                expect(await alchemists.connect(wallet).ownerOf(tokenId)).to.equal(wallet.address)
            }
        }

        for (let w = 0; w < wallets.length; w++) {
            const wallet = wallets[w]
            // using random wallet to connect to here
            let ownedAlchemists = await alchemistsLab.connect(erkle).alchemistsForOwner(wallet.address)
            logging.debug("Wallet %s owns %s Alchemists", w, ownedAlchemists.length)
            expect(ownedAlchemists.length).to.equal(maxPerWallet)
            for (let i = 0; i < ownedAlchemists.length; i++) {
                const tokenId = (w * maxPerWallet) + i + 1;
                logging.ultra("Wallet %s's Alchemist number %s: %s", w, ownedAlchemists[i])
                expect(ownedAlchemists[i]).to.equal(tokenId)
            }
        }
        
        let alchemist1 = await alchemistsLab.fullSolidityAlchemist(1);
        logging.debug(alchemist1);
        let tiers = await alchemistsLab.tiers(1);
        logging.debug(tiers);
        let tierCounts = await alchemistsLab.tierCounts(1);
        logging.debug(tierCounts);
    });
});
