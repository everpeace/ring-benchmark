-module(ringbench).
-export([main/1, start/2]).

main(A)->
  [N , M | _Tails] = lists:map(fun(X)->list_to_integer(atom_to_list(X)) end, A),
  start(N, M),
  init:stop().

start(N, M) ->
  statistics(runtime),
  statistics(wall_clock),
  Main = self(),
  Root = ring:init(Main, N, M),
  io:format("[main(~p)] injecting the token \"~p\".~n", [self(), M]),
  Root ! {Main, token},
  receive
    ended -> void
  end,
  Root ! {Main, kill},
  {_, Time1} = statistics(runtime),
  {_, Time2} = statistics(wall_clock),
  U1 = Time1,
  U2 = Time2,
  io:format("[main(~p)] ring benchmark for ~p processes and ~p tokens = ~p (~p) milliseconds\n", [self(), N, M, U1, U2]).


