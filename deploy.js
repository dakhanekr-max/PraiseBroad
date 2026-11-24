const hre = require("hardhat");
const fs = require("fs");
async function main() {
  const [deployer] = await hre.ethers.getSigners();
  // Ifeoma's address receives the funds; defaults to the deployer for the lab.
  const owner = process.env.OWNER_ADDRESS || deployer.address;
  const c = await hre.ethers.deployContract("PraiseBoard", [owner]);
  await c.waitForDeployment();
  const addr = await c.getAddress();
  const block = (await c.deploymentTransaction().wait()).blockNumber;
  fs.writeFileSync("deployed.json", JSON.stringify({ address: addr, block, chainId: 11155111 }, null, 2));
  console.log("PraiseBoard deployed:", addr, "block", block, "owner", owner);
}
main().catch(e => { console.error(e); process.exit(1); });
