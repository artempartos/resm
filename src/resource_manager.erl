-module(resource_manager).
-export([start/0, stop/0]).

start() ->
  {ok, _} = application:ensure_all_started(?MODULE).

stop() ->
  Apps = [sync, resource_manager],
  [application:stop(App) || App <- Apps],
  ok.
