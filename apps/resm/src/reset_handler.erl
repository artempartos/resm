-module(reset_handler).

-export([init/2]).

init(Req, Opts) ->
	Method = cowboy_req:method(Req),
	process(Method, Req, Opts).

process(<<"GET">>, Req, Opts) ->
	resm:reset(),
	Req2 = reply(204, Req, <<>>),
	{ok, Req2, Opts};

process(_, Req, Opts) ->
	Body = <<"Bad Request">>,
	Req2 = reply(404, Req, Body),
	{ok, Req2, Opts}.

reply(Status, Req, Body) ->
	cowboy_req:reply(Status, [{<<"content-type">>, <<"text/html">>}], Body, Req).
