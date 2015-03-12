-module(notfound_handler).

-export([init/2]).

init(Req, Opts) ->
	Body = <<"<h1>404 </h1> <h3>Page Not Found</h3>">>,
	Req2 = cowboy_req:reply(404, [{<<"content-type">>, <<"text/html">>}], Body, Req),
	{ok, Req2, Opts}.
