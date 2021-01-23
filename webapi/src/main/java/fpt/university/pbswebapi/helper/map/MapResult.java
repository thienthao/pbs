package fpt.university.pbswebapi.helper.map;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class MapResult {

    @JsonProperty("results")
    private Object results;

    public MapResult() {
    }

    public MapResult(Object results) {
        this.results = results;
    }

    public Object getResults() {
        return results;
    }

    public void setResults(Object results) {
        this.results = results;
    }
}
