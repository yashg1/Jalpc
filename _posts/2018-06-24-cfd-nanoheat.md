---
layout: post
title:  "Cooling Micro/Nanoscale Hotspots in Processors using COMSOL"
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

Collaborators: Aalok Gaitonde, Bhagyashree Ganore    

Advisor: Prof Timothy Fisher  

Institute: Purdue University, USA


</div>


## Motivation
{: .alert .alert-info}

Electronic devices keep getting more powerful and smaller due to [Moore's Law](https://en.wikipedia.org/wiki/Moore%27s_law). Todays transistors are just 70 atoms wide (Silicon's atomic size is $$ \approx 2\,\mathrm{nm$$). Thermal considerations have significantly impact the reliability and performance. Heat conduction for such small lengths (micro/nanoscale) is different from the macroscale.

>**Fourier's heat conduction equation is not applicable to heat transfer at small length scales because the heat transport mechanism is different. Instead, Boltzmann Transport Equation (BTE) governs the heat transfer for these length scales.** BTE being a *7 dimensional equation, is difficult to solve numerically*. I solved the BTE in COMSOL (FEA solver) by simplifying it and comparing it with the [Radiative Transport Equation](https://www.comsol.com/heat-transfer-module#features), which is solved by COMSOL.

Microscale effects in a thin layer inhibit heat flow from the hotspots in a processor (transistor) causing temperature peaks which can reduce the time to failure [^1]. A macroscale (Fourier) heat conduction model applied to a microscale does not capture microscale effects leading to a significant error and underprediction of temperatures in a processor.
{: .alert .alert-danger}

[^1]: Flik, M. I., B. I. Choi, and K. E. Goodson. "Heat transfer regimes in microstructures." Journal of Heat Transfer 114.3 (1992): 666-674.

Heat conduction equations for macroscale assume that the transport properties are independent of the size (length scale). In metals, free electrons continuously move randomly and collide with each other, which results in energy transfer. *Mean free path* is the distance travelled between successive collisions and relaxation time is the time between successive collisions. When two ends of a metal are maintained at different temperatures, there is a net transport of energy from the hot to the cold side since the electrons on the hot side have more energy (*diffusive heat transfer*). When the device thickness is similar to the mean free path, the electrons (in metals) and phonons (primary heat carriers in semiconductors and insulators) mostly collide with the boundary rather than each other. This is known as *ballistc heat transfer*[^2].

[^2]: [Heat transfer schematic from P-Olivier Chapius](http://polivier.chapuis.free.fr/P-Olivier%20CHAPUIS%20-%20Research.htm) and [Heat transfer regimes and thermal conductivity images from Electronics Cooling magazine](https://www.electronics-cooling.com/2007/02/microscale-heat-transfer/)

<style>
 .imsidenano>img {
    width:30%;
    padding:0 5px;
  }
</style>

![Diffusive and Ballistic heat transfer comparison](/static/assets/img/blog/nanoheat/ht_compare.jpg "2D temperature contours in diffusive and ballistic heat transfer regimes")
![Heat transfer regimes](/static/assets/img/blog/nanoheat/ht_regimes.gif "Heat transfer regime based on length scale")
![Effects of length scale on thermal conductivity](/static/assets/img/blog/nanoheat/thermal_cond_thickness.gif "Effects of length scale on thermal conductivity")
{: .imsidenano}


## Highlights
{: .alert .alert-info}

* Developed 2D micro/nanoscale heat transfer simulation in COMSOL

* Validated model with analytical solutions for different boundary conditions (*temperature only & combination of temperature and heat flux*)

* Simplified BTE to Radiative Transport Equation, which is solved in COMSOL

* Demonstrated that Fourier heat conduction equation is not applicable  $$<\,10\,\mathrm{um}$$ thickness


<style>
 .imsidenanohighlights>img {
    max-width:30%;
    padding:0 5px;
  }
</style>

![2D model geometry for heat transfer model validation in COMSOL ](/static/assets/img/blog/nanoheat/nano_validation.jpg "2D model geometry for heat transfer model validation in COMSOL")
![2D Hotspot geometry](/static/assets/img/blog/nanoheat/hotspot_geom.jpg "2D hotspot geometry")
![2D Hotspot geometry](/static/assets/img/blog/nanoheat/ang_grid_refine.jpg "Angular grid refinement for BTE")
{: .imsidenanohighlights}



## Publications
{: .alert .alert-info}


1. ME 503 Project Report : [Modelling Hotspots in thin films using the Boltzmann Transport Equation](https://github.com/yashg1/yashg1.github.io/blob/a835e87e1f467437dc75af64383b959f8dda45a4/resources/nanoheat_ref/Electronics%20Cooling%20Microscale%20Heat%20Transfer%20Project%20Report.pdf)



## Skills
{: .alert .alert-info}

  - Developing Micro/nanoscale heat transport model in COMSOL

* Running COMSOL simulations from MATLAB with [COMSOL MATLAB LiveLink](https://www.comsol.com/release/5.3/livelink-matlab)

* Understanding and simplifying new physics (governing equations)

* Non-dimensionalizing new equations to compare with built-in equations
{: .alert .alert-success}
