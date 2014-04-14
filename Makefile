
PREFIX:=../
DEST:=$(PREFIX)$(PROJECT)

REBAR=./rebar

all: generate
	@$(REBAR) get-deps compile

edoc:
	@$(REBAR) skip_deps=true doc

eunit:
	@$(REBAR) skip_deps=true eunit

clean:
	@$(REBAR) clean

generate: ./ebin/ux_unidata_db.beam

./ebin/ux_unidata_db.beam:
	cd utils;./generate_unidata ../priv/UNIDATA/UnicodeData.txt.gz ../src/
	erlc -o ./ebin/ ./src/ux_unidata_db.erl
	rm ./src/ux_unidata_db.erl

build_plt:
	@$(REBAR) build-plt

check_plt:
	@$(REBAR) check-plt

dialyzer:
	@$(REBAR) dialyze

app:
	@$(REBAR) create template=mochiwebapp dest=$(DEST) appid=$(PROJECT)

