package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter = [a-zA-Z]
Digit  = [0-9]
Identifier         = {Letter}({Letter}|{Digit}|_){0,31}
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%

<YYINITIAL> {

    {WhiteSpace}    { /* ignora espaços e quebras de linha */ }

    /* Palavras Reservadas — devem vir ANTES de Identifier */
    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* Delimitadores e Pontuação */
    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }
    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    /* Operadores Relacionais — os de 2 chars devem vir ANTES de < > = */
    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }

    /* Atribuição — deve vir DEPOIS de == */
    "="             { return symbol(sym.ASSIGN); }

    /* Operadores Aritméticos */
    "+"             { return symbol(sym.ADD_OP, yytext()); }
    "-"             { return symbol(sym.ADD_OP, yytext()); }
    "*"             { return symbol(sym.MUL_OP, yytext()); }
    "/"             { return symbol(sym.MUL_OP, yytext()); }
    "%"             { return symbol(sym.MUL_OP, yytext()); }

    /* Identificadores com tamanho excessivo — deve vir ANTES de Identifier */
    {OversizedIdentifier} {
        throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext());
    }

    /* Identificadores e Números válidos */
    {Identifier}    { return symbol(sym.ID, yytext()); }
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    /* Erro léxico para qualquer caractere não reconhecido */
    .               { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }

    /* Fim de arquivo */
    <<EOF>>         { return symbol(sym.EOF); }
}
