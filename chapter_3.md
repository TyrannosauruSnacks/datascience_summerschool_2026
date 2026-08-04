# Chapter 3
Max Arthur Hachemeister
2026-08-04

- [Prerequisites](#prerequisites)
- [3.1 Data Structures and Sequences](#31-data-structures-and-sequences)
  - [Tuple](#tuple)
    - [Unpacking Tuples](#unpacking-tuples)
  - [List](#list)
    - [Adding and Removing Elements](#adding-and-removing-elements)
    - [Concatenating and Combining
      Lists](#concatenating-and-combining-lists)
    - [Sorting](#sorting)
    - [Slicing](#slicing)
  - [Dictionary](#dictionary)
    - [Creating Dictionaries from
      Sequences](#creating-dictionaries-from-sequences)
    - [Default Values](#default-values)
    - [Valid Dictionary Key Types](#valid-dictionary-key-types)
  - [Set](#set)
  - [Built-In Sequence Functions](#built-in-sequence-functions)
    - [enumerate](#enumerate)
    - [sorted](#sorted)
    - [zip](#zip)
    - [Reversed](#reversed)
  - [List, Set, and Dictionary
    Comprehensions](#list-set-and-dictionary-comprehensions)
    - [Nested List Comprehensions](#nested-list-comprehensions)
- [3.2 Functions](#32-functions)
  - [Namespaces, Scope, and Local
    Functions](#namespaces-scope-and-local-functions)
  - [Returning Multiple Values](#returning-multiple-values)
  - [Functions are Objects](#functions-are-objects)
  - [Anonymous (Lambda) Functions](#anonymous-lambda-functions)
  - [Generators](#generators)
    - [Generator Expressions](#generator-expressions)
    - [itertools module](#itertools-module)
  - [Errors and Exception Handling](#errors-and-exception-handling)
  - [Files and the Operating System](#files-and-the-operating-system)
  - [Bytes and Unicodes with Files](#bytes-and-unicodes-with-files)

# Prerequisites

[Link to Chapter](https://wesmckinney.com/book/python-builtin)

# 3.1 Data Structures and Sequences

## Tuple

A tuple is somewhat of an *safer* object, as it’s *immutable*, meaning
it cannot be changed but only new versions can be copied from it. They
can be assinged with or without their values in parentheses:

``` python
tup = (4, 5, 6)
tup

tup = 4, 5, 6
tup
```

    (4, 5, 6)

    (4, 5, 6)

Any sequence or iterable object can be converted accordingly with
`tuple`:

``` python
tuple(range(11))

tuple("Lasagna")
```

    (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

    ('L', 'a', 's', 'a', 'g', 'n', 'a')

Elements of a tuple (but also other sequeces) can be accessed with `[]`.
Remember the zero-index, though:

``` python
tup = 1, 2, 3
tup[0]

sequence = range(11)
sequence[0]
```

    1

    0

Tuples can be nested (so they are like lists in R?):

> [!NOTE]
>
> This takes some getting used to. It’s like a pack of candy which holds
> smaller bags of candy which then hold the individual candies

This is a bag, containing two smaller bags that contain the individual
value:

``` python
bag = (4, 5, 6), (7, 8)
bag
```

    ((4, 5, 6), (7, 8))

So in a first step, I would only open the bag and hold the smaller bag
in my hand:

``` python
smaller_bag = bag[0]
smaller_bag
```

    (4, 5, 6)

And from that bag I can get a single candy:

``` python
candy = smaller_bag[0]
candy
```

    4

So now it get’s mushy. While a tuple itself is immutable, the objects it
stores still can be. So you cannot change the arrangement of the objects
in a tuple but the contents of individual objects you can.

Create a tuple with a string, a list, and a boolean:

``` python
tup = ("Lasagna", [1, 2], True)
```

Try to assing something new to tuple slot 2:

``` python
tup[1] = "something_new"
```

    TypeError: 'tuple' object does not support item assignment
    [31m---------------------------------------------------------------------------[39m
    [31mTypeError[39m                                 Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[8][39m[32m, line 1[39m
    [32m----> [39m[32m1[39m tup[[32m1[39m] = [33m"something_new"[39m

    [31mTypeError[39m: 'tuple' object does not support item assignment

Mutate the object of slot 2 of the tuple itself:

``` python
tup[1].append(3)
tup
```

    ('Lasagna', [1, 2, 3], True)

Tuples can be merged (concatenated) together with `+`:

``` python
("Lasagna", [1, 2, 3], True) + ("even more", 15) + (None, )
```

    ('Lasagna', [1, 2, 3], True, 'even more', 15, None)

And multiplying a tuple merges (concatenates) several copies of it:

``` python
("Lasagna", 1, True) * 3
```

    ('Lasagna', 1, True, 'Lasagna', 1, True, 'Lasagna', 1, True)

### Unpacking Tuples

I can *unpack* the elements of a tuple by giving tuple-like assingment
on the left side of `=` (the assing operator).

``` python
tup = (4, 5, 6)

a, c, b = tup

a; b; c
```

    4

    6

    5

But it then needs variables for all the tuple elements:

``` python
a, b = tup
```

    ValueError: too many values to unpack (expected 2, got 3)
    [31m---------------------------------------------------------------------------[39m
    [31mValueError[39m                                Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[13][39m[32m, line 1[39m
    [32m----> [39m[32m1[39m a, b = tup

    [31mValueError[39m: too many values to unpack (expected 2, got 3)

Also, nested tuples can be unpacked:

``` python
tup = 4, 5, (6, 7)

a, b, c = tup
c
```

    (6, 7)

Even down into the nesting:

``` python
a, b, (c, d) = tup

c; d
```

    6

    7

This works generally variables, and you can make multiple *unpacks* (or
reassigns) like so:

``` python
a, b = 1, 2

a
b
```

    1

    2

``` python
b, a = a, b

a
b
```

    2

    1

With a `*something` (usually `*_`) you can designate the “rest” of a
tuple to aviod assinging all elements when you just want some of those:

``` python
tup = 1, 2, 3, 4, 5

a, b, *_ = tup

a
b
_
```

    1

    2

    [3, 4, 5]

#### Tuple Methods

Tuples - as many Python objects - have methods attached to then
accessible with `tuple.method()`. `.count()` being useful for counting
occurences of a given value:

``` python
tup = 1, 2, 1, 1, 3, 4, 5, 1, 1

tup.count(1)
```

    5

## List

Lists are mutable, so their elements can be mutated without having to
copy an iteration of the object. But lists can be derived from tuples
with `list()`:

``` python
list_1 = [2, 3, 7, None]

tup = ("foo", "bar", "baz")

list_2 = list(tup)

list_2[0] = "Lasagna"

list_1[3] = "Lasagna"

list_1
list_2
```

    [2, 3, 7, 'Lasagna']

    ['Lasagna', 'bar', 'baz']

Lists and tuples can be, and are, used interchangeably in many code.

As shown in Chapter 2, `list` is also a nice way to *view* the result of
generator objects:

``` python
gen = range(11)

gen

list(gen)
```

    range(0, 11)

    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

### Adding and Removing Elements

Okay, the following methods all change the object in place. Now this
term makes sense to me. The object is altered permanently. (In R you
would have to explicitely assign to a new object.)

`append` adds an element to the end of the list:

``` python
list_2

list_2.append("Dosagna")

list_2
```

    ['Lasagna', 'bar', 'baz']

    ['Lasagna', 'bar', 'baz', 'Dosagna']

`insert` creates a new spot between elements of a list an places a new
one there:

``` python
list_2.insert(1, "Resagna")

list_2
```

    ['Lasagna', 'Resagna', 'bar', 'baz', 'Dosagna']

`pop` is the inverse of `insert`, as it removes an element and its space
in the list and also returns it:

``` python
list_2.pop(2)

list_2
```

    'bar'

    ['Lasagna', 'Resagna', 'baz', 'Dosagna']

`remove` works like `pop` but takes a value instead of index:

``` python
list_2.remove("baz")

list_2
```

    ['Lasagna', 'Resagna', 'Dosagna']

The `in` and `not in` operators check for the occurence or non-occurence
of a value in lists:

``` python
"Dosagna" in list_2

"Lasagna" not in list_2
```

    True

    False

### Concatenating and Combining Lists

Lists - just as tuples - can be concatenated with the `+` operator:

``` python
[4, None, "foo"] + [7, 8, (2, 3)]
```

    [4, None, 'foo', 7, 8, (2, 3)]

``` python
part_1 = [4, None, "foo"]
part_2 = [7, 8, (2, 3)]

part_1 + part_2
```

    [4, None, 'foo', 7, 8, (2, 3)]

Lists also have the `extend` method, which results also merges new
elements to a list, but in this case to an already existing one. This
safes some computations as an possibly already large list must not be
copied to a new merged object, as would be the case with the `+`
operator concatenation

This copies both lists and concatenates them into a new object, even
with the same variable assinged:

``` python
part_1 = part_1 + part_2
part_1
```

    [4, None, 'foo', 7, 8, (2, 3)]

This adds to an already existing object:

``` python
part_1 = [4, None, "foo"]

part_1.extend(part_2)
part_1
```

    [4, None, 'foo', 7, 8, (2, 3)]

### Sorting

The `sort` method mutates the list object in place (changes it
permanently):

``` python
a = [7, 2, 5, 1, 3]
a.sort()
a
```

    [1, 2, 3, 5, 7]

There are some practical options, most notably, the `key` option, with
which a function can be defined by which to transform each value before
comparing them. So you could sort strings by length instead of
alphabetically as follows:

``` python
b = ["otherwise","this", "how", "what", "Lasagna"]

b.sort(key = len)
b
```

    ['how', 'this', 'what', 'Lasagna', 'otherwise']

### Slicing

Parts of sequences can be direcly selected with putting a `:` (colon)
into the `[]` indexing operator:

``` python
seq = [3, 7, 5, 8, 0, 6, 7, 5]

seq[1:5]
```

    [7, 5, 8, 0]

Ah yeah, zero-index again, and also the stop index is not included in
the output. So whole parts of lists can be mutated with the slicing
operator like:

``` python
seq[0:3] = [1, 2, 3]

seq
```

    [1, 2, 3, 8, 0, 6, 7, 5]

When `start` or `stop` are omitted, “from the beginning of the sequence”
or “till the end of the sequence” is implied:

``` python
# From the first element till (exclusive) index 4.
seq[:4]

# From index 2 till (inclusive) the last element.
seq[2:]
```

    [1, 2, 3, 8]

    [3, 8, 0, 6, 7, 5]

Negative indices are counted from the last element backward, but the
slicing is still evalutated from `start` to (exclusive) `stop`:

``` python
seq[-4:-2]
```

    [0, 6]

If I want every i-th element there is the `::` (double colon) as a
`step` operator:

``` python
# Every 2nd element
seq[::2]
```

    [1, 3, 0, 7]

And reversing the order of the elements can be done with a negative step
argument:

``` python
seq[::-1]
```

    [5, 7, 6, 0, 8, 3, 2, 1]

## Dictionary

Most important built-in Python data structure (I don’t recall handling
these structures in R, but I know it from NIX).

A dict is described with `{}` (embrace). Its elements are *key-value*
pairs denoted by a `:` and separated with `,`.

``` python
empty_dict = {}
d1 = {"a": "some value", "b": [1, 2, 3, 4]}

d1
```

    {'a': 'some value', 'b': [1, 2, 3, 4]}

Now, just as with `list`, I can access, set, or insert elements either
by index or - in this case - the “value” of the *key*:

``` python
# Add an Elemend with the key 7 and the value "an integer".
d1[7] = "an integer"
d1

# Access the elememt with the "b" key.
d1["b"]
```

    {'a': 'some value', 'b': [1, 2, 3, 4], 7: 'an integer'}

    [1, 2, 3, 4]

I can also check the dictionary for occurence of keys (but probably not
values) with the `in` operator:

``` python
7 in d1
"some value" in d1
```

    True

    False

For deletion there are mainly two ways; either with the `del` operator
or with the `pop` method, where the former succeeds silently and the
latter returns the deleted element:

``` python
# Add an element with 5 as the key and "some value" as value.
d1[5] = "some value"
d1

# Add an element with "dummy" as the key and "another value" as value.
d1["dummy"] = "another value"
d1

# Delete the element with 5 as the key.
del d1[5]
d1

# Pop the element with "dummy" as the key and assing the output to the variable `ret`.
ret = d1.pop("dummy")
ret
d1
```

    {'a': 'some value', 'b': [1, 2, 3, 4], 7: 'an integer', 5: 'some value'}

    {'a': 'some value',
     'b': [1, 2, 3, 4],
     7: 'an integer',
     5: 'some value',
     'dummy': 'another value'}

    {'a': 'some value',
     'b': [1, 2, 3, 4],
     7: 'an integer',
     'dummy': 'another value'}

    'another value'

    {'a': 'some value', 'b': [1, 2, 3, 4], 7: 'an integer'}

Keys and values can be separately accessed for iteration with the `keys`
and `values` method respectively:

``` python
# Put all the keys in a list
list(d1.keys())

# Put all the values in a list
list(d1.values())
```

    ['a', 'b', 7]

    ['some value', [1, 2, 3, 4], 'an integer']

Additionaly, the `items` method puts all the elements of a dictionary
into a list with nested tuples:

``` python
d1
list(d1.items())
```

    {'a': 'some value', 'b': [1, 2, 3, 4], 7: 'an integer'}

    [('a', 'some value'), ('b', [1, 2, 3, 4]), (7, 'an integer')]

Dictionaries can be merged with the `update` method:

``` python
# Merge the dictionary {"b" : "foo", "c": 12} with d1
d1.update({"b": "foo", "c": 12})

d1
```

    {'a': 'some value', 'b': 'foo', 7: 'an integer', 'c': 12}

Beware though that, as `update` implies, if you merge an element that
matches an existing key, the old element gets mutated in place, which is
what happened with the `b` element in our case.

### Creating Dictionaries from Sequences

With the `dict` function any list of *2-tuples* can become a dictionary,
sparing you writing a for-loop:

``` python
# zip makes tuples from the input iterables
tuples = zip("abcde", range(5))
tuples

# Get a dictionary from the zip (tuples) element
mapping = dict(tuples)
mapping
```

    <zip at 0x7f945ad891c0>

    {'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4}

### Default Values

Okay, this is a tough part. There are for-loops and then methods as more
succint versions of those loops. Which means that these expressions are
used often. So I should make an effort to understant what is happening.
But it’s tough.

This expression says: “If the key exists give me its value otherwise
give me a default value (that I pre-defined)”:

    if key in some_dict:
        value = some_dict[key]
    else:
        value = default_value

And the `get` or `pop` method basically does the same:

    value = some_dict.get(key, default_value)

The *default* default value of `get` is `None`, but `pop` will “raise an
exception” (whatever that means).

Next, we have a for loop to categorize words by their firs letters.
Let’s see what I can make out of this:

``` python
# Create a list with words
words = ["apple", "bat", "bar", "basagna", "atom", "book"]

# Create an empty dictionary
by_letter = {}

# Make the for-loop
## For each element in words
for word in words:
    ## get the first letter and assign it to "letter"
    letter = word[0]
    ## Check if the letter is amongst the keys in "by_letter"
    ## If not, then the default is the key "letter" and its value an empty list
    ## and .append then means add the word to that list
    by_letter.setdefault(letter, []).append(word)

by_letter
```

    {'a': ['apple', 'atom'], 'b': ['bat', 'bar', 'basagna', 'book']}

Okay, what kinda got me was the stacked method
`by_letter.setdefault().append()`. I didn’t know that would be possible,
so had a hard time even noticing that. But loop logic in general is not
really intuitive…

And there is another function from a package that does this even more
conveniently:

``` python
# import the function defaultdict from the package collections
from collections import defaultdict

by_letter = defaultdict(list)
by_letter

by_letter["lasagna"[0]].append("lasagna")
by_letter
```

    defaultdict(list, {})

    defaultdict(list, {'l': ['lasagna']})

So it seems to be an important function to automatically order elements
to existing keys and to create keys if there are new key values coming
in. I guess for the grouping and sorting stuff.

### Valid Dictionary Key Types

Keys for dictionaries can only be Python objects that are *hashable*.
Python will throw you an error if that’s not the case. Lists are not
hashable, but you can convert them to a tuple, if you really wanted them
as a key.

## Set

*Sets* seem to be like vectors in R. You can create them with either the
`set` function, or with `{}` (embrace):

``` python
set([2, 2, 3, 7, 3, 7, 7, 9])

{2, 2, 3, 7, 3, 7, 7, 9}
```

    {2, 3, 7, 9}

    {2, 3, 7, 9}

Ah no, so a set only keeps the unique (distinct) values of its input.

Then there are some operators to handle sets. The `union` method, or `|`
operator, gives all the distinct values from the total of both sets, and
the `intersection` method, or `&` operator, gives only those distinct
values that both lists share. Like the `or` and `and` syntax for other
object types.

And there are many more operations for sets. Check the Help, or Chapter
3 Table 3.1 of the book.

So here it’s again about efficient computation. For sets there are
methods that replace the set on the *left side* instead of having to
create a whole new object. Keep that in mind when working with big
datasets. Basically ending other operators with `=`

``` python
a = set(range(5))
a
b = {3, 4, 5, 6, 7, 8}

# Make c an independent copy of the a object.
c = a.copy()

# Mutate c to the total distinct values of the sets b and c.
c |= b
c

# Make d an independent copy of the a object.
d = a.copy()

# Mutate d to the distinct values that the sets d and b share.
d &= b
d
```

    {0, 1, 2, 3, 4}

    {0, 1, 2, 3, 4, 5, 6, 7, 8}

    {3, 4}

## Built-In Sequence Functions

These are all nice to know, and used whenever possible.

### enumerate

Nice to keep track of the index of items in a sequence. So nice that it
has its own function for for-loop implementation. So you can prepend
this in a for-loop so that the index is being tracked for whatever the
rest of the loop does.

    for index, value in enumerate(collection):

### sorted

`sorted` takes any sequence and returns the elements in a sorted list.

``` python
sorted("lasagna, man!")

sorted([2, 9, 4, 7, 4, 6, 6, 0, 1])
```

    [' ', '!', ',', 'a', 'a', 'a', 'a', 'g', 'l', 'm', 'n', 'n', 's']

    [0, 1, 2, 4, 4, 6, 6, 7, 9]

### zip

`zip` merges any number of lists into a list of tuples. It has some
special heuristic about when to stop, if there are lists with different
number of elements:

``` python
seq1 = ["swag", "lasagna", "foo"]
seq2 = ["one", "two", "three", "four"]
seq3 = [1, 2, 3, 4, 5, 6, 7]

zipped = zip(seq1, seq2, seq3)

list(zipped)
```

    [('swag', 'one', 1), ('lasagna', 'two', 2), ('foo', 'three', 3)]

And this is an example to bring in `enumerate`:

``` python
for i, (a, b, c) in enumerate(zip(seq1, seq2, seq3)):
    print(f"{i}: {a}  \t{b}\t{c}")
```

    0: swag     one 1
    1: lasagna      two 2
    2: foo      three   3

### Reversed

`reversed` reverses the order of sequences:

``` python
list(reversed(range(10)))
```

    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

## List, Set, and Dictionary Comprehensions

Now it get’s fancy!

Python seems to have a lot of sytax implemented to avoid having to spell
out the for-loop sytax every time. For example, there is a syntax that
applies a function to each element of a sequence:

``` python
[expression for value in collection if condition]
```

So we could apply the method `upper` to all elements in a list of
strings that have more than two letters like so:

``` python
# Create the list of strings.
strings = ["a", "as", "Lasagna", "Caramel", "breath", "you"]

# According to the syntax above it goes.
[x.upper() for x in strings if len(x) > 2]
```

    ['LASAGNA', 'CARAMEL', 'BREATH', 'YOU']

Ah, but the only the applicable strings are returned, so we filter out
the short ones. Probably a way to concatenate, or append them back
together…

The same sytax goes for sets and dictionaries, just with `{}` for the
`[]`.

An alternative to this is the `map` function with the syntax
`map(function(), sequence_object)`. If we wanted to get the length for
each string we could go:

``` python
list(map(len, strings))
```

    [1, 2, 7, 7, 6, 3]

And something again with `enumerate`…

### Nested List Comprehensions

Hmm, so for nested lists its quite a brain exercise because the sytax
makes it possible, but it’s hard to keep track what part refers to which
level.

Let’s see. I make a list of tuples first:

``` python
tuple_list = [(1, 2, 3), (4, 5, 6), (7, 8, 9)]
```

Now, let’s refer to the tuples as tup, and each element of the tuple as
num. Then the expression for just having all the nums in a list would
be:

``` python
num_list = [num for tup in tuple_list for num in tup]
num_list
```

    [1, 2, 3, 4, 5, 6, 7, 8, 9]

This reads a bit backwards. So for each tup in tuple_list and each num
within a tup return the num.

I’m getting a little bit of traction I guess…

# 3.2 Functions

Spare repetitive code writing by making it a function.

`def` starts the declaration of a function, after which the function
name and its arguments are defined, and then after a `:` the *function
body* - the thing it’s supposed to do - follows. Like so:

``` python
def function_name(argument_a, argument_b):
    return argument_a + argument_b
```

`return` is important, as only then the actual results of the
computations are put out. The default behaviour otherwise is `None` as
output (silent success).

This function `return`s the result:

``` python
def my_function(a, b):
    return a + b

result = my_function(1, 2)
result
```

    3

This one does not:

``` python
def my_function_silent(a, b,):
    a + b

result = my_function_silent("I ", "succeeded")
print(result)
```

    None

Arguments can have default values assinged with `=` to them and then are
referred to as *keyword arguments*, while the ones without default
values are called *positional*.

``` python
def my_function2(
    x,  # This is positional;
    y,  # This as well
    z=1.5,  # And this is a keyword argument.
):
    if z > 1:  # If z is larger than 1 (the implicit default),
        return z * (x + y)  # Multiply it with the sum of x and y.
    else:  # If notn
        return z / (x + y)  # Divide it by the sum of x and y.
```

Some remarks about the order in which to call positional and keyword
arguments.

## Namespaces, Scope, and Local Functions

So there is a distinction between arguments and variables in functions.
Just because you defined an argument does not make it a variable. This
is sometimes confusing for me, when reading functions and wondering why
and where an `a` might have come from, when the arguments were just
`x, y, z`, or so. Well, at least with the typst language that confused
me.

But keep in mind that variables created in functions are destroyed at
the end unless you say to `return` them. Also the other way around, a
function might use a variable outside of its scope, but only if it
already exists.

Here, we create the variable as part of the function:

``` python
def func():
    a = []
    for i in range(5):
        a.append(i)
```

But get nothing out of it because its an interal variable and there is
no `return`:

``` python
result = func()
print(result)
```

    None

If we write the function to just append to *any* variable named `a`:

``` python
def func():
    # We leave out the internal variable `a`
    for i in range(5):
        a.append(i)
```

It will fail, if `a` does not already exist:

``` python
func()
```

    AttributeError: 'str' object has no attribute 'append'
    [31m---------------------------------------------------------------------------[39m
    [31mAttributeError[39m                            Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[66][39m[32m, line 1[39m
    [32m----> [39m[32m1[39m func()

    [36mCell[39m[36m [39m[32mIn[65][39m[32m, line 4[39m, in [36mfunc[39m[34m()[39m
    [32m      1[39m [38;5;28;01mdef[39;00m func():
    [32m      2[39m     [38;5;66;03m# We leave out the internal variable `a`[39;00m
    [32m      3[39m     [38;5;28;01mfor[39;00m i [38;5;28;01min[39;00m range([32m5[39m):
    [32m----> [39m[32m4[39m         a.append(i)

    [31mAttributeError[39m: 'str' object has no attribute 'append'

There are two ways to go about that. Either assign the variable in
golbal scope beforehand:

``` python
a = []
func()
a
```

    [0, 1, 2, 3, 4]

Or explictily tell the function to assging its internal variable in
`global` scope:

``` python
def func():
    global b
    b = []
    for i in range(5):
        b.append(i)

func()
b
```

    [0, 1, 2, 3, 4]

## Returning Multiple Values

You can return multiple values and assign them directly to separate
variables by separating the variables with `,` on the left side of the
assignment. This is slick if you think about it for ar moment:

``` python
# Define the function to `return` a, b, and c individually.
def f():
    a = 5
    b = 6
    c = 7
    return a, b, c


# Assign three different variables to the output of the function.
x, y, z = f()

# Show the results.
x
y
z
```

    5

    6

    7

## Functions are Objects

The fact that functions in Python are objects means they can be accesed
by their variable and as such implemented as parts of a more complex
function. This is handy when multiple “things” should be done to the
same data.

Let’s make an example list of strings that you would find in the wild:

``` python
states = [
    "   Alabama ", "Georgia!", "Georgia", "georgia",
    "FlOrIda", "south   carolina##", "West virginia?"
    ]
```

Now we want to do the following things: strip whitespaces, remove
punctuation symbols, and standardize the capitalization. The first
somewhat more intuitive way woul be to write a function with all the
explict subfunctions:

``` python
# We import a built-in package for string methods.
import re

def clean_strings(strings):
    # Initiate a list object for the results.
    result = []
    # For every element in the `strings` object
    # do the following.
    for value in strings:
        # Remove leading/trailing whitespace
        value = value.strip()
        # Replace all punctuation with "nothing".
        value = re.sub("[?!#]", "", value)
        # Convert to title case.
        value = value.title()
        # Append the element to the list object.
        result.append(value)
    # And make the result accessible.
    return result
```

If we run this now we get the following:

``` python
clean_strings(states)
```

    ['Alabama',
     'Georgia',
     'Georgia',
     'Georgia',
     'Florida',
     'South   Carolina',
     'West Virginia']

So far so good. We will accept the double whitespace in “South Carolina”
for now.

Another more elegant and flexible way would be to write a function that
accepts a list of subfunctions, so that you would just need to change
the list of the subfunctions instead of the whole function, when you
wanted to change or add some steps:

``` python
# Convert the `sub` method into a function
# so that it can be called with "func(value)".
def remove_punctuation(value):
    return re.sub("[?!#]", "", value)

# Create a list with subfunctions we want to apply.
clean_ops = [str.strip, remove_punctuation, str.title]

# Create the function that applies this list.
def clean_strings(strings, ops):
    # Initiate a list object for the results.
    result = []
    # For each element of the `strings` object
    # do the following:
    for value in strings:
        # Take each element of the `ops` object,
        for func in ops:
            # apply it to `value`,
            value = func(value)
        # then append it to the `result` list.
        result.append(value)
    # Finally, make the result accessible.
    return result
```

Now, let’s call the function:

``` python
# Now we provide both the list of strings
# and the list of operations (sub-functions).
clean_strings(states, clean_ops)
```

    ['Alabama',
     'Georgia',
     'Georgia',
     'Georgia',
     'Florida',
     'South   Carolina',
     'West Virginia']

Lastly, there is also the `map` function (I know this from R) which
applies a single function to each element of a sequence, which is
sometimes faster than to write the whole for expression.

``` python
# Apply `remove_punctuation` to each element of `states`
# and save it as a new object.
removed_punctuation = map(remove_punctuation, states)

# Show the result as a list.
list(removed_punctuation)
```

    ['   Alabama ',
     'Georgia',
     'Georgia',
     'georgia',
     'FlOrIda',
     'south   carolina',
     'West virginia']

This is basically like the list comprehension from before, minus the
filter part.

## Anonymous (Lambda) Functions

*Anonymous* or *lambda* functions are simple functions that will not be
assingned an addressible variable. So they are meant for “single” use as
a sub-function.

For example, if we thougth the `clean_strings` from above would just be
a one-of action, we could write:

``` python
map(
    lambda x: re.sub("[?!#]", "", x),
    states
    )
```

    <map at 0x7f945ad8e680>

This would have spared us defining the whole `clean_strings` function,
and calling it again with `maps`. So it’s a convenient way to do things.

## Generators

Generators are iterable objects just as lists, sets, or dictionaries.
Their unique feature is that they only produce data when actually asked
for, while the data the other sequences always exists before even being
used.

> [!NOTE]
>
> I think this is a more elegant way of what we did before with
> initiating an empty list object in a function and then appending to
> it.

To have a function produce an generator object, use `yield` instead of
`return`. Let’s create a function that `yields` a given number of
squares:

``` python
def squares(n = 10):
    print(f"Generating squares from 1 to {n ** 2}")
    # Here we set n + 1 as upper limit because its value is excluded
    # from the results.
    for i in range(1, n + 1):
        yield i ** 2
```

So when we run this function, it is not yet exected. So it’s basically a
promise to do the thing when its output is actually neede somewhere
else.

``` python
# Run the function an save the bind the result to the 
# `gen` variable.
gen = squares(12)

# Show me
gen
```

    <generator object squares at 0x7f9421533ca0>

Only when I request the elements from that generator in another
statement it will compute the `squares` function aswell:

``` python
for x in gen:
    print(
        x,
        # Add this so the numbers are in one line
        # instead of one line each
        end = " "
        )
```

    Generating squares from 1 to 144
    1 4 9 16 25 36 49 64 81 100 121 144 

> [!NOTE]
>
> Weirdly though, once the `gen` object has been evaluated the same
> expression with it inside does not generate ouput the next time. Only
> if I newly create the `gen` object. Hm…

### Generator Expressions

Like with the other sequences, `generator`s can also be called directly
at assignment to a variable with the corresponding sorrounding
characters. This time with `()` (parentheses) - as opposed to `[]` for
lists, or `{}` for sets or dictionaries.

``` python
# Make a generator that
# squares all the numbers from 0 to 99.
gen = (x ** 2 for x in range(100))

# For each elemend in the `gen` object
# print it and add a space at its end.
for i in gen:
    print(i, end = " ")
```

    0 1 4 9 16 25 36 49 64 81 100 121 144 169 196 225 256 289 324 361 400 441 484 529 576 625 676 729 784 841 900 961 1024 1089 1156 1225 1296 1369 1444 1521 1600 1681 1764 1849 1936 2025 2116 2209 2304 2401 2500 2601 2704 2809 2916 3025 3136 3249 3364 3481 3600 3721 3844 3969 4096 4225 4356 4489 4624 4761 4900 5041 5184 5329 5476 5625 5776 5929 6084 6241 6400 6561 6724 6889 7056 7225 7396 7569 7744 7921 8100 8281 8464 8649 8836 9025 9216 9409 9604 9801 

We omit the flexibily to change the values for `n` in range, but if we
know that we want just a paricular value this is just less code to
write.

### itertools module

This built-in library gives you convenience functions for often needed
generators.

For example, you could use `itertools.groupby` to group the elements of
a list according to a function that you give:

``` python
import itertools

# Define the grouping function.
## Give me the first letter of the string.
def first_letter(x):
    return x[0]

# Create a list to test with.
names = ["Asagna", "Alfried", "Ragna", "Erich", "Wilma", "Agatha", "Max"]

# Make me a generator for the strings
# grouped by their first letters.
names_grouped = itertools.groupby(names, first_letter)
## We could also write this with an anonimous function.

# We can to the comma thing here because the grouping
# generator is stored as key, value pairs.
for group, members in names_grouped:
    print(group, list(members))
```

    A ['Asagna', 'Alfried']
    R ['Ragna']
    E ['Erich']
    W ['Wilma']
    A ['Agatha']
    M ['Max']

> [!NOTE]
>
> Weird, It does not group the two names with the “A” together. But it
> also fails that in the book… Edit: `itertools.groupby` only groups
> elements of the same key if they come directly after one another. So
> only those “A” strings next to each other are grouped to “A”, and a
> single “A” string somewhere else gets his own “A” group

So so get this as intended we need to sort first:

``` python
# This needs more than one line.
def group_by_letters(strings, index = 0):
    return itertools.groupby(sorted(strings), lambda x: x[index])
    

names_grouped = group_by_letters(names)

for i, j in names_grouped:
    print(i, list(j))
```

    A ['Agatha', 'Alfried', 'Asagna']
    E ['Erich']
    M ['Max']
    R ['Ragna']
    W ['Wilma']

## Errors and Exception Handling

The concept of *failing gracefully* is introduced. This means that a
script should react to *errors* and *exceptions* with pragmatic
alternatives whenever possible instead of stopping outright.

`float` just fails:

``` python
float("1.2345")

float("something")
```

    1.2345

    ValueError: could not convert string to float: 'something'
    [31m---------------------------------------------------------------------------[39m
    [31mValueError[39m                                Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[83][39m[32m, line 3[39m
    [32m      1[39m float([33m"1.2345"[39m)
    [32m      2[39m 
    [32m----> [39m[32m3[39m float([33m"something"[39m)

    [31mValueError[39m: could not convert string to float: 'something'

Take the opportunity to read the error message as to get a sense for
what they refer to and how they express it then.

To add some grace we can use a `try`/`except` block:

``` python
def attempt_float(x):
    # Try to run `float`,
    try:
        return float(x)
    # if it gives an exception
    except:
        # just return `x`.
        return x
```

So now I will get back the input as is when it couldn’t convert it to a
floating point:

``` python
attempt_float("something")
```

    'something'

Now, `float` can throw some other errors:

``` python
float((1, 2))
```

    TypeError: float() argument must be a string or a real number, not 'tuple'
    [31m---------------------------------------------------------------------------[39m
    [31mTypeError[39m                                 Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[86][39m[32m, line 1[39m
    [32m----> [39m[32m1[39m float(([32m1[39m, [32m2[39m))

    [31mTypeError[39m: float() argument must be a string or a real number, not 'tuple'

So this is a `TypeError`, meaning the object type given is not not
approriate for the `float`. This is a relevant error, and we want the
user to be aware of that. Hence, we need to make a distinction between
this and the `ValueError`. This is possible within the `except` part:

``` python
def attempt_float(x):
    try:
        return float(x)
    # If there is a `ValueError`
    except ValueError:
        # just return the input.
        return x
```

This now gives the following:

``` python
attempt_float((1, 2))
```

    TypeError: float() argument must be a string or a real number, not 'tuple'
    [31m---------------------------------------------------------------------------[39m
    [31mTypeError[39m                                 Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[88][39m[32m, line 1[39m
    [32m----> [39m[32m1[39m attempt_float(([32m1[39m, [32m2[39m))

    [36mCell[39m[36m [39m[32mIn[87][39m[32m, line 5[39m, in [36mattempt_float[39m[34m(x)[39m
    [32m      1[39m [38;5;28;01mdef[39;00m attempt_float(x):
    [32m      2[39m     [38;5;28;01mtry[39;00m:
    [32m      3[39m         [38;5;28;01mreturn[39;00m float(x)
    [32m      4[39m     [38;5;66;03m# If there is a `ValueError`[39;00m
    [32m----> [39m[32m5[39m     [38;5;28;01mexcept[39;00m ValueError:
    [32m      6[39m         [38;5;66;03m# just return the input.[39;00m
    [32m      7[39m         [38;5;28;01mreturn[39;00m x

    [31mTypeError[39m: float() argument must be a string or a real number, not 'tuple'

Sometimes we want parts of the function to be executed regardless. We
can define this with `finally`:

``` python
def attempt_float(x):
    try:
        return float(x)
    except ValueError:
        return x
    finally:
        print("Lasagna, regardless!")

attempt_float((1, 2))
```

    Lasagna, regardless!

    TypeError: float() argument must be a string or a real number, not 'tuple'
    [31m---------------------------------------------------------------------------[39m
    [31mTypeError[39m                                 Traceback (most recent call last)
    [36mCell[39m[36m [39m[32mIn[89][39m[32m, line 9[39m
    [32m      5[39m         [38;5;28;01mreturn[39;00m x
    [32m      6[39m     [38;5;28;01mfinally[39;00m:
    [32m      7[39m         print([33m"Lasagna, regardless!"[39m)
    [32m      8[39m 
    [32m----> [39m[32m9[39m attempt_float(([32m1[39m, [32m2[39m))

    [36mCell[39m[36m [39m[32mIn[89][39m[32m, line 7[39m, in [36mattempt_float[39m[34m(x)[39m
    [32m      3[39m         [38;5;28;01mreturn[39;00m float(x)
    [32m      4[39m     [38;5;28;01mexcept[39;00m ValueError:
    [32m      5[39m         [38;5;28;01mreturn[39;00m x
    [32m      6[39m     [38;5;28;01mfinally[39;00m:
    [32m----> [39m[32m7[39m         print([33m"Lasagna, regardless!"[39m)

    [31mTypeError[39m: float() argument must be a string or a real number, not 'tuple'

With `else` you can also define what happens should the `except` part
not have happened. Note the difference to `finally` which is not
conditional on \`except.

So we could define success messages:

``` python
def attempt_float(x):
    try:
        return float(x)
    except ValueError:
        print("Failed elegantly.\n")
        return x
    else:
        print("Succeeded\n")
    finally:
        print("Lasagna, regardless!\n")


attempt_float("the_thing")
```

    Failed elegantly.

    Lasagna, regardless!

    'the_thing'

## Files and the Operating System

Access files:

``` python
# It's often more practical assign an
# individual variable for each filepath
path = "examples/segismundo.txt"

f = open(path, encoding = "utf-8")
```

Now the file is *open* in the session, meaning its data is in the
memory. We can now read it.

> [!NOTE]
>
> This is quite complicated, but probably sensible when you just want
> certain parts of a text file and then *close* it again to save memory.
> The whole python shebang is trying to make a point about being
> efficient.

``` python
for line in f:
    print(line)
```

    Sueña el rico en su riqueza,

    que más cuidados le ofrece;



    sueña el pobre que padece

    su miseria y su pobreza;



    sueña el que a medrar empieza,

    sueña el que afana y pretende,

    sueña el que agravia y ofende,



    y en el mundo, en conclusión,

    todos sueñan lo que son,

    aunque ninguno lo entiende.

We can also `rtrip` the empty lines with a *list comprehension*:

``` python
lines = [x.rstrip() for x in open(path, encoding = "utf-8")]

lines
```

    ['Sueña el rico en su riqueza,',
     'que más cuidados le ofrece;',
     '',
     'sueña el pobre que padece',
     'su miseria y su pobreza;',
     '',
     'sueña el que a medrar empieza,',
     'sueña el que afana y pretende,',
     'sueña el que agravia y ofende,',
     '',
     'y en el mundo, en conclusión,',
     'todos sueñan lo que son,',
     'aunque ninguno lo entiende.',
     '']

> [!NOTE]
>
> Using `f` direclty does not work because the *list comprehension*
> cannot access the objects in global scope.

Okay, and now we need to remember to `close` the file to save some
resources:

``` python
f.close()
```

To automate this so you spare the remembering, you can use the `with`
statement in an expression:

``` python
with open(path, encoding = "utf-8") as f:
    # Now `f` works because we assinged it in local scope.
    lines = [x.rstrip() for x in f]
```

Ah, and it even states it at the end.

There are other `modes` for the `open` function. For example, when you
want to create a new file you would set the `mode` to `"w"` or-the safer
alternative-`"x"`.

The most common methods for readable files are `read`, `seek`, and
`tell`. `read` returns a given number of characters:

``` python
# Have to reassing `f`, because we assinged it in
# the expression above.
f = open(path, encoding = "utf-8")

# Give me the first 9 (from 0 to 9[exclusive])characters.
f.read(10)
```

    'Sueña el r'

> [!NOTE]
>
> There was also a point made about the difference between opening the
> file regularly and in binary, but I will omit that here.

If you call `read` it advances a marker to the position till the file
was read. `tell` returns the current position of that marker:

``` python
f.tell()
```

    11

`seek` manually sets the pointer to the given index. We will use it to
reset the pointer to the beginning of the file for the following
elaborations:

``` python
f.seek(0)
```

    0

Notice that `tell` returned 11 even though we `read` only until 10. This
is because it takes actally 10 characters to encode the given string-one
extra for the ñ. You can see this if you open the file in `rb` (read
binary) mode:

``` python
f_binary = open(path, mode="rb")

# Compare them
f_binary.read(10)
f.read(10)
```

    b'Sue\xc3\xb1a el '

    'Sueña el r'

And-again-remember to `close` the files (as we did not make use of the
`with` statement):

``` python
f.close()
f_binary.close()
```

> [!NOTE]
>
> Omitted how to write to a text file.

## Bytes and Unicodes with Files

> [!NOTE]
>
> Omitted about Bytes and Unicodes and the implicatione and possible
> `Errors` induced from the difference between unicode and ASCII
> characters.
