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
}
