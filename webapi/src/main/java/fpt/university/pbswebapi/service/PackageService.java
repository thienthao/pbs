package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.ServicePackage;
import fpt.university.pbswebapi.repository.ServicePackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PackageService {

    @Autowired
    private ServicePackageRepository packageRepository;

    public PackageService(ServicePackageRepository packageRepository) {
        this.packageRepository = packageRepository;
    }

    public ServicePackage createPackage(ServicePackage servicePackage) {
        return packageRepository.save(servicePackage);
    }

    public Object removePackage(Long packageId) {
        ServicePackage servicePackage = packageRepository.findById(packageId).get();
        servicePackage.setIsAvailable(Boolean.TRUE);
        return packageRepository.save(servicePackage);
    }
}
