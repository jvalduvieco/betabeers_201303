-module(math).

-export([factorial/1, area/1]).

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).

area({square, Side}) ->
  {ok, Side * Side};
area({circle, Radius}) ->
	% almost :-)
  {ok, 3 * Radius * Radius};
area({triangle, A, B, C}) ->
	S = (A + B + C)/2,
  {ok, math:sqrt(S*(S-A)*(S-B)*(S-C))};
area(Other) ->
	{error, invalid_object}.