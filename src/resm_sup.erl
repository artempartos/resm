-module(resm_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
-define(CHILD(I, Type, Args), {I, {I, start_link, [Args]}, permanent, 5000, Type, [I]}).

start_link() ->
  ok, _ = supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Arg) ->
  {ok, Resources} = application:get_env(resm, resources),
  ResourceServer = ?CHILD(resource_server, worker, Resources),

  {ok, {{one_for_one, 5, 10}, [ResourceServer]}}.
