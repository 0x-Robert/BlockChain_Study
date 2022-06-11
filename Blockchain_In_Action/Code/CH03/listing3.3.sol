modifier name_of_modifier (parameters) 
{ require { conditions_to_be_checked};
	_;	
}

modifier validPhase(Phase reqPhase) 
    { require(state == reqPhase);
      _;     
    }

