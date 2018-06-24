---
layout: post
title:  "Cooling micro/nano-scale hotspots in processors in COMSOL"
date:   2018-06-24
desc: "Thermal simulation of PCB for electronics cooling in COMSOL"
keywords: "CFD, Simulation, MATLAB, COMSOL, Boltzmann Transport Equation, Radiative Transport Equation, Hotspots, Electronics Cooling"
categories: [Portfolio]
tags: [Electronics Cooling, COMSOL, MATLAB, Grad School, Heat Transfer]
icon: icon-html
---
{::options parse_block_html="true" /}

## Project Description
{: .alert .alert-info}

<div class="panel-body">

<style>
 .imsidefouriernano>img {
    width:30%;
    float:right;
    padding:0 5px;
  }
</style>

![2D temperature contours in diffusive and ballistic heat transfer regimes](/static/assets/img/blog/nanoheat/fourier_nano_ht.jpg  "2D temperature contours in diffusive and ballistic heat transfer regimes")
{: .imsidefouriernano}

Course: ME503: Micro/Nano Scale Energy Transport Processes  

Duration: August 2015 - December 2015    

Advisor: Prof Timothy Fisher  

Institute: Purdue University, USA
Collaborators:


</div>


## Motivation
{: .alert .alert-info}

Electronic devices keep getting more powerful and smaller due to [Moore's Law](https://en.wikipedia.org/wiki/Moore%27s_law). Todays transistors are just 70 atoms wide (Silicon's atomic size is $$ \approx 2\,\mathrm{nm$$). Thermal considerations have significantly impact the reliability and performance. Heat conduction for such small lengths (micro/nanoscale) is different from the macroscale.

>**Fourier's heat conduction equation is not applicable to heat transfer at small length scales because the heat transport mechanism is different. Instead, Boltzmann Transport Equation governs the heat transfer for these length scales.**

Microscale effects in a thin layer inhibit heat flow from the hotspots in a processor (transistor) causing temperature peaks which can reduce the time to failure [^2]. A macroscale (Fourier) heat conduction model applied to a microscale does not capture microscale effects leading to a significant error and underprediction of temperatures in a processor.
{: .alert .alert-danger}

[^2]: Flik, M. I., B. I. Choi, and K. E. Goodson. "Heat transfer regimes in microstructures." Journal of Heat Transfer 114.3 (1992): 666-674.

Heat conduction equations for macroscale assume that the transport properties are independent of the size (length scale). In metals, free electrons continuously move randomly and collide with each other, which results in energy transfer. *Mean free path* is the distance travelled between successive collisions and relaxation time is the time between successive collisions. When two ends of a metal are maintained at different temperatures, there is a net transport of energy from the hot to the cold side since the electrons on the hot side have more energy (*diffusive heat transfer*). When the device thickness is similar to the mean free path, the electrons (in metals) and phonons (primary heat carriers in semiconductors and insulators) mostly collide with the boundary rather than each other. This is known as *ballistc heat transfer*[^2].

[^2]: [Heat transfer schematic from P-Olivier Chapius](http://polivier.chapuis.free.fr/P-Olivier%20CHAPUIS%20-%20Research.htm) and [Heat transfer regimes and thermal conductivity images from Electronics Cooling magazine](https://www.electronics-cooling.com/2007/02/microscale-heat-transfer/)

<style>
 .imsidenano>img {
    width:30%;
    padding:0 5px;
  }
</style>

![Diffusive and Ballistic heat transfer comparison](/static/assets/img/blog/nanoheat/ht_compare.jpg "2D temperature contours in diffusive and ballistic heat transfer regimes")
![Heat transfer regimes](/static/assets/img/blog/nanoheat/ht_compare.jpg "Heat transfer regime based on length scale")
![Effects of length scale on thermal conductivity](/static/assets/img/blog/nanoheat/thermal_cond_thickness.gif "Effects of length scale on thermal conductivity")
{: .imsidenano}


## Objectives
{: .alert .alert-info}
1.
2. Develop customizable phase change CFD simulation in MATLAB
{: .alert .alert-warning}


## Highlights
{: .alert .alert-info}

* Developed and validated 2D CFD models of phase change in MATLAB and ANSYS FLUENT with analytical and numerical solutions

* Expanded model capability by including temperature variation of material properties (specific heat, thermal conductivity, viscosity) using [User Defined Functions](http://www.afs.enea.it/project/neptunius/docs/fluent/html/udf/node5.htm), programmed in C

* Developed 2D heat transfer and fluid flow CFD solver in MATLAB from first principles using finite volume method (FVM)

* Increased solver speed by vectorizing MATLAB code

<style>
 .imside608>img {
    width:30%;
    padding:0 5px;
  }
</style>

![2D model geometry for heat transfer model validation in MATLAB with non-dimensionalized initial and temperature boundary conditions ](/static/assets/img/blog/pcmsim/608_2d_model_geom.JPG "2D model geometry for heat transfer model validation in MATLAB with non-dimensionalized initial and temperature boundary conditions")
![Comparison of temperature variation along horizontal centerline for different grid sizes with analytical solution and simulation results of Cross et al at t=500s](/static/assets/img/blog/pcmsim/608_temp_plot.JPG "Grid independence test for 2D phase change heat transfer MATLAB model")
{: .imside608}



## Publications
{: .alert .alert-info}


1. Summer Undergraduate Research Report : [Viability of using Sodium and Potassium based salts as heat storage medium](https://github.com/yashg1/yashg1.github.io/blob/4c6fc517ba52d473385b2d00f4bb4f487842fae7/resources/pcmsim_ref/UGRI%20REPORT_college.pdf)



## Skills
{: .alert .alert-info}


* Comparing various CFD solution approaches

* Model validation and mesh refinement

* Developing 2D CFD solver in MATLAB

* Enhancing heat transfer model capability in ANSYS FLUENT using UDF
{: .alert .alert-success}
