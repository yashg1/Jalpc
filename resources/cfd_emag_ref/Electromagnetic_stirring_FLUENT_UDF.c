#include "udf.h"
#include "models.h" /* N_UDS is stored here*/
#include "math.h"
// Internal filename: CopperBar_27.3.c
/* CHECKLIST
---BOUNDARY CONDITIONS---
1. SYNTAX OF COMMON FUNCTIONS
2. SIGNS OF TERMS
3. CONSTANT VALUES / TYPOS IN FORMULAS
4. LOOPING CORRECT
5. ACCESS VIOLATION CHECK
*/

/* Validating magnetic field around copper bar (square)*/
/*User defined memories - TOTAL 14
=======scalar equations===========
C_UDSI(c,t,0) -- Ax
C_UDSI(c,t,1) -- Ay
C_UDSI(c,t,2) -- Az
C_UDSI(c,t,3) -- Phi

*/
/*======USER INPUTS START======*/
/* All data taken from Zhe Huang Chalmers thesis*/
#define sigair  1e-5    /* Electrical conductivity of air* in S/m/ */
#define sigcond 2700     /* Electrical conductivity of copper* in S/m/ */
#define mu0 1.26e-6  /* Magnetic permeability of air* in Wb/m/ */
#define xl  -0.2
#define xu 0.2
#define yl  -0.2
#define yu 0.2
#define zl  -6
#define zu   0


/* Using A-V formulation where voltage is specified*/


DEFINE_INIT(initialize,d)
{
  cell_t c;
  Thread *t;
  int i;

  thread_loop_c(t,d)   /* Loop over all cell threads in domain */
  {

    begin_c_loop(c,t)  /* Loop over all cells in a cell thread*/
    {
		 for(i=0; i<sg_udm; ++i) C_UDMI(c,t,i) = 0.0;
	  }
      end_c_loop(c,t)
}
  }
DEFINE_DIFFUSIVITY(my_diff,c,t,i)
{
real x[ND_ND];
real x0, y0, z0;
if(i==0 || i ==1 || i ==2)
return 1.0;
else if (i==3)
{
  C_CENTROID(x,c,t);
  x0 = x[0];
  y0 = x[1];
  z0 = x[2];
  if(x0>=xl && x0<=xu && y0>=yl && y0<=yu && z0>=zl && z0<=zu) //  && y0>=yl && y0<=yu && z0>=zl && z0<=zu
  { return sigcond;}
                    else
                    return sigair;
                    //else
                    //return 0.0;

}
}

/*====ADJUST FUNCTION====*/
DEFINE_ADJUST(my_adjust,d)
{
                               real Bx,By,Bz;
                               real Jx,Jy,Jz,JJ;
                               real Fx,Fy,Fz;
                               real sigma =0;
                               real x[ND_ND];
                               int i;
                               cell_t c;
                               Thread*t;
                               thread_loop_c(t,d)                            //Loop over all cell threads in a domain
                               {
                                                                             if(NULLP(THREAD_STORAGE(t,SV_UDS_I(0))))
                                                                             Internal_Error("Storage is not allocated for user defined storage variable : Ax");
                                                                             if(NULLP(THREAD_STORAGE(t,SV_UDS_I(1))))
                                                                             Internal_Error("Storage is not allocated for user defined storage variable : Ay");
                                                                             if(NULLP(THREAD_STORAGE(t,SV_UDS_I(2))))
                                                                             Internal_Error("Storage is not allocated for user defined storage variable : Az");
                                                                             if(NULLP(THREAD_STORAGE(t,SV_UDS_I(3))))
                                                                             Internal_Error("Storage is not allocated for user defined storage variable : V");
                                                                             if (NULLP(THREAD_STORAGE(t, SV_UDM_I)))
                                                                             Internal_Error("Thread has no user-defined memories set up on it !");
                                                                              begin_c_loop(c,t)           // Loop over all cells in a given thread
                                                                              {
                                                                                sigma = C_UDSI_DIFF(c,t,3);
                                                                                Jx = -sigma*C_UDSI_G(c,t,3)[0];
                                                                                Jy = -sigma*C_UDSI_G(c,t,3)[1];
                                                                                Jz = -sigma*C_UDSI_G(c,t,3)[2];
                                                                                JJ = sqrt((Jx*Jx) + (Jy*Jy) + (Jz*Jz));
                                                                                Bx = C_UDSI_G(c,t,2)[1] - C_UDSI_G(c,t,1)[2];
                                                                                By = C_UDSI_G(c,t,0)[2] - C_UDSI_G(c,t,2)[0];
                                                                                Bz = C_UDSI_G(c,t,1)[0] - C_UDSI_G(c,t,0)[1];
                                                                                C_UDMI(c,t,0) = Bx;
                                                                                C_UDMI(c,t,1) = By;
                                                                                C_UDMI(c,t,2) = Bz;
                                                                                C_UDMI(c,t,3) = Jx;
                                                                                C_UDMI(c,t,4) = Jy;
                                                                                C_UDMI(c,t,5) = Jz;
                                                                                C_UDMI(c,t,6) = JJ;
                                                                                C_UDMI(c,t,7) = NV_MAG(C_UDSI_G(c,t,3));
                                                                                C_UDMI(c,t,8) = sigma*C_UDMI(c,t,7);
                                                                                C_UDMI(c,t,9) = sqrt((Bx*Bx)+(By*By)+(Bz*Bz));
                                                                                C_UDMI(c,t,10) =sqrt((C_UDSI(c,t,0)*C_UDSI(c,t,0))+(C_UDSI(c,t,1)*C_UDSI(c,t,1))+(C_UDSI(c,t,2)*C_UDSI(c,t,2)));
                                                                                C_UDMI(c,t,11) = C_UDSI_G(c,t,3)[0];
                                                                                C_UDMI(c,t,12) = C_UDSI_G(c,t,3)[1];
                                                                                C_UDMI(c,t,13) = C_UDSI_G(c,t,3)[2];

                                                                               }
                                                                                end_c_loop(c,t)
                                                                                }
                                                                                }



/*======SOURCE TERMS=======*/
/* SOURCE TERMS = MU0*J  (CHECK MINUS SIGN OF A)*/
DEFINE_SOURCE(Ax_src,c,t,dS,eqn)
{
        real source;
        source = mu0*C_UDMI(c,t,3);
       return source;
       }
DEFINE_SOURCE(Ay_src,c,t,dS,eqn)
{
       real source;
       source = mu0*C_UDMI(c,t,4);
       return source;
       }
DEFINE_SOURCE(Az_src,c,t,dS,eqn)
{
       real source;
       source = mu0*C_UDMI(c,t,5);
       return source;
       }
