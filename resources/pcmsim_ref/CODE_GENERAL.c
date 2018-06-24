/* ======CHECKPOINTS=======
1. Bracket Compatibility
2. Influence of mixture terms
3. Definition of variables
4.  Define user defined memory locations 
*/
/* Validation problem from Incropera
   C_UDMI(c,t,0) -- Latent heat content (delta H)
   C_UDMI(c,t,1) -- Latent heat content for last timestep
   C_UDMI(c,t,2) -- Liquid fraction
   C_UDMI(c,t,3) -- Liquid fraction for last timestep
   C_UDMI(c,t,4) -- 0 indicates solid zone
				    1 indicates liquid zone
*/

#include "udf.h"
/* =========== USER INPUTS START ================ */
#define Cmor                 1.0e+07  /* Morphological Constant */
#define Tiny                 0.001     /* Small number to avoid div by zero */
#define lamda                0.01      /* Relaxation factor for latent heat update */
#define TMELT                302.9    /* Melting point in Kelvin */
#define Liquid_Cond          32      /* Liquid phase conductivity in W/m-K */
#define Solid_Cond           32.0      /* Solid phase conductivity in W/m-K */
#define Latent_Heat          80160.0   /* Latent heat in J/kg */
#define beta_thermal         1.81e-03  /* Thermal expansion coefficient */


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
	   if(C_T(c,t) < TMELT)
	  { C_UDMI(c,t,4) = 0.0;  /* Solidified region */
	    C_UDMI(c,t,0) = 0.0;
        C_UDMI(c,t,1) = 0.0;
        C_UDMI(c,t,2) = 0.0;
        C_UDMI(c,t,3) = 0.0; 
	   }
	   else
	   {
		C_UDMI(c,t,4) = 1.0;  /* Liquid region */
	    C_UDMI(c,t,0) = Latent_Heat;
        C_UDMI(c,t,1) = Latent_Heat;
        C_UDMI(c,t,2) = 1.0;
        C_UDMI(c,t,3) = 1.0;
	   }
	}
      end_c_loop(c,t)
}
  }
}

/*=========== DEFINING SOURCE TERMS==============*/
/* X-Momentum Source Term */
DEFINE_SOURCE(x_source, c, t, dS, eqn)
{ real con, source, lfrac;
  lfrac = C_UDMI(c,t,2);
  con = -Cmor*(1.0-lfrac)*(1.0-lfrac)/((lfrac*lfrac*lfrac) + Tiny);
  source = con * C_U(c,t);     /* CHECK IF V or U which denote velocity components*/
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
  thermal = C_R(c,t)*9.81*beta_thermal*(C_T(c,t)-TMELT);
  source += thermal;
  dS[eqn] = con;
  return source;
}
  /* Energy Source Term (second one is ignored as no velocity in solid zone*/

DEFINE_SOURCE(eng_source, c, t, dS, eqn)
{ real source, timestep;
  cell_t  c0, c1;
  Thread *tc0, *tc1, *ft;
  face_t f;
  int n;
  timestep = RP_Get_Real("physical-time-step");
  source   = -C_R(c,t)*(C_UDMI(c,t,0)-C_UDMI(c,t,1))/timestep;   /* Check definition of latent heat content*/
  dS[eqn]=0.0;
  return source;
}
/* Defining Adjust function. Here enthalpy will be updated*/
DEFINE_ADJUST(my_adjust, d)
{ real timestep, ap, ap0, eng_src;
  int n;
  cell_t c, c0, c1;
  Thread *t, *tc0, *tc1, *ft;
  face_t f;
  timestep = RP_Get_Real("physical-time-step");
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
	
  if(C_T(c,t) < TMELT)       C_UDMI(c,t,4) = 0.0;     /* Solid  region */
	  else                          C_UDMI(c,t,4) = 1.0;     /* Liquid region */
/* Update Latent heat content  (Define inverse function first then proceed. Inverse function is TMELT)*/
         ap0 = C_R(c,t)*C_CP(c,t)*C_VOLUME(c,t)/timestep;
         if (NNULLP(THREAD_STORAGE(t,SV_T_AP))) ap = -C_STORAGE_R(c,t,SV_T_AP);
         else ap = 0.0;
C_UDMI(c,t,0) += (ap/ap0)*C_CP(c,t)*lamda*(C_T(c,t) - TMELT);

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

