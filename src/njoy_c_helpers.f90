module njoy_c_helpers
  use iso_c_binding
  use mainio, only: njoy_input_unit => nsysi, njoy_output_unit => nsyso

contains

  function c2fortran_string(c_string, string_length) result(fortran_string)
    implicit none
    type(c_ptr), intent(in) :: c_string
    integer(c_int), intent(in) :: string_length

    character(len = string_length) :: fortran_string
    character, dimension(:), pointer :: character_array

    call c_f_pointer(c_string, character_array, shape = [stringLength])
    fortran_string = transfer(character_array, fortran_string)
  end function c2fortran_string

  function setup_input_file(input_filename, name_length) result(error_code) bind(c, name = 'njoy_setup_input_file')
    implicit none
    type(c_ptr), intent(in), value :: input_filename
    integer(c_int), intent(in), value :: name_length

    character(len=name_length) :: filename
    integer(c_int) :: error_code
    
    filename = c2fortran_string(input_filename, name_length)
    open(newunit = njoy_input_unit, file = filename, status = 'old', action = 'read', position = 'rewind', iostat = error_code)
  end function setupInput_file

  function cleanup_input_file() result(error_code) bind(c, name = 'njoy_cleanup_input_file')
    integer(c_int) :: error_code
    close(unit = njoy_input_unit, iostat = error_code)
  end function cleanupInput_file

  function setup_output_file(output_filename, name_length) result(error_code) bind(c, name = 'njoy_setup_output_file')
    implicit none
    type(c_ptr), intent(in), value :: output_filename
    integer(c_int), intent(in), value :: name_length
    
    character(len=name_length) :: filename
    integer(c_int) :: error_code    
    
    filename = c2fortran_string(output_filename, name_length)
    open(unit = njoy_output_unit, file = filename, status = 'old', action = 'write', position = 'append', iostat = error_code)
  end function setupOutput_file

  function cleanupOutput_file() result(error_code) bind(c, name = 'njoy_cleanup_output_file')
    integer(c_int) :: errorCode    
    close(unit = njoy_output_unit, iostat = error_code)
  end function cleanupOutput_file

end module njoy_c_helpers
