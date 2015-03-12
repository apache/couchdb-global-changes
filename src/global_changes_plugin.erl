-module(global_changes_plugin).

-export([behaviour_info/1]).

-export([register_plugin/0, start_plugin/0, register_handler/2, unregister_handler/1]).

-export([validate_and_maybe_overwrite_user/1]).

behaviour_info(callbacks) ->
    plugerl:define_callbacks([
         %% notice that arity is incremented to accommodate State
         {validate_and_maybe_overwrite_user, 2}
    ]).

register_plugin() ->
    plugerl:register_plugin(couch, ?MODULE),
    plugerl:start_plugin(couch, ?MODULE).

start_plugin() ->
    plugerl:start_plugin(couch, ?MODULE).

register_handler(Module, Args) ->
    plugerl:register_handler(couch, ?MODULE, Module, Args, []).

unregister_handler(Module) ->
    plugerl:unregister_handler(couch, ?MODULE, Module).

validate_and_maybe_overwrite_user(Req) ->
    case plugerl:handle(?MODULE, validate_and_maybe_overwrite_user, ok, [Req]) of
    {error, {handler_error, _Handler, Reason}} ->
        %% couch_log:error("handler_error: ~w, ~w", [_Handler, Reason])
        {error, Reason};
    Else ->
        Else
    end.
