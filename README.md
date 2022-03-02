# First Order Homogenization With MOOSE

[MOOSE](https://github.com/idaholab/moose) is a generic open-source finite element framework with a wide range of features. The module [Tensor Mechanics](https://mooseframework.inl.gov/modules/tensor_mechanics/index.html) offers several options for running solid mechanics simulations.

We would like to run microscopic simulations, defined on a periodic representative volume elements with MOOSE. In first order homogenization, the total displacement is assumed to consist of a known macroscopic part and a microscopic fluctuation part,

<p align="center">
  <img height="30" src="https://user-images.githubusercontent.com/94921576/156388341-1719b5b9-8650-4412-89f0-29b7fb0150fa.png">
</p>

and the total deformation gradient is given as

<p align="center">
  <img height="60" src="https://user-images.githubusercontent.com/94921576/156393541-a3d4c8ef-9b88-4fe5-b56e-c17ddbbcbef2.png">
</p>

Then, the following partial differential equation is solved
<p align="center">
  <img height="90" src="https://user-images.githubusercontent.com/94921576/156393796-904aa2a3-b3be-4db3-bfda-e65fe8b400a5.png">
</p>

Therefore, the macroscopic displacement field gradient acts as the external loading. MOOSE does not offer a direct way of solving such problems.

In the module Tensor Mechanics, you can provide a strain and stress file for the solution of the problem. In the strain file, the macroscopic displacement gradient has to be added to the microscopic deformation gradient, and then the problem will be solved for the microscopic displacement field, together with the periodicy conditions for that displacement field.

In this repository, the files for computing the deformation gradient and a file for computing the stress with a Neo-Hookean material model are provided. Additionally, there is an example mesh and input file showing how these files can be used, combined with a pseudo time controlling the amplitude of the loading.
