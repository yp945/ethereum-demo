pragma solidity ^0.5.0;

import "./RecOrderContract.sol";

contract ReceivableContract is RecOrderContract {

    //应收款状态
    enum ReceivableStatus {
        //待承兑
        UnAccepted,
        //已承兑
        Accepted,
        //未贴现
        UnDiscounted,
        //已贴现
        Discounted,
        //已兑付
        Redeemed
    }

    struct Receivable {
        string receivableNo;//应收款编号
        string orderNo;//订单编号
        address owner; //应收账款持有者
        address acceptor; //承兑人账号
        uint256 discountApplyAmount;//贴现申请金额
        ReceivableStatus status; //应收款状态
    }

    mapping(string => Receivable) receivableMap;

    event SignedReceivable(string orderNo, string receivableNo, address indexed owner);
    event ReceivableStatusChange(string receivableNo, ReceivableStatus statusBefore, ReceivableStatus statusNow);
    event TransferredReceivable(string receivableNo, address indexed oldOwner, address indexed newOwner);

    //应收账款签发
    function signReceivable(string memory orderNo, uint256 discountApplyAmount) public
    onlyRoleMatch(msg.sender, RoleCode.Supplier) {
        (string memory receivableNo, address acceptor) = getRecOrderInfo(orderNo);
        require(receivableMap[receivableNo].owner == address(0), "Receivable already signed");
        receivableMap[receivableNo] = Receivable({
            receivableNo: receivableNo,
            orderNo: orderNo,
            owner: msg.sender,
            acceptor:acceptor,
            discountApplyAmount:discountApplyAmount,
            status:ReceivableStatus.UnAccepted
            });
        emit SignedReceivable(orderNo, receivableNo, msg.sender);
    }

    //应收账款承兑
    function acceptReceivable(string memory receivableNo) public onlyRoleMatch(msg.sender, RoleCode.Company) {
        Receivable memory receivable = receivableMap[receivableNo];
        require(receivable.acceptor == msg.sender, "The receivable does not exist or the acceptor is wrong");
        require(receivable.status == ReceivableStatus.UnAccepted, "The status of the receivable is incorrect");
        receivableMap[receivableNo].status = ReceivableStatus.Accepted;
        emit ReceivableStatusChange(receivableNo, ReceivableStatus.UnAccepted, ReceivableStatus.Accepted);
    }

    //应收账款凭证转移
    function transferReceivable(string memory receivableNo, address newOwner) public
    onlyRoleMatch(msg.sender, RoleCode.Supplier) onlyRoleMatch(newOwner, RoleCode.Supplier)  {
        Receivable memory receivable = receivableMap[receivableNo];
        require(msg.sender == receivable.owner, "Receivable can only transfer by owner");
        require(receivableMap[receivableNo].status == ReceivableStatus.Accepted, "Can only transfer when receivable status is Accepted");
        receivableMap[receivableNo].owner = newOwner;
        emit TransferredReceivable(receivableNo, msg.sender, newOwner);
    }

    //应收账款申请贴现
    function applyDiscount(string memory receivableNo) public onlyRoleMatch(msg.sender, RoleCode.Supplier) {
        Receivable memory receivable = receivableMap[receivableNo];
        require(msg.sender == receivable.owner, "Receivable can only applyDiscount by owner");
        require(receivable.status == ReceivableStatus.Accepted, "The receivable does not exist or status is incorrect");
        receivableMap[receivableNo].status = ReceivableStatus.UnDiscounted;
        emit ReceivableStatusChange(receivableNo, ReceivableStatus.Accepted, ReceivableStatus.UnDiscounted);
    }

    //应收账款贴现
    function discountConfirm(string memory receivableNo) public onlyRoleMatch(msg.sender, RoleCode.Financial) {
        Receivable memory receivable = receivableMap[receivableNo];
        require(receivable.status == ReceivableStatus.UnDiscounted, "The receivable does not exist or status is incorrect");
        receivableMap[receivableNo].status = ReceivableStatus.Discounted;
        receivableMap[receivableNo].owner = msg.sender;
        emit ReceivableStatusChange(receivableNo, ReceivableStatus.UnDiscounted, ReceivableStatus.Discounted);
    }

    //应收账款兑付
    function redeemed(string memory receivableNo) public onlyRoleMatch(msg.sender, RoleCode.Company) {
        Receivable memory receivable = receivableMap[receivableNo];
        require(receivable.status == ReceivableStatus.Discounted, "The receivable does not exist or status is incorrect");
        require(receivable.acceptor == msg.sender, "Only acceptors can redeem");
        receivableMap[receivableNo].status = ReceivableStatus.Redeemed;
        receivableMap[receivableNo].owner = msg.sender;
        emit ReceivableStatusChange(receivableNo, ReceivableStatus.Discounted, ReceivableStatus.Redeemed);
    }

    //获取应收款凭证编号
    function getRecOrderInfo(string memory orderNo) private view returns (
        string memory receivableNo,
        address owner
    ) {
        RecOrder memory recOrder = recOrderMap[orderNo];
        require(recOrder.owner != address(0), "RecOrder not existed");
        return (recOrder.receivableNo, recOrder.owner);
    }

}
