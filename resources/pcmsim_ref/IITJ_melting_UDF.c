
/* Validation problem from Incropera
   C_UDMI(c,t,0) -- Latent heat content (delta H)
   C_UDMI(c,t,1) -- Latent heat content for last timestep
   C_UDMI(c,t,2) -- Liquid fraction
   C_UDMI(c,t,3) -- Liquid fraction for last timestep
   C_UDMI(c,t,4) -- 0 indicates solid zone
				    1 indicates liquid zone
   C_UDSI(c,t,0) -- Temperature
*/
/* USE OF UDSI TO WRITE TRANSPORT EQN IN TERMS OF TEMPERATURE*/

#include "udf.h"
#include "sg_mem.h"
#include "mem.h"
#include "sg.h"


/* =========== USER INPUTS START ================ */
#define Cmor                 1.0e+07  /* Morphological Constant */
#define Tiny                 0.001     /* Small number to avoid div by zero */
#define lamda                0.01      /* Relaxation factor for latent heat update */
#define TMELT                302.9    /* Melting point in Kelvin */
#define Liquid_Cond          32      /* Liquid phase conductivity in W/m-K */
#define Solid_Cond           32.0      /* Solid phase conductivity in W/m-K */
#define Latent_Heat          80160.0   /* Latent heat in J/kg */
#define beta_thermal         1.81e-03  /* Thermal expansion coefficient */


enum
{
	t1, N_REQUIRED_UDS
};

/* =========== USER INPUTS END ============== */


/*=========== INITIALIZING ==============*/
/* Identify the cells in the mushy zone (initial state is either solid or liquid – write for that) */

DEFINE_INIT(initialize,d)
{ cell_t c;
  Thread *t;
  int i;

  thread_loop_c(t,d)   /* Loop over all cell threads in domain */
  {
if (FLUID_THREAD_P(t))
   {
    begin_c_loop(c,t)  /* Loop over all cells in a cell thread*/
    { 
		 for(i=0; i<sg_udm; ++i) C_UDMI(c,t,i) = 0.0;
	  }
      end_c_loop(c,t)
}
  }
}

/* ============== UNSTEADY STATE TERM============*/
DEFINE_UDS_UNSTEADY(my_unsteady,c,t,i,apu,su)
{
	real timestep,vol,rho,temp_old;
	timestep = RP_Get_Real("physical-time-step");
	vol = C_VOLUME(c,t);
	rho = C_R_M1(c,t);
	*apu = -rho*vol/timestep; /*implicit part*/
	temp_old = C_STORAGE_R(c,t,SV_UDSI_M1(t1));
	*su = rho*vol*temp_old/timestep;  /* explicit part*/
}


/*=========== DEFINING SOURCE TERMS==============*/
/* X-Momentum Source Term */
DEFINE_SOURCE(x_source, c, t, dS, eqn)
{ real con, source, lfrac;
  lfrac = C_UDMI(c,t,2);
  con = -Cmor*(1.0-lfrac)*(1.0-lfrac)/((lfrac*lfrac*lfrac) + Tiny);
  source = con * C_U(c,t);     
 dS[eqn] = con;
  return source;
}
/* Y-Momentum Source Term (instead of Teut write Tmelt) */
DEFINE_SOURCE(y_source, c, t, dS, eqn)
{ real con, source, lfrac, thermal;
  lfrac = C_UDMI(c,t,2);
  con = -Cmor*(1.0-lfrac)*(1.0-lfrac)/((lfrac*lfrac*lfrac) + Tiny);
  source = con * C_V(c,t);
  /* Boussinesque terms */
  thermal = -C_R(c,t)*9.81*beta_thermal*(C_UDSI(c,t,t1)-TMELT);
  source += thermal;
 dS[eqn] = con;
  return source;
}
  /* Energy Source Term (second one is ignored as no velocity in solid zone*/

DEFINE_SOURCE(eng_source, c, t, dS, eqn)
{ real source, timestep;
  timestep = RP_Get_Real("physical-time-step");
 source   = C_R(c,t)*(C_UDMI(c,t,0)-C_UDMI(c,t,1))/(381.5*timestep);
    dS[eqn]=0.0;
return source;
}

/* Diffusivity*/
DEFINE_DIFFUSIVITY(diff_coeff,c,t,i)
{if(i==t1) return 0.083;
else return 0.0;
}
/* Defining Adjust function. Here enthalpy will be updated*/
DEFINE_ADJUST(my_adjust, d)
{ real timestep, ap, ap0, eng_src;
  int n;
  cell_t c, c0, c1;
  Thread *t;
  face_t f;
  timestep = RP_Get_Real("physical-time-step");
  if(N_UDS < N_REQUIRED_UDS)
	  Error("Not enough user defined scalar allocated");
thread_loop_c(t,d)     /* Loop over all cell threads in domain*/
  {
if (FLUID_THREAD_P(t))
     {
begin_c_loop(c,t)
       {
          /* Store the latent heat content for previous timestep
   	  This will be required for energy equation source term */
          if(first_iteration)
          {
	     C_UDMI(c,t,1) = C_UDMI(c,t,0);
             C_UDMI(c,t,3) = C_UDMI(c,t,2);
	  }
/* Identify the cells in the mushy zone (my code – note brackets) */
	
  if(C_UDSI(c,t,t1) < TMELT)       C_UDMI(c,t,4) = 0.0;     /* Solid  region */
	  else                          C_UDMI(c,t,4) = 1.0;     /* Liquid region */
/* Update Latent heat content  (Define inverse function first then proceed. Inverse function is TMELT)*/
          ap0 = C_R(c,t)*C_VOLUME(c,t)/timestep;
         if (NNULLP(THREAD_STORAGE(t,SV_UDSI_AP))) ap = -C_STORAGE_R(c,t,SV_UDSI_AP);
         else ap = 0.0;
C_UDMI(c,t,0) += (ap/ap0)*lamda*381.5*(C_UDSI(c,t,t1)- TMELT);

/* Eliminate unphysical values */

         if(C_UDMI(c,t,0) >  Latent_Heat ) C_UDMI(c,t,0) =  Latent_Heat;
          if(C_UDMI(c,t,0) < 0.0) C_UDMI(c,t,0) = 0;
	

        /* Calculate liquid fraction */
         C_UDMI(c,t,2) = (C_UDMI(c,t,0)) / Latent_Heat;
		 

}
       end_c_loop(c,t)
}
}
}

DEFINE_ON_DEMAND(my_demand)
 {
	Domain *d;
	Thread *t;
	cell_t c;
	real ap,ap0,timestep;
	d = Get_Domain(1);
	thread_loop_c(t,d)
	{
		begin_c_loop(c,t)
		{
			timestep = RP_Get_Real("physical-time-step");
			 ap0 = C_R(c,t)*C_VOLUME(c,t)/timestep;
			 if (NNULLP(THREAD_STORAGE(t,SV_UDSI_AP))) ap = -C_STORAGE_R(c,t,SV_UDSI_AP);
         else ap = 0.0;
		 C_UDMI(c,t,0) += (ap/ap0)*lamda*381.5*(C_UDSI(c,t,t1)- TMELT);
		 
         if(C_UDMI(c,t,0) >  Latent_Heat ) C_UDMI(c,t,0) =  Latent_Heat;
          if(C_UDMI(c,t,0) < 0.0) C_UDMI(c,t,0) = 0;
		 Message("ap = %g\t ap0 = %g \n Latent Heat now = %g \n",ap,ap0,C_UDMI(c,t,0));
		}
		end_c_loop(c,t)
	}
}


