-module(skvs_server_sup).
-behaviour(supervisor).

-export([start_link/0, start_in_shell/0 ]).
-export([init/1]).

start_link() ->
	% Initialize ETS table and link to supervsor process, making resistant to gen_server crashes
	skvs_server:initialize(),
    supervisor:start_link(skvs_server_sup, []).

start_in_shell() ->
    {ok, Pid} = start_link(),
    % Unlink the process from the shell
    unlink(Pid).

init(_Args) ->
    {ok, {{one_for_one, 1, 60},
          [{skvs_server, {skvs_server, start_link, []},
            permanent, brutal_kill, worker, [skvs_server]}]}}.