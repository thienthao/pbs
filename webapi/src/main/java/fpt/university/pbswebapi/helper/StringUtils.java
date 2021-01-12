package fpt.university.pbswebapi.helper;

import org.ahocorasick.trie.Emit;
import org.ahocorasick.trie.Trie;

import java.util.Arrays;
import java.util.Collection;

public class StringUtils {

    public static final String PASSWORD_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$";
    public static final String EMAIL_REGEX = "^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$";
    public static final String PHONE_REGEX = "(84|0[3|5|7|8|9])+([0-9]{8,9})";
    public static final String FULL_NAME_REGEX =
            "[A-Za-zàáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ ]+";

    public static boolean ContainsWord(String input, String[] words) {
        String str = input.replace("Vietnam", "");
        Trie trie = Trie.builder().onlyWholeWords().addKeywords(words).build();

        Collection<Emit> emits = trie.parseText(str);

        boolean found = false;
        for (String word : words) {
            boolean contains = Arrays.toString(emits.toArray()).contains(word);
            if (contains) {
                found = true;
                break;
            }
        }

        return found;
    }

}
