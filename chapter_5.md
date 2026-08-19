# Getting Started with pandas
Max Arthur Hachemeister
2026-08-19

- [Prerequisites](#prerequisites)
- [5.1 Introduction to pandas Data
  Structures](#51-introduction-to-pandas-data-structures)
  - [Series](#series)
  - [DataFrame](#dataframe)
  - [Index Objects](#index-objects)
- [5.2 Essential Functionality](#52-essential-functionality)
  - [Reindexing](#reindexing)
  - [Dropping Entries from an Axis](#dropping-entries-from-an-axis)
  - [Indexing, Selection, and
    Filtering](#indexing-selection-and-filtering)
    - [Selection on DataFrame with Loc and
      Iloc](#selection-on-dataframe-with-loc-and-iloc)
  - [Arithmetic and Data Alignment](#arithmetic-and-data-alignment)

# Prerequisites

[Link to chapter](https://wesmckinney.com/book/pandas-basics)

Import packages:

``` python
# General packages:
import numpy as np
import pandas as pd

# Direct import for convenience:
from pandas import Series, DataFrame
```

# 5.1 Introduction to pandas Data Structures

pandas introduces the *Series* and *DataFrame* object types, which are
extensions of of the NumPy *ndarray* we’ve been working with in the last
chapter.

## Series

A Series is a one-dimensional array-like object. So it contains a
sequence of values of the same type, and–this is the pandas addition–an
associated array of data labels, called its *index*. Let’s take a look:

> [!NOTE]
>
> I will omit the “Create object…” comment, as I expect you to be able
> to make sense of the according lines of code without such commentary.

``` python
obj = pd.Series([4, 7, -5, 3])
obj
```

    0    4
    1    7
    2   -5
    3    3
    dtype: int64

What you see retured are the index column on the left and the actual
values on the right. We can specify this index, but by default it will
take integers starting from `0` till `Number of Elements - 1`. You can
get either of those columns via the `array` or `index` attribute:

``` python
obj.array

obj.index
```

    <NumpyExtensionArray>
    [4, 7, -5, 3]
    Length: 4, dtype: int64

    RangeIndex(start=0, stop=4, step=1)

You give individual values for the index. They can also be of the string
type:

``` python
obj_2 = pd.Series(
    [4, 7, -5, 3], 
    index = ["d", "b", "a", "c"]
    )
obj_2

obj_2.index
```

    d    4
    b    7
    a   -5
    c    3
    dtype: int64

    Index(['d', 'b', 'a', 'c'], dtype='str')

One feature panda brings with the string index is that you can select
elements, or a range of them, directly by those labels:

``` python
obj_2["a"]

# Assign the value 6 to the element with the "b" label.
obj_2["d"] = 6

obj_2[["c", "a", "d"]]
```

    np.int64(-5)

    c    3
    a   -5
    d    6
    dtype: int64

Each element in a Series preserves its index value (keeps its identity)
throughout rearranging operations like filtering, scalar multiplication,
or other math functions:

``` python
# Give me all elements with positive values.
obj_2[obj_2 > 0]

# Multiply all each element by 2.
obj_2 * 2

# Take the exponent of each element.
np.exp(obj_2)
```

    d    6
    b    7
    c    3
    dtype: int64

    d    12
    b    14
    a   -10
    c     6
    dtype: int64

    d     403.428793
    b    1096.633158
    a       0.006738
    c      20.085537
    dtype: float64

A Series is technically an ordered dictionary with the index as key and
the data as values. So dictionary functions are also applicable:

``` python
# Is there an element with key/index "b"?
"b" in obj_2

# Is there an element with key/index "e"?
"e" in obj_2
```

    True

    False

You can even directly transform Python dictionaries into Series:

``` python
sdata = {
    "Ohio": 35000,
    "Texas": 71000,
    "Oregon": 16000,
    "Utah": 5000
    }

# Cast `sdata` into a series.
obj_3 = pd.Series(sdata)
obj_3
```

    Ohio      35000
    Texas     71000
    Oregon    16000
    Utah       5000
    dtype: int64

And Series have their own `to_dict` method to become dictionaries:

``` python
obj_3.to_dict()
```

    {'Ohio': 35000, 'Texas': 71000, 'Oregon': 16000, 'Utah': 5000}

When converting dictionaries to Series the index order of the series
follows that of the keys by default. Use the `index` argument to set a
different order for the index:

``` python
# Define the order of index values.
states_order = ["California", "Ohio", "Oregon", "Texas"]

obj_4 = pd.Series(sdata, index = states_order)
obj_4
```

    California        NaN
    Ohio          35000.0
    Oregon        16000.0
    Texas         71000.0
    dtype: float64

Note, how the index `"California"` got `NaN` (Not a Number) as value,
and `"Utah"` didn’t make it from the dictionary into the series.
`pd.Series()` will respect the index values given by both creating them
regardless of their presence in the input object and dropping those
elements whose keys weren’t called.

To detect “missing”, “NA”, or “Null” values–or the other way around–use
pandas `isna` and `notna` functions:

``` python
pd.isna(obj_4)

pd.notna(obj_4)
```

    California     True
    Ohio          False
    Oregon        False
    Texas         False
    dtype: bool

    California    False
    Ohio           True
    Oregon         True
    Texas          True
    dtype: bool

Well, Series also have these as methods:

``` python
obj_4.isna()
```

    California     True
    Ohio          False
    Oregon        False
    Texas         False
    dtype: bool

A relevant feature for arithmetic operations with Series is that the
data gets automatically alinged by index values:

``` python
obj_3

obj_4

obj_3 + obj_4
```

    Ohio      35000
    Texas     71000
    Oregon    16000
    Utah       5000
    dtype: int64

    California        NaN
    Ohio          35000.0
    Oregon        16000.0
    Texas         71000.0
    dtype: float64

    California         NaN
    Ohio           70000.0
    Oregon         32000.0
    Texas         142000.0
    Utah               NaN
    dtype: float64

The Series object and its index have a `name` attribute that can be set,
and then integrates well with further pandas operations:

``` python
obj_4.name = "population"

obj_4.index.name = "state"

obj_4
```

    state
    California        NaN
    Ohio          35000.0
    Oregon        16000.0
    Texas         71000.0
    Name: population, dtype: float64

> [!NOTE]
>
> I personally would give `state` its own column, but since we’re still
> talking about series here, this would probably the more efficient way
> to have that information stored

The index of Series can be, and are, altered in place by an assignmet
operation:

``` python
obj

obj.index = ["Lasagna", "Alfried", "Steward", "Ragna"]
obj
```

    0    4
    1    7
    2   -5
    3    3
    dtype: int64

    Lasagna    4
    Alfried    7
    Steward   -5
    Ragna      3
    dtype: int64

## DataFrame

Now, the DataFrame is a rectangular table of data…

> [!NOTE]
>
> **rectangular** *table* of data seems redundant to me, because a table
> is usually rectangular by definition, consisting of rows and columns.
>
> Ah well, if I think about it there is a point about separating
> matrices from tables as they have different arithmetic rules. But
> that’s a pretty specific point, which might confuse at least
> those–like me–that kinda glossed over, or never really had, matrices
> in high school.

…and contains an ordererd, named collection of columns (each containing
their respective rows). The individual columns can have different value
types and still be part of the same DataFrame. Furthemore, both rows and
columns have an index. While the columns get their index by default from
the keys of the input dictionary, the rows index will be ascending
integers starting from 0 by default.

Let’s create a dictionary first, and then convert it to a DataFrame:

``` python
data = {"state": ["Ohio", "Ohio", "Ohio", "Nevada", "Nevada", "Nevada"],
        "year": [2000, 2001, 2002, 2001, 2002, 2003],
        "pop": [1.5, 1.7, 3.6, 2.4, 2.9, 3.2]}

frame = pd.DataFrame(data)
```

Now, the keys become the index for the colums, and the rows get indexed
automatically:

``` python
frame
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | state  | year | pop |
|-----|--------|------|-----|
| 0   | Ohio   | 2000 | 1.5 |
| 1   | Ohio   | 2001 | 1.7 |
| 2   | Ohio   | 2002 | 3.6 |
| 3   | Nevada | 2001 | 2.4 |
| 4   | Nevada | 2002 | 2.9 |
| 5   | Nevada | 2003 | 3.2 |

</div>

And then we have methods like `head` and `tail` to get a look at the
firs or last five rows, resepectively:

``` python
frame.head()

frame.tail()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | state  | year | pop |
|-----|--------|------|-----|
| 0   | Ohio   | 2000 | 1.5 |
| 1   | Ohio   | 2001 | 1.7 |
| 2   | Ohio   | 2002 | 3.6 |
| 3   | Nevada | 2001 | 2.4 |
| 4   | Nevada | 2002 | 2.9 |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | state  | year | pop |
|-----|--------|------|-----|
| 1   | Ohio   | 2001 | 1.7 |
| 2   | Ohio   | 2002 | 3.6 |
| 3   | Nevada | 2001 | 2.4 |
| 4   | Nevada | 2002 | 2.9 |
| 5   | Nevada | 2003 | 3.2 |

</div>

You can rearrange the columns by giving the current or source DataFrame
as input to `pd.DataFrame` and the desired order as a sequence to the
`columns` argument:

``` python
pd.DataFrame(frame, columns = ["year", "state", "pop"])
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | year | state  | pop |
|-----|------|--------|-----|
| 0   | 2000 | Ohio   | 1.5 |
| 1   | 2001 | Ohio   | 1.7 |
| 2   | 2002 | Ohio   | 3.6 |
| 3   | 2001 | Nevada | 2.4 |
| 4   | 2002 | Nevada | 2.9 |
| 5   | 2003 | Nevada | 3.2 |

</div>

And just as with Series, DataFrame will respect your sequence and create
columns that you gave but might not have existed in the input object,
and populate them with `NaN`:

``` python
pd.DataFrame(frame, columns = ["year", "state", "pop", "lasagna"])
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | year | state  | pop | lasagna |
|-----|------|--------|-----|---------|
| 0   | 2000 | Ohio   | 1.5 | NaN     |
| 1   | 2001 | Ohio   | 1.7 | NaN     |
| 2   | 2002 | Ohio   | 3.6 | NaN     |
| 3   | 2001 | Nevada | 2.4 | NaN     |
| 4   | 2002 | Nevada | 2.9 | NaN     |
| 5   | 2003 | Nevada | 3.2 | NaN     |

</div>

Get a single column as a Series either by dictionary call, or as a dot
attribute:

``` python
frame["pop"]

frame.year
```

    0    1.5
    1    1.7
    2    3.6
    3    2.4
    4    2.9
    5    3.2
    Name: pop, dtype: float64

    0    2000
    1    2001
    2    2002
    3    2001
    4    2002
    5    2003
    Name: year, dtype: int64

Rows on the other hand, can be retrieved with special `loc` and `iloc`
attributes–which are useful in later contexts, and their difference will
be elaborated soon:

``` python
# Second row
frame.loc[1]

# Third row
frame.iloc[2]
```

    state    Ohio
    year     2001
    pop       1.7
    Name: 1, dtype: object

    state    Ohio
    year     2002
    pop       3.6
    Name: 2, dtype: object

So colums are not renamed, but their elements modified, by assigning
values to their index:

``` python
# Scalars are broadcast.
frame["debt"] = 16.5
frame

# Arrays work as well.
frame["debt"] = np.arange(6.)
frame
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | state  | year | pop | debt |
|-----|--------|------|-----|------|
| 0   | Ohio   | 2000 | 1.5 | 16.5 |
| 1   | Ohio   | 2001 | 1.7 | 16.5 |
| 2   | Ohio   | 2002 | 3.6 | 16.5 |
| 3   | Nevada | 2001 | 2.4 | 16.5 |
| 4   | Nevada | 2002 | 2.9 | 16.5 |
| 5   | Nevada | 2003 | 3.2 | 16.5 |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | state  | year | pop | debt |
|-----|--------|------|-----|------|
| 0   | Ohio   | 2000 | 1.5 | 0.0  |
| 1   | Ohio   | 2001 | 1.7 | 1.0  |
| 2   | Ohio   | 2002 | 3.6 | 2.0  |
| 3   | Nevada | 2001 | 2.4 | 3.0  |
| 4   | Nevada | 2002 | 2.9 | 4.0  |
| 5   | Nevada | 2003 | 3.2 | 5.0  |

</div>

Assigning lists or arrays to DataFrame columns only works when their
lengths match. With a series on the other hand, values get aligned to
existing indices while all other become `NaN`:

``` python
val = pd.Series([-1.2, -1.5, -1.7], index = [2, 4, 5])

frame["debt"] = val
frame

frame["debt"] = [1, 1, 2]
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | state  | year | pop | debt |
|-----|--------|------|-----|------|
| 0   | Ohio   | 2000 | 1.5 | NaN  |
| 1   | Ohio   | 2001 | 1.7 | NaN  |
| 2   | Ohio   | 2002 | 3.6 | -1.2 |
| 3   | Nevada | 2001 | 2.4 | NaN  |
| 4   | Nevada | 2002 | 2.9 | -1.5 |
| 5   | Nevada | 2003 | 3.2 | -1.7 |

</div>

    ValueError: Length of values (3) does not match length of index (6)
    [31m---------------------------------------------------------------------------[39m
    [31mValueError[39m                                Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[24][39m[32m, line 6[39m
    [32m      2[39m 
    [32m      3[39m frame[[33m"debt"[39m] = val
    [32m      4[39m frame
    [32m      5[39m 
    [32m----> [39m[32m6[39m frame[[33m"debt"[39m] = [[32m1[39m, [32m1[39m, [32m2[39m]

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/frame.py:4672[39m, in [36mDataFrame.__setitem__[39m[34m(self, key, value)[39m
    [32m   4668[39m             [38;5;66;03m# Column to set is duplicated[39;00m
    [32m   4669[39m             self._setitem_array([key], value)
    [32m   4670[39m         [38;5;28;01melse[39;00m:
    [32m   4671[39m             [38;5;66;03m# set column[39;00m
    [32m-> [39m[32m4672[39m             self._set_item(key, value)

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/frame.py:4874[39m, in [36mDataFrame._set_item[39m[34m(self, key, value)[39m
    [32m   4870[39m 
    [32m   4871[39m         Series/TimeSeries will be conformed to the DataFrames index to
    [32m   4872[39m         ensure homogeneity.
    [32m   4873[39m         """
    [32m-> [39m[32m4874[39m         value, refs = self._sanitize_column(value)
    [32m   4875[39m 
    [32m   4876[39m         if (
    [32m   4877[39m             key [38;5;28;01min[39;00m self.columns

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/frame.py:5756[39m, in [36mDataFrame._sanitize_column[39m[34m(self, value)[39m
    [32m   5752[39m                 value = Series(value)
    [32m   5753[39m             [38;5;28;01mreturn[39;00m _reindex_for_setitem(value, self.index)
    [32m   5754[39m 
    [32m   5755[39m         [38;5;28;01mif[39;00m is_list_like(value):
    [32m-> [39m[32m5756[39m             com.require_length_match(value, self.index)
    [32m   5757[39m         [38;5;28;01mreturn[39;00m sanitize_array(value, self.index, copy=[38;5;28;01mTrue[39;00m, allow_2d=[38;5;28;01mTrue[39;00m), [38;5;28;01mNone[39;00m

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/common.py:601[39m, in [36mrequire_length_match[39m[34m(data, index)[39m
    [32m    597[39m [38;5;250m[39m[33;03m"""[39;00m
    [32m    598[39m [33;03mCheck the length of data matches the length of the index.[39;00m
    [32m    599[39m [33;03m"""[39;00m
    [32m    600[39m [38;5;28;01mif[39;00m [38;5;28mlen[39m(data) != [38;5;28mlen[39m(index):
    [32m--> [39m[32m601[39m     [38;5;28;01mraise[39;00m [38;5;167;01mValueError[39;00m(
    [32m    602[39m         [33m"[39m[33mLength of values [39m[33m"[39m
    [32m    603[39m         [33mf[39m[33m"[39m[33m([39m[38;5;132;01m{[39;00m[38;5;28mlen[39m(data)[38;5;132;01m}[39;00m[33m) [39m[33m"[39m
    [32m    604[39m         [33m"[39m[33mdoes not match length of index [39m[33m"[39m
    [32m    605[39m         [33mf[39m[33m"[39m[33m([39m[38;5;132;01m{[39;00m[38;5;28mlen[39m(index)[38;5;132;01m}[39;00m[33m)[39m[33m"[39m
    [32m    606[39m     )

    [31mValueError[39m: Length of values (3) does not match length of index (6)

With the `del` *keyword*, columns can be deleted via a dictionary call.
Let’s create some columns first:

``` python
# Create a column named "eastern" where the values are true
# when value of the column "state" of the same row is "Ohio".
frame["eastern"] = frame["state"] == "Ohio"
frame
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | state  | year | pop | debt | eastern |
|-----|--------|------|-----|------|---------|
| 0   | Ohio   | 2000 | 1.5 | NaN  | True    |
| 1   | Ohio   | 2001 | 1.7 | NaN  | True    |
| 2   | Ohio   | 2002 | 3.6 | -1.2 | True    |
| 3   | Nevada | 2001 | 2.4 | NaN  | False   |
| 4   | Nevada | 2002 | 2.9 | -1.5 | False   |
| 5   | Nevada | 2003 | 3.2 | -1.7 | False   |

</div>

Now let’s delete that same column again:

``` python
del frame["eastern"]

frame.columns
```

    Index(['state', 'year', 'pop', 'debt'], dtype='str')

You will regularly get dictionaries nested into dictionaries like:

``` python
populations = {
    "Ohio": {2000: 1.5, 2001: 1.7, 2002: 3.6},
    "Nevada": {2001: 2.4, 2002: 2.9}
}
```

If you pass that to a DataFrame, the outer keys are still the column
index, but the inner dictionaries get resolved by setting their keys as
row index and the values as values:

``` python
frame_3 = pd.DataFrame(populations)
frame_3
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|      | Ohio | Nevada |
|------|------|--------|
| 2000 | 1.5  | NaN    |
| 2001 | 1.7  | 2.4    |
| 2002 | 3.6  | 2.9    |

</div>

Swap rows and columns with the `T` method–just like with NumPy arrays:

``` python
frame_3.T
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|        | 2000 | 2001 | 2002 |
|--------|------|------|------|
| Ohio   | 1.5  | 1.7  | 3.6  |
| Nevada | NaN  | 2.4  | 2.9  |

</div>

Be aware that when setting an index, values from the input that don’t
match are ommitted:

``` python
# We're loosing `2000` here.
pd.DataFrame(populations, index = [2001, 2002, 2003])
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|      | Ohio | Nevada |
|------|------|--------|
| 2001 | 1.7  | 2.4    |
| 2002 | 3.6  | 2.9    |
| 2003 | NaN  | NaN    |

</div>

Series nested within dictionaries are resolved indo a DataFrame the same
as nested dictionaries: Series nested within dictionaries are resolved
indo a DataFrame the same as nested dictionaries:

``` python
pdata = {
    # We're getting lists from indexing them out of the `frame_3` object.
    # Assing to the key `Ohio`:
    # From `frame_3`, column `Ohio`, every but the last row.
    "Ohio": frame_3["Ohio"][:-1],
    # Assign the the key `Nevada`:
    # From `frame_3` , column `Nevada`, get the first two rows.
    "Nevada": frame_3["Nevada"][:2],
}

# Make pdata a DataFrame
pd.DataFrame(pdata)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|      | Ohio | Nevada |
|------|------|--------|
| 2000 | 1.5  | NaN    |
| 2001 | 1.7  | 2.4    |

</div>

As with Series, the DataFrames attributes `index` and `columns` can be
set, and will be displayed if so:

``` python
frame_3.index.name = "year"

frame_3.columns.name = "state"

frame_3
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

| state | Ohio | Nevada |
|-------|------|--------|
| year  |      |        |
| 2000  | 1.5  | NaN    |
| 2001  | 1.7  | 2.4    |
| 2002  | 3.6  | 2.9    |

</div>

This means however, than DataFrame itself does not have a `name`
attribute–as opposed to Series.

> [!NOTE]
>
> Something about the details of the `to_numpy` method

## Index Objects

In pandas, the index are their own objects which can be assinged any
series type to set the index values (we did this to some extent above
already):

``` python
obj = pd.Series(np.arange(3), index=["a", "b", "c"])

# Here, we extract the `index`.
index = obj.index

# And see that it is an independent `object` indeed.
index

# For which regular indexing applies.
index[1:]
```

    Index(['a', 'b', 'c'], dtype='str')

    Index(['b', 'c'], dtype='str')

Interesting, yet sensible, these index objects are immutable– their
elements cannot be manually altered in place:

``` python
index[1] = "Lasagna"
```

    TypeError: Index does not support mutable operations
    [31m---------------------------------------------------------------------------[39m
    [31mTypeError[39m                                 Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[34][39m[32m, line 1[39m
    [32m----> [39m[32m1[39m index[[32m1[39m] = [33m"Lasagna"[39m

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexes/base.py:5382[39m, in [36mIndex.__setitem__[39m[34m(self, key, value)[39m
    [32m   5380[39m [38;5;129m@final[39m
    [32m   5381[39m [38;5;28;01mdef[39;00m[38;5;250m [39m[34m__setitem__[39m([38;5;28mself[39m, key, value) -> [38;5;28;01mNone[39;00m:
    [32m-> [39m[32m5382[39m     [38;5;28;01mraise[39;00m [38;5;167;01mTypeError[39;00m([33m"[39m[33mIndex does not support mutable operations[39m[33m"[39m)

    [31mTypeError[39m: Index does not support mutable operations

So the structure/data type of index objects is respected when used in
other functions–that’s the immutability:

``` python
# Creating a literal index object.
labels = pd.Index(np.arange(3))
labels

# "Integrating" it into a Series.
obj_2 = pd.Series([1.5, -2.5, 0], index = labels)
obj_2

# See, it's referencing that `label` object.
obj_2.index is labels
```

    Index([0, 1, 2], dtype='int64')

    0    1.5
    1   -2.5
    2    0.0
    dtype: float64

    True

Now you know.

Values of the index can be queried:

``` python
frame_3.columns

"Ohio" in frame_3.columns

2003 in frame_3.index
```

    Index(['Ohio', 'Nevada'], dtype='str', name='state')

    True

    False

And if values occur multiple times, all of them will be
returned/selected.

> [!NOTE]
>
> And a list of useful index methods and properties.

# 5.2 Essential Functionality

## Reindexing

Knowing the above, we can now see how this translates to quite neat
functonality with pandas DataFrames and Series. Let’s create one to play
around with:

``` python
# Index deliberately in a perculiar order.
obj = pd.Series([4.5, 7.2, -5.3, 3.6], index = ["d", "b", "a", "c"])
obj
```

    d    4.5
    b    7.2
    a   -5.3
    c    3.6
    dtype: float64

The `reindex` method rearranges the data according to the index you
give. As shown previously, indexes that are not explicitly called for
will be ommitted from the input data, and indexes for which no elements
exist in the input data will be created regardless:

``` python
obj_2 = obj.reindex(["a", "c", "d", "e"])
obj_2
```

    a   -5.3
    c    3.6
    d    4.5
    e    NaN
    dtype: float64

Within this method, there is the–wait for it–`method` keyword to address
indices for which input data might be missing. For example, giving
`ffil` as the argument’s value will *forward fill* (repeat) the last
value until the index for which a value exists again in the input data:

``` python
obj_3 = pd.Series(
    ["Alfried", "Lasagna", "Ragna"],
    index = [0, 2, 5]
    )
obj_3

obj_3.reindex(np.arange(7), method = "ffill")
```

    0    Alfried
    2    Lasagna
    5      Ragna
    dtype: str

    0    Alfried
    1    Alfried
    2    Lasagna
    3    Lasagna
    4    Lasagna
    5      Ragna
    6      Ragna
    dtype: str

And for DataFrame you can address either the index (rows), columns, or
both. The index (rows) are the the default target when giving just one
sequence:

``` python
frame = pd.DataFrame(
    np.arange(9).reshape((3, 3)),
    index=["a", "c", "d"],
    columns=["Ohio", "Texas", "California"],
)
frame

frame_2 = frame.reindex(index=["a", "b", "c", "d"])
frame_2
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | Ohio | Texas | California |
|-----|------|-------|------------|
| a   | 0    | 1     | 2          |
| c   | 3    | 4     | 5          |
| d   | 6    | 7     | 8          |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | Ohio | Texas | California |
|-----|------|-------|------------|
| a   | 0.0  | 1.0   | 2.0        |
| b   | NaN  | NaN   | NaN        |
| c   | 3.0  | 4.0   | 5.0        |
| d   | 6.0  | 7.0   | 8.0        |

</div>

To reindex the columns, supply the sequence to the–well–`columns`
keyword:

``` python
states = ["Texas", "Utah", "California"]

frame.reindex(columns = states)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | Texas | Utah | California |
|-----|-------|------|------------|
| a   | 1     | NaN  | 2          |
| c   | 4     | NaN  | 5          |
| d   | 7     | NaN  | 8          |

</div>

A variant of this would be to supply the sequence as the first
*positional* argument, and then set the direction with the `axis`
keyword:

``` python
frame.reindex(states, axis = "columns")
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | Texas | Utah | California |
|-----|-------|------|------------|
| a   | 1     | NaN  | 2          |
| c   | 4     | NaN  | 5          |
| d   | 7     | NaN  | 8          |

</div>

Might be more clear this way, but whatever you feel like.

> [!NOTE]
>
> Another table of further arguments and keywords for `reindex`.

Quick mention of the `loc` operator–we already heard of this before, and
will again shortly–that also does reindexing but refuses to create
elements that did not already exist in the input, so the index sequence
has to match the values of the input:

``` python
frame.loc[
    ["a", "d", "c"],
    ["California", "Texas"],
]

frame.loc[
    ["a", "b", "c"],
    ["California", "Texas"]
]
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|     | California | Texas |
|-----|------------|-------|
| a   | 2          | 1     |
| d   | 8          | 7     |
| c   | 5          | 4     |

</div>

    KeyError: "['b'] not in index"
    [31m---------------------------------------------------------------------------[39m
    [31mKeyError[39m                                  Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[43][39m[32m, line 6[39m
    [32m      2[39m     [[33m"a"[39m, [33m"d"[39m, [33m"c"[39m],
    [32m      3[39m     [[33m"California"[39m, [33m"Texas"[39m],
    [32m      4[39m ]
    [32m      5[39m 
    [32m----> [39m[32m6[39m frame.loc[
    [32m      7[39m     [[33m"a"[39m, [33m"b"[39m, [33m"c"[39m],
    [32m      8[39m     [[33m"California"[39m, [33m"Texas"[39m]
    [32m      9[39m ]

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1200[39m, in [36m_LocationIndexer.__getitem__[39m[34m(self, key)[39m
    [32m   1198[39m     [38;5;28;01mif[39;00m [38;5;28mself[39m._is_scalar_access(key):
    [32m   1199[39m         [38;5;28;01mreturn[39;00m [38;5;28mself[39m.obj._get_value(*key, takeable=[38;5;28mself[39m._takeable)
    [32m-> [39m[32m1200[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_getitem_tuple[39;49m[30;43m([39;49m[30;43mkey[39;49m[30;43m)[39;49m
    [32m   1201[39m [38;5;28;01melse[39;00m:
    [32m   1202[39m     [38;5;66;03m# we by definition only have the 0th axis[39;00m
    [32m   1203[39m     axis = [38;5;28mself[39m.axis [38;5;129;01mor[39;00m [32m0[39m

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1386[39m, in [36m_LocIndexer._getitem_tuple[39m[34m(self, tup)[39m
    [32m   1384[39m [38;5;28;01mwith[39;00m suppress(IndexingError):
    [32m   1385[39m     tup = [38;5;28mself[39m._expand_ellipsis(tup)
    [32m-> [39m[32m1386[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_getitem_lowerdim[39;49m[30;43m([39;49m[30;43mtup[39;49m[30;43m)[39;49m
    [32m   1388[39m [38;5;66;03m# no multi-index, so validate all of the indexers[39;00m
    [32m   1389[39m tup = [38;5;28mself[39m._validate_tuple_indexer(tup)

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1117[39m, in [36m_LocationIndexer._getitem_lowerdim[39m[34m(self, tup)[39m
    [32m   1115[39m             [38;5;28;01mreturn[39;00m section
    [32m   1116[39m         [38;5;66;03m# This is an elided recursive call to iloc/loc[39;00m
    [32m-> [39m[32m1117[39m         [38;5;28;01mreturn[39;00m [30;43mgetattr[39;49m[30;43m([39;49m[30;43msection[39;49m[30;43m,[39;49m[30;43m [39;49m[30;43mself[39;49m[30;43m.[39;49m[30;43mname[39;49m[30;43m)[39;49m[30;43m[[39;49m[30;43mnew_key[39;49m[30;43m][39;49m
    [32m   1119[39m [38;5;28;01mraise[39;00m IndexingError([33m"[39m[33mnot applicable[39m[33m"[39m)

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1200[39m, in [36m_LocationIndexer.__getitem__[39m[34m(self, key)[39m
    [32m   1198[39m     [38;5;28;01mif[39;00m [38;5;28mself[39m._is_scalar_access(key):
    [32m   1199[39m         [38;5;28;01mreturn[39;00m [38;5;28mself[39m.obj._get_value(*key, takeable=[38;5;28mself[39m._takeable)
    [32m-> [39m[32m1200[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_getitem_tuple[39;49m[30;43m([39;49m[30;43mkey[39;49m[30;43m)[39;49m
    [32m   1201[39m [38;5;28;01melse[39;00m:
    [32m   1202[39m     [38;5;66;03m# we by definition only have the 0th axis[39;00m
    [32m   1203[39m     axis = [38;5;28mself[39m.axis [38;5;129;01mor[39;00m [32m0[39m

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1386[39m, in [36m_LocIndexer._getitem_tuple[39m[34m(self, tup)[39m
    [32m   1384[39m [38;5;28;01mwith[39;00m suppress(IndexingError):
    [32m   1385[39m     tup = [38;5;28mself[39m._expand_ellipsis(tup)
    [32m-> [39m[32m1386[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_getitem_lowerdim[39;49m[30;43m([39;49m[30;43mtup[39;49m[30;43m)[39;49m
    [32m   1388[39m [38;5;66;03m# no multi-index, so validate all of the indexers[39;00m
    [32m   1389[39m tup = [38;5;28mself[39m._validate_tuple_indexer(tup)

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1093[39m, in [36m_LocationIndexer._getitem_lowerdim[39m[34m(self, tup)[39m
    [32m   1089[39m [38;5;28;01mfor[39;00m i, key [38;5;129;01min[39;00m [38;5;28mzip[39m([38;5;28mrange[39m([38;5;28mlen[39m(tup) - [32m1[39m, -[32m1[39m, -[32m1[39m), [38;5;28mreversed[39m(tup), strict=[38;5;28;01mTrue[39;00m):
    [32m   1090[39m     [38;5;28;01mif[39;00m is_label_like(key) [38;5;129;01mor[39;00m is_list_like(key):
    [32m   1091[39m         [38;5;66;03m# We don't need to check for tuples here because those are[39;00m
    [32m   1092[39m         [38;5;66;03m#  caught by the _is_nested_tuple_indexer check above.[39;00m
    [32m-> [39m[32m1093[39m         section = [30;43mself[39;49m[30;43m.[39;49m[30;43m_getitem_axis[39;49m[30;43m([39;49m[30;43mkey[39;49m[30;43m,[39;49m[30;43m [39;49m[30;43maxis[39;49m[30;43m=[39;49m[30;43mi[39;49m[30;43m)[39;49m
    [32m   1095[39m         [38;5;66;03m# We should never have a scalar section here, because[39;00m
    [32m   1096[39m         [38;5;66;03m#  _getitem_lowerdim is only called after a check for[39;00m
    [32m   1097[39m         [38;5;66;03m#  is_scalar_access, which that would be.[39;00m
    [32m   1098[39m         [38;5;28;01mif[39;00m section.ndim == [38;5;28mself[39m.ndim:
    [32m   1099[39m             [38;5;66;03m# we're in the middle of slicing through a MultiIndex[39;00m
    [32m   1100[39m             [38;5;66;03m# revise the key wrt to `section` by inserting an _NS[39;00m

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1438[39m, in [36m_LocIndexer._getitem_axis[39m[34m(self, key, axis)[39m
    [32m   1435[39m     [38;5;28;01mif[39;00m [38;5;28mhasattr[39m(key, [33m"[39m[33mndim[39m[33m"[39m) [38;5;129;01mand[39;00m key.ndim > [32m1[39m:
    [32m   1436[39m         [38;5;28;01mraise[39;00m [38;5;167;01mValueError[39;00m([33m"[39m[33mCannot index with multidimensional key[39m[33m"[39m)
    [32m-> [39m[32m1438[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_getitem_iterable[39;49m[30;43m([39;49m[30;43mkey[39;49m[30;43m,[39;49m[30;43m [39;49m[30;43maxis[39;49m[30;43m=[39;49m[30;43maxis[39;49m[30;43m)[39;49m
    [32m   1440[39m [38;5;66;03m# nested tuple slicing[39;00m
    [32m   1441[39m [38;5;28;01mif[39;00m is_nested_tuple(key, labels):

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1378[39m, in [36m_LocIndexer._getitem_iterable[39m[34m(self, key, axis)[39m
    [32m   1375[39m [38;5;28mself[39m._validate_key(key, axis)
    [32m   1377[39m [38;5;66;03m# A collection of keys[39;00m
    [32m-> [39m[32m1378[39m keyarr, indexer = [30;43mself[39;49m[30;43m.[39;49m[30;43m_get_listlike_indexer[39;49m[30;43m([39;49m[30;43mkey[39;49m[30;43m,[39;49m[30;43m [39;49m[30;43maxis[39;49m[30;43m)[39;49m
    [32m   1379[39m [38;5;28;01mreturn[39;00m [38;5;28mself[39m.obj._reindex_with_indexers(
    [32m   1380[39m     {axis: [keyarr, indexer]}, allow_dups=[38;5;28;01mTrue[39;00m
    [32m   1381[39m )

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexing.py:1576[39m, in [36m_LocIndexer._get_listlike_indexer[39m[34m(self, key, axis)[39m
    [32m   1573[39m ax = [38;5;28mself[39m.obj._get_axis(axis)
    [32m   1574[39m axis_name = [38;5;28mself[39m.obj._get_axis_name(axis)
    [32m-> [39m[32m1576[39m keyarr, indexer = [30;43max[39;49m[30;43m.[39;49m[30;43m_get_indexer_strict[39;49m[30;43m([39;49m[30;43mkey[39;49m[30;43m,[39;49m[30;43m [39;49m[30;43maxis_name[39;49m[30;43m)[39;49m
    [32m   1578[39m [38;5;28;01mreturn[39;00m keyarr, indexer

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexes/base.py:6302[39m, in [36mIndex._get_indexer_strict[39m[34m(self, key, axis_name)[39m
    [32m   6299[39m [38;5;28;01melse[39;00m:
    [32m   6300[39m     keyarr, indexer, new_indexer = [38;5;28mself[39m._reindex_non_unique(keyarr)
    [32m-> [39m[32m6302[39m [30;43mself[39;49m[30;43m.[39;49m[30;43m_raise_if_missing[39;49m[30;43m([39;49m[30;43mkeyarr[39;49m[30;43m,[39;49m[30;43m [39;49m[30;43mindexer[39;49m[30;43m,[39;49m[30;43m [39;49m[30;43maxis_name[39;49m[30;43m)[39;49m
    [32m   6304[39m keyarr = [38;5;28mself[39m.take(indexer)
    [32m   6305[39m [38;5;28;01mif[39;00m [38;5;28misinstance[39m(key, Index):
    [32m   6306[39m     [38;5;66;03m# GH 42790 - Preserve name from an Index[39;00m

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexes/base.py:6355[39m, in [36mIndex._raise_if_missing[39m[34m(self, key, indexer, axis_name)[39m
    [32m   6352[39m     [38;5;28;01mraise[39;00m [38;5;167;01mKeyError[39;00m([33mf[39m[33m"[39m[33mNone of [[39m[38;5;132;01m{[39;00mkey[38;5;132;01m}[39;00m[33m] are in the [[39m[38;5;132;01m{[39;00maxis_name[38;5;132;01m}[39;00m[33m][39m[33m"[39m)
    [32m   6354[39m not_found = [38;5;28mlist[39m(ensure_index(key)[missing_mask.nonzero()[[32m0[39m]].unique())
    [32m-> [39m[32m6355[39m [38;5;28;01mraise[39;00m [38;5;167;01mKeyError[39;00m([33mf[39m[33m"[39m[38;5;132;01m{[39;00mnot_found[38;5;132;01m}[39;00m[33m not in index[39m[33m"[39m)

    [31mKeyError[39m: "['b'] not in index"

## Dropping Entries from an Axis

We learned above that we can have elements get ommitted from any axis
when we leave out the according index value. This might be cumbesome,
however, as you’d always have to note *all* of the label values you
wanted to keep. The `drop` method will do the trick, by returning the
input object with those values dropped that you give:

``` python
obj = pd.Series(np.arange(5.), index = ["a", "b", "c", "d", "e"])
obj

# By default the row labels (axis 0) are addressed.
new_obj = obj.drop("c")
new_obj

obj.drop(["d", "c"])
```

    a    0.0
    b    1.0
    c    2.0
    d    3.0
    e    4.0
    dtype: float64

    a    0.0
    b    1.0
    d    3.0
    e    4.0
    dtype: float64

    a    0.0
    b    1.0
    e    4.0
    dtype: float64

With DataFrame you have two options to set the addressed label axis for
`drop`:

``` python
data = pd.DataFrame(
    np.arange(16).reshape((4, 4)),
    index = ["Ohio", "Colorado", "Utah", "New York"],
    columns = ["one", "two", "three", "four"],
    )
data
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 0   | 1   | 2     | 3    |
| Colorado | 4   | 5   | 6     | 7    |
| Utah     | 8   | 9   | 10    | 11   |
| New York | 12  | 13  | 14    | 15   |

</div>

So row(index) labels by default:

``` python
data.drop(index = ["Colorado", "Ohio"])
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Utah     | 8   | 9   | 10    | 11   |
| New York | 12  | 13  | 14    | 15   |

</div>

Now for the column labels:

``` python
# Either with the colums argument.
data.drop(columns = ["two"])

# Or labels sequence as positional
# and then via the axis keyword.
data.drop("two", axis = 1)

# You can also call the axis by its name.
data.drop(["two", "four"], axis = "columns")
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | three | four |
|----------|-----|-------|------|
| Ohio     | 0   | 2     | 3    |
| Colorado | 4   | 6     | 7    |
| Utah     | 8   | 10    | 11   |
| New York | 12  | 14    | 15   |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | three | four |
|----------|-----|-------|------|
| Ohio     | 0   | 2     | 3    |
| Colorado | 4   | 6     | 7    |
| Utah     | 8   | 10    | 11   |
| New York | 12  | 14    | 15   |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | three |
|----------|-----|-------|
| Ohio     | 0   | 2     |
| Colorado | 4   | 6     |
| Utah     | 8   | 10    |
| New York | 12  | 14    |

</div>

## Indexing, Selection, and Filtering

Ah yeah, we’re coming to the `loc` and `iloc` operators now. But first,
the overall situation for the rationale. Series and DataFrame elements
can be indexed, filtered and selected with `[]`, like NumPy Arrays, but
you can not only give integers but also the according axis labels. Here
are some examples:

``` python
obj = pd.Series(np.arange(4.), index = ["a", "b", "c", "d"])
obj

# Get row "b".
obj["b"]

# Get rows 3 to 4.
obj[2:4]

# Get rows "a", "b", and "d" in that exact order.
obj[["a", "b", "d"]]

# Get all rows for which the value is less than 2.
obj[obj < 2]
```

    a    0.0
    b    1.0
    c    2.0
    d    3.0
    dtype: float64

    np.float64(1.0)

    c    2.0
    d    3.0
    dtype: float64

    a    0.0
    b    1.0
    d    3.0
    dtype: float64

    a    0.0
    b    1.0
    dtype: float64

> [!NOTE]
>
> Seems like selecting with integers, either single or list, gives an
> error, but ranges still work.
>
> So these calls don’t work:
>
> ``` python
> # Get rows 3 and 4.
> obj[[2, 3]]
>
> # Get the second row.
> obj[1]
> ```
>
> Ah yea, you can read it in the error report:
>
> > 957 \# Note: GH#50617 in 3.0 we changed int key to always be treated
> > as 958 \# a label, matching DataFrame behavior.

So you can only use integers in indexing when the axis labels are
integers, too:

``` python
obj_2  = pd.Series(np.arange(6.))
obj_2

obj_2[1]

obj_2[[2, 4]]

obj_2[[0, 5, 1]]

obj_2[obj_2 < 2]
```

    0    0.0
    1    1.0
    2    2.0
    3    3.0
    4    4.0
    5    5.0
    dtype: float64

    np.float64(1.0)

    2    2.0
    4    4.0
    dtype: float64

    0    0.0
    5    5.0
    1    1.0
    dtype: float64

    0    0.0
    1    1.0
    dtype: float64

However, you can use `iloc` to ignore labels and select by “position”,
solving the above error:

``` python
obj
obj.iloc[1]

obj.iloc[[2, 3]]
```

    a    0.0
    b    1.0
    c    2.0
    d    3.0
    dtype: float64

    np.float64(1.0)

    c    2.0
    d    3.0
    dtype: float64

And the `loc` indexer only works with labels and throws an error when
encountering integer axis values. But, as seen above, the default
behaviour of the regular index operator will let you know when you mix
it up in both cases.

Furthemore, when you assing values to an index call, they will be
assigned to the actual values insted of the axis label:

``` python
obj_3 = pd.Series(
    [1, 2, 3],
    index = ["a", "b", "c"]
)
obj_3

obj_3.loc["b":"c"] = 5
obj_3
```

    a    1
    b    2
    c    3
    dtype: int64

    a    1
    b    5
    c    5
    dtype: int64

For DataFrame, the default axis for indexing is across the columns (1):

``` python
data = pd.DataFrame(
    np.arange(16).reshape((4, 4)),
    index = ["Ohio", "Colorado", "Utah", "New York"],
    columns = ["one", "two", "three", "four"]
)
data

data["two"]

data[["three", "one"]]
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 0   | 1   | 2     | 3    |
| Colorado | 4   | 5   | 6     | 7    |
| Utah     | 8   | 9   | 10    | 11   |
| New York | 12  | 13  | 14    | 15   |

</div>

    Ohio         1
    Colorado     5
    Utah         9
    New York    13
    Name: two, dtype: int64

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | three | one |
|----------|-------|-----|
| Ohio     | 2     | 0   |
| Colorado | 6     | 4   |
| Utah     | 10    | 8   |
| New York | 14    | 12  |

</div>

Now, there are some further idiosycracies:

``` python
# Slicing addresses the row axis (0),
data[:2]

# But boolean filtering only from the second layer.
# Well, not really, but check the later example.
data[data["three"] > 5]

# In the first layer you get `NaN`s.
data[data > 5]

# And the naked operation assings boolean values directly.
data < 5
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 0   | 1   | 2     | 3    |
| Colorado | 4   | 5   | 6     | 7    |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Colorado | 4   | 5   | 6     | 7    |
| Utah     | 8   | 9   | 10    | 11   |
| New York | 12  | 13  | 14    | 15   |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one  | two  | three | four |
|----------|------|------|-------|------|
| Ohio     | NaN  | NaN  | NaN   | NaN  |
| Colorado | NaN  | NaN  | 6.0   | 7.0  |
| Utah     | 8.0  | 9.0  | 10.0  | 11.0 |
| New York | 12.0 | 13.0 | 14.0  | 15.0 |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one   | two   | three | four  |
|----------|-------|-------|-------|-------|
| Ohio     | True  | True  | True  | True  |
| Colorado | True  | False | False | False |
| Utah     | False | False | False | False |
| New York | False | False | False | False |

</div>

So with boolean filtering you can assing new values to the `True`s of
the filter call. For example, assing the value 0 to *every* datapoint
that is less than 5 in `data`:

``` python
data[data < 5] = 0
data
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 0   | 0   | 0     | 0    |
| Colorado | 0   | 5   | 6     | 7    |
| Utah     | 8   | 9   | 10    | 11   |
| New York | 12  | 13  | 14    | 15   |

</div>

### Selection on DataFrame with Loc and Iloc

`loc` and `iloc` apply to DataFrame like for Series plus the addressing
of axis. Let’s get a single row by label:

``` python
data

data.loc["Colorado"]
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 0   | 0   | 0     | 0    |
| Colorado | 0   | 5   | 6     | 7    |
| Utah     | 8   | 9   | 10    | 11   |
| New York | 12  | 13  | 14    | 15   |

</div>

    one      0
    two      5
    three    6
    four     7
    Name: Colorado, dtype: int64

> [!CAUTION]
>
> Typo \> To select multiple **roles** {rows?}, creating a new
> DataFrame, pass a sequence of labels:

Passing a list of labels gives you a new DataFrame:

``` python
data.loc[["Colorado", "New York"]]
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Colorado | 0   | 5   | 6     | 7    |
| New York | 12  | 13  | 14    | 15   |

</div>

You can also select certain rows of those selected columns by passing
another list after a comma:

``` python
data.loc["Colorado", ["three", "four"]]

# Behaves differently if you pass the row selector as a list.
data.loc[["Colorado"], ["three", "four"]]
```

    three    6
    four     7
    Name: Colorado, dtype: int64

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | three | four |
|----------|-------|------|
| Colorado | 6     | 7    |

</div>

Same syntax works for integer selection with `iloc`:

``` python
# Get third row
data.iloc[2]

# Get rows three and two, in that exact order.
data.iloc[[2, 1]]

# Get third row of columns four, one and two, in that exact order
data.iloc[2, [3, 0, 1]]

# Get second and third row of columns four, one and two in that exact order.
data.iloc[[1, 2], [3, 0, 1]]
```

    one       8
    two       9
    three    10
    four     11
    Name: Utah, dtype: int64

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Utah     | 8   | 9   | 10    | 11   |
| Colorado | 0   | 5   | 6     | 7    |

</div>

    four    11
    one      8
    two      9
    Name: Utah, dtype: int64

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | four | one | two |
|----------|------|-----|-----|
| Colorado | 7    | 0   | 5   |
| Utah     | 11   | 8   | 9   |

</div>

Ah wild, you can even slice with labels and some boolean arrays:

``` python
# All rows up to (inclusively this time) "Utah" of column two.
data.loc[:"Utah", "two"]

# All rows of all columns up to (exclusively) row four
# and from that only the rows with values larger than 5 in column three.
data.iloc[:, :3][data.three > 5]
```

    Ohio        0
    Colorado    5
    Utah        9
    Name: two, dtype: int64

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three |
|----------|-----|-----|-------|
| Colorado | 0   | 5   | 6     |
| Utah     | 8   | 9   | 10    |
| New York | 12  | 13  | 14    |

</div>

Boolean arrays work with `loc` and `iloc` alike:

``` python
# Get those rows with values larger or equal to 2 in column three.
data.loc[data.three >= 2]
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Colorado | 0   | 5   | 6     | 7    |
| Utah     | 8   | 9   | 10    | 11   |
| New York | 12  | 13  | 14    | 15   |

</div>

#### Integer Indexing Pifalls

Indexing with integers has some perticular behavior, which probably grew
out of preventing hard to detect user errors. For example, you will get
an error with the following code:

``` python
ser = pd.Series(np.arange(3.))
ser

ser[-1]
```

    0    0.0
    1    1.0
    2    2.0
    dtype: float64

    KeyError: -1
    [31m---------------------------------------------------------------------------[39m
    [31mValueError[39m                                Traceback (most recent call last)
    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexes/range.py:521[39m, in [36mRangeIndex.get_loc[39m[34m(self, key)[39m
    [32m    520[39m [38;5;28;01mtry[39;00m:
    [32m--> [39m[32m521[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_range[39;49m[30;43m.[39;49m[30;43mindex[39;49m[30;43m([39;49m[30;43mnew_key[39;49m[30;43m)[39;49m
    [32m    522[39m [38;5;28;01mexcept[39;00m [38;5;167;01mValueError[39;00m [38;5;28;01mas[39;00m err:

    [31mValueError[39m: -1 is not in range

    The above exception was the direct cause of the following exception:

    [31mKeyError[39m                                  Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[61][39m[32m, line 4[39m
    [32m      1[39m ser = pd.Series(np.arange([32m3.[39m))
    [32m      2[39m ser
    [32m      3[39m 
    [32m----> [39m[32m4[39m ser[-[32m1[39m]

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/series.py:959[39m, in [36mSeries.__getitem__[39m[34m(self, key)[39m
    [32m    954[39m     key = unpack_1tuple(key)
    [32m    956[39m [38;5;28;01melif[39;00m key_is_scalar:
    [32m    957[39m     [38;5;66;03m# Note: GH#50617 in 3.0 we changed int key to always be treated as[39;00m
    [32m    958[39m     [38;5;66;03m#  a label, matching DataFrame behavior.[39;00m
    [32m--> [39m[32m959[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_get_value[39;49m[30;43m([39;49m[30;43mkey[39;49m[30;43m)[39;49m
    [32m    961[39m [38;5;66;03m# Convert generator to list before going through hashable part[39;00m
    [32m    962[39m [38;5;66;03m# (We will iterate through the generator there to check for slices)[39;00m
    [32m    963[39m [38;5;28;01mif[39;00m is_iterator(key):

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/series.py:1046[39m, in [36mSeries._get_value[39m[34m(self, label, takeable)[39m
    [32m   1043[39m     [38;5;28;01mreturn[39;00m [38;5;28mself[39m._values[label]
    [32m   1045[39m [38;5;66;03m# Similar to Index.get_value, but we do not fall back to positional[39;00m
    [32m-> [39m[32m1046[39m loc = [30;43mself[39;49m[30;43m.[39;49m[30;43mindex[39;49m[30;43m.[39;49m[30;43mget_loc[39;49m[30;43m([39;49m[30;43mlabel[39;49m[30;43m)[39;49m
    [32m   1048[39m [38;5;28;01mif[39;00m is_integer(loc):
    [32m   1049[39m     [38;5;28;01mreturn[39;00m [38;5;28mself[39m._values[loc]

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexes/range.py:523[39m, in [36mRangeIndex.get_loc[39m[34m(self, key)[39m
    [32m    521[39m         [38;5;28;01mreturn[39;00m [38;5;28mself[39m._range.index(new_key)
    [32m    522[39m     [38;5;28;01mexcept[39;00m [38;5;167;01mValueError[39;00m [38;5;28;01mas[39;00m err:
    [32m--> [39m[32m523[39m         [38;5;28;01mraise[39;00m [38;5;167;01mKeyError[39;00m(key) [38;5;28;01mfrom[39;00m[38;5;250m [39m[34;01merr[39;00m
    [32m    524[39m [38;5;28;01mif[39;00m [38;5;28misinstance[39m(key, Hashable):
    [32m    525[39m     [38;5;28;01mraise[39;00m [38;5;167;01mKeyError[39;00m(key)

    [31mKeyError[39m: -1

As the index of the series are integers, this indexing call can refer to
either positional or label-based indexing, and pandas does not want to
guess.

If we were to ask the same thing from an non-integer index there is no
ambiguity and the code will succeed:

``` python
ser_2 = pd.Series(
    np.arange(3.),
    index = ["a", "b", "c"]
    )

ser_2[-1]
```

    KeyError: -1
    [31m---------------------------------------------------------------------------[39m
    [31mKeyError[39m                                  Traceback (most recent call last)
    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexes/base.py:3641[39m, in [36mIndex.get_loc[39m[34m(self, key)[39m
    [32m   3640[39m [38;5;28;01mtry[39;00m:
    [32m-> [39m[32m3641[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_engine[39;49m[30;43m.[39;49m[30;43mget_loc[39;49m[30;43m([39;49m[30;43mcasted_key[39;49m[30;43m)[39;49m
    [32m   3642[39m [38;5;28;01mexcept[39;00m [38;5;167;01mKeyError[39;00m [38;5;28;01mas[39;00m err:

    [36mFile [39m[32mpandas/_libs/index.pyx:168[39m, in [36mpandas._libs.index.IndexEngine.get_loc[39m[34m()[39m
    [32m--> [39m[32m168[39m [33m'Could not get source, probably due dynamically evaluated source code.'[39m

    [36mFile [39m[32mpandas/_libs/index.pyx:176[39m, in [36mpandas._libs.index.IndexEngine.get_loc[39m[34m()[39m
    [32m--> [39m[32m176[39m [33m'Could not get source, probably due dynamically evaluated source code.'[39m

    [36mFile [39m[32mpandas/_libs/index.pyx:583[39m, in [36mpandas._libs.index.StringObjectEngine._check_type[39m[34m()[39m
    [32m--> [39m[32m583[39m [33m'Could not get source, probably due dynamically evaluated source code.'[39m

    [31mKeyError[39m: -1

    The above exception was the direct cause of the following exception:

    [31mKeyError[39m                                  Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[62][39m[32m, line 6[39m
    [32m      2[39m     np.arange([32m3.[39m),
    [32m      3[39m     index = [[33m"a"[39m, [33m"b"[39m, [33m"c"[39m]
    [32m      4[39m     )
    [32m      5[39m 
    [32m----> [39m[32m6[39m ser_2[-[32m1[39m]

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/series.py:959[39m, in [36mSeries.__getitem__[39m[34m(self, key)[39m
    [32m    954[39m     key = unpack_1tuple(key)
    [32m    956[39m [38;5;28;01melif[39;00m key_is_scalar:
    [32m    957[39m     [38;5;66;03m# Note: GH#50617 in 3.0 we changed int key to always be treated as[39;00m
    [32m    958[39m     [38;5;66;03m#  a label, matching DataFrame behavior.[39;00m
    [32m--> [39m[32m959[39m     [38;5;28;01mreturn[39;00m [30;43mself[39;49m[30;43m.[39;49m[30;43m_get_value[39;49m[30;43m([39;49m[30;43mkey[39;49m[30;43m)[39;49m
    [32m    961[39m [38;5;66;03m# Convert generator to list before going through hashable part[39;00m
    [32m    962[39m [38;5;66;03m# (We will iterate through the generator there to check for slices)[39;00m
    [32m    963[39m [38;5;28;01mif[39;00m is_iterator(key):

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/series.py:1046[39m, in [36mSeries._get_value[39m[34m(self, label, takeable)[39m
    [32m   1043[39m     [38;5;28;01mreturn[39;00m [38;5;28mself[39m._values[label]
    [32m   1045[39m [38;5;66;03m# Similar to Index.get_value, but we do not fall back to positional[39;00m
    [32m-> [39m[32m1046[39m loc = [30;43mself[39;49m[30;43m.[39;49m[30;43mindex[39;49m[30;43m.[39;49m[30;43mget_loc[39;49m[30;43m([39;49m[30;43mlabel[39;49m[30;43m)[39;49m
    [32m   1048[39m [38;5;28;01mif[39;00m is_integer(loc):
    [32m   1049[39m     [38;5;28;01mreturn[39;00m [38;5;28mself[39m._values[loc]

    [36mFile [39m[32m~/projects/datascience_summerschool_2026/.venv/lib/python3.13/site-packages/pandas/core/indexes/base.py:3648[39m, in [36mIndex.get_loc[39m[34m(self, key)[39m
    [32m   3643[39m     [38;5;28;01mif[39;00m [38;5;28misinstance[39m(casted_key, [38;5;28mslice[39m) [38;5;129;01mor[39;00m (
    [32m   3644[39m         [38;5;28misinstance[39m(casted_key, abc.Iterable)
    [32m   3645[39m         [38;5;129;01mand[39;00m [38;5;28many[39m([38;5;28misinstance[39m(x, [38;5;28mslice[39m) [38;5;28;01mfor[39;00m x [38;5;129;01min[39;00m casted_key)
    [32m   3646[39m     ):
    [32m   3647[39m         [38;5;28;01mraise[39;00m InvalidIndexError(key) [38;5;28;01mfrom[39;00m[38;5;250m [39m[34;01merr[39;00m
    [32m-> [39m[32m3648[39m     [38;5;28;01mraise[39;00m [38;5;167;01mKeyError[39;00m(key) [38;5;28;01mfrom[39;00m[38;5;250m [39m[34;01merr[39;00m
    [32m   3649[39m [38;5;28;01mexcept[39;00m [38;5;167;01mTypeError[39;00m:
    [32m   3650[39m     [38;5;66;03m# If we have a listlike key, _check_indexing_error will raise[39;00m
    [32m   3651[39m     [38;5;66;03m#  InvalidIndexError. Otherwise we fall through and re-raise[39;00m
    [32m   3652[39m     [38;5;66;03m#  the TypeError.[39;00m
    [32m   3653[39m     [38;5;28mself[39m._check_indexing_error(key)

    [31mKeyError[39m: -1

> [!NOTE]
>
> Ah, well, It seems this is not the case anymore. So pandas will throw
> an error in both cases, and you are sternly proposed to use `loc` and
> `iloc` for the above operations, to be really precise about the type
> of indexing you want–rightfully so.

So, to be precise about what you want, use `loc` and `iloc`:

``` python
# Select by position.
ser.iloc[-1]

# Select by label.
ser.loc[2]
```

    np.float64(2.0)

    np.float64(2.0)

For your convenience however, slicing with integers will allways be
positional:

``` python
# Give me the first rows.
ser_2[:2]
```

    a    0.0
    b    1.0
    dtype: float64

The jist is: Use `loc` and `iloc` whenever applicable.

#### Pittfalls with Chained Indexing

We’ve gotten to know the flexible selecting with `loc` and `iloc` by
now. The next logical step is often to assign new values to these
selection, which is another thing to wrap your head around first.

Whole rows and columns are relatively straight forward:

``` python
# Assign all rows of column "one" the value 1.
data.loc[:, "one"] = 1
data

# Assign all columns of the third row the value 5.
data.iloc[2] = 5
data

# Assign all columns of the row where
# the value in column "four" is larger than 5 the value 3.
data.loc[data["four"] > 5] = 3
data
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 1   | 0   | 0     | 0    |
| Colorado | 1   | 5   | 6     | 7    |
| Utah     | 1   | 9   | 10    | 11   |
| New York | 1   | 13  | 14    | 15   |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 1   | 0   | 0     | 0    |
| Colorado | 1   | 5   | 6     | 7    |
| Utah     | 5   | 5   | 5     | 5    |
| New York | 1   | 13  | 14    | 15   |

</div>

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 1   | 0   | 0     | 0    |
| Colorado | 3   | 3   | 3     | 3    |
| Utah     | 5   | 5   | 5     | 5    |
| New York | 3   | 3   | 3     | 3    |

</div>

The thing to keep in your mind when selecting a combination of rows and
columns is that when a call returns a subset, it will fail assing any
values given as it does not refer to the original object anymore:

``` python
# This is subsetting/creating a new Series
data.loc[data.three == 5]["three"] = 6
```

    /tmp/ipykernel_57860/2163647394.py:2: ChainedAssignmentError: A value is being set on a copy of a DataFrame or Series through chained assignment.
    Such chained assignment never works to update the original DataFrame or Series, because the intermediate object on which we are setting values always behaves as a copy (due to Copy-on-Write).

    Try using '.loc[row_indexer, col_indexer] = value' instead, to perform the assignment in a single step.

    See the documentation for a more detailed explanation: https://pandas.pydata.org/pandas-docs/stable/user_guide/copy_on_write.html#chained-assignment
      data.loc[data.three == 5]["three"] = 6

You even get a verbose error, explaining to you you that you should use
the row and column indexers in the same `loc` or `iloc` call, instead of
chaining them:

``` python
data.loc[data.three == 5, "three"] = 123
data
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }
&#10;    .dataframe tbody tr th {
        vertical-align: top;
    }
&#10;    .dataframe thead th {
        text-align: right;
    }
</style>

|          | one | two | three | four |
|----------|-----|-----|-------|------|
| Ohio     | 1   | 0   | 0     | 0    |
| Colorado | 3   | 3   | 3     | 3    |
| Utah     | 5   | 5   | 123   | 5    |
| New York | 3   | 3   | 3     | 3    |

</div>

## Arithmetic and Data Alignment
