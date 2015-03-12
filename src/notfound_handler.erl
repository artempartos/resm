-module(notfound_handler).

-export([init/2]).

init(Req, Opts) ->
	Body = <<"Bad Request">>,
	Req2 = cowboy_req:reply(400, [{<<"content-type">>, <<"text/html">>}], Body, Req),
	{ok, Req2, Opts}.
