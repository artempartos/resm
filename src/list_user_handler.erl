-module(list_user_handler).

-export([init/2]).

init(Req, Opts) ->
	Method = cowboy_req:method(Req),
	process(Method, Req, Opts).

process(<<"GET">>, Req, Opts) ->
	User = erlang:binary_to_atom(cowboy_req:binding(user, Req), utf8),
	List = resm:list(User),
	Body = jsx:encode(List),
	Req2 = reply(200, Req, Body),
	{ok, Req2, Opts};

process(Method, Req, Opts) ->
	Body = <<"Bad Request">>,
	Req2 = reply(400, Req, Body),
	{ok, Req2, Opts}.

reply(Status, Req, Body) ->
	cowboy_req:reply(Status, [{<<"content-type">>, <<"text/html">>}], Body, Req).
