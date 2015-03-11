-module(resm).
-export([start/0, stop/0]).

start() ->
  {ok, _} = application:ensure_all_started(?MODULE).

stop() ->
  Apps = [sync, resm],
  [application:stop(App) || App <- Apps],
  ok.
