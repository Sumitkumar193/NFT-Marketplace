import React, { Component } from "react";  //Import class components from "React"
import Web3 from "web3";    //Import web3
import detectEthereumProvider from "@metamask/detect-provider"; //detects ethereum provider (wallets ie metamask etc)
import Astreaus from '../abis/Astreaus.json';
import {MDBCard, MDBCardBody, MDBCardImage, MDBCardText, MDBCardTitle, MDBBtn} from 'mdb-react-ui-kit';
import './App.css';


class App extends Component {

    //Call functions here
    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    //Logins
    async loadWeb3(){
        if (detectEthereumProvider) { //check if Metamask is installed
            console.log('Ethereum provider is detected!')
        } else {
            console.log('Ethereum provider cannot be found!')
        }
    }

    async loadBlockchainData() {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts'});  //grab account address
        this.setState({account:accounts[0]})

        const networkId = await window.ethereum.networkVersion;   //grab network/chain ID

        const networkData = Astreaus.networks[networkId]

        if(networkData){
            const abi = Astreaus.abi;
            const address = networkData.address;
            const web3 = new Web3(window.ethereum);               //!important    Initialize web3.js
            await window.ethereum.request({ method: 'eth_requestAccounts' });            //!important
            const Contract = web3.eth.Contract(abi, address);
            this.setState({Contract})
            const totalSupply = await Contract.methods.totalSupply().call()
            this.setState({totalSupply})


            //Load NFTs into array
            for(let i=0;i<totalSupply;i++){
                const ASX = await Contract.methods.AstreausNFTs(i).call()
                const ownerOf = await Contract.methods.ownerOf(i).call()
                this.setState({ASXNFT:[...this.state.ASXNFT, ASX]})    // ... => previous state data
                this.setState({ownedBy:[...this.state.ownedBy, ownerOf]}) 
            }
        }else{
            window.alert("Smart contract is not deployed!")
            console.log('Network does not match according to contract')
        }
    }

    async transfer(tokenId) {

        //Load contracts -> find owner and buyer -> check a!=b -> call transfer

        const networkId = await window.ethereum.networkVersion;   //grab network/chain ID
        const networkData = Astreaus.networks[networkId]
        const abi = Astreaus.abi;
        const address = networkData.address;
        const web3 = new Web3(window.ethereum);               //!important    Initialize web3.js
        await window.ethereum.request({ method: 'eth_requestAccounts' });            //!important
        const Contract = web3.eth.Contract(abi, address);
        const from_address = await Contract.methods.ownerOf(tokenId).call()
        const to_address = this.state.account;
        if(from_address !== to_address){
            await Contract.methods.transferFrom(from_address,to_address,tokenId);   //call method 'transferFrom' to make transfer
        }else{
            window.alert('Transaction cannot be completed!')
        }
    }   

    refreshPage() {
        window.location.reload(false);
    }

    minting = (ASX) => {
        this.state.Contract.methods.mint(ASX).send({from:this.state.account})
        .once('receipt', (receipt) => {
            this.setState({ASXNFT:[...this.state.ASXNFT, ASX]})
        })
    }

    constructor(props) {    //Props - Pass states from one to another
        super(props)
        this.state = {  
            account: '',     //Create a state & look for changes
            Contract: null,
            totalSupply: 0,
            ASXNFT : [],    //Stores nft
            ownedBy : []    //Stores owners
        }
    }   

    render() {
        return( 
            <div className="container-filled">
                <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
                    <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{color: '#e6e6e6'}}>
                        Astreaus - The NFT Marketplace
                    </div>
                    <ul className="navbar-nav px-3">
                        <li key={''} className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                            <small className="text-white">
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>
                <div className="container-fluid mt-1">
                    <div className="row">
                        <main role='main' className='col-lg-12 d-flex text-center'>
                            <div className="content mr-auto ml-auto" style={{opacity: '0.8'}}>
                                <h1 style={{color:'black'}}>Astreaus - The NFT Marketplace</h1>
                                <form onSubmit={(event)=>{
                                    event.preventDefault();
                                    const ASX = this.ASX.value
                                    this.minting(ASX)
                                }}>
                                    <input type='text' placeholder='Location of NFT' className='form-control mb-1' ref={(input) => {this.ASX = input}} />
                                    <input type='submit' style={{margin:'6px'}} className="btn btn-primary btn-black" value='Mint NFT' />
                                </form>
                            </div>
                        </main>
                    </div>
                </div>
                <hr></hr>
                <div className="row textCenter">
                    {this.state.ASXNFT.map((ASXNFT, key) => {
                        return(
                            <div className="mdbCards" key={this.state.ASXNFT.indexOf(ASXNFT)}>
                                <MDBCard className="token img" style={{maxWidth:'22rem'}}>
                                <MDBCardImage alt='Not an Image Or Image load error' src={ASXNFT} position='top' height='250rem' style={{marginRight:'10px'}}/>
                                <MDBCardBody>
                                    <MDBCardTitle>This is AstreausNFT #{this.state.ASXNFT.indexOf(ASXNFT)+1} </MDBCardTitle>
                                    <MDBCardText>Lorem Ipsum is simply dummy text of the printing and typesetting industry.</MDBCardText>
                                    <MDBCardText style={{fontSize: '10px'}}> Owner:<br/> {this.state.ownedBy[this.state.ASXNFT.indexOf(ASXNFT)]} </MDBCardText>
                                    <MDBBtn href={ASXNFT}>Download</MDBBtn>
                                    <MDBBtn color='success' style={{marginLeft: '10px'}} onClick={() => { this.transfer(this.state.ASXNFT.indexOf(ASXNFT)) }}>Transfer/Buy</MDBBtn>
                                </MDBCardBody>
                                </MDBCard>
                            </div>
                        )
                    })}
                </div>
            </div>
        )
    }
}

export default App; //Moves app to index.js/ReactDom in homepage