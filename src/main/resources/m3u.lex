package es.m3u_parser.lexer;

import es.m3u_parser.Channel;
import es.m3u_parser.M3uFile;
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
    Channel ch = new Channel();
    boolean spanishChannel = false;
    boolean spanishMovies = false;
    boolean onError = false;
    public M3uLexer() {
        super();
    }

    public void append(String text) {
        if (!onError) {
            sb.append(text);
        }
    }

    public void print() {
        if (!onError) {
           System.out.print(sb.toString());
        }
        reset();
    }

    public void reset() {
        sb = new StringBuffer();
        onError = false;
        spanishChannel = false;
        spanishMovies = false;
    }

    public void setError(String text) {
        onError = true;
        //System.out.println("ERROR: " + text);
        //System.out.println("spanishChannel=" + spanishChannel);
        //System.out.println("spanishMovies=" + spanishMovies);

    }

%}
%state EXTM3U
%state EXTINF
%state TVGNAME
%state TVGID
%state TVGLOGO
%state GROUP_TITLE
%state GROUP_TITLE_SPANISH
%state NAME
%state URL

AnyCharOrDigit  = [-'0-9a-zÀ-ÿ]
BlankSpace      = [ \t\r]+
NewLine         = \r|\n|\r\n
SpecialChar     = [+=/|:.@%()-–_#&çÇ$!\"\'`]
ExtinfValues    = (-1)|0
AnyVal          = \"(.*?)\"
BetweenQuotes   = \"[-'0-9a-zÀ-ÿ \t\r+=/|:.@%()-–_#&çÇ$!\'`]*\"
Comma           = ,
CommaAndAnyVal  = ","[-'0-9a-zÀ-ÿ \t\r+=/|:.@%()-–_#&çÇ$!\'`]*
SpanishChannel  = \"[-'0-9a-zÀ-ÿ \t\r+=/|:.@%()-–_#&çÇ$!\'`]*ES:[-'0-9a-zÀ-ÿ \t\r+=/|:.@%()-–_#&çÇ$!\'`]*\"
SpanishGT       = "\"Live: Spain\""
SpanishMoviesGT = "\"Movies: Spanish\""
VipEsName       = "VIP ES:"
EsName          = "ES:"
http            = "http://"[-'0-9a-zÀ-ÿ \t\r+=/|:.@%()-–_#&çÇ$!\'`]*
Name            = [-'0-9a-zÀ-ÿ \t\r+=/|:.@%()-–_#&çÇ$!\'`]*

%eofval{
        print();
        return 0;
%eofval}

%%
<YYINITIAL> {
"#EXTM3U"       { append(yytext()); yybegin(EXTM3U); }
"#EXTINF:"      { append(yytext()); yybegin(EXTINF); }
"tvg-ID="       { append(yytext()); yybegin(TVGID); }
"tvg-name="     { append(yytext()); yybegin(TVGNAME); }
"tvg-logo="     { append(yytext()); yybegin(TVGLOGO); }
"group-title="  { append(yytext()); yybegin(GROUP_TITLE); }
{CommaAndAnyVal} { /* ignore */ }
{http}          { /* ignore */ }
{NewLine}       { /* ignore */ }
}
<EXTM3U> {
{NewLine}   { append(yytext());  print(); yybegin(YYINITIAL); }
}
<EXTINF> {
{ExtinfValues}   { append(yytext()); }
{BlankSpace}     { append(yytext()); yybegin(YYINITIAL); }
}
<TVGID> {
{BetweenQuotes} { append(yytext()); }
{BlankSpace}    { append(yytext()); yybegin(YYINITIAL); }
}
<TVGNAME> {
{SpanishChannel} { spanishChannel = true;
                   append(yytext()); }
{BetweenQuotes}  { spanishChannel = false;
                   append(yytext());
                 }
{BlankSpace}     { append(yytext());
                   yybegin(YYINITIAL); }
}
<TVGLOGO> {
{BetweenQuotes} { append(yytext()); }
{BlankSpace}    { append(yytext());
                  yybegin(YYINITIAL);
                }
}
<GROUP_TITLE> {
{SpanishGT}      { spanishChannel = true;
                   append(yytext());
                   yybegin(GROUP_TITLE_SPANISH);
                 }
{SpanishMoviesGT} { spanishMovies = true;
                   append(yytext());
                   yybegin(GROUP_TITLE_SPANISH);
                 }
{BetweenQuotes} { setError("group-title" + yytext());
                  yybegin(YYINITIAL);}
}
<GROUP_TITLE_SPANISH> {
{Comma}         { append(yytext());
                  yybegin(NAME);
                }
}
<NAME> {
{VipEsName}      { /* remove */ }
{EsName}         { /* remove */ }
{Name}           { append(yytext());}
{NewLine}        { append(yytext());
                   yybegin(URL);
                 }
}
<URL> {
{http}           { append(yytext());}
{NewLine}        {
                  append(yytext());
                  print();
                  yybegin(YYINITIAL);
                 }
}
