-module(allocate_handler).

-export([init/2]).

init(Req, Opts) ->
	Method = cowboy_req:method(Req),
	process(Method, Req, Opts).

process(<<"GET">>, Req, Opts) ->
	User = erlang:binary_to_atom(cowboy_req:binding(user, Req), utf8),
	case resm:allocate(User) of
    {ok, Resource} ->
			Body = jsx:encode([{resource, Resource}]),
			Status = 201;
    {error, Error} ->
			Body = jsx:encode([{error, Error}]),
			Status = 503
	end,
	{ok, Req2} = reply(Status, Req, Body),
	{ok, Req2, Opts};


process(Method, Req, Opts) ->
	Body = <<"<h1>404 </h1> <h3>Page Not Found</h3>">>,
	Req2 = cowboy_req:reply(404, [{<<"content-type">>, <<"text/html">>}], Body, Req),
	{ok, Req2, Opts}.

reply(Status, Req, Response) ->
	cowboy_req:reply(Status, [
                         {<<"Access-Control-Allow-Origin">>, <<"*">>},
                         {<<"content-type">>, <<"application/json; charset=utf-8">>}
                        ], Response, Req).
