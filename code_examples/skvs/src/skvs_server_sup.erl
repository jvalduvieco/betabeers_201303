-module(skvs_server_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	% Initialize ETS table and link to supervsor process, making resistant to gen_server crashes
	skvs_server:initialize(),
    supervisor:start_link(skvs_server_sup, []).

init(_Args) ->
    {ok, {{one_for_one, 1, 60},
          [{skvs_server, {skvs_server, start_link, []},
            permanent, brutal_kill, worker, [skvs_server]}]}}.