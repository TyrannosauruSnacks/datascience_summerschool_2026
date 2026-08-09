# 4 NumPy Basics:
Max Arthur Hachemeister
2026-08-09

- [Prerequisites](#prerequisites)
- [Introduction](#introduction)
- [4.1 The NumPy `ndarray`: A Multidimensional Array
  Object](#41-the-numpy-ndarray-a-multidimensional-array-object)
  - [Creating `ndarray`s](#creating-ndarrays)
  - [Data Types for `ndarray`s](#data-types-for-ndarrays)
  - [Arithmetic with NumPy Arrays](#arithmetic-with-numpy-arrays)
  - [Basic Indexing and Slicing](#basic-indexing-and-slicing)
    - [Indexing with Slices](#indexing-with-slices)
  - [Boolean Indexing](#boolean-indexing)
  - [Fancy Indexing](#fancy-indexing)
  - [Transposing Arrays and Swapping
    Axes](#transposing-arrays-and-swapping-axes)
- [4.2 Pseudorandom Number
  Generation](#42-pseudorandom-number-generation)
- [4.3 Universal Functions: Fast Element-Wise Array
  Functions](#43-universal-functions-fast-element-wise-array-functions)
- [4.4 Array-Oriented Programming with
  Arrays](#44-array-oriented-programming-with-arrays)
  - [Expressing Conditional Logic as Array
    Operations](#expressing-conditional-logic-as-array-operations)
  - [Mathematical & Statistical
    Methods](#mathematical--statistical-methods)
  - [Methods for Boolean Arrays](#methods-for-boolean-arrays)
  - [Sorting](#sorting)
  - [Unique and Other Set Logic](#unique-and-other-set-logic)
- [4.5 File Input and Output with
  Arrays](#45-file-input-and-output-with-arrays)
- [4.6 Linear Algebra](#46-linear-algebra)

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

    1.26 ms ± 173 μs per loop (mean ± std. dev. of 7 runs, 1,000 loops each)
    51.3 ms ± 608 μs per loop (mean ± std. dev. of 7 runs, 10 loops each)

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
or string, etc.. Every array has a `shape` that describes its
dimensions, and a `dtype` describing its datatype

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

    array([[[4.67903582e-310, 0.00000000e+000],
            [0.00000000e+000, 0.00000000e+000],
            [0.00000000e+000, 0.00000000e+000]],

           [[0.00000000e+000, 0.00000000e+000],
            [0.00000000e+000, 0.00000000e+000],
            [0.00000000e+000, 0.00000000e+000]]])

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
more efficiently by inferring the most appropriate methods for each.
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
sizes, which is called *broadcasting*.

We will gloss over this for now.

## Basic Indexing and Slicing

If you think about it, you might yet be missing the intuition for
indexing an slicing multidimensional arrays–if that is something you
ever pondered at all.

One-dimensional arrays are simple, as they basically behave like Python
lists:

``` python
# Create an array of 10 integers, starting from 0.
arr = np.arange(10)

# Return the element at index 5.
arr[5]

# Return the elements from index 5 to exclusively 8.
arr[5:8]

# Assign the value 12 to the elements from index 5 to exclusively 8.
arr[5:8] = 12
## And call the array to see the change.
arr
```

    np.int64(5)

    array([5, 6, 7])

    array([ 0,  1,  2,  3,  4, 12, 12, 12,  8,  9])

One important idiosycrasy of arrays is that slices of them refer to the
original object, meaning modifications of slice objects apply (also) to
the original object.

Take a look:

``` python
# Assign a slice of `arr` to its own variable.
arr_slice = arr[5:8]

# Call it.
arr_slice
```

    array([12, 12, 12])

A change in `arr_slice` will also affect `arr`:

``` python
# Set `arr_slice` index 1 to 123456.
arr_slice[1] = 123456

# Call the original `arr`.
arr
```

    array([     0,      1,      2,      3,      4,     12, 123456,     12,
                8,      9])

A *bare* slice `[:]` addresses all elements in an array:

``` python
arr_slice[:] = 7353

# Checking the original again.
arr
```

    array([   0,    1,    2,    3,    4, 7353, 7353, 7353,    8,    9])

Now, higher dimensions follow this principle sytax and layer it:

``` python
# Create an array with 2 dimensions.
arr_2d = np.array([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
])

# Call the element at index 2.
arr_2d[2]
```

    array([7, 8, 9])

We now got the object at index 2 which is also an array. The element of
which we would also call with `[]`. So the syntax allows you to stack
these calls in one expression–and that in two equivalent variants:

``` python
# Call the element at index 0 and from that element its element at index 2.
arr_2d[0][2]

# This does the same.
arr_2d[0, 2]
```

    np.int64(3)

    np.int64(3)

> [!NOTE]
>
> This seems to be inverse to R. So in Python `[x, y]` is
> `[row, column]`, and in R its `[column, row]`
>
> No, turns out I’m wrong. R and Python share the indexin sytax for
> multiple dimensions.

When you omit some dimension in your call, the rest of the structure is
preserved:

``` python
# Create an array with 3 dimensions.
arr_3d = np.array([
  [
    [1, 2, 3],
    [4, 5, 6]
  ],
  [
    [7, 8, 9],
    [10, 11, 12]
  ]
])

# Call index 0 of the first layer/dimension of that array.
arr_3d[0]
```

    array([[1, 2, 3],
           [4, 5, 6]])

Operations on those top-level calls apply to the rest of the structure.
Both scalars and arrays work in that regard:

``` python
# Save something for an undo.
arr_3d_undo = arr_3d[0].copy()

# For the structure at the index 0 of the first layer give the value 42.
arr_3d[0] = 42

# Show me.
arr_3d

# Same as above, but apply the array we saved before to the structure.
arr_3d[0] = arr_3d_undo

# Back change undone.
arr_3d
```

    array([[[42, 42, 42],
            [42, 42, 42]],

           [[ 7,  8,  9],
            [10, 11, 12]]])

    array([[[ 1,  2,  3],
            [ 4,  5,  6]],

           [[ 7,  8,  9],
            [10, 11, 12]]])

### Indexing with Slices

Even though it already felt like we were acessing “parts” of ndarrays,
we technically still got complete sequences. *Slicing* however refers to
taking a selection of elements from a sequence. For this, we expand the
above syntax with `:`.

We know this already from lists, and luckily enough, one-dimensional
arrays like our `arr` count as list in that regard.

``` python
# Call `arr` to see what we are working with.
arr

# Return the elements with from index 0 to exclusively 2.
arr[:2]
```

    array([   0,    1,    2,    3,    4, 7353, 7353, 7353,    8,    9])

    array([0, 1])

> [!NOTE]
>
> From here on out, I will omit the “exclusively” in commentary for
> slicing operations, and assume that you have that in mind by now.

Let’s see what happens with the two-dimensinal array `arr_2d`:

``` python
# What does it look like for reference.
arr_2d

# Same call as above.
arr_2d[:2]
```

    array([[1, 2, 3],
           [4, 5, 6],
           [7, 8, 9]])

    array([[1, 2, 3],
           [4, 5, 6]])

Think about it, we again got two elements, but each element is a list
now–the “rows” of our array.

Just as with the indexing before, we can stack the slicing operations
for each dimension in one call:

``` python
# From each of the first two rows, get the last two elements (everyone from index 1).
arr_2d[:2, 1:]

# Note, this is not equivalent anymore. 
arr_2d[:2][1:]
```

    array([[2, 3],
           [5, 6]])

    array([[4, 5, 6]])

> [!NOTE]
>
> Weird that those two variants don’t do the same thing anymore and it’s
> not mentioned in the original book.

You can mix slices with selections–so integers with `:`. Look:

``` python
# Select the second row and from that, the first two elements/columns.
arr_2d[1, :2]

# Get me the last two rows and from them, the second elements/columns.
arr_2d[:2, 1]
```

    array([4, 5])

    array([2, 5])

The solo `:` (colon) selects “all”:

``` python
# From all the rows, get me the third column.
arr_2d[:, 2]
```

    array([3, 6, 9])

Note that the dimensios got dropped–we got a one dimensional array, even
though we operated on one with two dimensions. If the dimensions weren’t
dropped, the result should look more like this:

    array([[3], 
           [6], 
           [9]])

Assigning to multi-dimensional slice expressions applies to all
elements:

``` python
# Take the first two rows and from that, the last two columns,
# and assing to each of them the value 0.
arr_2d[:2, 1:] = 0

# Show me.
arr_2d
```

    array([[1, 0, 0],
           [4, 0, 0],
           [7, 8, 9]])

## Boolean Indexing

Boolean indexing is useful to slice one set of elements that match the
conditions of another one.

Take the example of slicing only those rows that belong to a certain
“name”. So you might get some data of trees and want only those of the
pines.

Let’s create such a dataset:

``` python
species = np.array(["Pine", "Pine", "Beech", "Oak", "Pine", "Beech"])

measurements = np.array([[3, 5], [1, 8], [0, 3], [9, 5], [1, 1], [4, 7]])

species
measurements
```

    array(['Pine', 'Pine', 'Beech', 'Oak', 'Pine', 'Beech'], dtype='<U5')

    array([[3, 5],
           [1, 8],
           [0, 3],
           [9, 5],
           [1, 1],
           [4, 7]])

Let’s take this one step each. We can check each element of `species`
for the string “Pine”:

``` python
species == "Pine"
```

    array([ True,  True, False, False,  True, False])

And this can be used as guide for slicing from `measurements`:

``` python
measurements[species == "Pine"]
```

    array([[3, 5],
           [1, 8],
           [1, 1]])

These boolean operations can also be mixed with other selections or
slices:

``` python
# Get me all the rows that correspond to "Pine" and from that, the last two columns.
measurements[species == "Pine", 1:]

# Same rows as above, but now only select the second column.
measurements[species == "Pine", 1]
```

    array([[5],
           [8],
           [1]])

    array([5, 8, 1])

Use `!=` (“everything but”) to invert your slicing:

``` python
# Get me all the rows but those with "Pine".
measurements[species != "Pine"]
```

    array([[0, 3],
           [9, 5],
           [4, 7]])

For this, there is also the “prepend-`~`” variant, which is more
convenient when you have your condition check already as an object, for
example.

Like so:

``` python
# Assign the resulting condition check to a variable.
condition_check = species == "Pine"

# Get me all rows but the ones that match the condition.
measurements[~condition_check]
```

    array([[0, 3],
           [9, 5],
           [4, 7]])

Boolean operators also work with this. For example, to slice the oaks
and also the pines, you could write:

``` python
# Just to prove the operators are working.
pine_oak = (species == "Pine") | (species == "Oak")
pine_oak

# Use that boolean list to slice from the data.
measurements[pine_oak]

# This is equivalent.
measurements[(species == "Pine") | (species == "Oak")]
```

    array([ True,  True, False,  True,  True, False])

    array([[3, 5],
           [1, 8],
           [9, 5],
           [1, 1]])

    array([[3, 5],
           [1, 8],
           [9, 5],
           [1, 1]])

Also, you can directly assing new values via boolean slicing:

``` python
# Set all the measuremenst of Beeches to 0.
measurements[species == "Beech"] = 0
measurements
```

    array([[3, 5],
           [1, 8],
           [0, 0],
           [9, 5],
           [1, 1],
           [0, 0]])

## Fancy Indexing

The term *fancy indexing* is coined by NumPy and means indexing via
integer arrays. It’s better to show, I guess.

Let’s create data to work with:

``` python
# Create an 8 by 4 ndarray with all zeros.
arr = np.zeros((8, 4))

# Populate each row with the same integer as its index.
for i in range(8):
  arr[i] = i

# Show me.
arr
```

    array([[0., 0., 0., 0.],
           [1., 1., 1., 1.],
           [2., 2., 2., 2.],
           [3., 3., 3., 3.],
           [4., 4., 4., 4.],
           [5., 5., 5., 5.],
           [6., 6., 6., 6.],
           [7., 7., 7., 7.]])

Now the integer arrays. If you wanted to select no only a single row, or
a fixed range, but rather different rows at different locations, you can
pass their indices as list within the index call:

``` python
arr[[3, 0, 1, 4]]
```

    array([[3., 3., 3., 3.],
           [0., 0., 0., 0.],
           [1., 1., 1., 1.],
           [4., 4., 4., 4.]])

Note that the return respects the order of the list you gave.

This also works with negative integers to counting the index from the
end backwards–which might be practical for larger datasets:

``` python
arr[[-3, -4, -1]]
```

    array([[5., 5., 5., 5.],
           [4., 4., 4., 4.],
           [7., 7., 7., 7.]])

Now here comes something to wrap your head around, or at least be aware
of its existence. First, create new data to help observe what the code
after that does to it:

``` python
# I want each element in an 8 by 4 array to have its value in ascending order
# from left to right, top to bottom.
arr = np.arange(32).reshape((8,4))
arr
```

    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11],
           [12, 13, 14, 15],
           [16, 17, 18, 19],
           [20, 21, 22, 23],
           [24, 25, 26, 27],
           [28, 29, 30, 31]])

Passing multiple arrays for indexing has a particular behaviour. Read
the code and think of what you expect to happen, whether that is
reflected in the result, and if not, why that is:

``` python
arr[[1, 3, 7, 5], [0, 3, 1, 2]]
```

    array([ 4, 15, 29, 22])

Some might have expected to get an array made up of the rows 1, 3, 7, 5,
and the columns 0, 3, 1, 2–as it worked with basic indexing and slicing.
But the return now is a one-dimensional array. So the two lists we
passed to the indexing became paired tuples to select the elements
`(1, 0), (3, 3), (7, 1), (5, 2)`.

If we actually wanted to select whole rows and colmns we need to
explicitly write it as separate steps–one to first select all the rows,
and the second to select from those the intended colums:

``` python
arr[[1, 3, 7, 5]][:, [0, 3, 1, 2]]
```

    array([[ 4,  7,  5,  6],
           [12, 15, 13, 14],
           [28, 31, 29, 30],
           [20, 23, 21, 22]])

Just to be aware of: Assigning the return of fancy indexing to a
variable will copy the data, but assigning new values to an fancy index
selection will modify the original object.

## Transposing Arrays and Swapping Axes

ndarrays have the `transpose` method and the special `T` attribute. They
are somewhat comparable to the “pivot” functions in the R tidyverse.

Let’s see:

``` python
# Create an ndarray for inspection.
arr = np.arange(15).reshape((3,5))
arr

# Check out the `T` attribute.
arr.T

# The `T` attriute is the short version for this:
arr.transpose()
```

    array([[ 0,  1,  2,  3,  4],
           [ 5,  6,  7,  8,  9],
           [10, 11, 12, 13, 14]])

    array([[ 0,  5, 10],
           [ 1,  6, 11],
           [ 2,  7, 12],
           [ 3,  8, 13],
           [ 4,  9, 14]])

    array([[ 0,  5, 10],
           [ 1,  6, 11],
           [ 2,  7, 12],
           [ 3,  8, 13],
           [ 4,  9, 14]])

> [!NOTE]
>
> Something about the applicability of the transpose for matrix
> computations. I skipped this, and also the `swapaxes`. Can’t wrap my
> head around it right now.

# 4.2 Pseudorandom Number Generation

Numpy has its own module for generating random numbers, called
`numpy.random`. This is written to be more efficient/faster than the
built-in `random` mudule.

With this, you can easily generate random samples/values from a given
distribution, and that even for multiple dimensions of ndarrays:

``` python
# Create a 4 by 4 array with random values from the standard normal distribution.
samples = np.random.standard_normal(size = (4, 4))
samples
```

    array([[ 0.9358903 , -0.66518846, -1.0822056 , -0.50805893],
           [ 0.89406221, -0.05554117, -0.76836956, -0.8421976 ],
           [-0.87303321, -0.16506152, -0.93497801,  0.56731301],
           [ 0.37167935, -1.44100292, -0.47352194,  0.27962568]])

Here is a speed comparison between the built-in `random` and
`numpy.random` module:

``` python
# Just taking the one attribute from the module.
from random import normalvariate

N = 1_000_000

%timeit samples = [normalvariate(0, 1) for _ in range(N)]

%timeit np.random.standard_normal(N)
```

    473 ms ± 14.3 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
    23.1 ms ± 1.06 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)

The random numbers are “pseudorandom”, meaning they are generated in
relation to a seed. This is usefull for reproducibility, as you can set
this `seed` and use it for according methods:

``` python
rng = np.random.default_rng(seed = 123456)

data = rng.standard_normal((2, 3))
data
```

    array([[ 0.1928212 , -0.06550702,  0.43550665],
           [ 0.88235875,  0.37132785,  1.15998882]])

# 4.3 Universal Functions: Fast Element-Wise Array Functions

Universal functions–ufunc for short– are basically quick access versions
of functions that are often applied to ndarrays. For example,
`numpy.sqrt` and `numpy.exp`:

``` python
arr = np.arange(10)
arr

np.sqrt(arr)

np.exp(arr)
```

    array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

    array([0.        , 1.        , 1.41421356, 1.73205081, 2.        ,
           2.23606798, 2.44948974, 2.64575131, 2.82842712, 3.        ])

    array([1.00000000e+00, 2.71828183e+00, 7.38905610e+00, 2.00855369e+01,
           5.45981500e+01, 1.48413159e+02, 4.03428793e+02, 1.09663316e+03,
           2.98095799e+03, 8.10308393e+03])

As the functions above take just one array input they are referred to as
*unary* ufuncs. Therefore there are also *binary* ufuncs, with two
arrays as input, but still returning one single array.

For example `numpy.maximun`:

``` python
x = rng.standard_normal(8)
y = rng.standard_normal(8)

x
y

np.maximum(x, y)
```

    array([ 0.37835254, -0.11718594,  2.20800921,  1.95324484, -0.53790441,
           -0.30868175, -0.27351324,  0.71642266])

    array([ 0.49172141, -0.21815082, -0.14839858,  0.26709038,  0.01414178,
            0.81471778,  1.10047658,  0.61305867])

    array([ 0.49172141, -0.11718594,  2.20800921,  1.95324484,  0.01414178,
            0.81471778,  1.10047658,  0.71642266])

You see how the maximum for each pair of elements in `x` and `y` was
computed.

A few of the ufuncs actually return multiple arrays, like `numpy.modf`:

``` python
arr = rng.standard_normal(7) * 5
arr

remainder, whole_part = np.modf(arr)

remainder
whole_part
```

    array([-2.1858097 ,  6.20980267, -8.05891961, -1.5850453 , -3.40869088,
            3.26496065, -1.22198054])

    array([-0.1858097 ,  0.20980267, -0.05891961, -0.5850453 , -0.40869088,
            0.26496065, -0.22198054])

    array([-2.,  6., -8., -1., -3.,  3., -1.])

And you can send the results of ufuncs directly to a variable with the
`out` argument:

``` python
# Check out our array.
arr

# Create an array of all 0 but with the same structure as `arr`.
out = np.zeros_like(arr)

# Add 1 to each element of `arr`.
# This is not persistent.
np.add(arr, 1)

# Same as above but assing the output to a variable
# to make it persistent.
np.add(arr, 1, out = out)

# Show me `out`.
# We know that we created this with all 0.
out
```

    array([-2.1858097 ,  6.20980267, -8.05891961, -1.5850453 , -3.40869088,
            3.26496065, -1.22198054])

    array([-1.1858097 ,  7.20980267, -7.05891961, -0.5850453 , -2.40869088,
            4.26496065, -0.22198054])

    array([-1.1858097 ,  7.20980267, -7.05891961, -0.5850453 , -2.40869088,
            4.26496065, -0.22198054])

    array([-1.1858097 ,  7.20980267, -7.05891961, -0.5850453 , -2.40869088,
            4.26496065, -0.22198054])

# 4.4 Array-Oriented Programming with Arrays

ndarrays also work especially well with arithmetic operators. So
functions like `sqrt(x^2 + y^2)` work without you having to write a
respective for-loop.

> [!NOTE]
>
> Skipped some calculations and plotting of results.

## Expressing Conditional Logic as Array Operations

The `numpy.where` function is handy for operating only on those elements
that fit a certain condition. For example to encode all occurences of a
tree species.

Let’s create some data to work with:

``` python
species = np.array(["beech", "beech", "oak", "oak", "pine", "oak"])
height = np.array([15.1, 17.6, 11.6, 12.8, 9.1, 18.3])
diameter = np.array([26.1, 24.6, 20.1, 22.7, 19.9, 28.4])
```

Now encode all beeches according to the german inventory species code
“RBU”:

``` python
np.where(species == "beech", "RBU", species)
```

    array(['RBU', 'RBU', 'oak', 'oak', 'pine', 'oak'], dtype='<U5')

Or we could put all the measurements in groups by saying all above 15
are get the value 10 and all below the value 10:

``` python
np.where(height >= 15, "Tall", "Small")
```

    array(['Tall', 'Tall', 'Small', 'Small', 'Small', 'Tall'], dtype='<U5')

## Mathematical & Statistical Methods

Mathematical and statistical aggregations, like `sum`, `mean` or `std`,
are available both as methods for arrays and as top level `numpy`
funtions.

Let’s create some random data an get some aggregations:

``` python
arr = rng.standard_normal((5, 4))

arr

arr.mean()

# Equivalent to the above
np.mean(arr)

arr.sum()
```

    array([[-1.11359349, -0.16136165,  0.13035288, -1.30021389],
           [-0.9064342 , -1.76571409, -0.13530755,  0.08626036],
           [ 0.6060993 ,  1.22908319,  1.57168118, -0.52202565],
           [-0.03897298,  0.02745358,  1.2884647 , -0.00265976],
           [-0.52343401,  0.04762014,  0.34583066,  0.65692281]])

    np.float64(-0.023997422194462863)

    np.float64(-0.023997422194462863)

    np.float64(-0.4799484438892573)

Instead of the aggregate across all columns and rows, you can also have
the aggregations for each individual row/column with the `axis`
argument. Here, `axis = 0` refers to “down the rows/all elements of each
column” and `axis = 1` refers to “across the columns/ all elements of
each row”:

``` python
arr.mean(axis = 0)

arr.sum(axis = 1)
```

    array([-0.39526708, -0.12458376,  0.64020438, -0.21634322])

    array([-2.44481615, -2.72119547,  2.88483802,  1.27428555,  0.52693961])

Other methods, like `cumsum` or `cumprod` return arrays of intermediate
steps (accumulate). For arrays with one dimension you’d get something
like:

``` python
# Create an 1d array.
arr = np.arange(8)
arr

arr.cumsum()
```

    array([0, 1, 2, 3, 4, 5, 6, 7])

    array([ 0,  1,  3,  6, 10, 15, 21, 28])

For multidimensional arrays the same functions accumulate for each
individual lower dimension according to the given axis:

``` python
# Create a 2d array.
arr = np.arange(9).reshape((3, 3))
arr

# Cumsum down the rows.
arr.cumsum(axis = 0)

# Cumsum across the columns.
arr.cumsum(axis = 1)
```

    array([[0, 1, 2],
           [3, 4, 5],
           [6, 7, 8]])

    array([[ 0,  1,  2],
           [ 3,  5,  7],
           [ 9, 12, 15]])

    array([[ 0,  1,  3],
           [ 3,  7, 12],
           [ 6, 13, 21]])

## Methods for Boolean Arrays

As the boolean values `True` and `False` are usually coerced to `1` and
`0` respectively, mathematical methods like `sum` can be used to count
the `True` values in an Boolean array:

``` python
# Create 100 random values distributed around 0.
arr = rng.standard_normal(100)

# Of those values that are larger than 0, how many are there?
(arr > 0).sum()

# Of those values that are equal to or less than 0, how many are there?
(arr <= 0).sum()
```

    np.int64(55)

    np.int64(45)

The methods `any` and `all` are especially useful for Boolean arrays.
`any` tells you whether at least one value in an array is `True`, and
`all` tells you whether all of the values are `True`:

``` python
# Create an Boolean array.
bools = np.array([False, False, True, False])

# Are there any `True` values in the array?
bools.any()

# Are all the values `True` in the array?
bools.all()
```

    np.True_

    np.False_

## Sorting

NumPy arrays have the same `sort` method as Python’s built-in list
types:

``` python
# Create an array with 6 random values.
arr = rng.standard_normal(6)
arr

# Sort the values in ascending order.
arr.sort()
arr
```

    array([ 0.74542065,  1.3738326 ,  0.33899004, -1.31835123, -0.41362706,
            0.53525167])

    array([-1.31835123, -0.41362706,  0.33899004,  0.53525167,  0.74542065,
            1.3738326 ])

Note, that this method mutates the object in place, changing it
permanently.

For arrays with multiple dimensions, you can `sort` each section along a
given axis–so either the values of each row, or of each column:

``` python
# Create an 2d array with random numbers.
arr = rng.standard_normal((5,3))
arr

# Sort the values in each column in ascending order.
arr.sort(axis = 0)
arr

# Now sort the value in each row in ascending order.
arr.sort(axis = 1)
arr
```

    array([[-1.14699704,  0.24348457,  0.38604951],
           [ 0.25189489, -0.4157989 , -0.6538536 ],
           [-0.9519222 ,  1.04081189,  2.76645115],
           [-1.46114923,  0.21975188, -0.31943937],
           [-0.16177183, -0.25293288,  0.47501254]])

    array([[-1.46114923, -0.4157989 , -0.6538536 ],
           [-1.14699704, -0.25293288, -0.31943937],
           [-0.9519222 ,  0.21975188,  0.38604951],
           [-0.16177183,  0.24348457,  0.47501254],
           [ 0.25189489,  1.04081189,  2.76645115]])

    array([[-1.46114923, -0.6538536 , -0.4157989 ],
           [-1.14699704, -0.31943937, -0.25293288],
           [-0.9519222 ,  0.21975188,  0.38604951],
           [-0.16177183,  0.24348457,  0.47501254],
           [ 0.25189489,  1.04081189,  2.76645115]])

Use the top-level method/function `numpy.sort` if you rather preserve
your original objects and have the result returned to an new one
instead:

``` python
# Create another array.
# Spelling it out so spare the call to see them.
arr_2 = np.array([5, -10, 7, 0, -3])

# Create another array with the values sorted in ascending order.
arr_2_sorted = np.sort(arr_2)
arr_2_sorted
```

    array([-10,  -3,   0,   5,   7])

## Unique and Other Set Logic

NumPy has the `numpy.unique` function to give you just each distinct
value in an array. This is the more convenient version of Python’s
built-in `set` function with the added bonus of also sorting the values:

``` python
# Create an array of strings.
names = np.array(["Ragna", "Max", "Erich", "Max", "Ragna", "Alfried", "Alfried", "Max"])

# Give me only the unique values in ascending order.
np.unique(names)

# Create an array of integers.
ints = np.array([3, 3, 2, 2, 1, 1, 4, 4, 1, 1, 2, 2, 4])

# Same as above.
np.unique(ints)
```

    array(['Alfried', 'Erich', 'Max', 'Ragna'], dtype='<U7')

    array([1, 2, 3, 4])

And here is the raw Python version:

``` python
sorted(set(names))
```

    [np.str_('Alfried'), np.str_('Erich'), np.str_('Max'), np.str_('Ragna')]

> [!NOTE]
>
> Explanation of more NumPy functions, which are interesting for
> comparing two arrays, and getting things like intersection, difference
> or the union.

# 4.5 File Input and Output with Arrays

NumPy can save data in its own binary `.npy` format. The functions
`numpy.save` and `numpy.load` save and load such files:

``` python
# Create an array with 10 increasing integers.
arr = np.arange(10)

# And save it to disk.
# The `.npy` extension will be added automatically.
np.save("./output/some_array", arr)
```

Load the file from disk to see the sucess:

``` python
np.load("./output/some_array.npy")
```

    array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

You can also save multiple objects into on file as an `.npz` archive
with the `np.savez` function:

``` python
# Saving two copies of `arr` into a file to disk.
np.savez("./output/array_archive", a = arr, b = arr)
```

Now when you load these archives, you get an object that behaves like a
dictionary, meaning you can access the individual elements and they get
only loaded when you really ask for them:

``` python
# Load the archive and assign it to `arch`.
arch = np.load("./output/array_archive.npz")

# Get me element `b` of `arch`.
arch["b"]
```

    array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

And you can also have the data compressed with `numpy.savez_compressed`:

``` python
np.savez_compressed("./output/arrays_compressed", a=arr, b=arr)
```

# 4.6 Linear Algebra
