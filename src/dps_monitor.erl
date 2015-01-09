-module(dps_monitor).

-behaviour(gen_server).

-export([
	 start_link/0
	]).

-export([init/1,
	 handle_info/2,
	 terminate/2]).

start_link() ->
    gen_server:start(?MODULE, [], []).

%%%-------------------------
%%% gen_server Callbacks
%%%-------------------------



init([]) ->
    spawn_link(monitor, monitor, [self()]),
    {ok, []}.

handle_info(Info, State) ->
    io:format("~p handle_info received Info: ~p~n", [?MODULE, Info]),
    {noreply, State}.


terminate(Reason, _State) ->
    {stop, {Reason, iShouldNeverDie_PleaseRestart}}.


