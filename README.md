NJOY C and C++ bindings
=======

This library provides a collection of functions which expose NJOY2016 routines
to C and C++ and allow for file-based IO operations.

Minimal Example
---------------

```c++

#include "njoy_c.h"
#include <string>

int main(){

  std::string input("/path/to/input/file");
  std::string output("/path/to/output/file");

  auto bufferPointer = []( auto& string ){ return &(string[0]); };

  /* Calling to `njoy_setup_input_file` specifies that NJOY routines
   * ought to draw commands from the file at the argument path. If this
   * function is not called, input will be drawn from the standard input
   */
  int success = njoy_setup_input_file( bufferPointer(input), input.length() );

  /* Beyond any output files, NJOY routines also output information to
   * standard output and standard error. Calling to `njoy_setup_output_file` 
   * specifies that NJOY routines ought to dump diagnostic information to the
   * file at the argument path.
   */
  success = njoy_setup_output_file( bufferPointer(output), output.length() );

  njoy_c_MODER(); /* note SCREAMCASE routine names */
  njoy_c_RECONR() 
  
  success = njoy_cleanup_input_file();
  success = njoy_cleanup_output_file();
  
  return success;
}

```
