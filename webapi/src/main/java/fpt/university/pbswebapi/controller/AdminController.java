package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.CancelledBooking;
import fpt.university.pbswebapi.dto.UserBookingInfo;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.helper.DtoMapper;
import fpt.university.pbswebapi.repository.*;
import fpt.university.pbswebapi.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private static DecimalFormat df = new DecimalFormat("#.##");

    private CategoryRepository categoryRepository;
    private ReturningTypeRepository returningTypeRepository;
    private UserRepository userRepository;
    private UserService userService;
    private ThreadService threadService;
    private BookingService bookingService;
    private CancellationService cancellationService;
    private VariableService variableService;
    private BookingRepository bookingRepository;
    private RatingService ratingService;
    private ReportService reportService;
    private CategoryService categoryService;
    private ThreadTopicRepository threadTopicRepository;

    @Autowired
    public AdminController(CategoryRepository categoryRepository, ReturningTypeRepository returningTypeRepository, UserRepository userRepository, UserService userService, ThreadService threadService, BookingService bookingService, CancellationService cancellationService, VariableService variableService, BookingRepository bookingRepository, RatingService ratingService, ReportService reportService, CategoryService categoryService, ThreadTopicRepository threadTopicRepository) {
        this.categoryRepository = categoryRepository;
        this.returningTypeRepository = returningTypeRepository;
        this.userRepository = userRepository;
        this.userService = userService;
        this.threadService = threadService;
        this.bookingService = bookingService;
        this.cancellationService = cancellationService;
        this.variableService = variableService;
        this.bookingRepository = bookingRepository;
        this.ratingService = ratingService;
        this.reportService = reportService;
        this.categoryService = categoryService;
        this.threadTopicRepository = threadTopicRepository;
    }

    @GetMapping("/login")
    public String login(Model model, String error, String logout) {
        return "admin-rework/login";
    }

    @RequestMapping({"/dashboard", "/"})
    public String dashboard(Model model) {
        return "admin-refactor/admin-layout";
    }

    @RequestMapping("/users/add")
    public String userAdd() {
        return "admin/user-add";
    }

    @RequestMapping("/users")
    public String userList(Model model) {
        model.addAttribute("users", userRepository.findAll());
        return "admin-rework/user-list";
    }

    @GetMapping(value = {"/users/{userId}/edit"})
    public String showEditUserPage(Model model, @PathVariable long userId) {
        User user = null;
        List<Booking> userBooking = null;
        List<CancelledBooking> cancelledBooking = new ArrayList<>();
        UserBookingInfo userBookingInfo = new UserBookingInfo();
        try {
            user = userRepository.findById(userId).get();
            userBooking = bookingRepository.findAllByUserId(userId);
            List<Booking> cancelledBookingtmp = bookingRepository.findCancelledBookingsOf(userId);

            int numOfCancelled = 0;
            for (Booking booking : userBooking) {
                if (booking.getBookingStatus() == EBookingStatus.CANCELED) {
                    numOfCancelled += 1;
                }
            }

            double cancellationRate = 0.0;
            if (userBooking.size() > 0) {
                cancellationRate = ((double) numOfCancelled / (double) userBooking.size()) * 100;
            }

            for (Booking cancelled : cancelledBookingtmp) {
                cancelledBooking.add(DtoMapper.toCancelledBooking(cancelled));
            }
            cancellationRate = Double.parseDouble(df.format(cancellationRate));
            userBookingInfo.setNumOfBooking(userBooking.size());
            userBookingInfo.setNumOfCancelled(numOfCancelled);
            cancellationRate = Double.parseDouble(df.format(cancellationRate));
            userBookingInfo.setCancellationRate(cancellationRate);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMessage", "User Not Found");
        }
        model.addAttribute("add", false);
        model.addAttribute("user", user);
        model.addAttribute("booking", userBooking);
        model.addAttribute("info", userBookingInfo);
        model.addAttribute("cancelled", cancelledBooking);
        return "admin-rework/user-detail";
    }

    @PostMapping(value = {"/users/{userId}/block"})
    public String blockUser(
            Model model, @PathVariable long userId) {
        try {
            userService.blockUser(userId);
            String uri = "admin/users/" + userId + "/edit";
            model.addAttribute("errorMessage", "Blocked");
            return "redirect:/" + uri;
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            logger.error(errorMessage);
            model.addAttribute("errorMessage", errorMessage);
            return "/admin/user-edit";
        }
    }

    @PostMapping(value = {"/users/{userId}/unblock"})
    public String unblockUser(
            Model model, @PathVariable long userId) {
        try {
            userService.unblockUser(userId);
            String uri = "admin/users/" + userId + "/edit";
            model.addAttribute("errorMessage", "Blocked");
            return "redirect:/" + uri;
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            logger.error(errorMessage);
            model.addAttribute("errorMessage", errorMessage);
            return "/admin/user-edit";
        }
    }

    @RequestMapping("/returningTypes")
    public String returningTypeList(Model model) {
        model.addAttribute("returningTypes", returningTypeRepository.findAll());
        return "admin-rework/returning-list";
    }

    @RequestMapping("/variable")
    public String getVariablePage(Model model) {
        model.addAttribute("variable", variableService.findAll());
        return "admin-rework/variable-list";
    }

    @PostMapping("/variable")
    public String changeVariable(ArrayList<Variable> variable) {
        for (Variable var : variable) {
            System.out.println(var.getWeight());
            System.out.println(var.getVariableName());
        }
        return "admin-rework/variable-list";
    }

    @GetMapping(value = {"/returningTypes/{returningTypeId}/edit"})
    public String showReturningTypePage(Model model, @PathVariable int returningTypeId) {
        ReturningType returningType = null;
        try {
            returningType = returningTypeRepository.findById(returningTypeId);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Resource Not Found");
        }
        model.addAttribute("add", false);
        model.addAttribute("returningType", returningType);
        return "admin/returning-type-edit";
    }

    @RequestMapping("/categories")
    public String categoriesList(Model model) {
        model.addAttribute("categories", categoryRepository.findAll());
        return "admin-rework/category-list";
    }

    @RequestMapping("/categories/add")
    public String categoriesAdd(Model model) {
        model.addAttribute("categories", categoryRepository.findAll());
        return "admin/category-add";
    }

//    @GetMapping("/threads")
//    public String showThreadsPage(Model model) {
//        model.addAttribute("threads", threadService.all());
//        return "admin-rework/thread-list";
//    }

    @GetMapping("/threads")
    public String showThreadsPage1(Model model) {
        model.addAttribute("threads", threadService.all());
        return "admin-rework/thread-list-1";
    }

    @GetMapping("/threads/{id}")
    public String showThreadDetail(Model model, @PathVariable long id) {
        model.addAttribute("thread", threadService.findById(id));
        return "admin-rework/thread-detail";
    }

    @GetMapping("/threads/add")
    public String showAddThreadPage(Model model) {
        model.addAttribute("threads", threadService.all());
        model.addAttribute("topic", threadService.allTopics());
        return "admin-rework/thread-add";
    }

    @GetMapping("/threads/topics")
    public String showThreadTopicsPage(Model model) {
        model.addAttribute("topics", threadService.allTopics());
        return "admin-rework/topic-list";
    }

    @GetMapping(value = {"/threads/{threadId}/ban"})
    public RedirectView banThread(
            Model model, @PathVariable long threadId) {
        try {
            threadService.banThread(threadId);
            String uri = "/admin/threads/" + threadId;
            model.addAttribute("errorMessage", "Blocked");
            return new RedirectView(uri);
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            logger.error(errorMessage);
            model.addAttribute("errorMessage", errorMessage);
            return new RedirectView("/admin/threads");
        }
    }

    @GetMapping(value = {"/threads/{threadId}/unban"})
    public RedirectView unbanThread(
            Model model, @PathVariable long threadId) {
        try {
            threadService.unbanThread(threadId);
            String uri = "/admin/threads/" + threadId;
            model.addAttribute("errorMessage", "Blocked");
            return new RedirectView(uri);
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            logger.error(errorMessage);
            model.addAttribute("errorMessage", errorMessage);
            return new RedirectView("/admin/threads");
        }
    }

    @GetMapping("/ratings")
    public String showRatingList(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @RequestParam(defaultValue = "not_solve") String filter, Model model) {
        model.addAttribute("page", ratingService.getAll(pageable));
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("filter", filter);
        model.addAttribute("size", pageable.getPageSize());
        return "/admin-refactor/rating-list :: content";
    }

    @GetMapping("/v2/threads")
    public String showThreadList(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @RequestParam(defaultValue = "not_solve") String filter, Model model) {
        model.addAttribute("page", threadService.findAll(pageable, start, end, filter));
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("filter", filter);
        model.addAttribute("size", pageable.getPageSize());
        return "/admin-refactor/thread-list :: content";
    }

    @GetMapping("/v2/threads/{id}")
    public String showThreadDetail(Model model, @PathVariable Long id) {
        model.addAttribute("thread", threadService.findById(id));
        return "admin-refactor/thread-detail :: content";
    }

    @PostMapping("/v2/threads/{threadId}/unban")
    public String unbanThreadV2(@PathVariable Long threadId, Model model) {
        try {
            threadService.unbanThread(threadId);
            model.addAttribute("thread", threadService.findById(threadId));
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return "admin-refactor/thread-detail :: content";
    }

    @PostMapping("/v2/threads/{threadId}/ban")
    public String banThreadV2(@PathVariable Long threadId, Model model) {
        try {
            threadService.banThread(threadId);
            model.addAttribute("thread", threadService.findById(threadId));
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return "admin-refactor/thread-detail :: content";
    }

    @GetMapping("/cancellations")
    public String showCancellationList(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @RequestParam(defaultValue = "not_solve") String filter, Model model) {
        model.addAttribute("page", cancellationService.getCancellations(pageable, start, end, filter));
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("filter", filter);
        model.addAttribute("size", pageable.getPageSize());
        return "/admin-refactor/cancellation-list :: content";
    }

    @GetMapping("/cancellations/{id}")
    public String showCancellationDetail(Model model, @PathVariable Long id) {
        model.addAttribute("cancellation", cancellationService.findById(id));
        return "admin-refactor/cancellation-detail :: content";
    }

    @PostMapping("/cancellations/{id}")
    public String showCancellationDetailAfterApprove(Model model, @PathVariable Long id) {
        cancellationService.approve(id);
        model.addAttribute("cancellation", cancellationService.findById(id));
        return "admin-refactor/cancellation-detail :: content";
    }

    @PostMapping("/cancellations-warn/{id}")
    public String warnAndShowCancellationDetail(@PathVariable Long id) {
//        cancellationService.warn(id);
        return "admin-refactor/cancellation-detail :: content";
    }

    @GetMapping("/bookings/{bookingId}")
    public String showBookingDetail(@PathVariable Long bookingId, @RequestParam(value = "cancellationId", required = false) Long cancellationId, Model model) {
        if (cancellationId != null) {
            model.addAttribute("cancellation", cancellationService.findById(cancellationId));
        }
        model.addAttribute("booking", bookingRepository.findById(bookingId).get());
        return "admin-refactor/booking-detail :: content";
    }

    @GetMapping("/reports")
    public String showReportList(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @RequestParam(defaultValue = "not_solve") String filter, Model model) {
        model.addAttribute("page", reportService.getAll(pageable));
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("filter", filter);
        model.addAttribute("size", pageable.getPageSize());
        return "admin-refactor/report-list :: content";
    }

    @GetMapping("/reports/{id}")
    public String showReportDetail(Model model, @PathVariable Long id) {
        model.addAttribute("report", reportService.findById(id));
        return "admin-refactor/report-detail :: content";
    }

    @GetMapping("/bookings")
    public String showBookingList(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @RequestParam(defaultValue = "not_solve") String filter, Model model) {
        model.addAttribute("page", bookingService.findAll(pageable));
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("filter", filter);
        model.addAttribute("size", pageable.getPageSize());
        return "/admin-refactor/booking-list :: content";
    }

    @GetMapping("/v2/users")
    public String showUserListV2(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, Model model, @RequestParam(name = "role", defaultValue = "all") String role) {
//        model.addAttribute("bookingInfo", bookingService.getBookingInfo(userId));
//        if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")) {
//            model.addAttribute("page", bookingService.findAllByUserIdAndStatus(userId, pageable, status));
//        } else {
//            model.addAttribute("page", bookingService.findAllByUserIdAndStatusBetweenDate(userId, pageable, status, start, end));
//        }
        model.addAttribute("page", userService.getUserList(pageable, start, end, role));
        model.addAttribute("size", pageable.getPageSize());
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("role", role);
        return "admin-refactor/user-list :: content";
    }

    @GetMapping("/categories")
    public String showCategoryList(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @RequestParam(defaultValue = "not_solve") String filter, Model model) {
        model.addAttribute("page", categoryService.getAll(pageable));
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("filter", filter);
        model.addAttribute("size", pageable.getPageSize());
        return "/admin-refactor/category-list :: content";
    }

    @GetMapping("/returning-types")
    public String showReturningTypeList(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @RequestParam(defaultValue = "not_solve") String filter, Model model) {
        model.addAttribute("page", returningTypeRepository.findAll(pageable));
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("filter", filter);
        model.addAttribute("size", pageable.getPageSize());
        return "/admin-refactor/returning-type-list :: content";
    }

    @GetMapping("/topics")
    public String showTopicList(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @RequestParam(defaultValue = "not_solve") String filter, Model model) {
        model.addAttribute("page", threadTopicRepository.findAll(pageable));
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        model.addAttribute("filter", filter);
        model.addAttribute("size", pageable.getPageSize());
        return "/admin-refactor/topic-list :: content";
    }

    @GetMapping("/v2/users/{userId}")
    public String showUserDetailV2(@PageableDefault(size = 10) Pageable pageable, @RequestParam(defaultValue = "") String start, @RequestParam(defaultValue = "") String end, @PathVariable Long userId, Model model, @RequestParam(value = "status", defaultValue = "ALL") String status) {
        model.addAttribute("bookingInfo", bookingService.getBookingInfo(userId));
        model.addAttribute("user", userRepository.findById(userId).get());
        if (start.equalsIgnoreCase("") || end.equalsIgnoreCase("")) {
            model.addAttribute("page", bookingService.findAllByUserIdAndStatus(userId, pageable, status));
        } else {
            model.addAttribute("page", bookingService.findAllByUserIdAndStatusBetweenDate(userId, pageable, status, start, end));
        }
        model.addAttribute("size", pageable.getPageSize());
        model.addAttribute("status", status);
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        return "admin-refactor/user-detail :: content";
    }

    @PostMapping("/v2/users/{userId}/block")
    public String blockUserV2(@PathVariable Long userId, Model model) {
        try {
            userService.blockUser(userId);
            model.addAttribute("bookingInfo", bookingService.getBookingInfo(userId));
            model.addAttribute("user", userRepository.findById(userId).get());
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return "admin-refactor/user-detail :: content";
    }

    @PostMapping("/v2/users/{userId}/unblock")
    public String unblockUserV2(@PathVariable Long userId, Model model) {
        try {
            userService.unblockUser(userId);
            model.addAttribute("bookingInfo", bookingService.getBookingInfo(userId));
            model.addAttribute("user", userRepository.findById(userId).get());
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return "admin-refactor/user-detail :: content";
    }

    @PostMapping("/v2/users/{userId}/enable")
    public String enableUserV2(@PathVariable Long userId, Model model) {
        //block
        try {
            userService.enable(userId);
            model.addAttribute("bookingInfo", bookingService.getBookingInfo(userId));
            model.addAttribute("user", userRepository.findById(userId).get());
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return "admin-refactor/user-detail :: content";
    }

    @GetMapping("/variables")
    public String showVariableDetail(Model model) {
        model.addAttribute("price", variableService.findById(Long.parseLong("1")));
        model.addAttribute("rating", variableService.findById(Long.parseLong("2")));
        model.addAttribute("distance", variableService.findById(Long.parseLong("3")));
        return "admin-refactor/variable-detail :: content";
    }

    @PostMapping("/variables")
    public String updateVariable(@RequestParam Float rating, @RequestParam Float price, @RequestParam Float distance) {
        variableService.saveAll(rating, price, distance);
        return "admin-refactor/variable-detail :: content";
    }


    @RequestMapping("/content")
    public String loadContent() {
        return "/admin-refactor/index";
    }

    @RequestMapping("/content1")
    public String getContent1() {
        return "/admin-refactor/content :: content1";
    }

    @RequestMapping("/content2")
    public String getContent2() {
        return "/admin-refactor/content :: content2";
    }
}
