package fpt.university.pbswebapi.dto;

public class AlbumDto {
    private String name;
    private Long ptgId;

    public AlbumDto(String name, Long ptgId) {
        this.name = name;
        this.ptgId = ptgId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getPtgId() {
        return ptgId;
    }

    public void setPtgId(Long ptgId) {
        this.ptgId = ptgId;
    }
}
