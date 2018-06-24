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
 .imsideintrotable>img {
    width:auto;
    float:left;
    padding:0 5px;
  }
</style>

<style>
 .imsideiitjlfrac>img {
    width:30%;
    float:right;
    padding:5 5px;
  }
</style>

![Table](/static/assets/img/blog/pcmsim/intro_table.JPG  "Details table")
{: .imsideintrotable}
![Liquid fraction contours of Gallium melting at t=180s in ANSYS FLUENT](/static/assets/img/blog/pcmsim/iitj_lfrac.jpg  "Liquid fraction contours of Gallium melting at t=180s in ANSYS FLUENT")
{: .imsideiitjlfrac}

</div>


## Motivation
{: .alert .alert-info}

Phase Change Materials (*Eg: Wax* ) store a large amount of heat at almost constant temperature near their melting points because of latent heat. This is very useful for applications which require cooling ([electronic devices](https://yashg1.github.io/portfolio/2018/06/14/cooling-phones.html), green buildings) or heat storage (concentrated solar power as shown below [^2]).

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

Thermal energy is stored when the PCMs in the storage tank shown above melt.  Ideally, higher HTF temperatures are beneficial since more thermal energy can be stored. Typically, HTF used in CSP have melting points of $$\approx\,390\,°\mathrm{C} $$.


## Objectives
{: .alert .alert-info}
1. Feasibility study: molten salt as PCMs ($$ T_\mathrm{melting\,point}\,\approx\,500\,°\mathrm{C}$$) for solar energy storage in ANSYS FLUENT
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

<!-- blank line -->
<figure class="video_container">
  <iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/SwzDqAWGufE?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</figure>
<!-- blank line -->


## Publications
{: .alert .alert-info}


1. Summer Undergraduate Research Report : [Viability of using Sodium and Potassium based salts as heat storage medium](https://github.com/yashg1/yashg1.github.io/blob/4c6fc517ba52d473385b2d00f4bb4f487842fae7/resources/pcmsim_ref/UGRI%20REPORT_college.pdf)

2. Numerical Methods in Heat and Mass Transfer Project Report: [Modeling of soldi-liquid phase change using Enthalpy Porosity Technique](https://github.com/yashg1/yashg1.github.io/blob/4c6fc517ba52d473385b2d00f4bb4f487842fae7/resources/pcmsim_ref/ME%20608%20Final%20report%20group%205.pdf)

{% include archive.html %}

## Skills
{: .alert .alert-info}


* Comparing various CFD solution approaches

* Model validation and mesh refinement

* Developing 2D CFD solver in MATLAB

* Enhancing heat transfer model capability in ANSYS FLUENT using UDF
{: .alert .alert-success}
