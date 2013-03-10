-module(skvs_app).

-behaviour(application).

% application
-export([start/2, stop/1]).

% application callbacks
start(_Type, _Args) ->
	skvs_server_sup:start_link().

stop(_Reason)->
	ok.