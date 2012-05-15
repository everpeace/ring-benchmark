-module(ring).
-export([init/3]).

% Ring Initialization
init(_, N, M) when N < 1 orelse M < 1->
  io:format("N and M must be larger than 1."),
  exit({nMustBePositive, mMustBePositive});
init(Main, N, M) ->
  io:format("[main(~p)] constructing ~p nodes ring...~n", [self(), N]),
  Root = root_start(0, Main, M),
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
root_start(Name, Main, M) ->
  spawn(fun() ->
          io:format("[~p(~p)] starting...~n", [Name, self()]),
          wait_for_link(Name, Main, M)
        end).

wait_for_link(Name, Main, M) ->
  receive
    {link, Next} ->
      listen_tokens(Name, Main, Next, M)
  end.

listen_tokens(Name, Main, Next, M) ->
  receive
    % interfaces with main process.
    {Main, kill} ->
      Next ! kill,
      listen_tokens(Name, Main, Next, M);
    {Main, Token} ->
       io:format("[~p(~p)] token \"~p\" is injected from main. the token starts rounding in the ring.~n", [Name, self(), Token]),
       Next ! {0, Token},
       listen_tokens(Name, Main, Next, M);
    % rounding the token.
    {I, Token} when I =:= M-1 ->
      io:format("[~p(~p)] token \"~p\" reaches root ~p times.~n", [Name, self(), Token, M]),
      io:format("[~p(~p)] report the finish of benchmark to main(~p)~n", [Name, self(), Main]),
      Main ! ended,
      listen_tokens(Name, Main, Next, M);
    {I, Token} ->
      io:format("[~p(~p)] token \"~p\" reaches root ~p times.~n", [Name, self(), Token, I+1]),
      Next ! {I+1, Token},
      listen_tokens(Name, Main, Next, M);
    % kill self.
    kill ->
      io:format("[~p(~p)] exitting... \n", [Name, self()])
  end.

