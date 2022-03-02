//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADComputeStrainBase.h"
class Function;
class Point;
/**
 * ADComputeDeformationGradient computes the fluctuation deformation gradient and adds a macroscopic deformation gradient to it
 */
class ADComputeDeformationGradient : public ADComputeStrainBase
{
public:
  static InputParameters validParams();

  ADComputeDeformationGradient(const InputParameters & parameters);

protected:
  virtual void computeProperties() override;

  ADMaterialProperty<RankTwoTensor> & _deformation_gradient;

  const Function & _Fbar_xx;
  const Function & _Fbar_xy;
  const Function & _Fbar_yx;
  const Function & _Fbar_yy;
};
