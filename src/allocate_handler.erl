-module(allocate_handler).

-export([init/2]).

init(Req, Opts) ->
	Method = cowboy_req:method(Req),
	process(Method, Req, Opts).

process(<<"GET">>, Req, Opts) ->
	User = erlang:binary_to_atom(cowboy_req:binding(user, Req), utf8),
	case resm:allocate(User) of
    {ok, Resource} ->
			Body = erlang:atom_to_binary(Resource, utf8),
			Status = 201;
    {error, Error} ->
			Body = erlang:atom_to_binary(Error, utf8),
			Status = 503
	end,
	Req2 = reply(Status, Req, Body),
	{ok, Req2, Opts};


process(_, Req, Opts) ->
	Body = <<"Bad Request">>,
	Req2 = reply(400, Req, Body),
	{ok, Req2, Opts}.

reply(Status, Req, Body) ->
	cowboy_req:reply(Status, [{<<"content-type">>, <<"text/html">>}], Body, Req).
