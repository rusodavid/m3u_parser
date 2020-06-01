package es.m3u_parser;


import es.m3u_parser.lexer.M3uLexer;

import java.io.*;

public class Main {

    public static void main(String args[]) {

        if (args.length != 1) {
            System.out.println("Usage: java [-options] -jar jarfile filename");
            return;
        }
        String fileName = args[0];
        if (fileName == null) {
            fileName = "src/test/resources/tv_channels_jgN34XEfA0_plus.m3u";
        }
        String ruta = new File("src/main/resources/m3u.lex").getPath();

        Reader reader = null;
        try {
            reader = new FileReader(fileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        M3uLexer m3ulexer = new M3uLexer(reader);
        try {
            m3ulexer.yylex();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
