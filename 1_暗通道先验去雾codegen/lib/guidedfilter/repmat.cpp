//
// File: repmat.cpp
//
// MATLAB Coder version            : 4.2
// C/C++ source code generated on  : 14-Mar-2022 10:14:45
//

// Include Files
#include "guidedfilter.h"
#include "repmat.h"
#include "guidedfilter_emxutil.h"

// Function Definitions

//
// Arguments    : const emxArray_real_T *a
//                const float varargin_1[2]
//                emxArray_real_T *b
// Return Type  : void
//
void repmat(const emxArray_real_T *a, const float varargin_1[2], emxArray_real_T
            *b)
{
  int outsize_idx_0;
  int jtilecol;
  int i4;
  int ibtile;
  int k;
  outsize_idx_0 = a->size[0];
  jtilecol = b->size[0] * b->size[1];
  b->size[0] = outsize_idx_0;
  i4 = static_cast<int>(varargin_1[1]);
  b->size[1] = i4;
  emxEnsureCapacity_real_T(b, jtilecol);
  outsize_idx_0 = a->size[0];
  for (jtilecol = 0; jtilecol < i4; jtilecol++) {
    ibtile = jtilecol * outsize_idx_0;
    for (k = 0; k < outsize_idx_0; k++) {
      b->data[ibtile + k] = a->data[k];
    }
  }
}

//
// File trailer for repmat.cpp
//
// [EOF]
//
