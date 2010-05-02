<?php
/*************************************************************************************
 * farnsworth.php
 * -----
 * Author: Ryan Voots (simcop2387@simcop2387.info)
 * Copyright: (c) 2010 Nigel McNie (http://qbnz.com/highlighter/)
 * Release Version: 0.0.1
 * Date Started: 2010/05/01
 *
 * Farnsworth language file for GeSHi.
 *
 * CHANGES
 * -------
 * 2010/05/01 (0.0.1)
 *   -  First Release
 *
 * TODO (updated 2010/05/01)
 * -------------------------
 *  -  Finish it
 *
 *************************************************************************************
 *
 *     This file is part of GeSHi.
 *
 *   GeSHi is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   GeSHi is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with GeSHi; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 ************************************************************************************/

$language_data = array (
    'LANG_NAME' => 'Farnsworth',
    'COMMENT_SINGLE' => array(1 => '//'),
    'COMMENT_MULTI' => array('/*' => '*/'),
    'COMMENT_REGEXP' => array(
        //Multiline-continued single-line comments
        1 => '/\/\/(?:\\\\\\\\|\\\\\\n|.)*$/m',
        ),
    'CASE_KEYWORDS' => GESHI_CAPS_NO_CHANGE,
    'QUOTEMARKS' => array('"'),
    'ESCAPE_CHAR' => '',
    'ESCAPE_REGEXP' => array(
        //Simple Single Char Escapes
        1 => "#\\\\[\\\\abfnrtv\'\"?\n]#i",
        //Hexadecimal Char Specs
        2 => "#\\\\x[\da-fA-F]{2}#",
        //Hexadecimal Char Specs
        3 => "#\\\\u[\da-fA-F]{4}#",
        //Hexadecimal Char Specs
        4 => "#\\\\U[\da-fA-F]{8}#",
        //Octal Char Specs
        5 => "#\\\\[0-7]{1,3}#"
        ),
    'NUMBERS' =>
        GESHI_NUMBER_INT_BASIC | GESHI_NUMBER_INT_CSTYLE | GESHI_NUMBER_BIN_PREFIX_0B |
        GESHI_NUMBER_OCT_PREFIX | GESHI_NUMBER_HEX_PREFIX | GESHI_NUMBER_FLT_NONSCI |
        GESHI_NUMBER_FLT_NONSCI_F | GESHI_NUMBER_FLT_SCI_SHORT | GESHI_NUMBER_FLT_SCI_ZERO,
    'KEYWORDS' => array(
        1 => array(
            'if', 'while', 'else'
            ),
        2 => array(
            'undef', 'False', 'True',
            ),
        3 => array(
            'var', 'conforms', 'isa', 'byref',
            ),
        4 => array(
        	'push', 'pop', 'unshift', 'shift',
            'sort', 'map', 'min', 'max',
            'reverse', 'length', 'ord', 'chr',
            'index', 'eval', 'substrLen', 'substr',
            'left',	'right', 'now', 'unit'
            ),
        5 => array(
        	'sin', 'csc', 'cos', 'sec', 'tan', 'cot', 'atan', 'arctan',
        	'acos', 'arccos', 'asin', 'arcsin', 'sinh', 'cosh', 'tanh',
        	'atanh', 'arctanh', 'acosh', 'arccosh', 'asinh', 'arcsinh',
        	'atan2', 'sqrt', 'exp', 'ln', 'log', 'abs', 'gcd', 'lcm', 
        	'quad', 'quadratic', 'floor', 'ceil', 'int', 'trunc',
        	'rint', 'round', 'numerator', 'denominator', 'isprime',
        	'prime', 'nextprime', 'precprimep', 'conj', 'norm',
        	'real', 'imag', 'getrseed', 'randmax', 'setrseed', 'random',
        	),
        ),
    'SYMBOLS' => array(
        '(', ')', '[', ']',
        '{`', '{', '}', '`',
        '+', '-', '*', '/', '%', 'per', '^',
        '<=>', '<=', '>=', '!=', '==', '<', '>', 
        '=', '!', '^', '&', '|',
        '?', ':',
        ';', ','
        ),
    'CASE_SENSITIVE' => array(
        GESHI_COMMENTS => false,
        1 => true,
        2 => true,
        3 => true,
        4 => true,
        ),
    'STYLES' => array(
        'KEYWORDS' => array(
            1 => 'color: #b1b100;',
            2 => 'color: #000000; font-weight: bold;',
            3 => 'color: #000066;',
            4 => 'color: #993333;',
            5 => 'color: #333399;'
            ),
        'COMMENTS' => array(
            1 => 'color: #666666; font-style: italic;',
            2 => 'color: #339933;',
            'MULTI' => 'color: #808080; font-style: italic;'
            ),
        'ESCAPE_CHAR' => array(
            0 => 'color: #000099; font-weight: bold;',
            1 => 'color: #000099; font-weight: bold;',
            2 => 'color: #660099; font-weight: bold;',
            3 => 'color: #660099; font-weight: bold;',
            4 => 'color: #660099; font-weight: bold;',
            5 => 'color: #006699; font-weight: bold;',
            'HARD' => '',
            ),
        'BRACKETS' => array(
            0 => 'color: #009900;'
            ),
        'STRINGS' => array(
            0 => 'color: #ff0000;'
            ),
        'NUMBERS' => array(
            0 => 'color: #0000dd;',
            GESHI_NUMBER_BIN_PREFIX_0B => 'color: #208080;',
            GESHI_NUMBER_OCT_PREFIX => 'color: #208080;',
            GESHI_NUMBER_HEX_PREFIX => 'color: #208080;',
            GESHI_NUMBER_FLT_SCI_SHORT => 'color:#800080;',
            GESHI_NUMBER_FLT_SCI_ZERO => 'color:#800080;',
            GESHI_NUMBER_FLT_NONSCI_F => 'color:#800080;',
            GESHI_NUMBER_FLT_NONSCI => 'color:#800080;'
            ),
        'METHODS' => array(
            1 => 'color: #202020;',
            2 => 'color: #202020;'
            ),
        'SYMBOLS' => array(
            0 => 'color: #339933;'
            ),
        'REGEXPS' => array(
            ),
        'SCRIPT' => array(
            )
        ),
    'URLS' => array(
        1 => '',
        2 => '',
        3 => '',
        4 => ''
        ),
    'OOLANG' => true,
    'OBJECT_SPLITTERS' => array(
        ),
    'REGEXPS' => array(
        ),
    'STRICT_MODE_APPLIES' => GESHI_NEVER,
    'SCRIPT_DELIMITERS' => array(
        ),
    'HIGHLIGHT_STRICT_BLOCK' => array(
        ),
    'TAB_WIDTH' => 4
);

?>