; -- Mode: Markdown; -- ; vim: filetype=markdown tw=76 expandtab shiftwidth=4 tabstop=4

[Read edoc documentation](https://github.com/freeakk/ux/master/doc/README.md)
[License LGPLv3](http://http://www.gnu.org/licenses/lgpl-3.0.html)

This library contains helpful functions.

ux_string.erl: String Functions for lists of Unicode characters.
================================================================

This library provides functions for operations with
[UNIDATA](http://www.ksu.ru/eng/departments/ktk/test/perl/lib/unicode/UCDFF301.html).
UNIDATA contains data about Unicode characters.

Functions for working with Unicode Normal Forms (UNF)
-----------------------------------------------------
* to_nfc/1
* to_nfd/1
* to_nfkd/1
* to_nfkc/1
* is_nfc/1
* is_nfd/1
* is_nfkc/1
* is_nfkd/1

Functions from stdlib for Unicode strings
-----------------------------------------
* to_lower/1
* to_upper/1

Functions for processing strings as groups of graphemes
-------------------------------------------------------
Grapheme is letter with its modifiers.
* length/1
* reverse/1
* first/2
* last/2

"PHP-style" string functions
----------------------------
* explode/2,3
* html_special_chars/1 (htmlspecialchars in php)
* strip_tags/1,2

Examples
--------
Code:

```erlang
ux_string:explode(["==", "++", "|"], "+++-+=|==|==|=+-+++").
```

Result:

```
[[],"+-+=",[],[],[],[],"=+-","+"]
```

Code:

```erlang
ux_string:strip_tags("<b>bold text</b>").
```

Result:

```
"bold text"
```

Code:

```erlang
Str = "Erlang created the field of telephone
networks analysis. His early work in scrutinizing the use of local, exchange
and trunk telephone line usage in a small community, to understand the
theoretical requirements of an efficient network led to the creation of the
Erlang formula, which became a foundational element of present day
telecommunication network studies."
ux_string:explode_types([zs, lu], Str).
```

Result:

```
[[],"rlang","created","the","field","of","telephone",
 "networks","analysis.",[],"is","early","work","in",
 "scrutinizing","the","use","of","local,","exchange","and",
 "trunk","telephone","line","usage","in","a","small",
 [...]|...]
```

Code:

```erlang
ux_string:types(Str).
```

Result: 

```
[lu,ll,ll,ll,ll,ll,zs,ll,ll,ll,ll,ll,ll,ll,zs,ll,ll,ll,zs,
 ll,ll,ll,ll,ll,zs,ll,ll,zs,ll|...]
```
Where lu is Letter, Uppercase; ll is Letter, Lowercase. Read more about
types from description of ``ux_char:type/1``.

Code:

```erlang
ux_string:delete_types([ll], Str).
```

Result:

```
"E       . H        ,          ,                E ,           ."
```

ux_char.erl: Char Functions
===========================
Code:

```erlang
ux_char:type($ ).
```

Result:

```
zs
```
[List of types](http://www.ksu.ru/eng/departments/ktk/test/perl/lib/unicode/UCDFF301.html#General%20Category)
---------------
Normative Categories:
* lu  Letter, Uppercase
* ll  Letter, Lowercase
* lt  Letter, Titlecase
* mn  Mark, Non-Spacing
* mc  Mark, Spacing Combining
* me  Mark, Enclosing
* nd  Number, Decimal Digit
* nl  Number, Letter
* no  Number, Other
* zs  Separator, Space
* zl  Separator, Line
* zp  Separator, Paragraph
* cc  Other, Control
* cf  Other, Format
* cs  Other, Surrogate
* co  Other, Private Use
* cn  Other, Not Assigned (no characters in the file have this property)

Informative Categories:
* lm  Letter, Modifier
* lo  Letter, Other
* pc  Punctuation, Connector
* pd  Punctuation, Dash
* ps  Punctuation, Open
* pe  Punctuation, Close
* pi  Punctuation, Initial quote (may behave like Ps or Pe depending on usage)
* pf  Punctuation, Final quote (may behave like Ps or Pe depending on usage)
* po  Punctuation, Other
* sm  Symbol, Math
* sc  Symbol, Currency
* sk  Symbol, Modifier
* so  Symbol, Other

ux_col.erl: Unicode Collation Algorithm
=======================================
[Unicode Technical Standard #10](http://unicode.org/reports/tr10/)
* compare/2,3
* sort/1,2
* sort_key/1,2
* sort_array/1,2

Examples
--------
Code:

```erlang
ux_col:compare("a", "a").
ux_col:compare("a", "b").
ux_col:compare("c", "b").
```

Result:

```
equal
lower
greater
```


```erlang
Options = ux_col:get_options([ 
        {natural_sort, false}, 
        {strength, 3}, 
        {alternate, shifted} 
    ]),
InStrings = ["erlang", "esl", "nitrogen", "epm", "mochiweb", "rebar", "eunit"],
OutStrings = ux_col:sort(InStrings, Options),
[io:format("~ts~n", [S]) || S <- OutStrings],

SortKeys = [{Str, ux_col:sort_key(Str, Options)} || Str <- OutStrings],
[io:format("~ts ~w~n", [S, K]) || {S, K} <- SortKeys],

ok.
```

Result:

```
epm
erlang
esl
eunit
mochiweb
nitrogen
rebar
epm [5631,5961,5876,0,32,32,32,0,2,2,2]
erlang [5631,6000,5828,5539,5890,5700,0,32,32,32,32,32,32,0,2,2,2,2,2,2]
esl [5631,6054,5828,0,32,32,32,0,2,2,2]
eunit [5631,6121,5890,5760,6089,0,32,32,32,32,32,0,2,2,2,2,2]
mochiweb [5876,5924,5585,5735,5760,6180,5631,5561,0,32,32,32,32,32,32,32,32,0,2,2,2,2,2,2,2,2]
nitrogen [5890,5760,6089,6000,5924,5700,5631,5890,0,32,32,32,32,32,32,32,32,0,2,2,2,2,2,2,2,2]
rebar [6000,5631,5561,5539,6000,0,32,32,32,32,32,0,2,2,2,2,2]
ok
```


ux_unidata.erl
==============
Stores UNIDATA information. For internal using only.


