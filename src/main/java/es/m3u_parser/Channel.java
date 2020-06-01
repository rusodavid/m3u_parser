package es.m3u_parser;

import lombok.Builder;
import lombok.Data;

@Data
public class Channel {
    String extinf;
    String tvgId;
    String tvgName;
    String tvgLogo;
    String groupTitle;
    String name;
    String url;

    @Builder(builderMethodName = "builder")
    public static Channel newChannel() {
        Channel channel = new Channel();
        return channel;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(extinf);
        sb.append(tvgId);
        sb.append(tvgName);
        sb.append(tvgLogo);
        sb.append(groupTitle);
        sb.append(name);
        sb.append(url);

        return sb.toString();
    }
}
