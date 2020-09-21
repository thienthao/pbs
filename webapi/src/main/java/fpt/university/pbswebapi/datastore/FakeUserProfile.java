package fpt.university.pbswebapi.datastore;

import fpt.university.pbswebapi.domain.UserProfile;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class FakeUserProfile {
    private static final List<UserProfile> USER_PROFILES = new ArrayList<>();

    static {
        USER_PROFILES.add(new UserProfile(UUID.fromString("c08ee498-30a2-44a8-b7c6-682797928c64"), "thao tran", null));
        USER_PROFILES.add(new UserProfile(UUID.fromString("3700c3f1-2fe5-434b-97bc-4dec053912a2"), "dat bo", null));
        USER_PROFILES.add(new UserProfile(UUID.fromString("f862cb85-c3c7-4cf1-8b51-f63ec9a771ce"), "kien dao", null));
    }

    public List<UserProfile> getUserProfiles() {
        return USER_PROFILES;
    }
}
