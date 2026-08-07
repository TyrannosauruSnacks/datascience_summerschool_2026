# 4 NumPy Basics:
Max Arthur Hachemeister
2026-08-06

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

    1.39 ms ± 41.1 μs per loop (mean ± std. dev. of 7 runs, 1,000 loops each)
    76.3 ms ± 1.89 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)

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
data_2 = [[1, 2, 3, 4], [5, 6, 7, 8]]

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

    array([[[4.64091295e-310, 0.00000000e+000],
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
    [
        [
            1,
            2,
            3,
        ],
        [
            4,
            5,
            6,
        ],
    ],
    dtype=np.float64,  # Making it float to fit later operations.
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
    [
        [
            0,
            4,
            1,
        ],
        [7, 2, 12],
    ],
    dtype=np.float64,
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
arr_2d = np.array(
    [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ]
)

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
arr_3d = np.array([[[1, 2, 3], [4, 5, 6]], [[7, 8, 9], [10, 11, 12]]])

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
