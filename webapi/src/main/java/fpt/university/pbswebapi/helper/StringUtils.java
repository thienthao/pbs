package fpt.university.pbswebapi.helper;

import org.ahocorasick.trie.Emit;
import org.ahocorasick.trie.Trie;

import java.util.Arrays;
import java.util.Collection;

public class StringUtils {

    public static boolean ContainsWord(String input, String[] words) {
        String str = input.replace("Vietnam", "");
        Trie trie = Trie.builder().onlyWholeWords().addKeywords(words).build();

        Collection<Emit> emits = trie.parseText(str);

        boolean found = false;
        for(String word : words) {
            boolean contains = Arrays.toString(emits.toArray()).contains(word);
            if (contains) {
                found = true;
                break;
            }
        }

        return found;
    }

}
