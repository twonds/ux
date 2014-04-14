
PREFIX:=../
DEST:=$(PREFIX)$(PROJECT)

REBAR=./rebar

all:
	@$(REBAR) get-deps compile

edoc:
	@$(REBAR) skip_deps=true doc

eunit:
	@$(REBAR) skip_deps=true eunit

clean:
	@$(REBAR) clean

generate:
	cd utils;./generate_unidata ../priv/UNIDATA/UnicodeData.txt.gz ../priv/unidata_db.terms

build_plt:
	@$(REBAR) build-plt

check_plt:
	@$(REBAR) check-plt

dialyzer:
	@$(REBAR) dialyze

app:
	@$(REBAR) create template=mochiwebapp dest=$(DEST) appid=$(PROJECT)

