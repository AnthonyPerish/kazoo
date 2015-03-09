%%%-------------------------------------------------------------------
%%% @copyright (C) 2013, 2600Hz
%%% @doc
%%%
%%% @end
%%% @contributors
%%%-------------------------------------------------------------------
-module(ci_parsers_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).
-export([start_child/2]).

-include("../call_inspector.hrl").

%% ===================================================================
%% API functions
%% ===================================================================

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Starts the supervisor
%% @end
%%--------------------------------------------------------------------
-spec start_link() -> startlink_ret().
start_link() ->
    supervisor:start_link({'local', ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%% @end
%%--------------------------------------------------------------------
-spec init([]) -> sup_init_ret().
init([]) ->
    RestartStrategy = 'one_for_one',
    MaxRestarts = 5,
    MaxSecondsBetweenRestarts = 10,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    {'ok', {SupFlags, []}}.


start_child(Module, Args) ->
    {'parser_args', File, _IP} = lists:keyfind('parser_args', 1, Args),
    ChildSpec = ?WORKER_NAME_ARGS(Module, File, Args),
    supervisor:start_child(?MODULE, ChildSpec).
