package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.config.HibernateConfig;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.helper.NumberHelper;
import fpt.university.pbswebapi.service.CronJobService;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Repository
public class CustomRepository {
    private static final Logger logger = LoggerFactory.getLogger(CustomRepository.class);

    private static SessionFactory factory = HibernateConfig.getSessionFactory();

    private UserRepository userRepository;
    private CategoryRepository categoryRepository;
    private ServicePackageRepository packageRepository;
    private ReturningTypeRepository returningTypeRepository;
    private TimeLocationDetailRepository timeLocationDetailRepository;
    private BookingDetailRepository bookingDetailRepository;

    public CustomRepository(UserRepository userRepository, CategoryRepository categoryRepository, ServicePackageRepository packageRepository, ReturningTypeRepository returningTypeRepository, TimeLocationDetailRepository timeLocationDetailRepository, BookingDetailRepository bookingDetailRepository) {
        this.userRepository = userRepository;
        this.categoryRepository = categoryRepository;
        this.packageRepository = packageRepository;
        this.returningTypeRepository = returningTypeRepository;
        this.timeLocationDetailRepository = timeLocationDetailRepository;
        this.bookingDetailRepository = bookingDetailRepository;
    }

    public Float getSumPrice() {
        float result = (float) 0.0;
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select sum(price) " +
                    "from (" +
                    "select uu.id, uu.fullname, ifnull(avg(pb.package_price), 0) as price " +
                    "from users uu " +
                    "left join photographer_packages pb on uu.id = pb.photographer_id " +
                    "where uu.role_id=2 and pb.is_available=1 and uu.is_blocked=0 and uu.is_deleted=0 and uu.is_enabled=1 " +
                    "group by uu.id " +
                    ") as inner_query;";
            Query query = session.createSQLQuery(sql);
            BigDecimal bigDecimal = (BigDecimal) query.getSingleResult();
            result = bigDecimal.floatValue();

            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return result;
    }

    public Float getSumDistance(Double lat, Double lon) {
        float result = (float) 0.0;
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = MessageFormat.format("select sum(distance) " +
                    "from (" +
                    "SELECT min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) )" +
                    "                ) )) as distance " +
                    "                from users uu " +
                    "                left join locations lo on lo.user_id = uu.id " +
                    "                where uu.role_id = 2 and uu.is_enabled=1 and uu.is_blocked=0 and uu.is_deleted=0 " +
                    "                group by uu.id" +
                    ") as inner_query;", lat, lon);
            Query query = session.createSQLQuery(sql);
            Double queryResult = (double) query.getSingleResult();
            result = queryResult.floatValue();

            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return result;
    }

    // Query for multiple factor sorting
    public List<User> queryForMultipleFactorSorting(Double lat, Double lon) {
        List<User> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = MessageFormat.format("select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, ifnull(min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) )" +
                    "                ) )), (select sum(distance) from " +
                    "                (SELECT uu.id, uu.fullname, min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) ) " +
                    "                ) )) as distance " +
                    "                from users uu " +
                    "                left join locations lo on lo.user_id = uu.id " +
                    "                where uu.role_id = 2 and uu.is_enabled=1 and uu.is_blocked=0 and uu.is_deleted=0 " +
                    "                group by uu.id " +
                    ") as inner_query)) as distance, ifnull(avg(cc.rating), (select avg(co.rating) from booking_comments co)) as rating, ifnull(avg(pb.package_price), 0) as price from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "left join photographer_packages pb on uu.id = pb.photographer_id " +
                    "left join locations lo on lo.user_id = uu.id " +
                    "where uu.role_id=2 and pb.is_available=1 and uu.is_blocked=0 and uu.is_deleted=0 and uu.is_enabled=1 " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;", lat, lon);
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                User user = new User();
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setDistance(NumberHelper.format(Double.parseDouble(a[7].toString())));
                }
                if(a[8] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[8].toString())));
                }
                if(a[9] != null) {
                    user.setAveragePackagePrice(NumberHelper.format(Double.parseDouble(a[9].toString())));
                }
                results.add(user);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<User> queryForMultipleFactorSortingWhereCategory(Double lat, Double lon, Long category) {
        List<User> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = MessageFormat.format("select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, ifnull(min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) )" +
                    "                ) )), (select sum(distance) from " +
                    "                (SELECT uu.id, uu.fullname, min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) ) " +
                    "                ) )) as distance " +
                    "                from users uu " +
                    "                left join locations lo on lo.user_id = uu.id " +
                    "                where uu.role_id = 2 and uu.is_enabled=1 and uu.is_blocked=0 and uu.is_deleted=0 " +
                    "                group by uu.id " +
                    ") as inner_query)) as distance, ifnull(avg(cc.rating), (select avg(co.rating) from booking_comments co)) as rating, ifnull(avg(pb.package_price), 0) as price from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "left join photographer_packages pb on uu.id = pb.photographer_id " +
                    "left join locations lo on lo.user_id = uu.id " +
                    "where uu.role_id=2 and pb.is_available=1 and uu.is_blocked=0 and uu.is_deleted=0 and uu.is_enabled=1 " +
                    "and pb.category_id={2} and pb.photographer_id IS NOT NULL " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;", lat, lon, category);
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                User user = new User();
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setDistance(NumberHelper.format(Double.parseDouble(a[7].toString())));
                }
                if(a[8] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[8].toString())));
                }
                if(a[9] != null) {
                    user.setAveragePackagePrice(NumberHelper.format(Double.parseDouble(a[9].toString())));
                }
                results.add(user);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<User> queryForMultipleFactorSortingWhereCity(Double lat, Double lon, String city) {
        List<User> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = MessageFormat.format("select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, ifnull(min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) )" +
                    "                ) )), (select sum(distance) from " +
                    "                (SELECT uu.id, uu.fullname, min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) ) " +
                    "                ) )) as distance " +
                    "                from users uu " +
                    "                left join locations lo on lo.user_id = uu.id " +
                    "                where uu.role_id = 2 and uu.is_enabled=1 and uu.is_blocked=0 and uu.is_deleted=0 " +
                    "                group by uu.id " +
                    ") as inner_query)) as distance, ifnull(avg(cc.rating), (select avg(co.rating) from booking_comments co)) as rating, ifnull(avg(pb.package_price), 0) as price from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "left join photographer_packages pb on uu.id = pb.photographer_id " +
                    "left join locations lo on lo.user_id = uu.id " +
                    "where uu.role_id=2 and pb.is_available=1 and uu.is_blocked=0 and uu.is_deleted=0 and uu.is_enabled=1 " +
                    "and lo.formatted_address like ''%{2}%'' " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;", lat, lon, city);
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                User user = new User();
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setDistance(NumberHelper.format(Double.parseDouble(a[7].toString())));
                }
                if(a[8] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[8].toString())));
                }
                if(a[9] != null) {
                    user.setAveragePackagePrice(NumberHelper.format(Double.parseDouble(a[9].toString())));
                }
                results.add(user);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<User> queryForMultipleFactorSortingWhereCategoryAndCity(Double lat, Double lon, Long category, String city) {
        List<User> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = MessageFormat.format("select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, ifnull(min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) )" +
                    "                ) )), (select sum(distance) from " +
                    "                (SELECT uu.id, uu.fullname, min((6371 * acos( " +
                    "                cos( radians({0}) ) " +
                    "              * cos( radians( lo.latitude ) ) " +
                    "              * cos( radians( lo.longitude ) - radians({1}) ) " +
                    "              + sin( radians({0}) ) " +
                    "              * sin( radians( lo.latitude ) ) " +
                    "                ) )) as distance " +
                    "                from users uu " +
                    "                left join locations lo on lo.user_id = uu.id " +
                    "                where uu.role_id = 2 and uu.is_enabled=1 and uu.is_blocked=0 and uu.is_deleted=0 " +
                    "                group by uu.id " +
                    ") as inner_query)) as distance, ifnull(avg(cc.rating), (select avg(co.rating) from booking_comments co)) as rating, ifnull(avg(pb.package_price), 0) as price from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "left join photographer_packages pb on uu.id = pb.photographer_id " +
                    "left join locations lo on lo.user_id = uu.id " +
                    "where uu.role_id=2 and pb.is_available=1 and uu.is_blocked=0 and uu.is_deleted=0 and uu.is_enabled=1 " +
                    "and pb.category_id={2} and pb.photographer_id IS NOT NULL " +
                    "and lo.formatted_address like ''%{3}%'' " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;", lat, lon, category, city);
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                User user = new User();
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setDistance(NumberHelper.format(Double.parseDouble(a[7].toString())));
                }
                if(a[8] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[8].toString())));
                }
                if(a[9] != null) {
                    user.setAveragePackagePrice(NumberHelper.format(Double.parseDouble(a[9].toString())));
                }
                results.add(user);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<User> getAllByRating() {
        List<User> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, avg(cc.rating) as rating from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "where role_id=2 " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                User user = new User();
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[7].toString())));
                }
                results.add(user);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<Booking> queryBookingByStatusAndUserId(Long userId, String status) {
        List<Booking> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql =    "select b.id, b.booking_status, b.created_at, b.customer_canceled_reason, b.photographer_canceled_reason, b.price," +
                            "b.rejected_reason, b.service_name, b.updated_at, b.customer_id, b.photographer_id," +
                            "b.package_id, b.returning_type_id, b.edit_deadline, b.time_anticipate, b.returning_link, b.previous_status " +
                    "from bookings b " +
                    "where b.photographer_id = " + userId + " and b.booking_status like '" + status + "%' \n" +
                    "or b.customer_id = " + userId + " and b.booking_status like '" + status + "%'" +
                    "order by b.id desc, b.created_at desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> bookings = query.getResultList();

            for (Object[] a : bookings) {
                Booking booking = new Booking();
                booking.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    booking.setBookingStatus(EBookingStatus.valueOf(a[1].toString().toUpperCase()));
                if(a[2] != null)
                    booking.setCreatedAt(DateHelper.convertSQLDateViaString(a[2].toString()));
                if(a[3] != null)
                    booking.setCustomerCanceledReason(a[3].toString());
                if(a[4] != null)
                    booking.setPhotographerCanceledReason(a[4].toString());
                if(a[5] != null)
                    booking.setPrice(Integer.parseInt(a[5].toString()));
                if(a[6] != null)
                    booking.setRejectedReason(a[6].toString());
                if(a[7] != null) {
                    booking.setServiceName(a[7].toString());
                }
                if(a[8] != null) {
                    booking.setUpdatedAt(DateHelper.convertSQLDateViaString(a[8].toString()));
                }
                if(a[9] != null) {
                    Long customerId = Long.parseLong(a[9].toString());
                    User customer = userRepository.findById(customerId).get();
                    booking.setCustomer(customer);
                }
                if(a[10] != null) {
                    Long photographerId = Long.parseLong(a[10].toString());
                    User photographer = userRepository.findById(photographerId).get();
                    booking.setPhotographer(photographer);
                }
                if(a[11] != null) {
                    Long packageId = Long.parseLong(a[11].toString());
                    ServicePackage servicePackage = packageRepository.findById(packageId).get();
                    booking.setServicePackage(servicePackage);
                }
                if(a[12] != null) {
                    Integer returningTypeId = Integer.parseInt(a[12].toString());
                    ReturningType returningType = returningTypeRepository.findById(returningTypeId);
                    booking.setReturningType(returningType);
                }
                if(a[13] != null) {
                    booking.setEditDeadline(DateHelper.convertSQLDateViaString(a[13].toString()));
                }
                if(a[14] != null) {
                    booking.setTimeAnticipate(Integer.parseInt(a[14].toString()));
                }
                if(a[15] != null) {
                    booking.setReturningLink(a[15].toString());
                }
                if(a[16] != null) {
                    booking.setPreviousStatus(EBookingStatus.valueOf(a[16].toString().toUpperCase()));
                }
                booking.setTimeLocationDetails(timeLocationDetailRepository.findAllByBookingId(booking.getId()));
                booking.setBookingDetails(bookingDetailRepository.findAllByBookingId(booking.getId()));
                results.add(booking);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public User findOne(Long id) {
        User user = new User();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, avg(cc.rating) as rating from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "where role_id=2 and uu.id = " + id + " " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[7].toString())));
                }
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return user;
    }

    public List<User> findPhotographersInCityOrderByRating(String city) {
        List<User> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, avg(cc.rating) as rating from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "inner join locations lo on lo.user_id = uu.id " +
                    "where role_id=2 and lo.formatted_address like '%" + city +"%' " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                User user = new User();
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[7].toString())));
                }
                results.add(user);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<User> findPhotographersByCategorySortByRating(long categoryId) {
        List<User> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, avg(cc.rating) as rating from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "inner join photographer_packages package on package.photographer_id = uu.id " +
                    "inner join categories category on category.id = package.category_id " +
                    "where role_id=2 and category.id=" + categoryId + " " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                User user = new User();
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[7].toString())));
                }
                results.add(user);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<User> findPhotographersByCategoryAndCitySortByRating(String city, long categoryId) {
        List<User> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select uu.id, uu.avatar, uu.description, uu.email, uu.fullname, uu.username, uu.cover, avg(cc.rating) as rating from users uu " +
                    "left join bookings bb on bb.photographer_id = uu.id " +
                    "left join booking_comments cc on cc.booking_id = bb.id " +
                    "inner join photographer_packages package on package.photographer_id = uu.id " +
                    "inner join categories category on category.id = package.category_id " +
                    "inner join locations lo on lo.user_id = uu.id " +
                    "where role_id=2 and category.id=" + categoryId + " and lo.formatted_address like '%" + city + "%' " +
                    "group by uu.id " +
                    "order by (" +
                    "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = uu.id " +
                    ") desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> users = query.getResultList();

            for (Object[] a : users) {
                User user = new User();
                user.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    user.setAvatar(a[1].toString());
                if(a[2] != null)
                    user.setDescription(a[2].toString());
                if(a[3] != null)
                    user.setEmail(a[3].toString());
                if(a[4] != null)
                    user.setFullname(a[4].toString());
                if(a[5] != null)
                    user.setUsername(a[5].toString());
                if(a[6] != null)
                    user.setCover(a[6].toString());
                if(a[7] != null) {
                    user.setRatingCount(NumberHelper.format(Float.parseFloat(a[7].toString())));
                }
                results.add(user);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public Double getRatingCount(long userId) {
        Double result = 0.0;
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select avg(c.rating) from booking_comments c " +
                    "inner join bookings b on b.id = c.booking_id " +
                    "inner join users u on u.id = photographer_id " +
                    "where u.id = "+ userId +";";
            Query query = session.createSQLQuery(sql);
            result = NumberHelper.format((Double) query.getSingleResult());

            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return result;
    }

    public List<Album> getAlbumSortByLikes() {
        List<Album> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select al.*, count(ca.album_id) as likecount from albums al " +
                    "left join customers_albums ca on ca.album_id = al.id " +
                    "where al.is_deleted=false " +
                    "group by al.id " +
                    "order by (" +
                    "select count(*) from customers_albums where album_id=al.id" +
                    ") desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> albums = query.getResultList();

            for (Object[] a : albums) {
                Album album = new Album();
                album.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    album.setCreatedAt((Date) a[1]);
                if(a[2] != null)
                    album.setDescription(a[2].toString());
                if(a[3] != null)
                    album.setIsActive((Boolean) a[3]);
                if(a[4] != null)
                    album.setName(a[4].toString());
                if(a[5] != null)
                    album.setThumbnail(a[5].toString());
                if(a[6] != null) {
                    Long photographerId = Long.parseLong(a[6].toString());
                    album.setPhotographer(userRepository.findById(photographerId).get());
                }
                if(a[9] != null) {
                    Long categoryId = Long.parseLong(a[9].toString());
                    album.setCategory(categoryRepository.findById(categoryId).get());
                }
                if(a[10] != null)
                    album.setIsDeleted((Boolean) a[10]);
                if(a[11] != null) {
                    album.setLikes(Integer.parseInt(a[11].toString()));
                }
                results.add(album);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<Album> getAlbumByCategorySortByLikes(Long category) {
        List<Album> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select al.*, count(ca.album_id) as likecount from albums al " +
                    "left join customers_albums ca on ca.album_id = al.id " +
                    "where al.is_deleted=false and al.category_id=" + category + " " +
                    "group by al.id " +
                    "order by (" +
                    "select count(*) from customers_albums where album_id=al.id " +
                    ") desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> albums = query.getResultList();

            for (Object[] a : albums) {
                Album album = new Album();
                album.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    album.setCreatedAt((Date) a[1]);
                if(a[2] != null)
                    album.setDescription(a[2].toString());
                if(a[3] != null)
                    album.setIsActive((Boolean) a[3]);
                if(a[4] != null)
                    album.setName(a[4].toString());
                if(a[5] != null)
                    album.setThumbnail(a[5].toString());
                if(a[6] != null) {
                    Long photographerId = Long.parseLong(a[6].toString());
                    album.setPhotographer(userRepository.findById(photographerId).get());
                }
                if(a[9] != null) {
                    Long categoryId = Long.parseLong(a[9].toString());
                    album.setCategory(categoryRepository.findById(categoryId).get());
                }
                if(a[10] != null)
                    album.setIsDeleted((Boolean) a[10]);
                if(a[11] != null) {
                    album.setLikes(Integer.parseInt(a[11].toString()));
                }
                results.add(album);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<Album> getAlbumSortByLikes(Long photographerId) {
        List<Album> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select al.*, count(ca.album_id) as likecount from albums al " +
                    "left join customers_albums ca on ca.album_id = al.id " +
                    "where al.is_deleted=false and al.photographer_id=" + photographerId + " " +
                    "group by al.id " +
                    "order by (" +
                    "select count(*) from customers_albums where album_id=al.id" +
                    ") desc;";
            Query query = session.createSQLQuery(sql);
            List<Object []> albums = query.getResultList();

            for (Object[] a : albums) {
                Album album = new Album();
                album.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    album.setCreatedAt((Date) a[1]);
                if(a[2] != null)
                    album.setDescription(a[2].toString());
                if(a[3] != null)
                    album.setIsActive((Boolean) a[3]);
                if(a[4] != null)
                    album.setName(a[4].toString());
                if(a[5] != null)
                    album.setThumbnail(a[5].toString());
                if(a[6] != null) {
                    album.setPhotographer(userRepository.findById(photographerId).get());
                }
                if(a[9] != null) {
                    Long categoryId = Long.parseLong(a[9].toString());
                    album.setCategory(categoryRepository.findById(categoryId).get());
                }
                if(a[10] != null)
                    album.setIsDeleted((Boolean) a[10]);
                if(a[11] != null) {
                    album.setLikes(Integer.parseInt(a[11].toString()));
                }
                results.add(album);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public List<Image> getImageOfAlbum(Long albumId) {
        List<Image> results = new ArrayList<>();
        Session session = factory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            String sql = "select i.* from images i " +
                    "inner join albums_images ai on ai.image_id = i.id " +
                    "where ai.album_id =" + albumId +";";
            Query query = session.createSQLQuery(sql);
            List<Object []> images = query.getResultList();

            for (Object[] a : images) {
                Image image = new Image();
                image.setId(Long.parseLong(a[0].toString()));
                if(a[1] != null)
                    image.setComment(a[1].toString());
                if(a[2] != null)
                    image.setCreatedAt((Date) a[2]);
                if(a[3] != null)
                    image.setDescription(a[3].toString());
                if(a[4] != null)
                    image.setImageLink(a[4].toString());
                results.add(image);
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return results;
    }

    public int likeAlbum(Long albumId, Long userId) {
        Session session = factory.openSession();
        Transaction transaction = null;

        int result = 0;

        try {
            transaction = session.beginTransaction();
            String sql = "INSERT INTO customers_albums (album_id, user_id) " +
                    "SELECT * FROM (SELECT " + albumId + ", "+ userId +") AS tmp " +
                    "WHERE NOT EXISTS (" +
                    "    SELECT album_id, user_id FROM customers_albums where album_id = "+ albumId + " and user_id = "+ userId + " " +
                    ") LIMIT 1;";
            Query query = session.createSQLQuery(sql);
            result = query.executeUpdate();

            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return result;
    }

    public int unlikeAlbum(Long albumId, Long userId) {
        Session session = factory.openSession();
        Transaction transaction = null;

        int result = 0;

        try {
            transaction = session.beginTransaction();
            String sql = "delete from customers_albums where album_id = "+ albumId + " and user_id = "+ userId + " ";
            Query query = session.createSQLQuery(sql);
            result = query.executeUpdate();

            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return result;
    }

    public int isLike(Long albumId, Long userId) {
        Session session = factory.openSession();
        Transaction transaction = null;

        int result = 0;

        try {
            transaction = session.beginTransaction();
            String sql = "select * from customers_albums where album_id = "+ albumId + " and user_id = "+ userId + " ";
            Query query = session.createSQLQuery(sql);
            result = query.getResultList().size();

            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return result;
    }

    public int login(String username) {
        Session session = factory.openSession();
        Transaction transaction = null;
        int result = 0;

        try {
            transaction = session.beginTransaction();
            String sql = "select * from users where username=" + username +" and is_blocked != 1;";
            Query query = session.createSQLQuery(sql);
            if(query.getResultList().size()  > 0) {
                result = 1;
            }
            transaction.commit();
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
        return result;
    }

    public int setExpiredPendingBookingAfter24Hours() {
        Session session = factory.openSession();
        Transaction transaction = null;

        int result = 0;

        try {
            transaction = session.beginTransaction();
            String sql = "update bookings b " +
                    "set b.booking_status = 'EXPIRED', b.previous_status = 'PENDING', b.rejected_reason = 'Đã quá 24 giờ' " +
                    "where b.booking_status = 'PENDING' and datediff(b.created_at, now()) != 0;";
            Query query = session.createSQLQuery(sql);
            result = query.executeUpdate();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            logger.error(e.getMessage());
        } finally {
            session.close();
        }
        return result;
    }

}
