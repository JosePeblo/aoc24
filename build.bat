@echo off
set day=%1

if %day%==1 (
    rem lisp
    echo do this on wsl 'sbcl --script day01.lsp'

) else if %day%==2 (
    rem clojure
    echo clojure

) else if %day%==3 (
    rem haskell
    stack ghc -- -o builds/day03.exe day03.hs
    .\\builds\\day03.exe
    del day03.hi
    del day03.o

) else if %day%==4 (
    rem erlang
    echo erlang

) else if %day%==5 (
    rem perl
    echo perl

) else if %day%==6 (
    rem objective c
    echo objective c

) else if %day%==7 (
    rem rust
    echo rust

) else if %day%==8 (
    rem elixir
    echo elixir

) else if %day%==9 (
    rem swift
    echo swift

) else if %day%==10 (
    rem julia
    echo julia

) else if %day%==11 (
    rem ocaml
    echo ocaml

) else if %day%==12 (
    rem nim
    echo nim

) else if %day%==13 (
    rem zig
    echo zig

) else if %day%==14 (
    rem go
    echo go

) else if %day%==15 (
    rem php
    echo php

) else if %day%==16 (
    rem ruby
    echo ruby

) else if %day%==17 (
    rem scala
    echo scala

) else if %day%==18 (
    rem kotlin
    echo kotlin

) else if %day%==19 (
    rem c#
    echo c#

) else if %day%==20 (
    rem java
    echo java

) else if %day%==21 (
    rem c
    echo c

) else if %day%==22 (
    rem c++
    echo c++

) else if %day%==23 (
    rem python
    echo python

) else if %day%==24 (
    rem lua
    echo lua

) else if %day%==25 (
    rem javascript
    echo js

) else (
    echo Invalid option
)


