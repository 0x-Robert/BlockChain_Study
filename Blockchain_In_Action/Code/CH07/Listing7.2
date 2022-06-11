App = {
    web3: null,
    contracts: {},
    //development
    url:'http://127.0.0.1:7545',
    network_id:5777,
    receiver:null,
    value:1000000000000000000,
    index:0,
    margin:10,
    left:15,
    init: function() {
      return App.initWeb3();
    },
  
    initWeb3: function() {         
      if (typeof web3 !== 'undefined') {
        App.web3 = new Web3(Web3.givenProvider);
      } else {
        App.web3 = new Web3(App.url);
      }
      ethereum.enable();      
      return App.initContract();  
    },

    initContract: function() {   
      $.getJSON('MPC.json', function(data) {       
        App.contracts.Payment = new App.web3.eth.Contract(data.abi, data.networks[App.network_id].address, {});
        App.web3.eth.getBalance(App.contracts.Payment._address).then((res)=>{ jQuery('#channel_balance').text(web3.fromWei(res),"ether");})   
      }) 
           
      return App.bindEvents();
    },  
  
    bindEvents: function() {  
      $(document).on('click', '#sign', function(){
         App.handleSignedMessage(jQuery('#receiver').val(),jQuery('#amount').val());
      });
  
      $(document).on('click', '#transfer', function(){
        App.handleTransfer(jQuery('#receiveramount').val(),jQuery('#signedMessage').val());
      });
      App.populateAddress();
    },

    populateAddress : function(){  
                     
        new Web3(App.url).eth.getAccounts((err, accounts) => {
          if(!err){
            App.receiver=accounts[1];          
            jQuery('#receiver').val(App.receiver);
            App.web3.eth.getBalance(accounts[0]).then((res)=>{ jQuery('#sender_balance').text(web3.fromWei(res),"ether");});
            App.web3.eth.getBalance(accounts[1]).then((res)=>{ jQuery('#receiver_balance').text(web3.fromWei(res),"ether");});      
        }else{
            console.log('Something went wrong');
            }
          });
    },  
  
    handleSignedMessage:function(receiver,amount){      
      if(receiver!=App.receiver){
        alert('Error in reciever\'s address.')
        return false;
      }
      if(amount<=0){
        alert('Please correct the amount.');
        return false;
      }
      var weiamount=App.web3.utils.toWei(amount, 'ether');
      var message = App.constructPaymentMessage(App.contracts.Payment._address, weiamount);
      App.signMessage(message,amount);   
      
    },

    constructPaymentMessage:function(contractAddress, weiamount) {
      return App.web3.utils.soliditySha3(contractAddress,weiamount)
    },
  
    signMessage:function (message,amount) {      
      web3.personal.sign(message, web3.eth.defaultAccount, function(err, signedMessage) {
        if(!err)
        {
          var box='<div class="check col-md-12 col-lg-12" style="position:absolute;margin-top:'+App.margin+'px;z-index:'+App.index+';left:'+App.left+'px">'+
                  '<span class="amount"><b>'+amount+' ETH </b></span>'+
                  '<p class="signedMessage">'+signedMessage+'</p>'+
                  '</div>';
          App.index=App.index+1;
          App.margin=App.margin+30;
          App.left=App.left+5;
          jQuery('#allchecks').append(box); 
        } 
        else{
          toastr["error"]("Error: Error in signing the message");
          return false;
        }
      });
    },
  
      handleTransfer:function(amount,signedMessage){

        //toHex conversion to support big numbers
        if(App.web3.utils.isHexStrict(signedMessage)){
        var weiamount=App.web3.utils.toWei(amount,'ether')
        var amount=App.web3.utils.toHex(weiamount)
        var option={from:App.receiver}
        App.contracts.Payment.methods.claimPayment(amount,signedMessage)
        .send(option)
        .on('receipt', (receipt) => {
          if(receipt.status){
              toastr.success("Funds are transferred to your account");
              App.populateAddress();
              App.web3.eth.getBalance(App.contracts.Payment._address).then((res)=>{ jQuery('#channel_balance').text(web3.fromWei(res),"ether");})                                
            }
          else{
              toastr["error"]("Error in transfer");
            }
          })
        .on('error',(err)=>{
          if(err.message.indexOf('Signed')!=-1){
            toastr["error"]("Error: Not a valid signed message");
            return false;
          }else if(err.message.indexOf('recipient')!=-1){
            toastr["error"]("Error: Not an intended recipient");
            return false;
          }else if(err.message.indexOf('Insufficient')!=-1){
            toastr["error"]("Error: Insufficient funds");
            return false;
          }else{
            toastr["error"]("Error: Something went wrong");
            return false;
          }
        });  
      }
    else{
      toastr["error"]("Error: Please enter a valid signed message");
      return false;
    }
    }
  }
  
  $(function() {
    $(window).load(function() {
      App.init();
      toastr.options = {
        "positionClass": "right newtoast",
        "preventDuplicates": true,
        "closeButton": true
      };
    });
  });
  