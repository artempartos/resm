-module(resm_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, start_cowboy/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  ok, _ = start_cowboy(),
  ok, _ = resm_sup:start_link().

stop(_State) ->
  ok.

start_cowboy() ->
  Dispatch = cowboy_router:compile([
		{'_', [
			{"/allocate/:user", allocate_handler, []},
			{"/deallocate/:resource", deallocate_handler, []},
			{"/reset", reset_handler, []},
			{"/list/:user", list_user_handler, []},
			{"/list", list_handler, []},
      {'_', notfound_handler, []}
		]}
	]),



  {ok, Port} = application:get_env(resm, port),
  Env = [{env, [{dispatch, Dispatch}]}],

  erlang:display("resource manager started on port"),
  erlang:display(Port),

  {ok, _} = cowboy:start_http(http, 100,
    [{port, Port}],
    Env
	).
