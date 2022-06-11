pragma solidity >=0.4.22 <=0.6.0;
    
    contract Airlines  {
   
    address chairperson;
    
    struct reqStruc{
        uint reqID;
        uint fID;
        uint numSeats;
        uint passengerID;
        address toAirline;
    } 

   struct respStruc{
        uint reqID;
        bool status;
        address fromAirline;
    } 
    
    mapping (address=>uint) public escrow;
    mapping (address=>uint) membership; 
    mapping (address=>reqStruc) reqs;
    mapping (address=>respStruc) reps;
    mapping (address=>uint) settledReqID;
    
    //modifier or rules
    modifier onlyChairperson {
        require(msg.sender==chairperson);
        _;
    }
    modifier onlyMember {
        require(membership[msg.sender]==1);
        _;
    }
    
    // constructor function
    constructor () public payable  {
      
        chairperson=msg.sender;
        membership[msg.sender]=1; // automatically registered
        escrow[msg.sender] = msg.value;

        
    }
    
    function register ( ) public payable{
        
        address AirlineA =msg.sender;
        membership[AirlineA]=1;
        escrow[AirlineA] = msg.value;

        
    }
        
   function unregister (address payable AirlineZ) onlyChairperson public {
        membership[AirlineZ]=0;
        //return escrow to leaving airline: other consitions may be verified
        AirlineZ.transfer(escrow[AirlineZ]);
        escrow[AirlineZ] = 0;
        
    }
    
    
    function ASKrequest (uint reqID, uint flightID, uint numSeats, uint custID, address toAirline) onlyMember public{
        /*if(membership[toAirline]!=1){
            revert();}  */
        require(membership[toAirline] == 1);
        reqs[msg.sender] = reqStruc(reqID, flightID, numSeats, custID, toAirline);
      
    }
    
    function  ASKresponse (uint reqID, bool success, address fromAirline) onlyMember public{
      
        if(membership[fromAirline]!=1){
            revert();
        }
        
        reps[msg.sender].status=success;
        reps[msg.sender].fromAirline = fromAirline;
        reps[msg.sender].reqID = reqID;
       
       
    }
    
    function settlePayment  (uint reqID, address payable toAirline, uint numSeats) onlyMember payable public{
        //before calling this, it will update ASK view table
        address fromAirline = msg.sender;
       
        //this is the consortium account transfer you want to do
         //assume cost of 1 ETH for each seat 
        // computations are in Wei 
        
        escrow[toAirline] = escrow[toAirline] + numSeats*1000000000000000000;
        escrow[fromAirline] = escrow[fromAirline] - numSeats*1000000000000000000;
       
        settledReqID[fromAirline] = reqID;
       
    }
    
    function replenishEscrow() payable public
    {
        escrow[msg.sender] = escrow[msg.sender] + msg.value;
    }
}