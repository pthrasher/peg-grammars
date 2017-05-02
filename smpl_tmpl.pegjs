/*
 * Simple String Template Parser
 * =============================
 *
 * Accepts expressions like "2 * (3 + 4)" and computes their value.
 * some text [comment '{comment}'] and another part [with other data {other}]
 * [foo bar baz{other}]
 * 
 */

Start = Block *

Block = ExpressionBlock / PlainTextBlock

PlainTextBlock = $ PlainTextChar + {
  return {
    type: 'PlainTextBlock',
    value: text(),
  };
}
PlainTextChar = ! CurlyBlock ! SquareBlock char:. { return char; }

ExpressionBlock = SquareBlock / CurlyBlock;
SquareBlock = "[" prefix:OptionalText datapath:CurlyBlock postfix:OptionalText "]" {
  return {
    type: 'SquareBlock',
    prefix: prefix,
    postfix: postfix,
    datapath: datapath.datapath,
  };
}
OptionalText = $ [^{\]] *

CurlyBlock = "{" dp: $ DataPath "}" {
  return {
    type: 'CurlyBlock',
    prefix: '',
    postfix: '',
    datapath: dp
  };
}
DataPath = $ [^}\]] +

//UnescapedChar = [^\0-\x1F\x22\x5C]
