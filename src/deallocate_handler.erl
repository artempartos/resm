-module(deallocate_handler).

-export([init/2]).

init(Req, Opts) ->
	Method = cowboy_req:method(Req),
	process(Method, Req, Opts).

process(<<"GET">>, Req, Opts) ->
	Resource = erlang:binary_to_atom(cowboy_req:binding(resource, Req), utf8),
	case resm:deallocate(Resource) of
    ok ->
			Body = <<>>,
			Status = 204;
    {error, Error} ->
			Body = erlang:atom_to_binary(Error, utf8),
			Status = 404
	end,
	{ok, Req2} = reply(Status, Req, Body),
	{ok, Req2, Opts};

process(_, Req, Opts) ->
	Body = <<"Bad Request">>,
	{ok, Req2} = reply(404, Req, Body),
	{ok, Req2, Opts}.

reply(Status, Req, Body) ->
	cowboy_req:reply(Status, [{<<"content-type">>, <<"text/html">>}], Body, Req).
