package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.PhotographerInfoDto;
import fpt.university.pbswebapi.dto.SearchDto;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.helper.DtoMapper;
import fpt.university.pbswebapi.repository.ServicePackageRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import fpt.university.pbswebapi.service.PhotographerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/photographers")
public class PhotographerController {
    private final UserRepository photographerRepository;
    private final ServicePackageRepository packageRepository;
    private final PhotographerService phtrService;

    @Autowired
    public PhotographerController(UserRepository photographerRepository, ServicePackageRepository packageRepository, PhotographerService phtrService) {
        this.photographerRepository = photographerRepository;
        this.packageRepository = packageRepository;
        this.phtrService = phtrService;
    }

    @GetMapping
    public ResponseEntity<List<User>> findAll() {
        return new ResponseEntity<List<User>>(phtrService.findAllPhotographers(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<?> updateProfile(@RequestBody User user) {
        return new ResponseEntity<>(phtrService.updateProfile(user), HttpStatus.OK);
    }

    @GetMapping("/byrating")
    public ResponseEntity<Map<String, Object>> findPhotographersByRatingCount(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size,
            @RequestParam(defaultValue = "1") long categoryId,
            @RequestParam(defaultValue = "0") double lat,
            @RequestParam(defaultValue = "0") double lon,
            @RequestParam(defaultValue = "") String city
    ) {
        try {
            Pageable paging = PageRequest.of(page, size);
            Page<User> pageUser;

            if(categoryId == 1) {
                pageUser = phtrService.findPhotographersByRating(paging, city);
            } else {
                pageUser = phtrService.findPhotographersByCategorySortByRating(paging, categoryId, city);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("users", pageUser.getContent());
            response.put("currentPage", pageUser.getNumber());
            response.put("totalItems", pageUser.getTotalElements());
            response.put("totalPages", pageUser.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            System.out.println(e);
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/byfactors")
    public ResponseEntity<Map<String, Object>> findPhotographersByFactors(@RequestParam(name = "lat", defaultValue = "10.7757") double lat,
                                                                          @RequestParam(name = "long", defaultValue = "106.7004") double lon) {
        try {
            List<User> photographers = phtrService.findPhotographersByFactors(lat, lon);

            Map<String, Object> response = new HashMap<>();
            response.put("users", photographers);
//            response.put("currentPage", 0);
//            response.put("totalItems", 0);
//            response.put("totalPages", pageUser.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            System.out.println(e);
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

//    @GetMapping("/{name}")
//    public ResponseEntity<List<Photographer>> findAllByNameContaining(@PathVariable String name) {
//        return new ResponseEntity<List<Photographer>>(phtrService.findAllByNameContaining(name), HttpStatus.OK);
//    }

    @GetMapping("/{id}")
    public ResponseEntity<?> findOne(@PathVariable("id") Long id) {
        return new ResponseEntity<>(DtoMapper.toPhotographerDto(phtrService.findOne(id)), HttpStatus.OK);
    }

    @GetMapping("/{id}/split")
    public ResponseEntity<?> findOneSplited(@PathVariable("id") Long id) {
        return new ResponseEntity<>(DtoMapper.toSplitedPhotographerDto(phtrService.findOne(id)), HttpStatus.OK);
    }

    @GetMapping("/{id}/packages")
    public ResponseEntity<Map<String, Object>> findPackagesByPtgId(
            @PathVariable("id") Long id,
            @RequestParam(required = false) String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        try {
            List<ServicePackage> packages = new ArrayList<ServicePackage>();
            Pageable paging = PageRequest.of(page, size);

            Page<ServicePackage> pagePackages;
            if(name == null)
                pagePackages = packageRepository.findServicePackageByPtgId(id, paging);
            else
                pagePackages = packageRepository.findServicePackageByPtgIdAndByNameContaining(name, id, paging);

            packages = pagePackages.getContent();
            Map<String, Object> response = new HashMap<>();
            response.put("packages", packages);
            response.put("currentPage", pagePackages.getNumber());
            response.put("totalItems", pagePackages.getTotalElements());
            response.put("totalPages", pagePackages.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{ptgId}/busydays")
    public ResponseEntity<?> getBusyDays(@RequestParam(value = "from", defaultValue = "") String from,
                                         @RequestParam(value = "to", defaultValue = "") String to,
                                         @PathVariable("ptgId") Long ptgId) {
        if(from.equalsIgnoreCase("") && to.equalsIgnoreCase("")) {
            return new ResponseEntity<>(phtrService.getBusyDays(ptgId), HttpStatus.OK);
        }
        return new ResponseEntity<>(phtrService.getBusyDays(ptgId, from, to), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/busydays/since")
    public ResponseEntity<?> getBusyDaysSince(@RequestParam("since") String since,
                                              @PathVariable("ptgId") Long ptgId) {
        return new ResponseEntity<>(phtrService.getBusyDaysSince(ptgId, since), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/days")
    public ResponseEntity<?> getUnavailableDays(@PathVariable("ptgId") Long ptgId) {
        return new ResponseEntity<>(phtrService.getUnavailableDays(ptgId), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/schedule")
    public ResponseEntity<?> getSchedule(@PathVariable("ptgId") Long ptgId) {
        return new ResponseEntity<>(phtrService.getSchedule(ptgId), HttpStatus.OK);
    }

    // Search photographer by fullname and packagename
    @GetMapping("/search")
    public ResponseEntity<?> searchPhotographer(@RequestParam(value = "search", defaultValue = "") String search,
                                                @RequestParam(value = "page", defaultValue = "0") int page,
                                                @RequestParam(value = "size", defaultValue = "10") int size) {
        // query photographer containing name
        // query package containing name
        SearchDto searchDto = phtrService.searchPhotographer(search, page, size);
        // return 1 object co 2 property la list photographer va list package
        return new ResponseEntity<>(searchDto, HttpStatus.OK);
    }

    @PostMapping(value = "/{id}/upload",
                consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> uploadAvatar(@PathVariable("id") String id,
                                          @RequestParam("file") MultipartFile file) {
        //check ptgId
        if(!photographerRepository.findById(Long.parseLong(id)).isPresent())
            throw new BadRequestException("Photographer not exists");
        String fullpath = phtrService.uploadAvatar(id, file);
        if(fullpath != null) {
            return new ResponseEntity<>(fullpath, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Fail", HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping(value = "/{id}/cover/upload",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> uploadCover(@PathVariable("id") String id,
                                          @RequestParam("file") MultipartFile file) {
        //check ptgId
        if(!photographerRepository.findById(Long.parseLong(id)).isPresent())
            throw new BadRequestException("Photographer not exists");
        String fullpath = phtrService.uploadCover(id, file);
        if(fullpath != null) {
            return new ResponseEntity<>(fullpath, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Fail", HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/{ptgId}/busydays")
    public ResponseEntity<?> addBusyDays(@PathVariable("ptgId") Long ptgId, @RequestBody BusyDay busyDay) {
        return new ResponseEntity<>(phtrService.addBusyDays(ptgId, busyDay), HttpStatus.OK);
    }

    @DeleteMapping("/{ptgId}/busydays/{busyDayId}")
    public ResponseEntity<?> deleteBusyDays(@PathVariable("ptgId") Long ptgId, @PathVariable("busyDayId") long busyDayId) {
        return new ResponseEntity<>(phtrService.deleteBusyDay(busyDayId), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/busydays/json")
    public ResponseEntity<?> testBusyDays(@PathVariable("ptgId") Long ptgId) {
        return new ResponseEntity<>(phtrService.testBusyDays(ptgId), HttpStatus.OK);
    }

    @GetMapping(value = "/{id}/download",
                produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] downloadAvatar(@PathVariable("id") String id) {
        return phtrService.downloadAvatar(id);
    }

    @GetMapping(value = "/{id}/cover/download",
            produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] downloadCover(@PathVariable("id") String id) {
        return phtrService.downloadCover(id);
    }

    @GetMapping("/fakeAvatar")
    public void fake(@RequestParam MultipartFile[] file) {
        int i = 0;
        for(User user : phtrService.findAllPhotographers()) {
            phtrService.fakeAvatar(user.getId(), file[i]);
            i++;
        }
    }

    @GetMapping("/fakeCover")
    public void fakeCover(@RequestParam MultipartFile[] file) {
        int i = 0;
        for(User user : phtrService.findAllPhotographers()) {
            phtrService.fakeCover(user.getId(), file[i]);
            i++;
        }
    }

    @GetMapping("/fakeCustomerAvatar")
    public void fakeCustomerAvatar(@RequestParam MultipartFile[] file) {
        int i = 0;
        for(User user : phtrService.findAllCustomers()) {
            phtrService.fakeAvatar(user.getId(), file[i]);
            i++;
        }
    }

    // api get lich (sau khi them goi nhieu ngay)
    @GetMapping("/{ptgId}/calendar")
    public ResponseEntity<?> getCalendar(@PathVariable("ptgId") long ptgId) {
        return new ResponseEntity<>(phtrService.getCalendar(ptgId), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/calendar/for-customer")
    public ResponseEntity<?> getCalendarForCustomer(@PathVariable("ptgId") long ptgId) {
        return new ResponseEntity<>(phtrService.getCalendarForCustomer(ptgId), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/on-day")
    public ResponseEntity<?> getPhotographerEventOnDay(@PathVariable("ptgId") long ptgId, @RequestParam("date") String date) {
        return new ResponseEntity<>(phtrService.getPhotographerEventOnDay(ptgId, date), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/on-day/for-customer")
    public ResponseEntity<?> getPhotographerEventOnDayForCustomer(@PathVariable("ptgId") long ptgId, @RequestParam("date") String date) {
        return new ResponseEntity<>(phtrService.getPhotographerEventOnDayForCustomer(ptgId, date), HttpStatus.OK);
    }

    @PostMapping("/{ptgId}/working-days")
    public ResponseEntity<?> editWorkingDay(@PathVariable("ptgId") long ptgId, @RequestBody List<DayOfWeek> dows) {
        return new ResponseEntity<>(phtrService.editWorkingDay(ptgId, dows), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/working-days")
    public ResponseEntity<?> getWorkingDay(@PathVariable("ptgId") long ptgId) {
        return new ResponseEntity<>(phtrService.getWorkingDay(ptgId), HttpStatus.OK);
    }

    @PutMapping
    public ResponseEntity<?> editProfile(@RequestBody PhotographerInfoDto photographerDto) {
        return new ResponseEntity<>(phtrService.editInfo(photographerDto), HttpStatus.OK);
    }

    @GetMapping("/{ptgId}/locations")
    public ResponseEntity<?> getPhotographerLocations(@PathVariable long ptgId) {
        return new ResponseEntity<>(phtrService.getPhotographerLocations(ptgId), HttpStatus.OK);
    }

    @PostMapping("/locations")
    public ResponseEntity<?> addLocation(@RequestBody Location location) {
        return new ResponseEntity<>(phtrService.addLocation(location), HttpStatus.OK);
    }
}
