package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.datastore.FakeUserProfile;
import fpt.university.pbswebapi.domain.UserProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class UserProfileRepository {
    private final FakeUserProfile fakeUserProfile;

    @Autowired
    public UserProfileRepository(FakeUserProfile fakeUserProfile) {
        this.fakeUserProfile = fakeUserProfile;
    }

    public List<UserProfile> getUserProfile() {
        return fakeUserProfile.getUserProfiles();
    }
}
