//
// File: main.cpp
//
// MATLAB Coder version            : 4.2
// C/C++ source code generated on  : 14-Mar-2022 10:14:45
//

//***********************************************************************
// This automatically generated example C++ main file shows how to call
// entry-point functions that MATLAB Coder generated. You must customize
// this file for your application. Do not modify this file directly.
// Instead, make a copy of this file, modify it, and integrate it into
// your development environment.
//
// This file initializes entry-point function arguments to a default
// size and value before calling the entry-point functions. It does
// not store or use any values returned from the entry-point functions.
// If necessary, it does pre-allocate memory for returned values.
// You can use this file as a starting point for a main function that
// you can deploy in your application.
//
// After you copy the file, and before you deploy it, you must make the
// following changes:
// * For variable-size function arguments, change the example sizes to
// the sizes that your application requires.
// * Change the example values of function arguments to the values that
// your application requires.
// * If the entry-point functions return values, store these values or
// otherwise use them as required by your application.
//
//***********************************************************************
// Include Files
#include "guidedfilter.h"
#include "main.h"
#include "guidedfilter_terminate.h"
#include "guidedfilter_emxAPI.h"
#include "guidedfilter_initialize.h"

// Function Declarations
static float argInit_real32_T();
static double argInit_real_T();
static emxArray_real_T *c_argInit_UnboundedxUnbounded_r();
static void main_guidedfilter();

// Function Definitions

//
// Arguments    : void
// Return Type  : float
//
static float argInit_real32_T()
{
  return 0.0F;
}

//
// Arguments    : void
// Return Type  : double
//
static double argInit_real_T()
{
  return 0.0;
}

//
// Arguments    : void
// Return Type  : emxArray_real_T *
//
static emxArray_real_T *c_argInit_UnboundedxUnbounded_r()
{
  emxArray_real_T *result;
  int idx0;
  int idx1;

  // Set the size of the array.
  // Change this size to the value that the application requires.
  result = emxCreate_real_T(2, 2);

  // Loop over the array to initialize each element.
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      // Set the value of the array element.
      // Change this value to the value that the application requires.
      result->data[idx0 + result->size[0] * idx1] = argInit_real_T();
    }
  }

  return result;
}

//
// Arguments    : void
// Return Type  : void
//
static void main_guidedfilter()
{
  emxArray_real_T *q;
  emxArray_real_T *b_I;
  emxArray_real_T *p;
  emxInitArray_real_T(&q, 2);

  // Initialize function 'guidedfilter' input arguments.
  // Initialize function input argument 'I'.
  b_I = c_argInit_UnboundedxUnbounded_r();

  // Initialize function input argument 'p'.
  p = c_argInit_UnboundedxUnbounded_r();

  // Call the entry-point 'guidedfilter'.
  guidedfilter(b_I, p, argInit_real32_T(), argInit_real32_T(), q);
  emxDestroyArray_real_T(q);
  emxDestroyArray_real_T(p);
  emxDestroyArray_real_T(b_I);
}

//
// Arguments    : int argc
//                const char * const argv[]
// Return Type  : int
//
int main(int, const char * const [])
{
  // Initialize the application.
  // You do not need to do this more than one time.
  guidedfilter_initialize();

  // Invoke the entry-point functions.
  // You can call entry-point functions multiple times.
  main_guidedfilter();

  // Terminate the application.
  // You do not need to do this more than one time.
  guidedfilter_terminate();
  return 0;
}

//
// File trailer for main.cpp
//
// [EOF]
//
