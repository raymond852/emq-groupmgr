-module(emq_groupmgr).

-include_lib("emqttd/include/emqttd.hrl").

-export([load/1, unload/0]).

-export([on_message_publish/2]).

load(Env) ->
  emqttd:hook('message.publish', fun ?MODULE:on_message_publish/2, [Env]).

unload() ->
  emqttd:unhook('message.publish', fun ?MODULE:on_message_publish/2).


on_message_publish(Message = #mqtt_message{topic = <<"$$GRP/add", _/binary>>}, _) ->
    PayloadList = binary_to_list(Message#mqtt_message.payload),
    Separator = binary_to_list(<<":">>),
    [ClientId | [Topic|Ignore]] = string:tokens(PayloadList, Separator),
    if
       (length(Ignore) == 0) and (length(ClientId) > 0) and (length(Topic) > 0) ->
         emqttd:subscribe(list_to_binary(Topic), list_to_binary(ClientId), [{qos, 1}]);
       true->
         ok
    end,
    {ok, Message};

on_message_publish(Message = #mqtt_message{topic = <<"$$GRP/remove", _/binary>>}, _) ->
    PayloadList = binary_to_list(Message#mqtt_message.payload),
    Separator = binary_to_list(<<":">>),
    [ClientId | [Topic|Ignore]] = string:tokens(PayloadList, Separator),
    if
       (length(Ignore) == 0) and (length(ClientId) > 0) and (length(Topic) > 0) ->
         emqttd:unsubscribe(list_to_binary(Topic), list_to_binary(ClientId));
       true->
         ok
    end,
    {ok, Message};


on_message_publish(Message = #mqtt_message{topic = <<"$$BW/add", _/binary>>}, _) ->
    PayloadList = binary_to_list(Message#mqtt_message.payload),
    Separator = binary_to_list(<<":">>),
    [ClientId | [Topic|Ignore]] = string:tokens(PayloadList, Separator),
    if
       (length(Ignore) == 0) and (length(ClientId) > 0) and (length(Topic) > 0) ->
         emqttd:subscribe(list_to_binary(Topic), list_to_binary(ClientId), [{qos, 1}]);
       true->
         ok
    end,
    {ok, Message};

on_message_publish(Message = #mqtt_message{topic = <<"$$BW/remove", _/binary>>}, _) ->
    PayloadList = binary_to_list(Message#mqtt_message.payload),
    Separator = binary_to_list(<<":">>),
    [ClientId | [Topic|Ignore]] = string:tokens(PayloadList, Separator),
    if
       (length(Ignore) == 0) and (length(ClientId) > 0) and (length(Topic) > 0) ->
         emqttd:unsubscribe(list_to_binary(Topic), list_to_binary(ClientId));
       true->
         ok
    end,
    {ok, Message};

on_message_publish(Message, _) ->
    {ok, Message}.
