package com.proteingallery.util;

public class JsonUtil {

    public static String quote(String text) {
        if (text == null) {
            return "null";
        }
        String escaped = text.replace("\\", "\\\\")
                             .replace("\"", "\\\"")
                             .replace("\n", "\\n")
                             .replace("\r", "\\r")
                             .replace("\t", "\\t");
        return '"' + escaped + '"';
    }

    public static String object(String... entries) {
        StringBuilder builder = new StringBuilder("{");
        for (int i = 0; i < entries.length; i++) {
            builder.append(entries[i]);
            if (i < entries.length - 1) {
                builder.append(',');
            }
        }
        builder.append('}');
        return builder.toString();
    }

    public static String array(String... items) {
        StringBuilder builder = new StringBuilder("[");
        for (int i = 0; i < items.length; i++) {
            builder.append(items[i]);
            if (i < items.length - 1) {
                builder.append(',');
            }
        }
        builder.append(']');
        return builder.toString();
    }
}
