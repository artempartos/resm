% -module(resource_server_tests).

-module(resource_server_SUITE).
-include_lib("eunit/include/eunit.hrl").
-include_lib("common_test/include/ct.hrl").
-compile(export_all).
-export([all/0]).
-export([test_success_allocate_resource/1, test_fail_allocate_resource/1, test_list_of_resources/1,
        test_success_deallocate_resource/1, test_fail_deallocate_resource/1, test_reset_resources/1]).

all() -> [
  test_success_allocate_resource,
  test_fail_allocate_resource,
  test_list_of_resources,
  test_success_deallocate_resource,
  test_fail_deallocate_resource,
  test_reset_resources
  ].

init_per_suite(Config) ->
  application:load(resm),
  application:set_env(resm, port, 8081),
  application:set_env(resm, resources, [test1, test2]),
  resm:start(),
  Config.

init_per_testcase(_, Config) ->
  Config.

end_per_testcase(_, Config) ->
  resm:reset(),
  Config.

end_per_suite(Config) ->
  resm:stop(),
  Config.

test_success_allocate_resource(_Config) ->
  Response1 = resm:allocate(partos),
  ?assertEqual({ok, test1}, Response1),

  Response2 = resm:allocate(partos),
  ?assertEqual({ok, test2}, Response2).

test_fail_allocate_resource(_Config) ->
  resm:allocate(partos),
  resm:allocate(partos),

  Response = resm:allocate(partos),
  ?assertEqual({error, out_of_resource}, Response).

test_list_of_resources(_Config) ->
  {_, {deallocated, List}} = resm:list(),
  ?assertEqual([test1, test2], List),

  EmptyUserList = resm:list(partos),
  ?assertEqual([], EmptyUserList),

  {ok, Resource} = resm:allocate(partos),
  UserList = resm:list(partos),
  ?assertEqual([Resource], UserList),

  {_, {deallocated, NewList}} = resm:list(),
  ?assertEqual([test2], NewList).

test_success_deallocate_resource(_Config) ->
  StartState = resm:list(),
  {ok, Resource} = resm:allocate(partos),
  ok = resm:deallocate(Resource),
  EndState = resm:list(),
  ?assertEqual(EndState, StartState).

test_fail_deallocate_resource(_Config) ->
  {ok, Resource} = resm:allocate(partos),
  ok = resm:deallocate(Resource),
  Response = resm:deallocate(Resource),
  ?assertEqual({error, not_allocated}, Response).

test_reset_resources(_Config) ->
  StartState = resm:list(),
  resm:allocate(partos),
  resm:allocate(partos),
  resm:reset(),
  EndState = resm:list(),
  ?assertEqual(EndState, StartState).
