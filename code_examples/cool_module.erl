-module(cool_module).

-export([sum/2]).

sum (Foo, Bar) ->
	Result = Foo + Bar,
	{ok, Result}.