;; extends
((true) @boolean (#set! conceal "⊤"))
((false) @boolean (#set! conceal "⊥"))
((nil) @constant.builtin (#set! conceal "∅"))
("=" @operator (#set! conceal "≔"))
("==" @operator (#set! conceal "≡"))
("~=" @operator (#set! conceal "≢"))
("<=" @operator (#set! conceal "≤"))
(">=" @operator (#set! conceal "≥"))
("not" @keyword.operator (#set! conceal "¬"))
("and" @keyword.operator (#set! conceal "⋀"))
("or" @keyword.operator (#set! conceal "⋁"))