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
Phones keep getting more powerful and smaller in size. For reliable operation, the
 The temperature limits for reliable operation of the materials used to make phones (*Ex: Silicon used in processor*) have

<p style ="text-align:center;">
  <img width= 70% alt = "Computing power increased by about 2x in 5 years" src="/static/assets/img/blog/msthesis/intro_watch.jpg">
</p>

$$
\begin{align*}
  & \phi(x,y) = \phi \left(\sum_{i=1}^n x_ie_i, \sum_{j=1}^n y_je_j \right)
  = \sum_{i=1}^n \sum_{j=1}^n x_i y_j \phi(e_i, e_j) = \\
  & (x_1, \ldots, x_n) \left( \begin{array}{ccc}
      \phi(e_1, e_1) & \cdots & \phi(e_1, e_n) \\
      \vdots & \ddots & \vdots \\
      \phi(e_n, e_1) & \cdots & \phi(e_n, e_n)
    \end{array} \right)
  \left( \begin{array}{c}
      y_1 \\
      \vdots \\
      y_n
    \end{array} \right)
\end{align*}
$$
