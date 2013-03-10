-module(cool_func).

-export([foo_bar_func/2]).

foo_bar_func (Foo, Bar) ->
	Result = Foo + Bar,
	{ok, Result}.