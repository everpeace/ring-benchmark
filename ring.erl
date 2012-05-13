-module(ring).
-export([init/2]).

% Ring Initialization
init(Main, N) ->
  io:format("constructing ~p nodes ring...~n", [N]),
  Root = root_start(0, Main),
  First = create_nodes(N-1, Root),
  Root ! {link, First},
  io:format("ring construction done.~n"),
  Root.

create_nodes(0, Root)-> Root;
create_nodes(1, Root)-> node_start(1, Root);
create_nodes(N, Root)->
  Next = create_nodes(N-1, Root),
  node_start(N, Next).

% Ordinal Node
node_start(Name, Next) ->
  spawn(fun() ->
        io:format("[~p(~p)] starting...~n", [Name, self()]),
          node(Name, Next)
        end).

node(Name, Next) ->
  receive
    kill ->
      forward_kill(Name, Next);
    Token ->
      forward_token(Name, Token, Next),
      node(Name, Next)
  end.

forward_token(Name, Token, Next) ->
      io:format("[~p(~p)] token \"~p\" received. forwading to [~p]~n", [Name, self(), Token, Next]),
      Next ! Token.

forward_kill(Name, Next)->
      io:format("[~p(~p)] exitting...~n", [Name, self()]),
      Next ! kill.

% Root node
root_start(Name, Main) ->
  spawn(fun() -> listen_tokens(Name, Main) end).

listen_tokens(Name, Main) ->
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
    {From, Token} when From=:=Main ->
       io:format("[~p(~p)] token \"~p\" is injected.~n", [Name, self(), Token]),
       Next ! Token,
       listen_tokens(Name, Main, Next);
    Token ->
      io:format("[~p(~p)] token \"~p\" reaches root.~n", [Name, self(), Token]),
       listen_tokens(Name, Main, Next)
  end.

