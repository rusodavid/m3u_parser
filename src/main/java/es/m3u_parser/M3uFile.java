package es.m3u_parser;


import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Data
public class M3uFile {
    String extm3u;
    List<Channel> channels;

    @Builder(builderMethodName = "builder")
    public static M3uFile newM3uFile() {
        M3uFile file = new M3uFile();
        file.channels = new ArrayList<>();
        return file;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(extm3u);
        channels.stream().forEach(ch->sb.append(ch.toString()));
        return sb.toString();
    }

}
