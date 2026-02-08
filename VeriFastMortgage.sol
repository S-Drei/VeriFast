// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title VeriFastMortgage
 * @dev Concept-level demo showing how Flare's Data Connector could be used
 *      to verify off-chain mortgage data and progress a loan application.
 *
 * Notes for demo:
 * - This contract uses mocked verification functions (pure/internal) to
 *   simulate responses that in a real Flare deployment would come from
 *   Flare's Data Connector (an off-chain oracle/orchestration service).
 * - Where mocks are used we include comments explaining how the Data
 *   Connector integration would replace them (request -> callback).
 */
contract VeriFastMortgage {
    enum Status { Submitted, Verifying, Verified, Approved }

    struct MortgageApplication {
        address applicant;
        bool identityVerified;
        bool incomeVerified;
        bool employmentVerified;
        bool creditVerified;
        bool fundsVerified;
        Status status;
        uint256 submittedAt;
    }

    mapping(uint256 => MortgageApplication) public applications;
    uint256 public nextAppId = 1;

    address public owner;
    mapping(address => bool) public lenders;

    /* Events to emit verification progress so an external UI or indexer
       can follow the application's lifecycle. */
    event ApplicationSubmitted(uint256 indexed appId, address indexed applicant);
    event VerificationRequested(uint256 indexed appId, string verificationType);
    event VerificationResult(uint256 indexed appId, string verificationType, bool result);
    event ApplicationVerified(uint256 indexed appId);
    event ApplicationApproved(uint256 indexed appId, address indexed lender);

    modifier onlyOwner() {
        require(msg.sender == owner, "owner only");
        _;
    }

    modifier onlyLender() {
        require(lenders[msg.sender], "lender only");
        _;
    }

    modifier onlyApplicant(uint256 appId) {
        require(applications[appId].applicant == msg.sender, "not applicant");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// Owner helper to register lenders for the demo
    function addLender(address _lender) external onlyOwner {
        lenders[_lender] = true;
    }

    /// Borrower submits a mortgage application; returns the app id
    function submitApplication() external returns (uint256) {
        uint256 appId = nextAppId++;
        applications[appId] = MortgageApplication({
            applicant: msg.sender,
            identityVerified: false,
            incomeVerified: false,
            employmentVerified: false,
            creditVerified: false,
            fundsVerified: false,
            status: Status.Submitted,
            submittedAt: block.timestamp
        });

        emit ApplicationSubmitted(appId, msg.sender);
        return appId;
    }

    /**
     * runVerifications
     * Demo function that triggers all verifications. In a production Flare
     * integration this function would create Data Connector requests for each
     * verification type (identity, income, employment, credit, proof of funds).
     * Flare's Data Connector would call back (via a verified callback / oracle
     * response) to set each verification flag. For the hackathon demo we
     * simulate/inline those responses with mocked functions to keep the demo
     * on-chain and synchronous.
     */
    function runVerifications(uint256 appId) external onlyApplicant(appId) {
        MortgageApplication storage app = applications[appId];
        require(app.status == Status.Submitted || app.status == Status.Verifying, "invalid status");

        app.status = Status.Verifying;

        // ---- Identity ----
        emit VerificationRequested(appId, "Identity");
        // In a real Flare integration: send a Data Connector request to an
        // identity verification provider (e.g., government ID check). The
        // Data Connector would return a signed response indicating success.
        bool idRes = _mockVerifyIdentity(app.applicant);
        app.identityVerified = idRes;
        emit VerificationResult(appId, "Identity", idRes);

        // ---- Income & Employment ----
        emit VerificationRequested(appId, "IncomeEmployment");
        // Real: Data Connector queries payroll/bank or uses Open Banking API
        // connectors and returns structured results.
        (bool incomeRes, bool empRes) = _mockVerifyIncomeAndEmployment(app.applicant);
        app.incomeVerified = incomeRes;
        app.employmentVerified = empRes;
        emit VerificationResult(appId, "Income", incomeRes);
        emit VerificationResult(appId, "Employment", empRes);

        // ---- Credit ----
        emit VerificationRequested(appId, "Credit");
        // Real: Data Connector would query credit bureaus and return a
        // confirmation or score; Data Connector ensures the response origin.
        bool creditRes = _mockVerifyCredit(app.applicant);
        app.creditVerified = creditRes;
        emit VerificationResult(appId, "Credit", creditRes);

        // ---- Proof of Funds ----
        emit VerificationRequested(appId, "Funds");
        // Real: Data Connector could connect to bank APIs or custodial
        // services to confirm balances / wallet funds.
        bool fundsRes = _mockVerifyFunds(app.applicant);
        app.fundsVerified = fundsRes;
        emit VerificationResult(appId, "Funds", fundsRes);

        // If all checks pass, update status
        if (app.identityVerified && app.incomeVerified && app.employmentVerified && app.creditVerified && app.fundsVerified) {
            app.status = Status.Verified;
            emit ApplicationVerified(appId);
        }
    }

    /**
     * approveApplication
     * Lender action to approve a verified application.
     */
    function approveApplication(uint256 appId) external onlyLender {
        MortgageApplication storage app = applications[appId];
        require(app.status == Status.Verified, "application not verified");
        app.status = Status.Approved;
        emit ApplicationApproved(appId, msg.sender);
    }

    // ------------------ Mocked verification helpers ------------------
    // These are deterministic/synchronous mocks for the hackathon demo.
    // Replace these with Data Connector request handling in production.

    function _mockVerifyIdentity(address /*applicant*/) internal pure returns (bool) {
        return true; // Always pass in demo
    }

    function _mockVerifyIncomeAndEmployment(address /*applicant*/) internal pure returns (bool, bool) {
        return (true, true); // Income & employment pass in demo
    }

    function _mockVerifyCredit(address /*applicant*/) internal pure returns (bool) {
        return true; // Credit check passes in demo
    }

    function _mockVerifyFunds(address /*applicant*/) internal pure returns (bool) {
        return true; // Proof of funds passes in demo
    }

    /**
     * getApplication
     * Helper to read application state in one call for convenience.
     */
    function getApplication(uint256 appId) external view returns (
        address applicant,
        uint256 submittedAt,
        bool identityVerified,
        bool incomeVerified,
        bool employmentVerified,
        bool creditVerified,
        bool fundsVerified,
        Status status
    ) {
        MortgageApplication storage app = applications[appId];
        return (
            app.applicant,
            app.submittedAt,
            app.identityVerified,
            app.incomeVerified,
            app.employmentVerified,
            app.creditVerified,
            app.fundsVerified,
            app.status
        );
    }
}
