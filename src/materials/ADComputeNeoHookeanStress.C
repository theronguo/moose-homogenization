//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADComputeNeoHookeanStress.h"
#include<iostream>
registerMooseObject("TheronApp", ADComputeNeoHookeanStress);

InputParameters
ADComputeNeoHookeanStress::validParams()
{
  InputParameters params = ADComputeStressBase::validParams();
  params.addClassDescription("Compute first PK stress with a Neo-Hookean material model with deformation gradient.");
  params.addRequiredParam<Real>("C1", "First parameter of Neo-Hookean.");
  params.addRequiredParam<Real>("D1", "Second parameter of Neo-Hookean.");
  return params;
}

ADComputeNeoHookeanStress::ADComputeNeoHookeanStress(
    const InputParameters & parameters)
  : ADComputeStressBase(parameters),
    GuaranteeConsumer(this),
    _C1(getParam<Real>("C1")),
    _D1(getParam<Real>("D1")),
    _deformation_gradient(getADMaterialPropertyByName<RankTwoTensor>(_base_name + "deformation_gradient"))    
{
}

void
ADComputeNeoHookeanStress::computeQpStress()
{
  ADRankTwoTensor iden(ADRankTwoTensor::initIdentity);
  
  ADRankTwoTensor right_cg = _deformation_gradient[_qp].transpose() * _deformation_gradient[_qp];
  ADRankTwoTensor right_cg_inv = right_cg.inverse();
  _stress[_qp] = 2.0*(_C1*(iden - right_cg_inv) + _D1*(_deformation_gradient[_qp].det()-1.0)*_deformation_gradient[_qp].det()*right_cg_inv);
  _stress[_qp] = _deformation_gradient[_qp]*_stress[_qp];
}
