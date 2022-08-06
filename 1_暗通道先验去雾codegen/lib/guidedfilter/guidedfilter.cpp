//
// File: guidedfilter.cpp
//
// MATLAB Coder version            : 4.2
// C/C++ source code generated on  : 14-Mar-2022 10:14:45
//

// Include Files
#include "guidedfilter.h"
#include "guidedfilter_emxutil.h"
#include "rdivide_helper.h"
#include "boxfilter.h"

// Function Definitions

//
// GUIDEDFILTER   O(1) time implementation of guided filter.
//
//    - guidance image: I (should be a gray-scale/single channel image)
//    - filtering input image: p (should be a gray-scale/single channel image)
//    - local window radius: r
//    - regularization parameter: eps
// Arguments    : const emxArray_real_T *b_I
//                const emxArray_real_T *p
//                float r
//                float eps
//                emxArray_real_T *q
// Return Type  : void
//
void guidedfilter(const emxArray_real_T *b_I, const emxArray_real_T *p, float r,
                  float eps, emxArray_real_T *q)
{
  emxArray_real_T *r0;
  int I_idx_0;
  int I_idx_1;
  int i0;
  emxArray_real_T *N;
  emxArray_real_T *mean_I;
  emxArray_real_T *mean_p;
  emxArray_real_T *mean_II;
  emxArray_real_T *mean_Ip;
  emxArray_real32_T *a;
  emxArray_real32_T *b_mean_p;
  emxInit_real_T(&r0, 2);
  I_idx_0 = b_I->size[0];
  I_idx_1 = b_I->size[1];
  i0 = r0->size[0] * r0->size[1];
  r0->size[0] = I_idx_0;
  r0->size[1] = I_idx_1;
  emxEnsureCapacity_real_T(r0, i0);
  I_idx_0 *= I_idx_1;
  for (i0 = 0; i0 < I_idx_0; i0++) {
    r0->data[i0] = 1.0;
  }

  emxInit_real_T(&N, 2);
  emxInit_real_T(&mean_I, 2);
  emxInit_real_T(&mean_p, 2);
  emxInit_real_T(&mean_II, 2);
  boxfilter(r0, r, N);

  //  the size of each local patch; N=(2r+1)^2 except for boundary pixels.
  //  imwrite(uint8(N), 'N.jpg');
  //  figure,imshow(N,[]),title('N');
  boxfilter(b_I, r, r0);
  rdivide_helper(r0, N, mean_I);
  boxfilter(p, r, r0);
  rdivide_helper(r0, N, mean_p);
  i0 = mean_II->size[0] * mean_II->size[1];
  mean_II->size[0] = b_I->size[0];
  mean_II->size[1] = b_I->size[1];
  emxEnsureCapacity_real_T(mean_II, i0);
  I_idx_0 = b_I->size[0] * b_I->size[1];
  for (i0 = 0; i0 < I_idx_0; i0++) {
    mean_II->data[i0] = b_I->data[i0] * p->data[i0];
  }

  emxInit_real_T(&mean_Ip, 2);
  boxfilter(mean_II, r, r0);
  rdivide_helper(r0, N, mean_Ip);

  //  this is the covariance of (I, p) in each local patch.
  i0 = mean_II->size[0] * mean_II->size[1];
  mean_II->size[0] = b_I->size[0];
  mean_II->size[1] = b_I->size[1];
  emxEnsureCapacity_real_T(mean_II, i0);
  I_idx_0 = b_I->size[0] * b_I->size[1];
  for (i0 = 0; i0 < I_idx_0; i0++) {
    mean_II->data[i0] = b_I->data[i0] * b_I->data[i0];
  }

  emxInit_real32_T(&a, 2);
  boxfilter(mean_II, r, r0);
  rdivide_helper(r0, N, mean_II);
  i0 = a->size[0] * a->size[1];
  a->size[0] = mean_Ip->size[0];
  a->size[1] = mean_Ip->size[1];
  emxEnsureCapacity_real32_T(a, i0);
  I_idx_0 = mean_Ip->size[0] * mean_Ip->size[1];
  for (i0 = 0; i0 < I_idx_0; i0++) {
    a->data[i0] = static_cast<float>((mean_Ip->data[i0] - mean_I->data[i0] *
      mean_p->data[i0])) / (static_cast<float>((mean_II->data[i0] - mean_I->
      data[i0] * mean_I->data[i0])) + eps);
  }

  emxFree_real_T(&mean_II);
  emxInit_real32_T(&b_mean_p, 2);

  //  Eqn. (5) in the paper;
  //  Eqn. (6) in the paper;
  b_boxfilter(a, r, r0);
  rdivide_helper(r0, N, q);
  i0 = b_mean_p->size[0] * b_mean_p->size[1];
  b_mean_p->size[0] = mean_p->size[0];
  b_mean_p->size[1] = mean_p->size[1];
  emxEnsureCapacity_real32_T(b_mean_p, i0);
  I_idx_0 = mean_p->size[0] * mean_p->size[1];
  for (i0 = 0; i0 < I_idx_0; i0++) {
    b_mean_p->data[i0] = static_cast<float>(mean_p->data[i0]) - a->data[i0] *
      static_cast<float>(mean_I->data[i0]);
  }

  emxFree_real32_T(&a);
  emxFree_real_T(&mean_p);
  emxFree_real_T(&mean_I);
  b_boxfilter(b_mean_p, r, r0);
  rdivide_helper(r0, N, mean_Ip);
  i0 = q->size[0] * q->size[1];
  I_idx_0 = q->size[0] * q->size[1];
  emxEnsureCapacity_real_T(q, I_idx_0);
  I_idx_0 = i0 - 1;
  emxFree_real32_T(&b_mean_p);
  emxFree_real_T(&r0);
  emxFree_real_T(&N);
  for (i0 = 0; i0 <= I_idx_0; i0++) {
    q->data[i0] = q->data[i0] * b_I->data[i0] + mean_Ip->data[i0];
  }

  emxFree_real_T(&mean_Ip);

  //  Eqn. (8) in the paper;
}

//
// File trailer for guidedfilter.cpp
//
// [EOF]
//
