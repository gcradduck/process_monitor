-module(monitor).

-export([monitor/1]).

monitor(Parent) ->

    Parent ! {monitor, sleeping},
    timer:sleep(2000),

    JpsOutput = os:cmd("jps -v"),
    case is_running(JpsOutput) of
	true ->
	    Parent ! {running, moveon},
	    monitor(Parent);
	false ->
	    Parent ! {notrunning, start_interface},
	    start_interface(Parent),
	    monitor(Parent)
    end,
    monitor(Parent).

start_interface(Parent) ->
    JavaStart = fun() ->
			os:cmd("touch /home/gcradduck/Desktop/Test/" ++ lists:flatten(io_lib:format("~p", [calendar:datetime_to_gregorian_seconds(calendar:local_time())]))),
			os:cmd("cd /home/gcradduck/Desktop/Test;java -Ddpsinterface test sdfl")
		end,
    spawn(fun() -> JavaStart() end).

is_running([]) ->
    false;
is_running(ProcessList) ->
    Tokens = string:tokens(ProcessList, "\r\n"),
    
    F = fun(T) ->
		TU = string:to_upper(T),
		case string:str(TU, "DPSINTERFACE") of
		    0 ->
			false;
		    _ ->
			true
		end
	end,
    
    Matches = lists:filter(F, Tokens),
    
    case length(Matches) of
	0 ->
	    false;
	_ ->
	    true
    end.
