//
// File: rdivide_helper.cpp
//
// MATLAB Coder version            : 4.2
// C/C++ source code generated on  : 14-Mar-2022 10:14:45
//

// Include Files
#include "guidedfilter.h"
#include "rdivide_helper.h"
#include "guidedfilter_emxutil.h"

// Function Definitions

//
// Arguments    : const emxArray_real_T *x
//                const emxArray_real_T *y
//                emxArray_real_T *z
// Return Type  : void
//
void rdivide_helper(const emxArray_real_T *x, const emxArray_real_T *y,
                    emxArray_real_T *z)
{
  int i5;
  int loop_ub;
  i5 = z->size[0] * z->size[1];
  z->size[0] = x->size[0];
  z->size[1] = x->size[1];
  emxEnsureCapacity_real_T(z, i5);
  loop_ub = x->size[0] * x->size[1];
  for (i5 = 0; i5 < loop_ub; i5++) {
    z->data[i5] = x->data[i5] / y->data[i5];
  }
}

//
// File trailer for rdivide_helper.cpp
//
// [EOF]
//
