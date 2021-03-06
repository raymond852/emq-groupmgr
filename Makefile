PROJECT = emq_groupmgr
PROJECT_DESCRIPTION = Group management
PROJECT_VERSION = 2.1.0

BUILD_DEPS = emqttd cuttlefish
dep_emqttd = git https://github.com/emqtt/emqttd master
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

NO_AUTOPATCH = cuttlefish

COVER = true

ERLC_OPTS += +'{parse_transform, lager_transform}'

include erlang.mk

app:: rebar.config

app.config::
	deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emq_groupmgr.conf -i priv/emq_groupmgr.schema -d data
