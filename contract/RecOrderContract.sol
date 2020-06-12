// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 < 0.7.0;

import "./AccountContract.sol";

contract RecOrderContract is AccountContract {

    struct RecOrder {
        address owner; //订单创建者账户地址
        string orderNo;//订单编号
        string goodsNo; //货物编号
        string receivableNo;  //应收款凭证编号
    }

    //订单编号到订单的映射
    mapping(string => RecOrder) recOrderMap;

    event RecOrderCreated(address indexed owner, string orderNo, string receivableNo);

    //创建订单
    function createRecOrder(string memory orderNo,
        string memory goodsNo,
        string memory receivableNo
    ) public onlyRoleMatch(msg.sender, RoleCode.Company) {
        recOrderMap[orderNo] = RecOrder({owner:msg.sender,
            orderNo:orderNo,
            goodsNo:goodsNo,
            receivableNo:receivableNo
            });
        emit RecOrderCreated(msg.sender, orderNo, receivableNo);
    }

}
