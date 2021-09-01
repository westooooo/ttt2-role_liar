L = LANG.GetLanguageTableReference("日本語")

-- GENERAL ROLE LANGUAGE STRINGS
L[LIAR.name] = "Liar"
L["info_popup_" .. LIAR.name] = [[嘘つきなテロリストに選ばれた。もし死んだら裏切者の死体へとなってしまい、
裏切者に有益なことになってしまうので注意しよう。]]
L["body_found_" .. LIAR.abbr] = "奴はLiarのようだ..."
L["search_role_" .. LIAR.abbr] = "こいつはLiarだったようだな！"
L["target_" .. LIAR.name] = "Liar"
L["ttt2_desc_" .. LIAR.name] = [[LiarはInnocent陣営だが、その中でも嘘つきな者である。
もし死んだらTraitorの死体へと変化してしまい、Traitorが有利となってしまうので注意しよう。]]