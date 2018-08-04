# node means the people in social network
param N>0 integer;
param P>0 integer;

param indlinks integer;	# total number of friends constrain for a person

set nodes:=1..N;	# people
set features:=1..P;	# features

set ch{nodes} within features;	# characters for each person
param connect{nodes,nodes} binary; 	# connection state of two people
param f_in_ch{f in features, n in nodes}	# indicate whether or not a features is owned by a person
	= if f in ch[n] then 1 else 0;

var x{nodes,nodes} binary;	# calculated connection state
var y{nodes}>=0;	# a correlation value of a person with all others

maximize F:sum{n in nodes}(y[n]);

subject to all_links{n in nodes}:	# link number constrain
	sum{m in nodes}(x[n,m])<=indlinks;	
subject to value{n in nodes}:	# a correlation value of a person with all others 
	sum{m in nodes}(if n!=m then (sum{f in features}(f_in_ch[f,n]*f_in_ch[f,m]*x[n,m]))**2 else 0)=y[n];
subject to generation{n in nodes, m in nodes}:	# keep original connections
	x[n,m]>=connect[n,m];
subject to equal{n in nodes, m in nodes}:	# connection is undirected
	x[n,m]=if n==m then 0 else x[m,n];