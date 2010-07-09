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
    %% wire slider to slide event. 
    wf:wire(slider_percent, #event {type=slide, actions=#script { script="
        var sliderValue = objs('slider_percent').slider('value');
        objs('textbox_percent').val(sliderValue);
      "}
    }),
    [
        #flash {},
        #p{},
        #label { text="Percent:"},
        #textbox{ id=textbox_percent },
        #slider { id=slider_percent, tag=test_slider, animate=true },
        #button { text="Post", postback=post },
        #button { text="Set Value to 50", postback=set_value }
    ].

slider_change_event(ChangeValue, _Tag) ->
    Message = wf:f("Change Event Value: ~p~n", [ChangeValue]),
    wf:flash(Message),
    ok.
 
event(post) ->
    Message = wf:f("POST Value: ~p~n", [wf:q(slider_percent)]),
    wf:flash(Message),
    ok;
event(set_value) ->
    Value = 50,
    wf:wire( #script { 
      script= wf:f("objs('slider_percent').slider('value',~p)",[Value])
    });
event(_) -> ok.
