# ethereum-demo

以太坊开发入门示例

1. contract 文件夹下存放的是应收账款合约以及合约编译后的bin和abi文件
   * AccountContract 负责管理账户信息
   * RecOrderContract 负责管理订单信息
   * ReceivableContract 负责管理应收账款票据信息
2. private-chain 文件夹下存放的是搭建私链相关的文件
   * genesis.json 是创区区块的配置文件
   * private-net.sh 是启动私有链的脚本

**注意**:   geth的二进制程序需要解压在该目录下，否则执行启动脚本将会报错

3. web3script 文件夹下存放的是部署智能合约和调用智能合约的脚本

   * deploy.js 部署合约
   * invoke.js 调用合约
4. accountlist 中存放合约部署和调用所需要的账户，均已经在创世区块中初始化完成。

