//
// File: useConstantDim.cpp
//
// MATLAB Coder version            : 4.2
// C/C++ source code generated on  : 14-Mar-2022 10:14:45
//

// Include Files
#include "guidedfilter.h"
#include "useConstantDim.h"

// Function Definitions

//
// Arguments    : emxArray_real_T *varargin_2
//                int varargin_3
// Return Type  : void
//
void useConstantDim(emxArray_real_T *varargin_2, int varargin_3)
{
  int i9;
  int k;
  int i10;
  int b_k;
  int subsb_idx_1;
  if (1 == varargin_3) {
    if ((varargin_2->size[0] != 0) && (varargin_2->size[1] != 0)) {
      i9 = varargin_2->size[1];
      for (k = 0; k < i9; k++) {
        i10 = varargin_2->size[0];
        if (0 <= i10 - 2) {
          subsb_idx_1 = k + 1;
        }

        for (b_k = 0; b_k <= i10 - 2; b_k++) {
          varargin_2->data[(b_k + varargin_2->size[0] * (subsb_idx_1 - 1)) + 1] +=
            varargin_2->data[b_k + varargin_2->size[0] * k];
        }
      }
    }
  } else {
    if ((varargin_2->size[0] != 0) && (varargin_2->size[1] != 0)) {
      i9 = varargin_2->size[1];
      for (k = 0; k <= i9 - 2; k++) {
        i10 = varargin_2->size[0];
        for (b_k = 0; b_k < i10; b_k++) {
          varargin_2->data[b_k + varargin_2->size[0] * (k + 1)] +=
            varargin_2->data[b_k + varargin_2->size[0] * k];
        }
      }
    }
  }
}

//
// File trailer for useConstantDim.cpp
//
// [EOF]
//
