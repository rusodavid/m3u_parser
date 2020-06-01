package es.m3u_parser.lexer;

%%

%public
%class M3uLexer
%final
%unicode
%char
%standalone

%{
    /**
     * Create an empty lexer, yyrset will be called later to reset and assign
     * the reader
     */
    StringBuffer sb = new StringBuffer();
    public M3uLexer() {
        super();
    }

%}
%state EXTM3U
%state EXTINF
%state TVGNAME
%state TVGID
%state TVGLOGO
%state GROUPTITLE
%state NAME
%state URL

AnyCharOrDigit  = [-'0-9a-zÀ-ÿ]
BlankSpace      = [ \t\r]+
NewLine         = \r|\n|\r\n
SpecialChar     = [+=/|:.@%()-–_#&çÇ$!\"\'`]
ExtinfValues    = (-1)|0
SpanishChannel  = \"(.*?)ES:(.*?)\"
AnyValue        = \"(.*?)\"
Comma           = ,

%%
<YYINITIAL> {
"^#EXTM3U"        { System.out.print(yytext());}
"^(?!#EXTM3U)"    { yybegin(URL); }
"#EXTINF:"        { System.out.print(yytext());
                    yybegin(EXTINF);
                    }
"tvg-ID="         { System.out.print(yytext());
                    yybegin(TVGID);
                  }
"tvg-name="       { System.out.print(yytext());
                    yybegin(TVGNAME);
                  }

"tvg-logo="       { System.out.print(yytext());
                    yybegin(TVGLOGO);
                  }
"group-title="    { System.out.print(yytext());
                    yybegin(GROUPTITLE);
                  }
{BlankSpace}     { System.out.print(yytext()); }
}

<EXTM3U> {
{NewLine}   { System.out.print(yytext());
                   yybegin(YYINITIAL);}
}

<EXTINF> {
{ExtinfValues}   { System.out.print(yytext());
                   yybegin(YYINITIAL);}
}

<TVGID> {
{AnyValue} { System.out.print(yytext()); }
{BlankSpace} { yybegin(YYINITIAL);}
}

<TVGNAME> {
{SpanishChannel} { System.out.print(yytext());}
{BlankSpace}     { yybegin(YYINITIAL);}
}

<TVGLOGO> {
{AnyValue} { System.out.print(yytext()); yybegin(YYINITIAL);}
{BlankSpace}     { yybegin(YYINITIAL);}
}

<GROUPTITLE> {
{AnyValue}      { System.out.print(yytext()); }
{BlankSpace}    { System.out.print(yytext()); }
{Comma }        { System.out.print(yytext()); yybegin(NAME);}
}

<NAME> {
{AnyCharOrDigit} { yybegin(YYINITIAL);}
{BlankSpace}     { yybegin(YYINITIAL);}
{SpecialChar}    { yybegin(YYINITIAL);}
{NewLine}        { System.out.print(yytext()); yybegin(URL); }
}

<URL> {
{AnyCharOrDigit} { yybegin(YYINITIAL);}
{BlankSpace}     { yybegin(YYINITIAL);}
{NewLine}        {
                    System.out.print(yytext());
                    yybegin(YYINITIAL);
                 }
{SpecialChar}    { yybegin(YYINITIAL);}
}
