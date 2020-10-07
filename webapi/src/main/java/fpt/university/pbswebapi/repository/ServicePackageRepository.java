package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.ServicePackage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ServicePackageRepository extends JpaRepository<ServicePackage, Long> {
    Page<ServicePackage> findByNameContaining(String name, Pageable pageable);

    @Query("FROM ServicePackage p where p.photographer.id = :ptgId")
    Page<ServicePackage> findServicePackageByPtgId(Long ptgId, Pageable pageable);

    @Query("FROM ServicePackage p where p.photographer.id = :ptgId and p.name LIKE :name")
    Page<ServicePackage> findServicePackageByPtgIdAndByNameContaining(String name, Long ptgId, Pageable pageable);
}
