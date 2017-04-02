-module(emq_groupmgr_app).

-behaviour(application).

-include("emq_groupmgr_app.hrl").

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  {ok, Sup} = emq_groupmgr_sup:start_link(),
  emq_groupmgr:load(application:get_all_env()),
  {ok, Sup}.

stop(_State) ->
  emq_groupmgr:unload().
