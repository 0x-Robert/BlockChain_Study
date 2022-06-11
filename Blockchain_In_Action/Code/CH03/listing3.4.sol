function register(address voter) public validPhase(Phase.Regs)  {
        //if (state != Phase.Regs) {revert();} 
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[voter].weight = 1;
        voters[voter].voted = false;
