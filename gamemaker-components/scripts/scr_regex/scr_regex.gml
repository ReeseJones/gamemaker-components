/*
 *
 * Mini regex-module inspired by Rob Pike's regex code described in:
 *
 * http://www.cs.princeton.edu/courses/archive/spr09/cos333/beautiful.html
 *
 *
 *
 * Supports:
 * ---------
 *   '.'        Dot, matches any character
 *   '^'        Start anchor, matches beginning of string
 *   '$'        End anchor, matches end of string
 *   '*'        Asterisk, match zero or more (greedy)
 *   '+'        Plus, match one or more (greedy)
 *   '?'        Question, match zero or one (non-greedy)
 *   '[abc]'    Character class, match if one of {'a', 'b', 'c'}
 *   '[^abc]'   Inverted class, match if NOT one of {'a', 'b', 'c'} -- NOTE: feature is currently broken!
 *   '[a-zA-Z]' Character ranges, the character set of the ranges { a-z | A-Z }
 *   '\s'       Whitespace, \t \f \r \n \v and spaces
 *   '\S'       Non-whitespace
 *   '\w'       Alphanumeric, [a-zA-Z0-9_]
 *   '\W'       Non-alphanumeric
 *   '\d'       Digits, [0-9]
 *   '\D'       Non-digits
 *
 */

// Terminology      Definition
// Character        A single letter, digit, punctuation marker, whitespace, etc.
// Whitespace       Any character that is not visible: space, tab, etc.
// String           Any sequence of characters.
// Operator         Characters with special meaning in a particular context.

//https://npp-user-manual.org/docs/searching/#character-escape-sequences
//https://regexr.com/3dvqn

///@param {string} _pattern
function regex_build_dfa(_pattern) {
    
}

///@param {string} _pattern
function Regex(_pattern) constructor {
    pattern = _pattern;
    
    dfaStart = regex_build_dfa(_pattern);
    
    ///@param {string}
    static match = function(_string) {
        
        return false;
    }
}