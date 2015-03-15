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

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(Resources) ->
  ok, _ = gen_server:start_link({local, ?MODULE}, ?MODULE, Resources, []).

init(Resources) ->
  Allocated = {allocated, dict:new()},
  Deallocated = {deallocated, Resources},
  {ok, {Allocated, Deallocated}}.

handle_call({allocate, _User}, _From, State = {_, {deallocated, []}}) ->
  {reply, {error, out_of_resource}, State};

handle_call({allocate, User}, _From, {{allocated, AllocatedState}, {deallocated, [Resource | DeallocatedState]}}) ->
  Allocated = {allocated, dict:store(Resource, User, AllocatedState)},
  NewState = {Allocated, {deallocated, DeallocatedState}},
  {reply, {ok, Resource}, NewState};

handle_call({deallocate, _Resource}, _From, State = {_Deallocated, {allocated, []}}) ->
  {reply, {error, not_allocated}, State};

handle_call({deallocate, Resource}, _From, State = {{allocated, AllocatedState}, {deallocated, DeallocatedState}}) ->
  case dict:is_key(Resource, AllocatedState) of
    true ->
      Allocated = dict:erase(Resource, AllocatedState),
      NewState = {{allocated, Allocated}, {deallocated, [Resource | DeallocatedState]}},
      {reply, ok, NewState};
    false ->
      {reply, {error, not_allocated}, State}
  end;

handle_call(reset, _From, {{allocated, AllocatedState}, {deallocated, DeallocatedState}}) ->
  Keys = dict:fetch_keys(AllocatedState),
  NewState = {{allocated, dict:new()}, {deallocated, Keys ++ DeallocatedState}},
  {reply, ok, NewState};

handle_call(list, _From, State = {{allocated, AllocatedState}, {deallocated, DeallocatedState}}) ->
  List = dict:to_list(AllocatedState),
  {reply, {{allocated, List}, {deallocated, DeallocatedState}}, State};

handle_call({list, User}, _From, State = {{allocated, AllocatedState}, _}) ->
  UserDict = dict:filter(fun(_, Value) -> Value == User end, AllocatedState),
  Keys = dict:fetch_keys(UserDict),
  {reply, Keys, State};

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
