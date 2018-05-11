-module(kuberl).

-export([new_cfg/0,
         update_cfg/1,
         cfg_with_bearer_token/1,
         cfg_with_bearer_token/2,
         cfg_with_host/1,
         cfg_with_host/2,
         update_default_cfg/1,
         set_default_cfg/0,
         set_default_cfg/1]).

%% If in in-cluster environment, and with proper privileges to this pod,
%% get token information from following path
-define(service_account_path, "/var/run/secrets/kubernetes.io/serviceaccount").
-define(kube_master, "https://kubernetes.default.svc.cluster.local").

new_cfg() ->
    #{host => application:get_env(kuberl, host, host()),
      hackney_opts => [{ssl_options, [{server_name_indication, disable}]}],
      auth => auth(),
      api_key_prefix => #{<<"authorization">> => <<"Bearer">>}}.

auth() ->
    #{'BearerToken' => application:get_env(kuberl, api_key, token())}.

cfg_with_bearer_token(Token) ->
    cfg_with_bearer_token(new_cfg(), Token).

cfg_with_bearer_token(Cfg, Token) when is_binary(Token) ->
    maps:merge(Cfg, #{auth => #{'BearerToken' => Token},
                      api_key_prefix => #{<<"authorization">> => <<"Bearer">>}}).

cfg_with_host(Host) ->
    cfg_with_host(new_cfg(), Host).

cfg_with_host(Cfg, Host) ->
    maps:merge(Cfg, #{host => Host}).

%% Update a default config with values in the map argument
update_cfg(Map) ->
    maps:merge(new_cfg(), Map).

update_default_cfg(Map) ->
    set_default_cfg(maps:merge(new_cfg(), Map)).

set_default_cfg() ->
    set_default_cfg(new_cfg()).

set_default_cfg(Cfg) ->
    application:set_env(kuberl, config, Cfg).

token() ->
    case file:read_file(filename:join(?service_account_path, "token")) of
        {ok, Data} ->
            Data;
        _ ->
            undefined
    end.

host() ->
    case file:read_file(filename:join(?service_account_path, "token")) of
        {ok, _} ->
            ?kube_master;
        _ ->
            "localhost:8001"
    end.