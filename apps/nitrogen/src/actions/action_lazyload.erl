% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_lazyload).
-include_lib ("wf.hrl").
-compile(export_all).

render_action(Record) -> 
    Src = iolist_to_binary(Record#lazyload.src),
    Charset = iolist_to_binary(Record#lazyload.charset),
    Delegate = Record#lazyload.delegate,
    Tag = Record#lazyload.tag,

    CompletePostbackInfo = case Record#lazyload.postback of
        undefined -> null;
        Postback -> wf_event:serialize_event_context(Postback, undefined, undefined, Delegate)
    end,
    
    ErrorPostbackInfo = wf_event:serialize_event_context({lazyload_error_event, Delegate, Tag}, undefined, undefined, ?MODULE),

    LoaderOptions = ?STRUCT([
        {src, Src}        
    ]),

    [#script {
        script = wf:f("Nitrogen.$lazyload.apply(Nitrogen, ~s);", [
            ?JSON_ENCODE([
              LoaderOptions,
              CompletePostbackInfo,
              ErrorPostbackInfo
            ])
        ])
    }].
    
event({lazyload_error_event=Event, Delegate, Tag}) ->
    {struct, JsonData} = ?JSON_DECODE(wf:q(error)),
    
    ErrorMesssage =  proplists:get_value(<<"message">>, JsonData), 
    Url = proplists:get_value(<<"url">> , JsonData),
    LineNumber =  proplists:get_value(<<"line">> , JsonData),
    ?LOG("Error Event: ~p, Message: \"~s\", Tag: ~p, URL: \"~s\", Line Number: ~p~n", [Event, ErrorMesssage, Tag, Url, LineNumber]),
    
    Module = wf:coalesce([Delegate, wf_context:page_module()]),
    case erlang:function_exported(Module, lazyload_error_event, 1) of
        false -> ignore;
        true  -> Module:lazyload_error_event({javascript, ErrorMesssage, Url, LineNumber, Tag})
    end.
