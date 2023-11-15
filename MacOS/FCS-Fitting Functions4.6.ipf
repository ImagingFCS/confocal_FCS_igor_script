#pragma rtGlobals=1		// Use modern global access method.


//********************************************************************************
// FCS-Fitting Functions.ipf                               Bo Huang, 12.25.2001
// Version 2.0 changed on 5/9/2003 by T. Wohland
// Version 3.4 changed on 2003 by T. Wohland
// Version 4.0 changed on 29/1/2004 by T. Wohland
// Added flow model mod_D_flow on 23/8/2004
// Added 2flow model mod_D_2flow on 09/06/2004
// Added 3D rotational model mod_3D_1p1t1r on 25/10/2004
// Added 3D rotational model mod_3D_1p2t1r on 25/10/2004
//********************************************************************************
//             Fitting Models copied from FCS-Flex99R.ipf by T. Wohland
//********************************************************************************
//     Funciton definitions for the different models [tauD=w0^2/(4*D)]
//********************************************************************************

//ACF 1 component, 3D Diffusion
Function/D mod_3D_1p(cofit,tau)			// |cofit=(N, tauD, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[2]^2))^(-0.5)
	
	return ((g1*g2)/cofit[0]+cofit[3])
End


//ACF 2 components, 3D Diffusion	
Function/D mod_3D_2p(cofit,tau)			// |cofit=(N, tauD,tauD2,F2,K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1-cofit[3])*(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[4]^2))^(-0.5)
	g2=cofit[3]*(1+tau/cofit[2])^(-1)*(1+tau/(cofit[2]*cofit[4]^2))^-(0.5)
	
	return ((g1+g2)/cofit[0]+cofit[5])
	
End


//ACF 3 components, 3D Diffusion	
Function/D mod_3D_3p(cofit,tau)			// |cofit=(N, tauD,tauD2,tauD3,F2,F3,K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1-cofit[4]-cofit[5])*(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[6]^2))^(-0.5)
	g2=cofit[4]*(1+tau/cofit[2])^(-1)*(1+tau/(cofit[2]*cofit[6]^2))^-(0.5)
	g3=cofit[5]*(1+tau/cofit[3])^(-1)*(1+tau/(cofit[3]*cofit[6]^2))^-(0.5)
	
	return ((g1+g2+g3)/cofit[0]+cofit[7])
	
End


//ACF 1 component, 3D Diffusion, 1 triplet
Function/D mod_3D_1p1t(cofit,tau)			// |cofit=(N, tauD,tauTrip,Ftrip, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[4]^2))^(-0.5)
	g2=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	
	return ((g1*g2)/cofit[0]+cofit[5])
End

//ACF 1 component, 3D Diffusion, 2 triplet
Function/D mod_3D_1p2t(cofit,tau)			// |cofit=(N, tauD,tauTrip,Ftrip, tauTrip2,Ftrip2, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[6]^2))^(-0.5)
	g2=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	g3=cofit[5]/(1-cofit[5])*exp(-tau/cofit[4])+1
	
	return ((g1*g2*g3)/cofit[0]+cofit[7])
End


//ACF 2 components, 3D Diffusion, 1 triplet
Function/D mod_3D_2p1t(cofit,tau)			// |cofit=(N,tauD,tauD2,F2,tauTrip,Ftrip,K,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1-cofit[3])*(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[6]^2))^(-0.5)
	g2=cofit[3]*(1+tau/cofit[2])^(-1)*(1+tau/(cofit[2]*cofit[6]^2))^-(0.5)
	g3=cofit[5]/(1-cofit[5])*exp(-tau/cofit[4])+1
	
	return ((g1+g2)*g3/cofit[0]+cofit[7])
End


//ACF 2 components, 3D Diffusion, 2 triplet
Function/D mod_3D_2p2t(cofit,tau)			// |cofit=(N, tauD,tauD2,F2,tauTrip1,Ftrip1,tauTrip2,Ftrip2, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3,g4
	
	g1=(1-cofit[3])*(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[6]^2))^(-0.5)
	g2=cofit[3]*(1+tau/cofit[2])^(-1)*(1+tau/(cofit[2]*cofit[6]^2))^-(0.5)
	g3=cofit[5]/(1-cofit[5])*exp(-tau/cofit[4])+1
	g4=cofit[7]/(1-cofit[7])*exp(-tau/cofit[6])+1
	
	return ((g1*g3+g2*g4)/cofit[0]+cofit[9])
End


//ACF 3 components, 3D Diffusion, 1 triplet
Function/D mod_3D_3p1t(cofit,tau)			// |cofit=(N, tauD,tauD2,tauD3,F2,F3,tauTrip,Ftrip, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3,g4
	
	g1=(1-cofit[4]-cofit[5])*(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[8]^2))^(-0.5)
	g2=cofit[4]*(1+tau/cofit[2])^(-1)*(1+tau/(cofit[2]*cofit[8]^2))^-(0.5)
	g3=cofit[5]*(1+tau/cofit[3])^(-1)*(1+tau/(cofit[3]*cofit[8]^2))^-(0.5)
	g4=cofit[7]/(1-cofit[7])*exp(-tau/cofit[6])+1
	
	return ((g1+g2+g3)*g4/cofit[0]+cofit[9])
End


//ACF ASD (only 2 dimensions)
Function/D mod_ASD(cofit,tau)			// |cofit=(N, Gamma, Alpha, w0,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1
	
	g1=(1+cofit[1]*tau^cofit[2]/cofit[3]^2)^(-1)
	
	return (g1/cofit[0]+cofit[4])
End


//ACF 2 components, 3D Diffusion, QuantumEff	
Function/D mod_3D_2pq(cofit,tau)			// |cofit=(N, tauD,tauD2,F2,K, Q,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1-cofit[3])*(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[4]^2))^(-0.5)
	g2=cofit[5]^2*cofit[3]*(1+tau/cofit[2])^(-1)*(1+tau/(cofit[2]*cofit[4]^2))^-(0.5)
	g3=(1-cofit[3]+cofit[5]*cofit[3])^2
	
	return ((g1+g2)/g3/cofit[0]+cofit[6])
	
End

//ACF 3 components, 3D Diffusion, QuantumEff	
Function/D mod_3D_3pq(cofit,tau)			// |cofit=(N, tauD,tauD2,tauD3,F2,F3,K, Q,Q2,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3,g4
	
	g1=(1-cofit[5]-cofit[6])*(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[7]^2))^(-0.5)
	g2=cofit[7]^2*cofit[4]*(1+tau/cofit[2])^(-1)*(1+tau/(cofit[2]*cofit[6]^2))^-(0.5)
	g3=cofit[8]^2*cofit[5]*(1+tau/cofit[3])^(-1)*(1+tau/(cofit[3]*cofit[6]^2))^-(0.5)
	g4=(1-cofit[4]-cofit[5]+cofit[7]*cofit[4]+cofit[8]*cofit[5])^2
	
	return ((g1+g2+g3)/g4/cofit[0]+cofit[9])
	
End

//ACF 2 components, 3D Diffusion, 1 triplet, QuantumEff	
Function/D mod_3D_2pq1t(cofit,tau)			// |cofit=(N, tauD,tauD2,F2,tauTrip,Ftrip,K, Q,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3,g4
	
	g1=(1-cofit[3])*(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[6]^2))^(-0.5)
	g2=cofit[7]^2*cofit[3]*(1+tau/cofit[2])^(-1)*(1+tau/(cofit[2]*cofit[6]^2))^-(0.5)
	g3=(1-cofit[3]+cofit[7]*cofit[3])^2
	g4=cofit[5]/(1-cofit[5])*exp(tau/cofit[4])+1
	
	return ((g1+g2)*g4/g3/cofit[0]+cofit[8])
	
End


//ACF 1 component, 2D Diffusion
Function/D mod_2D_1p(cofit,tau)			// |cofit=(N, tauD, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1+tau/cofit[1])^(-1)
	
	return (g1/cofit[0]+cofit[2])
End Function mod2D_1p

//ACF 1 component, 2D Diffusion, asymmetric
Function/D mod_2Dasym_1p(cofit,tau)			// |cofit=(N, tauDx, tauDy, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1+tau/cofit[1])^(-0.5)
	g2=(1+tau/cofit[2])^(-0.5)
	
	return (g1*g2/cofit[0]+cofit[3])
End Function mod2D_1p

//ACF 1 component, 2D Diffusion, 1 triplet, asymmetric
Function/D mod_2Dasym_1p1t(cofit,tau)			// |cofit=(N, tauDx,tauDy,tauTrip,Ftrip, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1+tau/cofit[1])^(-0.5)
	g2=(1+tau/cofit[2])^(-0.5)
	g3=cofit[4]/(1-cofit[4])*exp(-tau/cofit[3])+1
	
	return ((g1*g2*g2)/cofit[0]+cofit[5])
End

//ACF 2 components, 2D Diffusion	
Function/D mod_2D_2p(cofit,tau)			// |cofit=(N, tauD,tauD2,F2, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1-cofit[3])*(1+tau/cofit[1])^(-1)
	g2=cofit[3]*(1+tau/cofit[2])^(-1)
	
	return ((g1+g2)/cofit[0]+cofit[4])
	
End


//ACF 3 components, 2D Diffusion	
Function/D mod_2D_3p(cofit,tau)			// |cofit=(N, tauD,tauD2,tauD3,F2,F3, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1-cofit[4]-cofit[5])*(1+tau/cofit[1])^(-1)
	g2=cofit[4]*(1+tau/cofit[2])^(-1)
	g3=cofit[5]*(1+tau/cofit[3])^(-1)
	
	return ((g1+g2+g3)/cofit[0]+cofit[6])
	
End


//ACF 1 component, 2D Diffusion, 1 triplet
Function/D mod_2D_1p1t(cofit,tau)			// |cofit=(N, tauD,tauTrip,Ftrip, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1+tau/cofit[1])^(-1)
	g2=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	
	return ((g1*g2)/cofit[0]+cofit[4])
End

//ACF 1 component, 2D Diffusion, 2 triplet
Function/D mod_2D_1p2t(cofit,tau)			// |cofit=(N, tauD,tauTrip,Ftrip, tauTrip2,Ftrip2, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1+tau/cofit[1])^(-1)
	g2=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	g3=cofit[5]/(1-cofit[5])*exp(-tau/cofit[4])+1
	
	return ((g1*g2*g3)/cofit[0]+cofit[6])
End


//ACF 2 components, 2D Diffusion, 1 triplet
Function/D mod_2D_2p1t(cofit,tau)			// |cofit=(N, tauD,tauD2,F2,tauTrip,Ftrip, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1-cofit[3])*(1+tau/cofit[1])^(-1)
	g2=cofit[3]*(1+tau/cofit[2])^(-1)
	g3=cofit[5]/(1-cofit[5])*exp(-tau/cofit[4])+1
	
	return ((g1+g2)*g3/cofit[0]+cofit[6])
End


//ACF 2 components, 2D Diffusion, 2 triplet
Function/D mod_2D_2p2t(cofit,tau)			// |cofit=(N, tauD,tauD2,F2,tauTrip1,Ftrip1,tauTrip2,Ftrip2, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3,g4
	
	g1=(1-cofit[3])*(1+tau/cofit[1])^(-1)
	g2=cofit[3]*(1+tau/cofit[2])^(-1)
	g3=cofit[5]/(1-cofit[5])*exp(-tau/cofit[4])+1
	g4=cofit[7]/(1-cofit[7])*exp(-tau/cofit[6])+1
	
	return ((g1*g3+g2*g4)/cofit[0]+cofit[8])
End

//ACF 3 components, 2D Diffusion, 1 triplet
Function/D mod_2D_3p1t(cofit,tau)			// |cofit=(N, tauD,tauD2,tauD3,F2,F3,tauTrip,Ftrip, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3,g4
	
	g1=(1-cofit[4]-cofit[5])*(1+tau/cofit[1])^(-1)
	g2=cofit[4]*(1+tau/cofit[2])^(-1)
	g3=cofit[5]*(1+tau/cofit[3])^(-1)
	g4=cofit[7]/(1-cofit[7])*exp(-tau/cofit[6])+1
	
	return ((g1+g2+g3)*g4/cofit[0]+cofit[8])
End

//ACF diffusion coeff. distribution, 3D Diffusion
Function/D mod_3D_dist(cofit,tau)			// |cofit=(N, MtauD, WtauD, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D mp,inv,dist,func,totfunc
	Variable i
	
	totfunc=0
	i=-4
	do
	mp=(2^i+2^(i-1))/2*cofit[1]
	inv=(2^i-2^(i-1))*mp
	dist=1/(sqrt(2*Pi)*cofit[2])*exp(-0.5*((tau-cofit[1])/cofit[2])^2)
	func=(1+tau/mp)^(-1)*(1+tau/(mp*cofit[3]^2))^(-0.5)
	totfunc+=inv*dist*func
	i+=1
	while (i<6)
	
	return (1/cofit[0]*totfunc+cofit[4])
End

//ACF 1 component, 3D cross correlation
Function/D mod_CC_1p(cofit,tau)			// |cofit=(N, tauD, K, P, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[2]^2))^(-0.5)
	g3=exp(-cofit[3]^2*(1+tau/(cofit[1]*cofit[2]^2)))
	
	return ((g1*g2*g3)/cofit[0]+cofit[4])
End

//ACF diffusion and flow
Function/D mod_P_flow(cofit,tau)			// |cofit=(N, tauF,DC)
	Wave/D cofit; Variable/D tau
	
	return (  (exp(-(tau/cofit[1])^2))/cofit[0]+cofit[2])
End

//ACF diffusion and flow
Function/D mod_D_flow(cofit,tau)			// |cofit=(N, tauD, K, tauF,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[2]^2))^(-0.5)
	
	return ((g1*g2*exp(-(tau/cofit[3])^2*g1))/cofit[0]+cofit[4])
End

//ACF diffusion and flow and triplet
Function/D mod_D_flow_1t(cofit,tau)			// |cofit=(N, tauD, tauTrip,Ftrip,K, tauF, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[4]^2))^(-0.5)
	g3=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	
	return ((g3*g1*g2*(exp(-(tau/cofit[5])^2*g1)))/cofit[0]+cofit[6])
End

//ACF diffusion and triplet, and two flow
Function/D mod_D_2flow_1t(cofit,tau)			// |cofit=(N, tauD, tauTrip,Ftrip,K, tauF1, tauF2, Fflow1, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[4]^2))^(-0.5)
	g3=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	
	return ((g3*g1*g2*(cofit[7]*exp(-(tau/cofit[5])^2*g1) + (1-cofit[7])*exp(-(tau/cofit[6])^2*g1) ))/cofit[0]+cofit[8])
End

//ACF diffusion and two flow, no triplet
Function/D mod_D_2flow(cofit,tau)			// |cofit=(N, tauD, K, tauF1, tauF2, Fflow1, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[2]^2))^(-0.5)
		
	return ((g1*g2*(cofit[5]*exp(-(tau/cofit[3])^2*g1) + (1-cofit[5])*exp(-(tau/cofit[4])^2*g1) ))/cofit[0]+cofit[6])
End

//ACF diffusion and flow in z direction, no triplet
Function/D mod_D_Zflow(cofit,tau)			// |cofit=(N, tauD, K, ZtauF, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[2]^2))^(-0.5)
		
	return ((g1*g2*exp(-(tau/cofit[3])^2*g2*g2))/cofit[0]+cofit[4])
End

//ACF diffusion and flow in z direction, 1 triplet
Function/D mod_D_Zflow_1t(cofit,tau)			// |cofit=(N,tauD,tauTrip,Ftrip, K,ZtauF,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[4]^2))^(-0.5)
	g3=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
		
	return ((g3*g1*g2*exp(-(tau/cofit[5])^2*g2*g2))/cofit[0]+cofit[6])
End

//ACF diffusion and flow in both x and z direction, without triplet
Function/D mod_D_XZflow(cofit,tau)			// |cofit=(N,tauD,K,tauF,phi,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,gf_phi
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[2]^2))^(-0.5)
	
	gf_phi = (cos(cofit[4]/180*pi))^2 /(1+tau/cofit[1]) + (sin(cofit[4]/180*pi)/cofit[2])^2 /(1+tau/(cofit[1]*cofit[2]^2))
		
	return (    1/cofit[0]  * (g1*g2)  * exp(-(tau/cofit[3])^2 * gf_phi) + cofit[5]  )
End


Function/D mod_D_XZflow_1t(cofit,tau)			// |cofit=(N,tauD,tauTrip,Ftrip,K,tauF,phi,DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3,gf_phi
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[4]^2))^(-0.5)
	g3=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	
	gf_phi = (cos(cofit[6]/180*pi))^2 /(1+tau/cofit[1]) + (sin(cofit[6]/180*pi)/cofit[4])^2 /(1+tau/(cofit[1]*cofit[4]^2))
		
	return (    1/cofit[0]  * (g3*g1*g2)  * exp(-(tau/cofit[5])^2 * gf_phi) +  cofit[7]  )
End

//two beam FCCS and flow, 1 triplet
Function/D mod_D_2Bflow(cofit,tau)			// |cofit=(N,tauD,R,tauFcc,Angle,K)  // note: R = distance/w0
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,gfcc
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[5]^2))^(-0.5)
	
	gfcc = exp(-cofit[2]^2 * g1 * (tau^2/cofit[3]^2 + 1 - 2*tau/cofit[3]*cos(cofit[4]/180*pi)))
		
	return (    1/cofit[0]  * (g1*g2*gfcc))
End

//two beam FCCS and flow, 1 triplet
Function/D mod_D_2BflowR(cofit,tau)			// |cofit=(N,tauD,R,w0,Vs,K)  // note: R = distance
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,gfcc
	
	g1=(1+tau/cofit[1])^(-1)
	g2=(1+tau/(cofit[1]*cofit[5]^2))^(-0.5)
	
	gfcc = exp(-cofit[2]^2/cofit[3]^2 * g1 * (tau^2*cofit[4]^2/cofit[2]^2 + 1 - 2*tau*cofit[4]/cofit[2]))
		
	return (    1/cofit[0]  * (g1*g2*gfcc))
End

//ACF 1 component, 3D Diffusion, 1 triplet, 1 rotational
Function/D mod_3D_1p1t1r(cofit,tau)		// |cofit=(N, tauD,tauTrip,Ftrip,tauRot,R, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3
	
	g1=(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[6]^2))^(-0.5)
	g2=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	g3=cofit[5]/(1-cofit[5])*exp(-tau/cofit[4])+1

	return ((g1*g2*g3)/cofit[0]+cofit[7])
End

//ACF 1 component, 3D Diffusion, 2 triplet, 1 rotational
Function/D mod_3D_1p2t1r(cofit,tau)        // |cofit=(N, tauD,tauTrip,Ftrip, tauTrip2,Ftrip2, tauRot,R, K, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D g1,g2,g3,g4
	
	g1=(1+tau/cofit[1])^(-1)*(1+tau/(cofit[1]*cofit[8]^2))^(-0.5)
	g2=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1
	g3=cofit[5]/(1-cofit[5])*exp(-tau/cofit[4])+1
	g4=cofit[7]/(1-cofit[7])*exp(-tau/cofit[6])+1

	return ((g1*g2*g3*g4)/cofit[0]+cofit[9])
End

//ACF diffusion confinement in y,z directions. 3D_1p1t model
Function/D mod_CFyz_3D1p_1t(cofit,tau)			// |cofit=(N, tauD, tauTrip, Ftrip, K, Y, Z, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D gx, gy2, gz2, gt
	
	gx = 1/sqrt(1+tau/cofit[1])
	gy2 = (sqrt(pi)/cofit[5]) * ( 1+ (cofit[5]/sqrt(pi)*erf(cofit[5])/(erf(cofit[5]/sqrt(2)))^2 -1) * (exp( -(0.689 + 0.34*exp(-0.37*(cofit[5]-0.5)^2))*(pi/cofit[5])^2*tau/cofit[1]) /(sqrt(1+tau/cofit[1]))))
	//gy2 = 1/sqrt(1+tau/cofit[1])
	gz2 = (sqrt(pi)/cofit[6]) * ( 1+ (cofit[6]/sqrt(pi)*erf(cofit[6])/(erf(cofit[6]/sqrt(2)))^2 -1) * (exp( -(0.689 + 0.34*exp(-0.37*(cofit[6]-0.5)^2))*(pi/(cofit[4]*cofit[6]))^2*tau/cofit[1]) /(sqrt(1+tau/((cofit[4])^2*cofit[1])))))
	//gz2 = (1+tau/((cofit[4])^2*cofit[1]))^(-0.5)
	gt=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1

	return ( (gx*gy2*gz2*gt)/cofit[0]+cofit[7])
End

//ACF diffusion confinement in y,z directions. 3D_1p1t model
Function/D mod_CFz_3D1p_1t(cofit,tau)			// |cofit=(N, tauD, tauTrip, Ftrip, K, Z, DC)
	Wave/D cofit; Variable/D tau
	
	Variable/D gx, gy, gz2, gt
	
	gx = 1/sqrt(1+tau/cofit[1])
	gy = 1/sqrt(1+tau/cofit[1])
	gz2 = (sqrt(pi)/cofit[5]) * ( 1+ (cofit[5]/sqrt(pi)*erf(cofit[5])/(erf(cofit[5]/sqrt(2)))^2 -1) * (exp( -(0.689 + 0.34*exp(-0.37*(cofit[5]-0.5)^2))*(pi/(cofit[4]*cofit[5]))^2*tau/cofit[1]) /(sqrt(1+tau/((cofit[4])^2*cofit[1])))))
	gt=cofit[3]/(1-cofit[3])*exp(-tau/cofit[2])+1

	return ( (gx*gy*gz2*gt)/cofit[0]+cofit[7])
End



Function mod_ALL(Model, cofit, tau)
	Wave/D cofit
	Variable/D tau, Model
	Switch(Model)
		case 0:
			return mod_3D_1p(cofit, tau)
			break
		case 1:
			return mod_3D_2p(cofit, tau)
			break
		case 2:
			return mod_3D_3p(cofit, tau)
			break
		case 3:
			return mod_3D_1p1t(cofit, tau)
			break
		case 4:
			return mod_3D_1p2t(cofit,tau)
			break
		case 5:
			return mod_3D_2p1t(cofit, tau)
			break
		case 6:
			return mod_3D_2p2t(cofit, tau)
			break
		case 7:
			return mod_3D_3p1t(cofit, tau)
			break
		case 8:
			return mod_ASD(cofit, tau)
			break
		case 9:
			return mod_3D_2pq(cofit, tau)
			break
		case 10:
			return mod_3D_3pq(cofit, tau)
			break
		case 11:
			return mod_3D_2pq1t(cofit, tau)
			break
		case 12:
			return mod_2D_1p(cofit, tau)
			break
		case 13:
			return mod_2Dasym_1p(cofit,tau)
			break
		case 14:
			return mod_2Dasym_1p1t(cofit,tau)
			break
		case 15:
			return mod_2D_2p(cofit, tau)
			break
		case 16:
			return mod_2D_3p(cofit, tau)
			break
		case 17:
			return mod_2D_1p1t(cofit, tau)
			break
		case 18:
			return mod_2D_1p2t(cofit, tau)
			break
		case 19:
			return mod_2D_2p1t(cofit, tau)
			break
		case 20:
			return mod_2D_2p2t(cofit, tau)
			break
		case 21:
			return mod_2D_3p1t(cofit, tau)
			break
		case 22:
			return mod_3D_dist(cofit, tau)
			break
		case 23:
			return mod_CC_1p(cofit,tau)
			break
		case 24:
			return mod_P_flow(cofit,tau)
			break
		case 25:
			return mod_D_flow(cofit,tau)
			break
		case 26:
			return mod_D_flow_1t(cofit,tau)
			break
		case 27:
			return mod_D_2flow_1t(cofit,tau)
			break
		case 28:
			return mod_D_2flow(cofit, tau)
			break
		case 29:
			return mod_D_Zflow(cofit,tau)
			break
		case 30:
			return mod_D_Zflow_1t(cofit,tau)
			break
		case 31:
			return mod_D_XZflow(cofit,tau)
			break
		case 32:
			return mod_D_XZflow_1t(cofit,tau)
			break
		case 33:
			return mod_D_2Bflow(cofit,tau)
			break
		case 34:
			return mod_D_2BflowR(cofit, tau)
			break	
		case 35:
			return mod_3D_1p1t1r(cofit,tau)
			break
		case 36:
			return mod_3D_1p2t1r(cofit,tau)
			break
		case 37:
			return mod_CFyz_3D1p_1t(cofit,tau)
			break
	endswitch
end		