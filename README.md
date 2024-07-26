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

Here's a README with detailed explanations of the inputs, outputs, and internal module instantiations of the FFT butterfly module:

---

# FFT Butterfly Module

## Overview

This repository contains a SystemVerilog implementation of a butterfly operation used in Fast Fourier Transform (FFT) and Inverse Fast Fourier Transform (IFFT). The module performs complex arithmetic operations on input data and twiddle factors to produce the butterfly outputs, which are crucial components in FFT computations.

## File Description

- `fft_butterfly.sv`: SystemVerilog file containing the implementation of the FFT butterfly module.

## Features

- Supports parameterized data width.
- Configurable for both FFT and IFFT operations.
- Handles complex input data and twiddle factors.
- Outputs complex data results after butterfly computation.

## Inputs and Outputs

### Inputs

- **clk**: System clock signal.
- **rst_n**: Active low asynchronous reset signal.
- **fft_ifft**: Configuration input to select between FFT (0) and IFFT (1).
- **in0_r**: Real part of the first input data, represented in Q1.31 fixed-point format.
- **in0_i**: Imaginary part of the first input data, represented in Q1.31 fixed-point format.
- **in1_r**: Real part of the second input data, represented in Q1.31 fixed-point format.
- **in1_i**: Imaginary part of the second input data, represented in Q1.31 fixed-point format.
- **twiddle_r**: Real part of the twiddle factor, represented in Q1.31 fixed-point format.
- **twiddle_i**: Imaginary part of the twiddle factor, represented in Q1.31 fixed-point format.

### Outputs

- **out0_r**: Real part of the first output data, represented in Q1.31 fixed-point format.
- **out0_i**: Imaginary part of the first output data, represented in Q1.31 fixed-point format.
- **out1_r**: Real part of the second output data, represented in Q1.31 fixed-point format.
- **out1_i**: Imaginary part of the second output data, represented in Q1.31 fixed-point format.

## Internal Modules and Signals

The butterfly module uses several internal signals and instantiated sub-modules to perform the necessary complex arithmetic operations. Here are the key internal components:

- **fft_adder**: Module used to perform addition of complex numbers.
- **fft_multiplier**: Module used to perform multiplication of complex numbers.
- **fft_get_negative**: Module used to get the negative of a complex number.

### Internal Signals

- **CF_mult_n, DE_mult_n**: Signals used for intermediate multiplication results.
- **negCF_negDE_adder, negCE_DF_adder**: Signals used for intermediate addition results.
- **out0_r_i, out0_i_i, out1_r_i, out1_i_i**: Signals representing the intermediate output values before final assignment to the module outputs.

## Block Diagram

Below is a simplified block diagram of the 2-input butterfly module:

```
         +-----------------------+
         |      Butterfly        |
         |                       |
   in0_r +-->+                   |
   in0_i +-->|                   |
   in1_r +-->| Complex Arithmetic|
   in1_i +-->|                   |
twiddle_r +-->|                   +--> out0_r
twiddle_i +-->|                   +--> out0_i
   fft_ifft +-->|                   +--> out1_r
         clk +-->|                   +--> out1_i
       rst_n +-->+                   |
         |                       |
         +-----------------------+
```

## Description of Operation

1. **Input Handling**: The module takes in complex data (real and imaginary parts) from two inputs, `in0` and `in1`, and a twiddle factor.
2. **Complex Arithmetic**: It performs the necessary complex multiplications and additions to compute the butterfly outputs. This involves several internal signals and sub-modules to handle the arithmetic operations.
3. **Output Generation**: The results of the computations are assigned to the outputs `out0` and `out1`, providing the real and imaginary parts of the transformed data.

## Summary

The `fft_butterfly` module is designed to efficiently perform the core butterfly operation required in FFT and IFFT computations. By configuring the parameters and providing the appropriate input signals, the module outputs the transformed data necessary for further stages of the FFT/IFFT process.

For detailed signal waveforms and timing diagrams, refer to the implementation details in the `fft_butterfly.sv` file.

---

