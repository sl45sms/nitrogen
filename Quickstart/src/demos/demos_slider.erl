-module (demos_slider).
-include_lib ("nitrogen/include/wf.hrl").
-compile(export_all).

main() -> #template { file="./templates/demos46.html" }.

title() -> "Slider".

headline() -> "Slider".

left() -> 
    [
        "
        <p>
        Please add documentation!
        ",
        linecount:render()
    ].

right() -> 
    [
        #flash {},
        #p{},
        #slider { id=percent, tag=testSlider },
        #button { text="Post", postback=post }
    ].

slider_change_event(ChangeValue, _Tag) ->
    Message = wf:f("Change Event Value: ~p~n", [ChangeValue]),
    wf:flash(Message),
    ok.
event(post) ->
    Message = wf:f("POST Value: ~p~n", [wf:q(percent)]),
    wf:flash(Message),
    ok;
event(_) -> ok.
