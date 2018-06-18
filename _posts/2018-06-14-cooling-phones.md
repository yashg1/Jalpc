---
layout: post
title:  "Cooling Smartphones with Phase Change Materials (PCMs)"
date:   2018-06-14
desc: "Electronics Cooling"
keywords: "Electronics cooling, CFD, Heat Transfer, Phase Change Materials,Thermal stress test, COMSOL, Simulation"
categories: [Portfolio]
tags: [Electronics Cooling, MS Thesis Research, Heat Transfer, CFD, Experiments]
icon: icon-html
---
# Project Description

<p><img src="/static/assets/img/blog/msthesis/intro_pcm.jpg" alt="Why PCM" style="float:right;width:40%; margin-right: 10px;">
Advisor: Prof. Amy Marconnet & John Howarter  
Funding Agency: [Cooling Technologies Research Center](https://engineering.purdue.edu/CTRC)  
Duration: August 2014 - December 2016  
Course: MS Thesis Research  
Collaborators: Zhenhuan Xu, Alex Bruce,       Javieradrian Ruiz, Michael Woodworth, Claire Lang
</p>
# Introduction
Electronic devices keep getting more powerful and smaller in size. The temperature limits for reliable operation of the materials used to make phones (*Ex: Silicon used in processor*) have not changed. For reliable operation, the processor temperature should be < 120°C. Hence, cooling solutions play a vital role in device performance.

## Cooling Mobile Phones
Cooling a mobile phone implies developing a thermal management solution with the following challenges:
1. The outer case or surface temperature of the phone should be < 40°C so that the user can hold the phone
2. The processor temperature should be < 80°C for reliable operation
3. Presence of a protective case around the phone creates an additional barrier (insulation)
4. Heat transfer to the ambient is often dominated by natural convection. In other words, the phone is not used in a "windy" environment. (*This is a practical assumption because users do not think about wind conditions before using the phone.*)  
5. [Many interactive smartphone applications have a short burst of excess power consumption followed by an idle time waiting for user inputs](www.scientificamerican.com/article/computational-sprinting/). Keeping the processor temperature within operating limits goes a long way in ensuring a responsive user interface (*preventing lags*).

Summarizing, the cooling solution should move or spread the heat from a smaller surface area (processor) to a larger surface area (outer surface of phone) for the heat to be dissipated out to the ambient while ensuring that the user can hold the phone at all times. In addition, the cooling solution should be able to respond to short duration, sharp spikes in power consumption ($$\approx 10\times$$ Thermal Design Power).

## Why Phase Change materials

 Store heat without increasing the temperature (around their melting point). The supplied heat is absorbed and used to change the phase. Conversely, during solidification, heat is liberated and the material changes phase to solid.  

From a thermal management standpoint, this is like hitting a jackpot! A PCM can be used to absorb the excess heat during periods of intense use in a smartphone while keeping the temperatures around the melting point. This is a win-win situation since the smartphone performance is improved while keeping the (processor & surface) temperatures in check.

## Why not Phase Change Materials
As promising as the ability to absorb heat while keeping the temperature pinned around the melting point sounds, this heat still needs to be dissipated to the ambient. This is challenging because most PCMs (*such as candle wax*) are poor heat conductors compared to copper, a common heat spreader (thermal conductivity is $$ 100 \times $$ lower). The temperature of PCM increases like other materials if it absorbs heat before or after phase change (*i.e. if the temperature is not close to the melting point*).

# Objectives

> How can PCMs be used to deliver an optimal cooling solution?
I conducted a feasibility study on the use of PCMs in smartphones to answer the following questions.

<style type="text/css">
table{
    border-collapse: collapse;
    border:2px solid black;  
}

</style>

| Questions      | Work Done         |
| ------------- | ------------------ |
| How to compare different thermal solutions?         |   {::nomarkdown}<ul><li> Reviewed literature </li><li> Surveyed thermal engineers in the industry</li></ul>{:/} Identified cutoff time - time taken to reach cutoff temperature (*Cutoff temperature is the temperature after which throttling begins to lower device performance*)|
|   What are the key design parameters?         |    {::nomarkdown}<ul><li>Integration location of the PCM: on the processor or near the surface </li><li>Weight/Volume of PCM required </li><li>Processor power profile (*power vs time curve*) </li></ul>{:/}|
|  What are the critical material properties?         |    {::nomarkdown}<ul><li> Thermal conductivity </li><li> Latent Heat </li>     <li> Melting Point (Transition Temperature) </li></ul>{:/} Characterized thermal conductivity using reference bar method (*ASTM D5470 standard*) with Infra-Red (IR) camera       |
|How do they influence the key design parameters?| Analyzed the effect of material properties, PCM weight and integration location on the cutoff time by       {::nomarkdown} <ul><li> Performing stress tests with PCM on the processor of a Thermal Test Vehicle   </li><li> Developed phone and processor level heat transfer simulations in COMSOL & ANSYS ICEPAK </li> <li> Performed Uncertainty Ananlysis (Parametric sweep) to determine critical properties </li> </ul> {:/}|

# Highlights

* Achieved an increase in cutoff time by $$ 1.5 - 2.48 \times $$ with the PCM compared to no PCMs
* PCM thickness and convection heat transfer coefficient have the largest impact on the cutoff time

# Publications
1. [MS Thesis](https://search.proquest.com/docview/1881313041)
2. [Intl Journal of Thermal Sciences Paper](https://doi.org/10.1016/j.ijthermalsci.2018.03.012)
3. [ASME InterPack 2015 Conference Paper](resources/ASME_InterPack.pdf)


# Skills
* Thermal Design
* MATLAB programing to process raw temperature data ($$ \approx 1e6 $$ pixels)
* 2D/3D heat transfer/CFD simulations in COMSOL, ANSYS ICEPAK
* Hardware thermal testing
* 3D Printing
* IR Camera & thermocouples temperature measurement
* Mentoring undergraduate students
