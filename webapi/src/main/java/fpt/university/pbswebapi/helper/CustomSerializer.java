package fpt.university.pbswebapi.helper;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import fpt.university.pbswebapi.domain.Portfolio;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CustomSerializer extends StdSerializer<List<Portfolio>> {
    public CustomSerializer() {
        this(null);
    }

    public CustomSerializer(Class<List<Portfolio>> t) {
        super(t);
    }

    @Override
    public void serialize(List<Portfolio> portfolios, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException {
        List<Long> ids = new ArrayList<>();
        for (Portfolio portfolio : portfolios) {
            ids.add(portfolio.getId());
        }
        jsonGenerator.writeObject(ids);
    }
}
