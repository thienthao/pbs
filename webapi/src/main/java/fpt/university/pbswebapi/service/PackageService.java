package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.ServicePackage;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.ServicePackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class PackageService {


    private final ServicePackageRepository packageRepository;
    private final BookingRepository bookingRepository;

    @Autowired
    public PackageService(ServicePackageRepository packageRepository, BookingRepository bookingRepository) {
        this.packageRepository = packageRepository;
        this.bookingRepository = bookingRepository;
    }

    public ServicePackage createPackage(ServicePackage servicePackage) {
        servicePackage.setIsAvailable(Boolean.TRUE);
        return packageRepository.save(servicePackage);
    }

    public Object removePackage(Long packageId) {
        if(bookingRepository.countPackageBeingUsed(packageId) > 0) {
            return ResponseEntity.badRequest().body("Bạn không thể xóa gói dịch vụ này đang được sử dụng bởi khách hàng!");
        }
        ServicePackage servicePackage = packageRepository.findById(packageId).get();
        servicePackage.setIsAvailable(Boolean.FALSE);
        return packageRepository.save(servicePackage);
    }
}
