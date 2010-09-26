-module (element_fieldset).
-include_lib ("wf.hrl").
-compile(export_all).

reflect() -> record_info(fields, fieldset).

render_element(Record) -> 
	Legend = Record#fieldset.legend,
	Body = [Elem || Elem <- case Legend of
		undefined -> [];
		Text ->	[wf_tags:emit_tag(legend, Text, [])]
		end ++ Record#fieldset.body
	],
	wf_tags:emit_tag(fieldset, Body, []).
