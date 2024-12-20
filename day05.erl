%% Aoc day 5 erlang
%% erl
%% c(day05), day05:main().

-module(day05).
-export([main/0]).
-import(lists, [map/2, foldl/3, reverse/1, nth/2, filter/2, all/2, dropwhile/2]).
-import(string, [trim/1, split/2, split/3]).

%% Get lines as string until the first empty line
getlines(Fd, Acc) ->
    case io:get_line(Fd, "") of
        eof -> 
            reverse(Acc);
        Line -> 
            Trimmed = string:trim(Line),
            case Trimmed of
                "" -> reverse(Acc);
                _ -> getlines(Fd, [trim(Line) | Acc])
            end
    end.

%% Take each rule "before|num" and turn it into a map of sets {num: (before...)}
reduceIntoMap(X, Map) ->
    Parts = map(fun list_to_integer/1, split(X, "|")),
    Key = nth(2, Parts),
    Value = nth(1, Parts),
    Set = maps:get(Key, Map, sets:new()),
    maps:put(Key, sets:add_element(Value, Set), Map).

%% Split a string by the comma and map each caracter to an int
stringArrToIntArr(Arr) ->
    map(fun(X) -> 
                map(fun(Y) -> 
                            list_to_integer(Y, 10) 
                    end, split(X, ",", all))
        end, Arr).

%% Process the input as a map of sets Conditions and a list of sequences
getProblemInput() ->
    case file:open("inputs/input05.txt", [read]) of
        {ok, File} ->
            Conditions = foldl(fun reduceIntoMap/2, #{}, getlines(File, [])),
            Sequences = stringArrToIntArr(getlines(File, [])),
            
            file:close(File),
            {Conditions, Sequences};
        {error, Reason} ->
            io:format("Failed to open file ~p~n", [Reason]),
            {#{}, []}
    end.

%% Get if one rule is not followed on a list
applyRules(X, Map) -> 
    not lists:any(
          fun({Key, Value}) -> 
                  Set = sets:from_list(
                          dropwhile(fun(Y) -> Key /= Y end, X)),
                  not sets:is_disjoint(Set, Value)
          end, maps:to_list(Map)).

%% Recursively iterate the list and fix the cases where a rule is not followed
sortSequences([], _) -> [];
sortSequences([Head | Tail], Map) ->
    case maps:get(Head, Map, nil) of
        nil -> [Head | sortSequences(Tail, Map)];
        Set ->
            {Ix, Found} = foldl(
                            fun(X, {Idx, nil}) ->
                                      case sets:is_element(X, Set) of
                                          true -> {Idx, true};
                                          false -> {Idx + 1, nil}
                                      end;
                               (_, {Idx, Acc}) -> {Idx + 1, Acc}
                            end, {1, nil}, Tail),
            case Found of
                nil -> [Head | sortSequences(Tail, Map)];
                true ->
                    {Left, Right} = lists:split(Ix, Tail),
                    sortSequences(Left ++ [Head] ++ Right, Map)
            end
    end.

%% Add all the middle items of lists (this asumes the list is of odd length
sumMidles(List) -> 
    lists:sum(map(fun(X) ->
                          Idx = ceil(length(X) /2),
                          nth(Idx, X)
                  end, List)).

main() -> 
    {Conditions, Sequences} = getProblemInput(),

    %% Part 1
    GoodPages = filter(fun(X) -> 
                               applyRules(X, Conditions) 
                       end, Sequences),
    MiddleSum = sumMidles(GoodPages),
    io:fwrite("Correct middle sum: ~w~n", [MiddleSum]),
    %% Part 2
    BadPages = filter(fun(X) -> 
                              not applyRules(X, Conditions)
                      end, Sequences),
    FixedPages = map(fun(X) -> sortSequences(X, Conditions) end, BadPages),
    FixedMiddleSum = sumMidles(FixedPages),
    io:fwrite("Fixed middle sum: ~w~n", [FixedMiddleSum]).

