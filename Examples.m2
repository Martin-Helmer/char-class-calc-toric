---------------------------------
--Not product of P^n's examples
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

---------
--
--Prod of P^n's
--------------

----------------------------------
--Tests of Segre
--
---------------------------------

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
--Multi-Projjective Csm
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
