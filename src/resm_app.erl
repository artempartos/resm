-module(resm_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
		{'_', [
			{"/", main_handler, []}
		]}
	]),

  {ok, Port} = application:get_env(resm, port),
  {ok, _} = cowboy:start_http(http, 100, [{port, Port}], [
		{env, [{dispatch, Dispatch}]}
	]),

  ok, _ = resm_sup:start_link().

stop(_State) ->
  ok.
