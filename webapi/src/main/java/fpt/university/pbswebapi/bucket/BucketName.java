package fpt.university.pbswebapi.bucket;

public enum BucketName {
    PROFILE_IMAGE("pbs-image-storage");

    private final String bucketName;

    BucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    public String getBucketName() {
        return bucketName;
    }
}
