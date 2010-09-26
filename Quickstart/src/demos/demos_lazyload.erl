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
        #link { text="Load Javascript", actions=#event { type=click,
            actions= #lazyload {
                src="/nitrogen/bert.js"
            }
        }}
    ].

lazyload_error_event({javascript, ErrorMesssage, Url, LineNumber, Tag})->
    wf:flash(wf:f("Error! ~p",[Tag])),
    ok.

event(_) -> 
    wf:flash("Script loaded!"),
    ok.
