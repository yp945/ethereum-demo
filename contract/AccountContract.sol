pragma solidity ^0.5.0;

contract AccountContract {
    //用户角色枚举
    enum RoleCode {
        //核心企业
        Company,
        //供应商
        Supplier,
        //金融机构
        Financial
    }
    //账户状态枚举
    enum AccountStatus { Valid, Invalid, Frozen }

    //账户创建事件
    event AccountCreated(address indexed owner, string userName, RoleCode role);

    struct AccountInfo {
        address owner;   //用户地址
        string userName;  //用户名
        string enterpriseName;//企业名称
        RoleCode role;//角色
        AccountStatus status;  //账户状态
        string certNo; //证件号码
        string acctSvcrName; //开户行名称
    }

    //用户信息集合
    mapping(address => AccountInfo) private accountInfoMap;

    //注册用户信息
    function registerAccountInfo(
        string memory userName,
        string memory enterpriseName,
        RoleCode role,
        AccountStatus status,
        string memory certNo,
        string memory acctSvcrName) public {
        require(accountInfoMap[msg.sender].owner == address(0), "Account already existed");
        accountInfoMap[msg.sender] = AccountInfo({owner:msg.sender,
            userName:userName,
            enterpriseName:enterpriseName,
            role:role,
            status:status,
            certNo:certNo,
            acctSvcrName:acctSvcrName
            });
        emit AccountCreated(msg.sender, userName, role);
    }

    //检测账户是是否存在于角色是否匹配
    modifier onlyRoleMatch(address addr, RoleCode role) {
        AccountInfo memory accountInfo = accountInfoMap[addr];
        require(addr == accountInfo.owner, "Account address is wrong or account is not existed");
        require (accountInfo.role == role, "This account role does not allow this behavior");
        _;
    }

}
