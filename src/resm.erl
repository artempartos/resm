-module(resm).
-export([start/0, stop/0]).
-export([allocate/1, deallocate/1, reset/0, list/0, list/1]).

start() ->
  {ok, _} = application:ensure_all_started(?MODULE).

stop() ->
  Apps = [sync, resm, ranch, cowboy, cowlib],
  [application:stop(App) || App <- Apps],
  ok.

allocate(User) ->
  gen_server:call(resource_server, {allocate, User}).

deallocate(Resource) ->
  gen_server:call(resource_server, {deallocate, Resource}).

reset() ->
  gen_server:call(resource_server, reset).

list() ->
  gen_server:call(resource_server, list).

list(User) ->
  gen_server:call(resource_server, {list, User}).
