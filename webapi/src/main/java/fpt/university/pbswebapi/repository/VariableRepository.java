package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Variable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VariableRepository extends JpaRepository<Variable, Long> {

    Variable findByVariableName(String name);
}
