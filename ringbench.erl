-module(ringbench).
-export([main/1, start/2]).

main(A)->
  [N , M | _Tails] = lists:map(fun(X)->list_to_integer(atom_to_list(X)) end, A),
  start(N, M),
  init:stop().

start(N, M) when (N < 1) orelse (M < 1) ->
  io:format("N and M must be larger than 1."),
  exit({nMustBePositive, mMustbePositive});
start(N, M) ->
  statistics(runtime),
  statistics(wall_clock),
  Main = self(),
  Root = ring:init(Main, N),
  io:format("[main(~p)] start injecting ~p tokens.~n", [self(), M]),
  inject_tokens(Root, M),
  receive
    ended -> void
  end,
  {_, Time1} = statistics(runtime),
  {_, Time2} = statistics(wall_clock),
  U1 = Time1,
  U2 = Time2,
  io:format("main[~p] ring benchmark for ~p processes and ~p tokens = ~p (~p) milliseconds\n", [self(), N, M, U1, U2]).

inject_tokens(Root, 0) -> Root ! {self(), kill};
inject_tokens(Root, M) ->
  Root ! {self(), M},
  inject_tokens(Root, M-1).

