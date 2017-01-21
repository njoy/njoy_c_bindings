#ifndef NJOY_C_H
#define NJOY_C_H

#ifdef __cplusplus
extern "C"
{
#endif

#define SIGNATURE( module_name ) void njoy_c_##module_name();
  SIGNATURE( MODER )
  SIGNATURE( RECONR )
  SIGNATURE( BROADR )
  SIGNATURE( UNRESR )
  SIGNATURE( HEATR )
  SIGNATURE( THERMR )
  SIGNATURE( GROUPR )
  SIGNATURE( GAMINR )
  SIGNATURE( ERRORR )
  SIGNATURE( COVR )
  SIGNATURE( DTFR )
  SIGNATURE( CCCCR )
  SIGNATURE( MATXSR )
  SIGNATURE( RESXSR )
  SIGNATURE( ACER )
  SIGNATURE( POWR )
  SIGNATURE( WIMSR )
  SIGNATURE( PLOTR )
  SIGNATURE( VIEWR )
  SIGNATURE( MIXR )
  SIGNATURE( PURR )
  SIGNATURE( LEAPR )
  SIGNATURE( GASPR )
#undef SIGNATURE  

  int njoy_setup_input_file( char* filename, int string_length );
  int njoy_setup_output_file( char* filename, int string_length );
  int njoy_cleanup_input_file();
  int njoy_cleanup_output_file();
  
#ifdef __cplusplus
}
#endif
  
#endif
