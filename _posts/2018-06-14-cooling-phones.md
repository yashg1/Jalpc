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
Advisor: Prof. Amy Marconnet & John Howarter  
Funding Agency: [Cooling Technologies Research Center](https://engineering.purdue.edu/CTRC)  
Duration: August 2014 - December 2016  
Course: MS Thesis Research

# Introduction
Electronic devices keep getting more powerful and smaller in size. The temperature limits for reliable operation of the materials used to make phones (*Ex: Silicon used in processor*) have not changed. For reliable operation, the processor temperature should be $$ < 120 $$°C. Hence, cooling solutions play a vital role in device performance.

## Cooling Mobile Phones
Cooling a mobile phone implies developing a thermal management solution with the following challenges:
1. The outer case or surface temperature of the phone should be $$ <40 $$°C so that the user can hold the phone
2. The processor temperature should be $$ <80 $$ °C for reliable operation
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

Conduct a feasibility study on the use of PCMs in smartphones. I sought answers to the following questions.
| Header1 | Header2 | Header3 |
|:--------|:-------:|--------:|
| cell1   | cell2   | cell3   |

 Hence, the cooling solution should be designed such that PCMs are only used around their melting points (*also known as transition temperature*)

 | A simple | table |
 | with multiple | lines|
