package fpt.university.pbswebapi.helper;

import org.ahocorasick.trie.Emit;
import org.ahocorasick.trie.Trie;
import org.passay.CharacterData;
import org.passay.CharacterRule;
import org.passay.EnglishCharacterData;
import org.passay.PasswordGenerator;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.Collection;

public class StringUtils {

    public static final String URL_PREFIX = "/api";
    // Note: If changing password regex, remember to modify password generator to match that regex
    public static final String PASSWORD_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$";
    public static final String EMAIL_REGEX = "^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$";
    public static final String PHONE_REGEX = "(84|0[3|5|7|8|9])+([0-9]{8,9})";
    public static final String FULL_NAME_REGEX =
            "[A-Za-zàáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ ]+";
    public static final String ERROR_CODE = "ERRONEOUS_SPECIAL_CHARS";

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

    public static String getBaseUrl(HttpServletRequest request) {
        String requestUrl = request.getRequestURL().toString();
        return requestUrl.substring(0, requestUrl.indexOf(URL_PREFIX) + URL_PREFIX.length());
    }

    public static String generateRandomPassword() {
        PasswordGenerator generator = new PasswordGenerator();
        CharacterRule lowerCaseRule = new CharacterRule(EnglishCharacterData.LowerCase);
        lowerCaseRule.setNumberOfCharacters(2);

        CharacterRule upperCaseRule = new CharacterRule(EnglishCharacterData.UpperCase);
        upperCaseRule.setNumberOfCharacters(2);

        CharacterRule digitRule = new CharacterRule(EnglishCharacterData.Digit);
        digitRule.setNumberOfCharacters(2);

        CharacterData specialChars = new CharacterData() {
            public String getErrorCode() {
                return ERROR_CODE;
            }

            public String getCharacters() {
                return "@$!%*#?&";
            }
        };
        CharacterRule specialCharsRule = new CharacterRule(specialChars);
        specialCharsRule.setNumberOfCharacters(2);

        String password = generator.generatePassword(8, specialCharsRule, lowerCaseRule, upperCaseRule, digitRule);
        return password;
    }
}
