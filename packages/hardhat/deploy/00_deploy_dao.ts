import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

// ------------------------------------------------------------
// 00_deploy_dao.ts
// Deploys GovernanceToken first, then DAO with token address
// ------------------------------------------------------------

const deployDAO: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  console.log("\n🚀 Deploying contracts with account:", deployer);

  // 1. Deploy GovernanceToken
  const govToken = await deploy("GovernanceToken", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  console.log("✅ GovernanceToken deployed at:", govToken.address);

  // 2. Deploy DAO, passing GovernanceToken address
  const dao = await deploy("DAO", {
    from: deployer,
    args: [govToken.address],
    log: true,
    autoMine: true,
  });

  console.log("✅ DAO deployed at:", dao.address);
  console.log("\n🎉 All contracts deployed successfully!");
  console.log("--------------------------------------------");
  console.log("GovernanceToken:", govToken.address);
  console.log("DAO:            ", dao.address);
  console.log("--------------------------------------------\n");
};

export default deployDAO;

deployDAO.tags = ["GovernanceToken", "DAO"];