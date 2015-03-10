-module(resource_server).
-behaviour(gen_server).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-export([get_state/0]).
% -export([get_history/1, login_user/2, get_users_count/1, get_users/1, kick_user/2]).
%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(Resources) ->
  ok, _ = gen_server:start_link({local, ?MODULE}, ?MODULE, Resources, []).

% start_link(_Args) ->
  % gen_server:start_link(?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(Resources) ->
  Available = Resources,
  UnAvailable = {},
  {ok, {{available, Available}, {unavailable, UnAvailable}}}.

handle_call(_Request, _From, State) ->
  {reply, State, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

get_state() ->
  gen_server:call(?MODULE, {get, state}).
