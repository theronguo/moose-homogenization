[Mesh]
  file = sim.msh
  use_displaced_mesh = false
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [./disp_x]
    order = second
  [../]
  [./disp_y]
    order = second
  [../]
[]


[BCs]
  [./fixed_x]
    type = DirichletBC
    variable = 'disp_x'
    boundary = botleftcorner
    value = 0
  [../]
  [./fixed_y]
    type = DirichletBC
    variable = 'disp_y'
    boundary = botleftcorner
    value = 0
  [../]
  [./fixed_rightx]
    type = DirichletBC
    variable = 'disp_x'
    boundary = botrightcorner
    value = 0
  [../]
  [./fixed_righty]
    type = DirichletBC
    variable = 'disp_y'
    boundary = botrightcorner
    value = 0
  [../]
  [./fixed_topx]
    type = DirichletBC
    variable = 'disp_x'
    boundary = topleftcorner
    value = 0
  [../]
  [./fixed_topy]
    type = DirichletBC
    variable = 'disp_y'
    boundary = topleftcorner
    value = 0
  [../]

  [./Periodic]
    [./x]
      variable = disp_x
      primary = 6
      secondary = 8
      translation = '0 1 0'
    [../]
    [./y]
      variable = disp_y
      primary = 6
      secondary = 8
      translation = '0 1 0'
    [../]

    [./x2]
      variable = disp_x
      primary = 9
      secondary = 7
      translation = '1 0 0'
    [../]
    [./y2]
      variable = disp_y
      primary = 9
      secondary = 7
      translation = '1 0 0'
    [../]
    
  [../]
[]

[Kernels]
  [./x]
    type = ADStressDivergenceTensors
    variable = disp_x
    component = 0
  [../]
  [./y]
    type = ADStressDivergenceTensors
    variable = disp_y
    component = 1
  [../]
[]

[Materials]
  [./strain]
    type = ADComputeDeformationGradient
    Fbar_xx = -0.1*t
    Fbar_xy = 0.1*t
    Fbar_yx = 0.1*t
    Fbar_yy = -0.1*t
  [../]
  [./stress_mat]
    type = ADComputeNeoHookeanStress
    C1 = 1.0
    D1 = 1.0
    block = 'matrix'
  [../]
  [./stress_fib]
    type = ADComputeNeoHookeanStress
    C1 = 100.0
    D1 = 100.0
    block = 'fiber'
  [../]
[]


[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0.0
  dtmin = 0.0001

  end_time = 1.0
  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-20
  nl_max_its = 15
  
  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 7
    dt = 1
  [../]

  [./Quadrature]
    order = second
  [../]

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -ksp_gmres_restart'
  petsc_options_value = 'asm lu 1 101'
[]

[AuxVariables]
  [./P_xx_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xx_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xx_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xy_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xy_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xy_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yx_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yx_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yx_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yy_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yy_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yy_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zz_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zz_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zz_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./P_xx_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xx_1
    index_i = 0
    index_j = 0
    selected_qp = 0
  [../]
  [./P_xx_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xx_2
    index_i = 0
    index_j = 0
    selected_qp = 1    
  [../]
  [./P_xx_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xx_3
    index_i = 0
    index_j = 0
    selected_qp = 2    
  [../]
  [./P_xy_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xy_1
    index_i = 0
    index_j = 1
    selected_qp = 0
  [../]
  [./P_xy_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xy_2
    index_i = 0
    index_j = 1
    selected_qp = 1    
  [../]
  [./P_xy_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xy_3
    index_i = 0
    index_j = 1
    selected_qp = 2    
  [../]
  [./P_yx_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yx_1
    index_i = 1
    index_j = 0
    selected_qp = 0
  [../]
  [./P_yx_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yx_2
    index_i = 1
    index_j = 0
    selected_qp = 1    
  [../]
  [./P_yx_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yx_3
    index_i = 1
    index_j = 0
    selected_qp = 2    
  [../]
  [./P_yy_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yy_1
    index_i = 1
    index_j = 1
    selected_qp = 0
  [../]
  [./P_yy_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yy_2
    index_i = 1
    index_j = 1
    selected_qp = 1    
  [../]
  [./P_yy_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yy_3
    index_i = 1
    index_j = 1
    selected_qp = 2    
  [../]
  [./P_zz_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zz_1
    index_i = 2
    index_j = 2
    selected_qp = 0
  [../]
  [./P_zz_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zz_2
    index_i = 2
    index_j = 2
    selected_qp = 1
  [../]
  [./P_zz_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zz_3
    index_i = 2
    index_j = 2
    selected_qp = 2
  [../]
[]


[Outputs]
  execute_on = 'INITIAL TIMESTEP_END'
  exodus = true
  print_linear_residuals = false
[]
