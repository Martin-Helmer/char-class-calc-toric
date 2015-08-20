newPackage(
	"ToricSubschemeChar",
	Version => "1.01", 
    	Date => "August 15, 2015",
    	Authors => {{Name => "Martin Helmer", 
		  Email => "martin.helmer2@gmail.com", 
		  HomePage => "http://publish.uwo.ca/~mhelmer2/"}},
    	Headline => "Computes CSM classes, Segre classes and the Euler Char. in Multi-Projective Space",
    	DebuggingMode => false,
	Reload => true
    	);
needsPackage "NormalToricVarieties";
--Exported functions/variables
export{"Segre",
   "CSM",
   "Euler",
   "ChowRing",
   "isMultiHomogeneous",
   "Output",
   "ListForm",
   "CheckToricVarietyValid",
   "ChowRingElement",
   "Method",
   "InclusionExclusion",
   "DirectCompleteInt"}

CheckToricVarietyValid=method(TypicalValue=>Boolean);
CheckToricVarietyValid NormalToricVariety:=X->(
   -- needsPackage "NormalToricVarieties";
    Value:=true;
    for i from 0 to #(rays(X))-1 do (
	if not isNef(X_i) then(
	    return false;
	    );
	);
    if length(primaryDecomposition ideal X)!=(#(rays(X))-dim(X)) then(
	Value=false;
	);
    return Value;
);

isMultiHomogeneous=method(TypicalValue=>Boolean);
isMultiHomogeneous Ideal:=I->(
    Igens:=flatten entries gens(I);
    d:=0;
    fmons:=0;
    for f in Igens do(
	fmons=flatten entries monomials(f);
	if length(fmons)!=1 then(
	    d=degree(first(fmons));
	    for mon in fmons do(
		if degree(mon)!=d then(
		    <<"Input term below is not homogeneous with respect to the grading"<<endl;
		    <<f<<endl;
		    return false;
		    );
		);
	    
	    );
	);
    return true;
    
    );
ChowRing=method(TypicalValue=>QuotientRing);
ChowRing NormalToricVariety:=TorVar->(
    needsPackage "NormalToricVarieties";
    assert isSimplicial TorVar;
    --First build Chow ring, need Stanley-Reisner Ideal (SR) and the ideal
    -- generated by the linear relations of the rays (J)
    --See Cox, Little, Schenck Th. 12.5.3 and comments after proof
    R:=ring(TorVar);
    A:=0;
    --For simplical toric var. Lemma 3.5 of Euler characteristic of coherent sheaves on simplicial torics via the Stanley-Reisner ring
    -- (and probally other sources) tell us that the SR ideal is the Alexander
    --dual of the toric irrelevant ideal 
    --SR:=dual monomialIdeal TorVar;
    P:=primaryDecomposition ideal TorVar;
    SR:=ideal for p in P list product flatten entries gens p;
    F:=fan TorVar;
    Fd:=dim(F);
    --Build ideal generated by linear relations of the rays
    Jl:={};
    for j from 0 to dim(F)-1 do(
	Jl=append (Jl,sum(length rays(TorVar), i->(((rays TorVar)_i)_j)*R_i ));
    	);
    J:=ideal(Jl);
    --Chow ring
    if isSmooth(TorVar) then(
	--if smooth our Chow ring should be over ZZ
	 --C:=QQ[gens R, Degrees=>degrees R, Heft=>heft R];
	 C:=ZZ[gens R];
         A=C/substitute(SR+J,C);
	 )
     else (error "Calculations for subschemes of singular toric varieties are not implemented yet";return 0;);
    --Generators (as a ring) of the quotient ring representation of the chow ring corespond to 
    --the divisors associated to the rays in the fan Theorem 12.5.3. Cox, Little, Schenck and 
    --comments above
    return A;
    
    
    );
ChowRing Ring:=R->(
    Rgens:=gens R;
    Rdegs:=degrees R;
    degd:=0;
    eqs:=0;
    ChDegs:=unique Rdegs;
    m:=length ChDegs;
    h:=symbol h;
    C:=ZZ[h_1..h_m];
    K:={};
    inds:={};
    rg:=0;
    ns:={};
    temp:=0;
    for d in ChDegs do(
	temp=0;
	for a in Rdegs do(
	    if d==a then temp=temp+1;
	    );
	ns=append(ns,temp);
	);
    
    for i from 0 to length(ChDegs)-1 do(
	K=append(K,h_(i+1)^(ns_i));
	);
    K=substitute(ideal K,C);
    A:=C/K;
    return A;
);
Euler = method(TypicalValue => RingElement,Options => {Method=>InclusionExclusion});

Euler Ideal:=opts->I->(
    A:=ChowRing(ring I);
    B:=last flatten entries sort basis A;
    csm:=CSM(A,I,Method=>opts.Method);
    EC:=csm_(B);
    <<"The Euler Chacteristic = "<<EC<<endl;
    return EC;
    );
Euler RingElement:=opts->csm->(
    <<"Finding the Euler Chacteristic using input csm class= "<<csm<<endl;
    A:=ring csm;
    B:=last flatten entries sort basis A;
    EC:=csm_(B);
    <<"The Euler Chacteristic = "<<EC<<endl;
    return EC;
    );

CSM = method(TypicalValue => RingElement,Options => {Method=>InclusionExclusion});

CSM (NormalToricVariety, Ideal):= opts->(TorVar,I)->(
    needsPackage "NormalToricVarieties";
    return CSM(ChowRing(TorVar),TorVar,I,Method=>opts.Method);
    );

CSM (QuotientRing,NormalToricVariety, Ideal):= opts->(ChRing,TorVar,I)->(
    (if not isMultiHomogeneous(I) then error "Requires Homogenous Input, try saturating by the irrelevant ideal"<<endl;
    irel:=ideal TorVar;
    PDl:=primaryDecomposition irel;
    n:=dim(TorVar);
    );
    return CSM(ChRing,I,PDl,n,Method=>opts.Method);
    );
CSM Ideal:=opts->I->(
    error "Not implemented yet";
    --return CSM(ChowRing(ring I),I,Method=>opts.Method);
    );

CSM (QuotientRing,Ideal,List,ZZ):= opts->(ChRing,I,PDl,n)->(
    R:=ring I;
    A:=ChRing;
    gensI:=flatten entries gens I;
    B:=flatten entries sort basis A;
    SegY:=0;
    SegV:=0;
    V:=0;
    K:=0;
    J:=0;
    vf:=0;
    csm:=0;
    csm2:=0;
    ChernTR:=substitute(product(numgens(R),i->(1+R_i)),A);
    if opts.Method==DirectCompleteInt then(
	<<"Trying direct"<<endl;
	use R;
	--codimI:=codim I;
	codimI:= codim ideal leadTerm groebnerBasis(I, Strategy=>"MGB");
	irelId:=irrell(R);
	J2:=0;
	Z:=0;
	Sing:=0;
	cont:=false;
	if codimI!=length(gensI) then(
	    <<"codim= "<<codimI<<", len= "<<length(gensI)<<endl;
	    <<"Input is not a complete intersection, using inclusion/exclusion instead"<<endl;
	    return CSM(ChRing,I);
	    )
	else(
	    --check if input smooth?
	    ssets:=subsets(gensI,length(gensI)-1);
	    for s in ssets do (
	    	J2=saturate(minors(length(s),jacobian ideal(s))+ideal(s),irelId);
	    	if codim(J2)>n then (
	    	    Z=ideal(s);
	    	    Sing=ideal toList(set(gensI)-set(s));
	    	    cont=true;
	    	    break;
	    	    );
	    	);
	    if cont then(
		<<"Assumtions okay"<<endl;
		if length(gensI)>1 then J=saturate(minors(length(gensI),jacobian I)+I,irelId);
		--if length(gensI)>1 then J=minors(length(gensI),jacobian I)+I;
		Vlist:={};
		dv:=0;
		for f in gensI do(
		    dv=flatten exponents first flatten entries monomials f;
	    	    Vlist=append(Vlist,sum(numgens(R), i-> dv_i*substitute(R_i,A)));
		    );
		r:=length(gensI);
		CE:=product(r,j->(1+Vlist_j));
		dv=flatten exponents first flatten entries monomials Sing_0;
		Vr:=sum(numgens(R), i-> dv_i*substitute(R_i,A));
		V2:=product(r,j->Vlist_j);
		if r==1 then return (ChernTR*V2)//CE;
		SegY=Segre(A,J,PDl,n,Output=>ListForm);
		CEotimesL:=sum(0..r,i->(-1)^i*(1+Vr)^(r-i)*sum(select(terms CE, q->sum(degree(q))==i)));
		segstuff:=sum(0..n,i->((-1)^i*SegY_(i))//( (1+Vr)^i) );
		cfj:=(ChernTR//CE)*V2;
		milnor:=(ChernTR//CE)*(-1)^(r+1)*CEotimesL*(segstuff);
		csm=cfj+milnor;
		return csm;
		)
	    else(
		 <<"Input does not satisfy assumtions, using inclusion/exclusion instead"<<endl;
	    	 return CSM(ChRing,I);
		);
	);
    )
    else (
	Isubsets:=delete({},subsets(gensI));
	for f in Isubsets do(
	    K=ideal product(f);
	    J=ideal(delete(0_R,flatten entries jacobian K));
	    vf=flatten exponents first flatten entries monomials K_0;
	    V=sum(numgens(R),i->vf_i*substitute(R_i,A));
	    J=J+K;
	    SegY=Segre(A,J,PDl,n,Output=>ListForm);
	    SegV=V//(1+V);
	    csm2=(-1)^(length(f)+1)*(ChernTR*(SegV+sum(n+1,i->sum(n+1-i,j->binomial(n-i,j)*(-V)^j*(-1)^(n-j-i)*SegY_(n-i-j)))) );
	    csm=csm+csm2;
	    );
	<<"The CSM class= "<<csm<<endl;
	return csm;
	);
    
    )



Segre = method(TypicalValue => RingElement,Options => {Output=>ChowRingElement});

Segre (NormalToricVariety, Ideal):= opts->(TorVar,I)->(
    needsPackage "NormalToricVarieties";
    return Segre(ChowRing(TorVar),TorVar,I,Output=>opts.Output);
    );

Segre (QuotientRing,NormalToricVariety, Ideal):= opts->(ChRing,TorVar,I)->(
    if not isMultiHomogeneous(I) then error"Reqires Homogenous Input, try saturating by the irrelevant ideal"<<endl;
    irel:=ideal TorVar;
    PDl:=primaryDecomposition irel;
    n:=dim(TorVar);
    --<<"Fin prime decomp"<<endl;
    
    return Segre(ChRing,I,PDl,n,Output=>opts.Output);
    );
Segre Ideal:=opts->I->(
    --ADD PDl calc from degrees ring
    error"Not implemanted yet"<<endl;
    return Segre(ChowRing(ring I),I,Output=>opts.Output);
    );
Segre (QuotientRing,Ideal,List,ZZ):= opts->(ChRing,I,PDl,n)->(
    --<<"Start Segre"<<endl;
    --<<"input= "<<I<<endl;
    R:=ring I;
    kk:=coefficientRing R;
    A:=ChRing;
    zdim:=0;
    B:=flatten entries sort basis A;
    for b in B do(
	if sum(flatten(exponents(b)))==n then zdim=b;
	); 
    seg:=0;
    t1:=symbol t1;
    S:=kk[gens R, t1];
    codimI:=codim(I);
    --codimI:= codim ideal leadTerm groebnerBasis(I, Strategy=>"F4");
    dimI:=n-codimI;
    gensI:= flatten sort entries gens I;
    exmon:=0;
    degI:= degrees I;
    transDegI:= transpose degI;
    len:= length transDegI;
    maxDegs:= for i from 0 to len-1 list max transDegI_i;
    maxexs:=flatten exponents first flatten entries monomials random(maxDegs,R);
    alpha:=sum(numgens(R),i->maxexs_i*substitute(R_i,A));
    J:= for i from 1 to n list sum(gensI,g -> g*random(kk)*random(maxDegs-degree(g),R));
    --<<"J= "<<J<<endl;
    <<"alpha= "<<alpha<<endl;
    RdList:={};
    GList:={};
    Jd:=0;
    JT:=0;
    c:={};
    v:=0;
    ve:=0;
    K:=0;
    Ls:=0;
    LA:=0;
    gbWt2:=0;
    tall2:=0;
    Yiota:=0;
    if codimI<=n then(
	GList=for iota from 0 to (codimI-1) list alpha^(iota);
	--time(
	for iota from codimI to n do(
	    Jd=substitute(ideal take(J,iota),S);
	    JT=ideal (1-t1*substitute(sum(gensI,g -> g*random(kk)),S));
    	    c={};
    	    for w in B do if sum(flatten(exponents(w)))==iota then c=append(c,w);
    	    Yiota=0;
    	    for w in c do(
	    	Ls=0;
		LA=0;
	    	K=0;
	    	v=zdim//w;
		--<<"zdim= "<<zdim<<endl;
		--<<"w= "<<w<<endl;
		--<<"v= "<<v<<endl;
		ve=flatten exponents(v);
		--<<"ve= "<<ve<<endl;
		--<<"legth ve= "<<length(ve)<<endl;
	    	for i from 0 to length(ve)-1 do(
	    	    if ve_i!=0 then (
		    	Ls=Ls+sum(ve_i,j->ideal(random(degree(R_i),R)));
		    	);
	    	    );
		--time(
		for p in PDl do (
		    LA=LA+ideal(1-sum(numgens(p),i->random(kk)*p_i));
		    );
	    	K=Jd+JT+substitute(Ls,S)+substitute(LA,S);
		--<<"n= "<<numgens(S)<<", codim K= "<<codim(K)<<endl;
		--<<"codim LA= "<<codim(substitute(LA,S))<<endl;--<<", codim Ls= "<<codim(substitute(Ls,S))<<endl;
		--<<"codim Jd= "<<codim(Jd)<<", codim Jt= "<<codim(JT)<<endl;
	    	gbWt2 = groebnerBasis(K, Strategy=>"F4");
            	tall2 = numColumns basis(cokernel leadTerm gbWt2);
		--);
	    	Yiota=Yiota+tall2*w;
		--<<"gam= "<<tall2<<endl;
		--<<tall2<<", ";
	    	);
    	    GList=append(GList,Yiota);
    	    );
	--);
	--the following preforms the aluffi tensor notation comp    
	--GxOMD:=sum(0..n,i->GList_i//((1+cOMaxDegs)^i));
	temp3:=1;
	GxOMD:=0;
	<<"Glist= "<<GList<<endl;
	tayAlph:=1;
	temp4:=1;
	ind:=1;
	while temp4!=0 do(
	    temp4=alpha*temp4;
	    tayAlph=tayAlph+(-1)^ind*temp4;
	    ind=ind+1;
	    );
	--time(
	for i from 0 to n do(
	    GxOMD=GxOMD+GList_i*(temp3);
	    temp3=temp3*tayAlph;
	    );
	--<<"done loop"<<endl;
	seg=1-(GxOMD*tayAlph);
	--);
        --<<"Done Quotient Ring calcs "<<endl;
	tseg:=terms(seg);
	tot:=0;
    	if opts.Output==ListForm then( 
	    segList:={};
	    for i from 0 to n do(
	    tot=0_A;
	    for f in tseg do(
		if sum(flatten(exponents(f)))==i then(
		    tot=tot+f
		    );
	    );
	    segList=append(segList,tot);
	    );	
	    return segList
	    )
	else (
	    <<"Segre= "<<seg<<endl;
	    return seg
	    );
	)
    else(
	segList=for i from 0 to n list 0_A;
	seg=0_A;
	if opts.Output==ListForm then(
	    return segList;
	    )
	 else (
	     <<"Segre= "<<seg<<endl;
	     return seg;
	     );
	);
);

---------------------------
--Internal functions 
---------------------------

OneAti=(dl,i)->(
    vec:={};
    for j from 0 to dl-1 do(
	if j==i then vec=append(vec,1) else vec=append(vec,0);
	);
    return vec;
    )

irrell=R->(    
    Rgens:=gens R;
    Rdegs:=degrees R;
    bloks:=unique Rdegs;
    irId:=ideal 1_R;
    elList:={};
    for a in bloks do(
	elList={};
	for r in Rgens do(
	    if degree(r)==a then(
		elList=append(elList,r);
		);
	    );
	irId=irId*ideal(elList)
	
	);
    return irId;
    )
----------------------------
--Miscilaneous Examples
--
---------------------------

----------------
--Intro multi-proj Ex
--
----------------
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(4,CoefficientRing =>ZZ/32749,Variable =>symbol x)**projectiveSpace(2,CoefficientRing =>ZZ/32749,Variable =>symbol y)
    R=ring X
    gens R
    I=ideal(5*R_0*R_5,9*R_7*R_6*R_2-4*R_7^2*R_1)
    degrees I
    segre=time Segre(X,I)
    csm=time CSM(X,I)

///
---------------------------------
--Multi-Proj Csm
-----------------------
--Ex. 1
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk);
    R=ring X;
    I=ideal(random({1,1},R),R_0^2*R_5^2-R_1*R_2*R_4*R_5)
    time CSM(X,I)

///

--Ex. 2
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(6,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk);
    R=ring X;
    I=ideal(R_0^2*R_1-R_2^3,R_7^2)
    degrees I
    codim I
    time CSM(X,I)

///

--Ex. 3
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(5,CoefficientRing =>kk)**projectiveSpace(3,CoefficientRing =>kk);
    R=ring X;
    I=ideal(4*R_0*R_6-7*R_7*R_2,R_0*R_4*R_8)
    degrees I
    codim I
    time CSM(X,I)

///

--Ex. 4
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(3,CoefficientRing =>kk);
    R=ring X;
    I=ideal((R_0*R_1-R_2^2)*R_4,R_5*(R_6^2-R_7*R_6))
    codim I
    time CSM(X,I)

///

--Ex. 5
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(3,CoefficientRing =>kk);
    R=ring X;
    I=ideal((R_0*R_1-R_2^2)*R_4,R_5*(R_6^2-R_7*R_6),R_0*R_3^2)
    K=ideal(I_0*I_1*I_2)
    codim I
    time CSM(X,I)
    time CSM(X,K)

///





------------------------------------------
--
--CSM complete intersection examples
-----------------------------------------

--Ex. 1
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk);
    R=ring X;
    A=ChowRing(R);
    I=ideal(random({1,1},R),random({1,1},R),R_1*R_0*R_3-R_0^2*R_4);
    csm=time CSM(X,I)
    csm2=time CSM(X,I,Method=>DirectCompleteInt)
    

///


--Ex. 2
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(3,CoefficientRing =>kk);
    R=ring X;
    A=ChowRing(R);
    I=ideal(random({2,1},R),R_1*R_0*R_4);
    csm=time CSM(X,I)
    csm2=time CSM(X,I,Method=>DirectCompleteInt)
///

--Ex. 3
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk);
    R=ring X
    A=ChowRing(R);
    I=ideal(random({2,1,0},R),random({0,0,1},R),R_2*R_6-7*R_0*R_7);
    csm=time CSM(X,I)
    csm2=time CSM(X,I,Method=>DirectCompleteInt)
    
   
///
--Ex. 4
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    kk=ZZ/32749;
    X=projectiveSpace(3,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk)**projectiveSpace(2,CoefficientRing =>kk);
    R=ring X;
    A=ChowRing(R);
    I=ideal(random({2,1,0},R),R_2*R_5-7*R_0*R_6);
    csm=time CSM(X,I)
    csm2=time CSM(X,I,Method=>DirectCompleteInt)   
   
///
----------------------------------
--End csm examples
--
----------------------------------

----------------------------------
--Tests of Segre
--
---------------------------------

---------------------------------
--Not prod of P^n's (valid)
--
---------------------------------
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    Rho = {{1,0,0},{0,1,0},{0,0,1},{-1,-1,0},{0,0,-1}}
    Sigma = {{0,1,2},{1,2,3},{0,2,3},{0,1,4},{1,3,4},{0,3,4}}
    kk=ZZ/32749;
    X = normalToricVariety(Rho,Sigma,CoefficientRing =>kk)
    R=ring(X)
    I=ideal(R_0^4*R_1,R_0*R_3*R_4*R_2-R_2^2*R_0^2)
    I=ideal(R_0^4*R_1,R_0*R_3*R_4*R_2-R_2^2*R_0^2,R_0^8*R_4-R_0*R_1^6*R_3*R_2)
    isMultiHomogeneous(I)
    length(primaryDecomposition ideal X)==(#(rays(X))-dim(X))
    for i from 0 to #(rays(X))-1 list isNef X_i
    time Segre(X,I)
    time CSM(X,I)
///
---------
--
--Prod of P^n's
--------------


--EX. 1
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(2,CoefficientRing =>ZZ/32749)**projectiveSpace(3,CoefficientRing =>ZZ/32749);
    R=ring X;
    I2 = ideal(random({2,0},R),R_3*R_5*R_4^2,R_0*R_1)
    time Segre(X,I2);
///

--EX. 2
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(1,CoefficientRing =>ZZ/32749)**projectiveSpace(1,CoefficientRing =>ZZ/32749)**projectiveSpace(1,CoefficientRing =>ZZ/32749);
    R=ring X;
    I2 = ideal(random({2,1,1},R),R_3*R_5*R_4^2-R_2*R_5^3)
    s=time Segre(X,I2);
///

--EX. 3
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(3,CoefficientRing =>ZZ/32749)**projectiveSpace(2,CoefficientRing =>ZZ/32749);
    S=ring X;
    A=ChowRing(X)
    I = ideal(S_0*S_1*S_2-S_2^2*S_3,S_0*S_2*S_1*S_3)
    time Segre(X,I)
///

--EX. 4
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(5,CoefficientRing =>ZZ/32749)**projectiveSpace(3,CoefficientRing =>ZZ/32749);
    S=ring X;
    A=ChowRing(X);
    I = ideal(S_0^2*S_7^2-S_6*S_7*S_1*S_2)
    degrees I
    time Segre(X,I)
///

--EX. 5
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(2,CoefficientRing =>ZZ/32749)**projectiveSpace(3,CoefficientRing =>ZZ/32749)**projectiveSpace(1,CoefficientRing =>ZZ/32749);
    S=ring X;
    I = ideal(S_0*S_1*S_3-5*S_4*S_2^2,S_4*S_6)
    degrees I
    time Segre(X,I)
///

--EX. 6
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(2,CoefficientRing =>ZZ/32749)**projectiveSpace(2,CoefficientRing =>ZZ/32749)**projectiveSpace(2,CoefficientRing =>ZZ/32749);
    S=ring X;
    I = ideal(S_0*S_3*S_6,S_5*S_7-7*S_4*S_8)
    degrees I
    time Segre(X,I)
///

--EX. 7
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(4,CoefficientRing =>ZZ/32749)**projectiveSpace(3,CoefficientRing =>ZZ/32749)**projectiveSpace(3,CoefficientRing =>ZZ/32749);
    S=ring X;
    gens S
    I = ideal(S_0*S_6^2+8*S_1*S_5*S_7,S_10*S_9*S_0-S_11^2*S_1)
    degrees I
    time A=ChowRing(X)
    time Segre(X,I)
///

--EX. 8
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(4,CoefficientRing =>ZZ/32749)**projectiveSpace(3,CoefficientRing =>ZZ/32749)**projectiveSpace(5,CoefficientRing =>ZZ/32749);
    S=ring X;
    I = ideal(S_0*S_5^2-S_2*S_5*S_6,S_8*S_13-6*S_5*S_14)
    degrees I
    time Segre(X,I)
///

--EX. 9
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    X=projectiveSpace(2,CoefficientRing =>ZZ/32749)**projectiveSpace(2,CoefficientRing =>ZZ/32749)**projectiveSpace(1,CoefficientRing =>ZZ/32749);
    S=ring X;
    gens S
    I = ideal(S_3*(S_4-S_5),S_5*S_4*S_6+9*S_3^2*S_7,S_0^2*S_4,S_0^2+S_1^2)
    degrees I
    time Segre(X,I)
///
--------------
--End Segre Exs
--
-------------

    
---------------------------------
--Not prod of P^n's (valid)
--
---------------------------------
TEST ///
{*
    restart
    needsPackage "ToricSubschemeChar"
    needsPackage "NormalToricVarieties"
*}
    Rho = {{1,0,0},{0,1,0},{0,0,1},{-1,-1,0},{0,0,-1}}
    Sigma = {{0,1,2},{1,2,3},{0,2,3},{0,1,4},{1,3,4},{0,3,4}}
    kk=ZZ/32749;
    X = normalToricVariety(Rho,Sigma,CoefficientRing =>kk)
    R=ring(X)
    I=ideal(R_0^4*R_1,R_0*R_3*R_4*R_2-R_2^2*R_0^2)
    I=ideal(R_0^4*R_1,R_0*R_3*R_4*R_2-R_2^2*R_0^2,R_0^8*R_4-R_0*R_1^6*R_3*R_2)
    isMultiHomogeneous(I)
    
    --Check Reqired Assumtions 
    length(primaryDecomposition ideal X)==(#(rays(X))-dim(X))
    for i from 0 to #(rays(X))-1 list isNef X_i
    --or 
    CheckToricVarietyValid(X)   
     
    time Segre(X,I)
    time CSM(X,I)
///
