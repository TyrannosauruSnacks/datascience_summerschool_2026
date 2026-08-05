# 4 NumPy Basics:
Max Arthur Hachemeister
2026-08-05

- [Prerequisites](#prerequisites)
- [Introduction](#introduction)
- [4.1 The NumPy `ndarray`: A Multidimensional Array
  Object](#41-the-numpy-ndarray-a-multidimensional-array-object)
  - [Creating `ndarray`s](#creating-ndarrays)
  - [Data Types for `ndarray`s](#data-types-for-ndarrays)
  - [Arithmetic with NumPy Arrays](#arithmetic-with-numpy-arrays)
  - [Basic Indexing and Slicing](#basic-indexing-and-slicing)

# Prerequisites

- [Link to chapter](https://wesmckinney.com/book/numpy-basics)

# Introduction

> “\[…\] Python a language of choice for wrapping legacy C, C++, or
> FORTRAN codebases \[…\]”

> “One of the reasons NumPy is so important for numerical computations
> in Python is because it is designed for efficiency on large arrays of
> data.”

> “NumPy is faster than regular Python code because its C-based
> algorithms avoid overhead present with regular interpreted Python
> code.”

> “While NumPy provides a computational foundation for general numerical
> data processing, many readers will want to use pandas as the basis for
> most kinds of statistics or analytics, especially on tabular data.
> Also, pandas provides some more domain-specific functionality like
> time series manipulation, which is not present in NumPy.”

Performance check:

``` python
import numpy as np

from numpy import float64
# Create array and list with 1e6 integers.
my_arr = np.arange(1_000_000)
my_list = list(range(1_000_000))

# Take the time it takes to multiply each of their elements
# by 2.
%timeit my_arr_2 = my_arr * 2
%timeit my_list_2 = [x * 2 for x in my_list]
```

    1.34 ms ± 24 μs per loop (mean ± std. dev. of 7 runs, 1,000 loops each)
    97.6 ms ± 15.1 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)

# 4.1 The NumPy `ndarray`: A Multidimensional Array Object

NumPy introduces N-dimensional array objects (ndarray) for Python which
can be handled like scalar elements for mathematical operations. Let’s
create such a ndarray and compute with it.

First, create a ndarray and assign it to the variable `data`:

``` python
import numpy as np

data = np.array([[1.5, -0.1, 3], [0, -3, 6.5]])
data
```

    array([[ 1.5, -0.1,  3. ],
           [ 0. , -3. ,  6.5]])

Now, do some mathematical operations with it:

``` python
data * 10

data + data
```

    array([[ 15.,  -1.,  30.],
           [  0., -30.,  65.]])

    array([[ 3. , -0.2,  6. ],
           [ 0. , -6. , 13. ]])

All of the elements of an ndarray must be of the same type-like integer,
or string, etc.. Every array has a `shape` that describes its dimesions,
and a `dtype` describing its datatype

Let’s see that for our `data` object:

``` python
data.shape

data.dtype
```

    (2, 3)

    dtype('float64')

## Creating `ndarray`s

The most basic way to make something an array is the function
`np.array()`:

``` python
# Create a list.
data_1 = [6, 7.5, 8, 0, 1]

# Make it an array.
arr_1 = np.array(data_1)

# Call it.
arr_1
```

    array([6. , 7.5, 8. , 0. , 1. ])

Nested sequences become individual dimensions in an array:

``` python
# Create a list of two lists.
data_2 = [
    [1, 2, 3, 4],
    [5, 6, 7, 8]
]

# Make it an array.
arr_2 = np.array(data_2)

# Call it.
arr_2
```

    array([[1, 2, 3, 4],
           [5, 6, 7, 8]])

Let’s check the dimensions of `arr_2`:

``` python
arr_2.ndim

arr_2.shape
```

    2

    (2, 4)

`np.array()` infers an appropriate data type from the input. Let’s check
the `dtypes` of the two arrays:

``` python
arr_1.dtype

arr_2.dtype
```

    dtype('float64')

    dtype('int64')

`np.zeros()` and `np.ones()` are functions to create arrays with
according values prepopulated, while `np.empty()` just initializes an
array in memory to be populated from another call:

``` python
# Return an array of 10 zeros.
np.zeros(10)

# Return an array of 3 by 6 elements with value 0.
np.zeros((3, 6))

# Initialize an array of 2 by 3 by 2 elements.
np.empty((2, 3, 2))
```

    array([0., 0., 0., 0., 0., 0., 0., 0., 0., 0.])

    array([[0., 0., 0., 0., 0., 0.],
           [0., 0., 0., 0., 0., 0.],
           [0., 0., 0., 0., 0., 0.]])

    array([[[ 4.68417113e-310,  0.00000000e+000],
            [ 6.90128425e-310,  2.00223048e+173],
            [ 6.90128425e-310,  6.90128425e-310]],

           [[-4.29193869e-226,  6.90128427e-310],
            [ 6.90128427e-310, -4.96546012e-073],
            [ 6.90128427e-310,  6.90128427e-310]]])

As you can see, `np.empty()` just points to some memory, and this might
still have some residual values from another use before.

`np.arrange()` is the NumPy equivalent of the built–in `range()`
function:

``` python
# Return an array of 15 integers starting from 0.
np.arange(15)

# This is basically the long version of it.
np.array(range(15))
```

    array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14])

    array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14])

## Data Types for `ndarray`s

Every ndarray comes with a `dtype` object attached to it describing the
array’s data type. Data types are important for functions to handle data
more efficiently by infering the most appropriate methods for each.
Glossing over the technical details of different types of data is
usually no problem, until it is.

We will gloss over it for now, but take note of the ways to convert
(cast) arrays between data types. The `astype` method is the intended
option for that:

``` python
# Create an array.
arr = np.array([1, 2, 3, 4, 5])

# Return `arr` data type.
arr.dtype

# "Cast" `arr` to a float64 type object.
float_arr = arr.astype(np.float64)

# Call it.
float_arr

# Return `float_arr` data type.
float_arr.dtype
```

    dtype('int64')

    array([1., 2., 3., 4., 5.])

    dtype('float64')

Be aware than when *casting* floating point to integer, the decimal part
will be truncated–meaning they will just be deleted instead of
interpreted for rounding up or down:

``` python
# Create an array with floating point values.
arr = np.array([3.7, -1.2, -2.6, 0.5, 12.9, 10.1])

# Cast it to integer.
arr.astype(np.int32)
```

    array([ 3, -1, -2,  0, 12, 10], dtype=int32)

Strings representing numbers can also be *cast* to numeric types:

``` python
# Create an array with numeric strings.
arr_num_string = np.array(["1.25", "-9.6", "42"])

# Cast it to integer.
arr_num_string.astype(np.float32)
```

    array([ 1.25, -9.6 , 42.  ], dtype=float32)

One array can also be cast explicitly into that of another array:

``` python
# Create an array of 10 integers starting from 0.
arr_int = np.arange(10)

# Cast it to the `dtype` of `arr_num_string`.
arr_int.astype(arr_num_string.dtype)
```

    array(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'], dtype='<U4')

Take note that there are also shorthand code strings for the `dtype`
argument. Check `?np.dtype` for further details.

## Arithmetic with NumPy Arrays

Arrays are *vectorized*, meaning, any operation is applied to their
individual elements without having to write a `for` loop:

``` python
# Create an array of two lists.
arr = np.array(
  [[1, 2, 3,],
  [4, 5, 6,]],
  dtype = np.float64 # Making it float to fit later operations.
  )

# Multiply `arr` by `arr` (basically square).
arr * arr

# Subtract `arr` from `arr` (should be all 0).
arr - arr
```

    array([[ 1.,  4.,  9.],
           [16., 25., 36.]])

    array([[0., 0., 0.],
           [0., 0., 0.]])

Operations with scalars (single standalone numeric value) apply that
scalar operation to each element of the array:

``` python
# For each element of arr divide on by it.
1 / arr

# Take each element of arr to the power of 2.
arr * 2
```

    array([[1.        , 0.5       , 0.33333333],
           [0.25      , 0.2       , 0.16666667]])

    array([[ 2.,  4.,  6.],
           [ 8., 10., 12.]])

With comparison operators and array with Boolean values is returned:

``` python
# Create an array for comparison.
arr_2 = np.array(
  [[0, 4, 1,],
  [7, 2, 12]],
  dtype = np.float64
  )

# Which elements of `arr_2` are bigger than their `arr` neighbor.
arr_2 > arr
```

    array([[False,  True, False],
           [ True, False,  True]])

There are some more intricacies to operations with arrays of different
sizes, which is called *broadcasting*. We will gloss over this for now.

## Basic Indexing and Slicing
