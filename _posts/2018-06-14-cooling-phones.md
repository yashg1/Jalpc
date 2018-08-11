---
layout: post
title:  "Cooling Smartphones with Phase Change Materials (PCMs)"
date:   2018-06-14
desc: "Electronics Cooling"
keywords: "Electronics cooling, CFD, Heat Transfer, Phase Change Materials,Thermal stress test, COMSOL, Simulation"
categories: [Portfolio]
tags: [Electronics Cooling, MS Thesis Research, Heat Transfer, CFD, Experiments, Grad School]
icon: icon-html
---
{::options parse_block_html="true" /}

## Project Description
{: .alert .alert-info}

<div class="panel-body">

<img src="/static/assets/img/blog/msthesis/intro_pcm.jpg" alt="Why PCM" style="float:right;width:25%; margin-left: 20px;">

Course: MS Thesis Research  

Duration: August 2014 - December 2016

Collaborators: Zhenhuan Xu, Alex Bruce, Prahlad Kulkarni, Javieradrian Ruiz, Michael Woodworth, Claire Lang  

Advisor: Prof. Amy Marconnet & John Howarter  

Funding Agency: [Cooling Technologies Research Center](https://engineering.purdue.edu/CTRC)  



</div>


## Motivation
{: .alert .alert-info}


> Electronic devices keep getting more powerful and smaller in size. The temperature limits for reliable operation of the materials used to make phones (*Ex: Silicon used in processor* ) remain unchanged.

Cooling a mobile phone implies developing a thermal management solution with the following challenges:

1. The outer case or surface temperature of the phone should be < 40°C so that the user can hold the phone  

2. The processor temperature should be < 80°C for reliable operation

3. Heat transfer to the ambient is limited by natural convection. In other words, the phone is not used in a "windy" environment.

4. [Many interactive smartphone applications have a short burst of excess power consumption followed by an idle time waiting for user inputs](www.scientificamerican.com/article/computational-sprinting/). Keeping the processor temperature within operating limits goes a long way in ensuring a responsive user interface (*preventing lags*).

## Why Phase Change materials
{: .alert .alert-info}

 Store heat without increasing the temperature (around their melting point). The supplied heat is absorbed and used to change the phase. Conversely, during solidification, heat is liberated and the material changes phase to solid.  

>From a thermal management standpoint, this is like hitting a jackpot!

A PCM can be used to absorb the excess heat during periods of intense use in a smartphone while keeping the temperatures around the melting point. This is a win-win situation since the smartphone performance is improved while keeping the (processor & surface) temperatures in check.


## Objectives
{: .alert .alert-info}


How can PCMs be used to deliver an optimal cooling solution?
I conducted a feasibility study on the use of PCMs in smartphones to answer the following questions.
{: .alert .alert-warning}

<style type="text/css">
table{
    border-collapse: collapse;
    border:2px solid black;  
}

</style>

| Questions      | Work Done         |
| -------------- + ------------------ |
| How to compare different thermal solutions?         |   {::nomarkdown}<ul><li> Reviewed literature </li><li> Surveyed thermal engineers in the industry</li></ul>{:/} Identified cutoff time - time taken to reach 80°C (cutoff temperature) |
| -------------- + ------------------ |
|   What are the key design parameters?         |    {::nomarkdown}<ul><li>Integration location of the PCM: on the processor or near the surface </li><li>Weight/Volume of PCM required </li><li>Processor power profile (*power vs time curve*) </li></ul>{:/}|
| -------------- + ------------------ |
|  What are the critical material properties?         |    {::nomarkdown}<ul><li> Thermal conductivity </li><li> Latent Heat </li>     <li> Melting Point (Transition Temperature) </li></ul>{:/} Characterized thermal conductivity using reference bar method (*ASTM D5470 standard*) with Infra-Red (IR) camera       |
| -------------- + ------------------ |
|How do they influence the key design parameters?| Analyzed the effect of material properties, PCM weight and integration location on the cutoff time by       {::nomarkdown} <ul><li> Performing stress tests with PCM on the processor of a Thermal Test Vehicle   </li><li> Developed phone and processor level heat transfer simulations in COMSOL & ANSYS ICEPAK </li> <li> Performed Uncertainty Ananlysis (Parametric sweep) to determine critical properties </li> </ul> {:/}|

## Highlights
{: .alert .alert-info}


* Achieved an increase in cutoff time by $$ 1.5 - 2.48 \times $$ with the PCM compared to no PCMs

* PCM thickness and convection heat transfer coefficient have the largest impact on the cutoff time

<style>
 .imsidemsthesishighlight>img {
    width:22%;
    padding:0 5px;
  }
</style>

![Measure thermal conductivity of TIM using IR camera and reference bar method](/static/assets/img/blog/msthesis/cross_plane_rig_temp_map.jpg "Measure thermal conductivity of TIM using IR camera and reference bar method")
![IR surface temperatures of processor only and PCM on top of processor during thermal stress test](/static/assets/img/blog/msthesis/ir_surface_temps.jpg "IR surface temperatures of processor only and PCM on top of processor during thermal stress test")
![Hardware thermal stress test setup](/static/assets/img/blog/msthesis/sbc_setup_image.jpg "Hardware thermal stress test setup")
![3D system level heat transfer simulation of a smartphone in COMSOL ](/static/assets/img/blog/msthesis/simphone.jpg "3D system level heat transfer simulation of a smartphone in COMSOL")
{: .imsidemsthesishighlight}

PCM Melt Front Propagation

<!-- blank line -->
<figure class="video_container">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/K4colRpZPqg?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</figure>
<!-- blank line -->


## Publications
{: .alert .alert-info}

1. MS Thesis: [Passive Thermal Management using Phase Change Materials](https://search.proquest.com/docview/1881313041)

2. International Journal of Thermal Sciences: [Experimental Investigation of Phase Change Materials for Thermal Management of Handheld Devices](https://doi.org/10.1016/j.ijthermalsci.2018.03.012)

3. ASME InterPACK 2015 Conference: [Passive Thermal Management Using Phase Change Materials: Experimental Evaluation of Thermal Resistances](resources/msthesis_ref/ASME_InterPack.pdf)



## Skills
{: .alert .alert-info}

* Design space exploration

* Thermal Design

* MATLAB programing and scripting to extract and analyze data

* 2D/3D heat transfer/CFD simulations in COMSOL, ANSYS ICEPAK

* Hardware thermal testing

* 3D Printing

* IR Camera & thermocouples temperature measurement

* Mentoring undergraduate students
{: .alert .alert-success}
