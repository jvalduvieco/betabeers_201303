%% Copyright
-module(skvs_siege).

%% API
-export([do/1]).

do(0) ->
	ok;
do(Requests) ->
	Key = "keyname"++integer_to_list(Requests),
	skvs_server:set(Key,Requests),
	skvs_server:get(Key),
	do(Requests - 1).