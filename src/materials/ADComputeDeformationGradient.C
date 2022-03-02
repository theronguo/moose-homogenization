//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADComputeDeformationGradient.h"
#include "libmesh/quadrature.h"
#include "Function.h"

registerMooseObject("TheronApp", ADComputeDeformationGradient);

InputParameters
ADComputeDeformationGradient::validParams()
{
  InputParameters params = ADComputeStrainBase::validParams();
  params.addClassDescription("Compute the deformation gradient from current fluctuation displacement and a macroscopic deformation gradient.");
  params.addRequiredParam<FunctionName>("Fbar_xx", "xx-component of macroscopic deformation gradient.");
  params.addRequiredParam<FunctionName>("Fbar_xy", "xy-component of macroscopic deformation gradient.");
  params.addRequiredParam<FunctionName>("Fbar_yx", "yx-component of macroscopic deformation gradient.");
  params.addRequiredParam<FunctionName>("Fbar_yy", "yy-component of macroscopic deformation gradient.");
  return params;
}

ADComputeDeformationGradient::ADComputeDeformationGradient(const InputParameters & parameters)
  : ADComputeStrainBase(parameters), 
    _deformation_gradient(declareADProperty<RankTwoTensor>(_base_name + "deformation_gradient")),
    _Fbar_xx(getFunction("Fbar_xx")),
    _Fbar_xy(getFunction("Fbar_xy")),
    _Fbar_yx(getFunction("Fbar_yx")),
    _Fbar_yy(getFunction("Fbar_yy"))
{
  // error out if unsupported features are to be used
  if (_global_strain)
    paramError("global_strain",
               "Global strain (periodicity) is not yet supported for Green-Lagrange strains");
  if (!_eigenstrains.empty())
    paramError("eigenstrain_names",
               "Eigenstrains are not yet supported for Green-Lagrange strains");
  if (_volumetric_locking_correction)
    paramError("volumetric_locking_correction",
               "Volumetric locking correction is not implemented for Green-Lagrange strains");
}

void
ADComputeDeformationGradient::computeProperties()
{
  for (_qp = 0; _qp < _qrule->n_points(); ++_qp)
  {
    auto dxu = ADRankTwoTensor::initializeFromRows(
        (*_grad_disp[0])[_qp], (*_grad_disp[1])[_qp], (*_grad_disp[2])[_qp]);

    _deformation_gradient[_qp] = dxu;

    // increment by Fbar to simulate macroscopic deformation
    _deformation_gradient[_qp](0, 0) += _Fbar_xx.value(_t, Point(0, 0, 0)); 
    _deformation_gradient[_qp](0, 1) += _Fbar_xy.value(_t, Point(0, 0, 0));
    _deformation_gradient[_qp](1, 0) += _Fbar_yx.value(_t, Point(0, 0, 0));
    _deformation_gradient[_qp](1, 1) += _Fbar_yy.value(_t, Point(0, 0, 0));
  
    _deformation_gradient[_qp].addIa(1.0);

    _mechanical_strain[_qp] = _total_strain[_qp] = _deformation_gradient[_qp];
  }
}
