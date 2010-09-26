-module (demos_lazyload).
-include_lib ("nitrogen/include/wf.hrl").
-compile(export_all).

main() -> #template { file="./templates/demos46.html" }.

title() -> "LazyLoad".

headline() -> "LazyLoad".

left() -> 
    [
       "
        <p>
        Please add documentation!
        ",
        linecount:render()
    ].

right() -> 
    %%wf:wire(),
    [
        #flash{}, 
        #link { text="Load Javascript files (a.js, b.js and c.js)", actions=#event { type=click,
            postback=postback,
            actions=#lazyload {
              deps_js = ["/js/a.js", "/js/b.js"],
              src="/js/c.js"
            }
        }}
    ].

lazyload_error_event({javascript, _ErrorMesssage, _Url, _LineNumber, Tag})->
    wf:flash(wf:f("Error! ~p",[Tag])),
    ok.

event(postback) ->
    wf:flash("Scripts loaded!"),
    ok.

