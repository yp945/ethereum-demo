var Web3 = require('web3');
const Common=require('ethereumjs-common').default

// In this example we create a transaction for a custom network.
//
// All of these network's params are the same than mainnets', except for name, chainId, and
// networkId, so we use the Common.forCustomChain method.
const customCommon = Common.forCustomChain(
  'mainnet',
  {
    name: 'my-network',
    networkId: 2020,
    chainId: 2020,
  },
  'petersburg',
)

//部署合约后得到的合约地址
const contractAddress = "0xde072610835dE29E6489aa2ec7d5F3ed8497BD25"
const EthereumTx = require('ethereumjs-tx').Transaction;
var web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');
var web3 = new Web3(web3Provider);
//核心企业私钥
var companyPrivateKey = new Buffer.from('EBD2F233014D4EDB6ECE8B4ADA5E3B64E80F28E9FCF27A70693990EB92660945', 'hex');
//核心企业账户地址
var companyAddress = '0xA522b056dB259D88a5D1c90c52466e129a8dFD95';

//供应商私钥
var supplierPrivateKey = new Buffer.from('76BA387282A8552F7056777B00233EE554C115E5DF9D01A2635BD611B53A4A65', 'hex');
//供应商账户地址
var supplierAddress = '0x1eba4e6c383269602Ce0E0FFA1319273EdBB62ca';

//金融机构私钥
var financialPrivateKey = new Buffer.from('98B9A9A7888427F9FCFB3021E9BC9173B38757966A29580B5F76FCEF77752F5D', 'hex');
//金融机构地址
var financialAddress = '0x408E9cd4F1733E1eB347Ad1D8125e74f9d466389';


//核心企业注册
web3.eth.getTransactionCount(companyAddress).then(count => {
    var tx = new EthereumTx(  {
        nonce: web3.utils.toHex(count),
	to: contractAddress,
        gasPrice: 4000000,
        gasLimit: 4000000,
        data: '0x83a7158100000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000180000000000000000000000000000000000000000000000000000000000000000575736572310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003656e3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005636572743100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000046163633100000000000000000000000000000000000000000000000000000000' 
    }, {common: customCommon});
    tx.sign(companyPrivateKey);
    var serializedTx = tx.serialize();
    web3.eth.sendSignedTransaction('0x'+serializedTx.toString('hex')).on('receipt', console.log);	
});

//供应商注册
web3.eth.getTransactionCount(supplierAddress).then(count => {
    var tx = new EthereumTx(  {
        nonce: web3.utils.toHex(count),
	to: contractAddress,
        gasPrice: 4000000,
        gasLimit: 4000000,
        data: '0x83a7158100000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000180000000000000000000000000000000000000000000000000000000000000000575736572320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003656e3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005636572743200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000046163633200000000000000000000000000000000000000000000000000000000'
    }, {common: customCommon});
    tx.sign(supplierPrivateKey);
    var serializedTx = tx.serialize();
    web3.eth.sendSignedTransaction('0x'+serializedTx.toString('hex')).on('receipt', console.log);	
});


//金融机构注册
web3.eth.getTransactionCount(financialAddress).then(count => {
    var tx = new EthereumTx(  {
        nonce: web3.utils.toHex(count),
	to: contractAddress,
        gasPrice: 4000000,
        gasLimit: 4000000,
        data: '0x83a7158100000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000180000000000000000000000000000000000000000000000000000000000000000575736572320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003656e3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005636572743200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000046163633200000000000000000000000000000000000000000000000000000000'
    }, {common: customCommon});
    tx.sign(financialPrivateKey);
    var serializedTx = tx.serialize();
    web3.eth.sendSignedTransaction('0x'+serializedTx.toString('hex')).on('receipt', console.log);	
});





