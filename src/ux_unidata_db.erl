%% unidata beambag module
-module(ux_unidata_db).

-include_lib("beambag/include/beambag_edit_magic.hrl").

-export([fetch/2, get_function/2, bool_fun/2, default_fun/3]).

-export([is_available/0, build/1, child_spec/0, state/0]).


child_spec() ->
    %%beambag:child_spec(ux_unidata_db,
    %%                                "./../priv/unidata_db.terms",
    %%                                "./../ebin/ux_unidata_db.beam",
    %%                                fun ux_unidata_db:build/1),
    LibDir = lib_dir(),
    DataFile = filename:join([LibDir, priv, "unidata_db.terms"]),
    BeamFile = filename:join([LibDir, ebin, ?MODULE_STRING ++ ".beam"]),
    Builder  = fun ux_unidata_db:build/1,

    Id = ux_unidata_db_edit,
    Mod = beambag,
    Func = start_link,
    Args =
        [?MODULE,
         DataFile,
         BeamFile,
         Builder
        ],
    Restart = permanent,
    Shutdown = brutal_kill,
    Mode = worker,
    Modules = [beambag],
    {Id,{Mod,Func,Args},Restart,Shutdown,Mode,Modules}.

get_function(w3, Value) -> 
    DefValue = false,
    default_fun(w3, Value, DefValue);
get_function(comp_tag, Value) -> 
    DefValue = false,
    default_fun(comp_tag, Value, DefValue);
get_function(ccc, Value) -> 
    DefValue = 0,
    default_fun(ccc, Value, DefValue);
get_function(is_upper, Value) -> 
    bool_fun(is_upper, Value);
get_function(is_lower, Value) -> 
    bool_fun(is_lower, Value);
get_function(is_compat, Value) -> 
    bool_fun(is_compat, Value);
get_function(type, Value) -> 
    DefValue = other,
    default_fun(type, Value, DefValue);
get_function(comment, Value) -> 
    DefValue = <<>>,
    default_fun(comment, Value, DefValue);
get_function(comp, Value) -> 
    DefValue = false,
    default_fun(comp, Value, DefValue);
get_function(decomp, Value) -> 
    DefValue = [],
    default_fun(decomp, Value, DefValue);
get_function(to_upper, Value) -> 
    DefValue = noop, % fun(C) -> C.
    default_fun(to_upper, Value, DefValue);
get_function(to_lower, Value) -> 
    DefValue = noop, % fun(C) -> C.
    default_fun(to_lower, Value, DefValue).

bool_fun(Type, skip_check) ->
    fun(C) ->
            ?MODULE:bool_fun(Type, C)
    end;
bool_fun(Type, C) ->
    case fetch(Type, C) of
        {C} ->
            true;
        _ -> false
    end.

default_fun(Type, skip_check, DefaultValue) ->
    fun(C) ->
            ?MODULE:default_fun(Type, C, DefaultValue)
    end;
default_fun(Type, C, DefaultValue) ->
   case fetch(Type, C) of
       skip when DefaultValue =:= noop
            -> C;
       skip -> DefaultValue;
       {C, Val} -> Val
    end.

is_available() ->
    case is_atom(state()) of
        true ->
            false;
        _ ->
            case dict:is_empty(state()) of
                true ->
                    false;
                _ -> true
            end
    end.

fetch(Type, Char) ->
    case dict:find({Type, Char}, state()) of
        {ok, Value} ->
            Value;
        error -> skip
    end.

lib_dir() ->
    case code:lib_dir(?MODULE) of
        {error, bad_name} ->
            Compile = module_info(compile),
            {source, Source} = lists:keyfind(source, 1, Compile),
            SrcDir = filename:dirname(Source),
            filename:dirname(SrcDir);
        LibDir ->
            LibDir
    end.


build(Data) ->
    %% Read in term files.
    dict:from_list(Data).

state() ->
    ?MAGIC.
