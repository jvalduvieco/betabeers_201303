-module(skvs_server).
-behaviour(gen_server).

%% Client API
%%  -export([start_link/0, set/2, set_fire_and_forget/2, get/1, list/0, initialize/0]).
-export([start_link/0, set/2, set_fire_and_forget/2, get/1, initialize/0]).

%% gen_server behaviour interfce
-export([init/1, handle_call/3,handle_cast/2,terminate/2,code_change/3,handle_info/2, crash/0]).

%% Implementation

%% ---- CLIENT code ------------------------------------------------------
start_link() ->
	gen_server:start_link({global, skvs}, skvs_server, [], []).

initialize() ->
	% Create a new ETS table, called from supervisor
	ets:new(data_store,[set, public, named_table, {write_concurrency, true}]).

get(Key) ->
	gen_server:call({global,skvs}, {get, Key}).

set(Key,Value) ->
	gen_server:call({global,skvs}, {set, Key, Value}).

set_fire_and_forget(Key,Value) ->
	gen_server:cast({global,skvs}, {set, Key, Value}).

%% list() ->
%% 	Result = gen_server:call({global,skvs},{list}),
%% 	io:format("~p ~n",[Result]).

crash() ->
	gen_server:call(skvs, {crash, 4}).

%% --- SERVER code -------------------------------------------------------
%% gen_server behaviour interface
init(_Args) ->
	{ok,[]}.
terminate(_Reason, State) -> {ok,State}.
code_change(_OldVsn, State, _Extra) -> {ok, State}.
handle_info( _, State) -> {noreply,State}.

%% Client Callbacks on server
%% Sync calls, expects response
handle_call({set, Key, Value}, _From, State) ->
	{reply, set_value(Key,Value), State};
handle_call({get, Key}, _From, State) ->
	{reply, get_value(Key), State};

%% handle_call({list}, _From, State) ->
%% 	Result = case ets:match(data_store,'$1') of
%% 		[] ->
%% 			{error,not_found};
%% 		Results ->
%% 			{ok,lists:flatten(Results)}
%% 	end,
%% 	{reply, Result, State};

handle_call({crash,Value}, _From, State) ->
	3 = Value,
	{reply, none_i_am_dead, State}.

%% Async calls, do not expect response
handle_cast({set, Key, Value}, State) ->
	{noreply, set_value(Key,Value), State}.

%% Private functions
set_value(Key, Value) ->
	% Insert Key, Value into ETS.
	% Fail early
	{ok, Result} = case ets:insert(data_store,{Key,Value}) of
	true ->
		{ok, {Key,Value}};
	{error, Reason} ->
		{error, Reason}
	end,
	Result.

get_value(Key) ->
	% Search for the key in ETS.
	% Tweak result and fail early
	{ok, Result} = case ets:lookup(data_store,Key) of
		[{_,Value}] ->
			{ok, {Key,Value}};
		[] ->
			{ok, none};
		{error, Reason} ->
			{error, Reason}
	end,
	Result.
