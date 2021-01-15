package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Variable;
import fpt.university.pbswebapi.repository.VariableRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VariableService {

    private VariableRepository variableRepository;

    @Autowired
    public VariableService(VariableRepository variableRepository) {
        this.variableRepository = variableRepository;
    }

    public List<Variable> findAll() {
        return variableRepository.findAll();
    }


    public boolean saveAll(Float rating, Float price, Float distance) {
        if ((rating + price + distance) != 1) {
            return false;
        } else {
            Variable priceVar = variableRepository.findById(Long.parseLong("1")).get();
            priceVar.setWeight(price);
            variableRepository.save(priceVar);
            Variable ratingVar = variableRepository.findById(Long.parseLong("2")).get();
            ratingVar.setWeight(rating);
            variableRepository.save(ratingVar);
            Variable distanceVar = variableRepository.findById(Long.parseLong("3")).get();
            distanceVar.setWeight(distance);
            variableRepository.save(distanceVar);
            return true;
        }
    }

    public Variable findById(long id) {
        return variableRepository.findById(id).get();
    }
}
