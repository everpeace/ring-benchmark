-module(ring).
-export([init/2]).

% Ring Initialization
init(_, N) when N < 1 ->
  exit(nMustBePositive);
init(Main, N) ->
  io:format("[main(~p)] constructing ~p nodes ring...~n", [self(), N]),
  Root = root_start(0, Main),
  First = create_nodes(1, N-1, Root),
  Root ! {link, First},
  Root.

create_nodes(_, 0, Root)-> Root;
create_nodes(N, N, Root)->
  Node = node_start(N),
  Node ! {link, Root},
  Node;
create_nodes(I, N, Root)->
  Node = node_start(I),
  Next = create_nodes(I+1, N, Root),
  Node ! {link, Next},
  Node.

% Ordinal Node
node_start(Name) ->
  spawn(fun() ->
          io:format("[~p(~p)] starting...~n", [Name, self()]),
          wait_for_link(Name)
        end).

wait_for_link(Name) ->
  receive
    {link, Next} ->
      listen_tokens(Name, Next)
  end.

listen_tokens(Name, Next) ->
  receive
    kill ->
      forward_kill(Name, Next);
    Token ->
      forward_token(Name, Token, Next),
      listen_tokens(Name, Next)
  end.

forward_token(Name, Token, Next) ->
      io:format("[~p(~p)] token \"~p\" received. forwading to ~p~n", [Name, self(), Token, Next]),
      Next ! Token.

forward_kill(Name, Next)->
      io:format("[~p(~p)] exitting...~n", [Name, self()]),
      Next ! kill.

% Root node
root_start(Name, Main) ->
  spawn(fun() ->
          io:format("[~p(~p)] starting...~n", [Name, self()]),
          wait_for_link(Name, Main)
        end).

wait_for_link(Name, Main) ->
  receive
    {link, Next} ->
      listen_tokens(Name, Main, Next)
  end.

listen_tokens(Name, Main, Next) ->
  receive
    kill ->
      io:format("[~p(~p)] exitting... \n", [Name, self()]),
      io:format("[~p(~p)] report the finish of benchmark to main(~p)~n", [Name, self(), Main]),
      Main ! ended;
    {Main, Token} ->
       io:format("[~p(~p)] token \"~p\" is injected from main. forward to ~p.~n", [Name, self(), Token, Next]),
       Next ! Token,
       listen_tokens(Name, Main, Next);
    Token ->
      io:format("[~p(~p)] token \"~p\" reaches root.~n", [Name, self(), Token]),
       listen_tokens(Name, Main, Next)
  end.

