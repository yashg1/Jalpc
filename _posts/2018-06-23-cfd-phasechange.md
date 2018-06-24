---
layout: post
title:  "Heat Transfer Simulation of Phase Change in MATLAB & ANSYS FLUENT "
date:   2018-06-23
desc: "CFD/Heat transfer simulation in MATLAB and ANSYS FLUENT"
keywords: "CFD, Simulation, MATLAB, Phase Change, Solar Energy Storage, ANSYS FLUENT, ANSYS, UDF, UDS, C, User defined functions"
categories: [Portfolio]
tags: [ANSYS FLUENT, MATLAB, User defined programing, Grad School, Undergrad, Heat Transfer, CFD]
icon: icon-html
---
{::options parse_block_html="true" /}

## Project Description
{: .alert .alert-info}

<div class="panel-body">

<style>
 .imside>img {
    width:auto;
    float:left;
    padding:0 5px;
  }
</style>

<style>
 .imside2>img {
    width:30%;
    float:right;
    padding:5 5px;
  }
</style>

![Table](/static/assets/img/blog/pcmsim/intro_table.JPG  "Details table")
{: .imside}
![Liquid fraction contours of Gallium melting at t=180s in ANSYS FLUENT](/static/assets/img/blog/pcmsim/iitj_lfrac.jpg  "Liquid fraction contours of Gallium melting at t=180s in ANSYS FLUENT")
{: .imside2}

</div>


## Motivation
{: .alert .alert-info}

Phase Change Materials (*Eg: Wax*) store a large amount of heat at almost constant temperature near their melting points because of latent heat. This is very useful for applications which require cooling ([electronic devices](https://yashg1.github.io/portfolio/2018/06/14/cooling-phones.html), green buildings) or heat storage (concentrated solar power as shown below [^2]).

[^2]: Figure from Mathur, A., et al. "Using encapsulated phase change salts for concentrated solar power plant." Energy Procedia 49 (2014): 908-915.

<style>
 .imsidepcmcsp>img {
    width:30%;
    padding:0 5px;
  }
</style>
![PCM used for Thermal Energy Storage in Concentrated Solar Power Plant](/static/assets/img/blog/pcmsim/pcm_csp.JPG "PCM used for Thermal Energy Storage in Concentrated Solar Power Plant")
{: .imsidepcmcsp}

In Concentrated Solar Power Plant (CSP), solar energy is concentrated via large array of mirrors that focus sunlight on to a Heat Transfer Fluid (HTF). At night, CSP are forced to undergo repeated startup and shut-down operations.
> To avoid using fossil fuels, excess power generated during daytime can be stored using PCMs and utilized at off-peak times.

Ideally, higher HTF temperatures are beneficial since more energy is stored. Typically, HTF used in CSP have melting points of ($$\approx\,390\,°\mathrm{C} $$).

## Objectives
{: .alert .alert-info}
1. Feasibility study: molten salt as PCMs ($$ T_\mathrm{melting\,point}\,\approx\,500,°\mathrm{C}$$) for solar energy storage in ANSYS FLUENT
2. Develop customizable phase change CFD simulation in MATLAB
{: .alert .alert-warning}


## Highlights
{: .alert .alert-info}



* Solved Maxwell's electromagnetic equations in ANSYS FLUENT using [User Defined Functions](http://www.afs.enea.it/project/neptunius/docs/fluent/html/udf/node5.htm), programmed in C

* Validated model with analytical solutions

* Enhanced model functionality to include custom inputs (waveforms) of AC current

* Developed CFD simulations by coupling electromagnetic and fluid flow equations


## Publications
{: .alert .alert-info}


1. BS Thesis: [Modeling of Electromagnetic Stirring of Liquid Metals](https://github.com/yashg1/yashg1.github.io/blob/43c78338d9abaad9278c5321e61bdf1b698ba4e0/resources/cfd_emag_ref/GanatraYash_BSME_thesis.pdf)

2. ANSYS FLUENT UDF code for solving Maxwell's equations: [Code](https://github.com/yashg1/yashg1.github.io/blob/469c21c739b1005086745d9b17427055ef4e8d33/resources/cfd_emag_ref/Electromagnetic_stirring_FLUENT_UDF.c)

## Skills
{: .alert .alert-info}


* Customizing CFD software

* Enhancing CAE model functionality

* Benchmarking models with reference solution (test cases)

* Writing User defined functions (UDF)
{: .alert .alert-success}
