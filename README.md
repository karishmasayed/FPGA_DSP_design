# Butterfly Filter Implementation README

## Overview

This project implements a butterfly filter with 256 inputs in Q1.31 format, designed to handle both real and imaginary components. The implementation includes a twiddle matrix with real and imaginary parts, and macros to facilitate efficient computation.

## File Structure

- `BUTTERFLY_RTL_IMP.xlsx`: Contains implementation details, input data, twiddle matrix, and macros.

## Input Data

The butterfly filter processes 256 inputs for both real and imaginary components. These inputs are represented as:

### Real Inputs
```
w0_r, w1_r, ..., w255_r
```

### Imaginary Inputs
```
w0_i, w1_i, ..., w255_i
```

## Twiddle Matrix

The twiddle matrix, used in the butterfly filter calculations, consists of real and imaginary components. Twiddle factors are complex numbers utilized in the Fast Fourier Transform (FFT) algorithm for frequency domain transformations.

### Real Twiddle Factors
```
tw0_r, tw1_r, ..., tw255_r
```

### Imaginary Twiddle Factors
```
tw0_i, tw1_i, ..., tw255_i
```

## Macros

Macros are written to streamline processing within the butterfly filter, aiding in repetitive tasks and ensuring code efficiency and readability.

### Example Macro

```c
#define BUTTERFLY_OPERATION(a_r, a_i, b_r, b_i, tw_r, tw_i) \
    do { \
        float temp_r = (a_r) + (tw_r) * (b_r) - (tw_i) * (b_i); \
        float temp_i = (a_i) + (tw_r) * (b_i) + (tw_i) * (b_r); \
        (a_r) = temp_r; \
        (a_i) = temp_i; \
    } while (0)
```

This macro performs a butterfly operation on complex numbers using the twiddle factors.

## Usage

1. **Preparation**: Ensure all required inputs and twiddle factors are available.
2. **Initialization**: Load the input data and twiddle factors into variables.
3. **Processing**: Use defined macros to perform butterfly operations on the input data.
4. **Result**: Collect and analyze the output data post-processing.

## Example

```c
float input_real[256] = { /* real inputs */ };
float input_imag[256] = { /* imaginary inputs */ };
float twiddle_real[256] = { /* real twiddle factors */ };
float twiddle_imag[256] = { /* imaginary twiddle factors */ };

for (int i = 0; i < 256; i++) {
    BUTTERFLY_OPERATION(input_real[i], input_imag[i], input_real[i], input_imag[i], twiddle_real[i], twiddle_imag[i]);
}
```

## Conclusion

This README provides an overview of the butterfly filter implementation, covering input data, the twiddle matrix, and macros. For detailed implementation specifics, refer to the `BUTTERFLY_RTL_IMP.xlsx` file.

---
