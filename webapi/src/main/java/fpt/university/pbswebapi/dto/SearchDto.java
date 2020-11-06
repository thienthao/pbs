package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.ServicePackage;
import fpt.university.pbswebapi.entity.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SearchDto {

    private List<User> photographers;

    private List<ServicePackage> packages;
}
