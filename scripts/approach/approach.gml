 function approach
 (atual, alvo, taxa)
 { 
	 if (atual < alvo)
	 { 
		 return min(atual + taxa, alvo); 
	 }
	 else 
	 { return max(atual - taxa, alvo); } }