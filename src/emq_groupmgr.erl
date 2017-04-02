-module(emq_groupmgr).

-include_lib("emqttd/include/emqttd.hrl").

-export([load/1, unload/0]).

-export([on_message_publish/2]).

load(Env) ->
  emqttd:hook('message.publish', fun ?MODULE:on_message_publish/2, [Env]).

unload() ->
  emqttd:unhook('client.connected', fun ?MODULE:on_client_connected/3),


on_message_publish(Message = #mqtt_message{topic = <<"$$GRP/add", _/binary>>}, _) ->
    PayloadList = binary_to_list(Message#mqtt_message.payload),
    Separator = binary_to_list(<<":">>),
    [ClientId | [Topic|Ignore]] = string:tokens(PayloadList, Separator),
    if
       (length(Ignore) == 0) and (length(ClientId) > 0) and (length(Topic) > 0) ->
         emqttd:subscribe(bin(Topic), bin(ClientId), [{qos, 1}]);
       true->
         ok
    end,
    Message#mqtt_message.payload = <<"ok">>,
    {ok, Message};

on_message_publish(Message = #mqtt_message{topic = <<"$$GRP/remove", _/binary>>}, _) ->
    PayloadList = binary_to_list(Message#mqtt_message.payload),
    Separator = binary_to_list(<<":">>),
    [ClientId | [Topic|Ignore]] = string:tokens(PayloadList, Separator),
    if
       (length(Ignore) == 0) and (length(ClientId) > 0) and (length(Topic) > 0) ->
         emqttd:unsubscribe(bin(Topic), bin(ClientId));
       true->
         ok
    end,
    Message#mqtt_message.payload = <<"ok">>,
    {ok, Message};


on_message_publish(Message = #mqtt_message{topic = <<"$$BW/add", _/binary>>}, _) ->
    PayloadList = binary_to_list(Message#mqtt_message.payload),
    Separator = binary_to_list(<<":">>),
    [ClientId | [Topic|Ignore]] = string:tokens(PayloadList, Separator),
    if
       (length(Ignore) == 0) and (length(ClientId) > 0) and (length(Topic) > 0) ->
         emqttd:subscribe(bin(Topic), bin(ClientId), [{qos, 1}]);
       true->
         ok
    end,
    Message#mqtt_message.payload = <<"ok">>,
    {ok, Message};

on_message_publish(Message = #mqtt_message{topic = <<"$$BW/remove", _/binary>>}, _) ->
    PayloadList = binary_to_list(Message#mqtt_message.payload),
    Separator = binary_to_list(<<":">>),
    [ClientId | [Topic|Ignore]] = string:tokens(PayloadList, Separator),
    if
       (length(Ignore) == 0) and (length(ClientId) > 0) and (length(Topic) > 0) ->
         emqttd:unsubscribe(bin(Topic), bin(ClientId));
       true->
         ok
    end,
    Message#mqtt_message.payload = <<"ok">>,
    {ok, Message};

on_message_publish(Message, _) ->
    {ok, Message}.
