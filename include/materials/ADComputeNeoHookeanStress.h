//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADComputeStressBase.h"
#include "GuaranteeConsumer.h"

/**
 * ADComputeHyper computes the stress following elasticity
 * theory for finite strains
 */
class ADComputeNeoHookeanStress : public ADComputeStressBase, public GuaranteeConsumer
{
public:
  static InputParameters validParams();

  ADComputeNeoHookeanStress(const InputParameters & parameters);

protected:
  virtual void computeQpStress() override;

  // Material parameters
  const Real _C1;
  const Real _D1;
  
  const ADMaterialProperty<RankTwoTensor> & _deformation_gradient;
};
