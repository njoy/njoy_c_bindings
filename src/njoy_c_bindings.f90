module njoy_c_bindings
  use iso_c_binding
contains

  subroutine moder_binding() bind(c, name = 'njoy_c_MODER')
    use modem
    implicit none
    call moder()
  end subroutine moder_binding

  subroutine reconr_binding() bind(c, name = 'njoy_c_RECONR')
    use reconm
    implicit none
    call reconr()
  end subroutine reconr_binding

  subroutine broadr_binding() bind(c, name = 'njoy_c_BROADR')
    use broadm
    implicit none
    call broadr()
  end subroutine broadr_binding

  subroutine unresr_binding() bind(c, name = 'njoy_c_UNRESR')
    use unresm
    implicit none
    call unresr()
  end subroutine unresr_binding

  subroutine heatr_binding() bind(c, name = 'njoy_c_HEATR')
    use heatm
    implicit none
    call heatr()
  end subroutine heatr_binding

  subroutine thermr_binding() bind(c, name = 'njoy_c_THERMR')
    use thermm
    implicit none
    call thermr()
  end subroutine thermr_binding

  subroutine groupr_binding() bind(c, name = 'njoy_c_GROUPR')
    use groupm
    implicit none
    call groupr()
  end subroutine groupr_binding

  subroutine gaminr_binding() bind(c, name = 'njoy_c_GAMINR')
    use gaminm
    implicit none
    call gaminr()
  end subroutine gaminr_binding

  subroutine errorr_binding() bind(c, name = 'njoy_c_ERRORR')
    use errorm
    implicit none
    call errorr()
  end subroutine errorr_binding

  subroutine covr_binding() bind(c, name = 'njoy_c_COVR')
    use covm
    implicit none
    call covr()
  end subroutine covr_binding

  subroutine dtfr_binding() bind(c, name = 'njoy_c_DTFR')
    use dtfm
    implicit none
    call dtfr()
  end subroutine dtfr_binding

  subroutine ccccr_binding() bind(c, name = 'njoy_c_CCCCR')
    use ccccm
    implicit none
    call ccccr()
  end subroutine ccccr_binding

  subroutine matxsr_binding() bind(c, name = 'njoy_c_MATXSR')
    use matxsm
    implicit none
    call matxsr()
  end subroutine matxsr_binding

  subroutine resxsr_binding() bind(c, name = 'njoy_c_RESXSR')
    use resxsm
    implicit none
    call resxsr()
  end subroutine resxsr_binding

  subroutine acer_binding() bind(c, name = 'njoy_c_ACER')
    use acem
    implicit none
    call acer()
  end subroutine acer_binding

  subroutine powr_binding() bind(c, name = 'njoy_c_POWR')
    use powm
    implicit none
    call powr()
  end subroutine powr_binding

  subroutine wimsr_binding() bind(c, name = 'njoy_c_WIMSR')
    use wimsm
    implicit none
    call wimsr()
  end subroutine wimsr_binding

  subroutine plotr_binding() bind(c, name = 'njoy_c_PLOTR')
    use plotm
    implicit none
    call plotr()
  end subroutine plotr_binding

  subroutine viewr_binding() bind(c, name = 'njoy_c_VIEWR')
    use viewm
    implicit none
    call viewr()
  end subroutine viewr_binding

  subroutine mixr_binding() bind(c, name = 'njoy_c_MIXR')
    use mixm
    implicit none
    call mixr()
  end subroutine mixr_binding

  subroutine purr_binding() bind(c, name = 'njoy_c_PURR')
    use purm
    implicit none
    call purr()
  end subroutine purr_binding

  subroutine leapr_binding() bind(c, name = 'njoy_c_LEAPR')
    use leapm
    implicit none
    call leapr()
  end subroutine leapr_binding

  subroutine gaspr_binding() bind(c, name = 'njoy_c_GASPR')
    use gaspm
    implicit none
    call gaspr()
  end subroutine gaspr_binding

end module njoy_c_bindings
