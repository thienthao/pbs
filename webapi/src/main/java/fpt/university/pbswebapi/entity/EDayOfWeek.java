package fpt.university.pbswebapi.entity;

public enum EDayOfWeek {
    Sunday(1),
    Monday(2),
    Tuesday(3),
    Wednesday(4),
    Thursday(5),
    Friday(6),
    Saturday(7);

    private final int value;

    EDayOfWeek(int value) {
        this.value = value;
    }

    public int getValue() { return value; }
}
