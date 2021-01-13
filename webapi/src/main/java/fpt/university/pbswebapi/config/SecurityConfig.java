package fpt.university.pbswebapi.config;

import fpt.university.pbswebapi.security.jwt.AuthEntryPointJwt;
import fpt.university.pbswebapi.security.jwt.AuthTokenFilter;
import fpt.university.pbswebapi.security.services.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.BeanIds;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(
        securedEnabled = true,
        jsr250Enabled = true,
        prePostEnabled = true
)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    private static final String[] AUTH_WHITELIST = {
            // -- swagger ui
            "/v2/api-docs",
            "/swagger-resources",
            "/swagger-resources/**",
            "/swagger-ui.html",
            "/resources/**"
    };

    @Autowired
    UserDetailsServiceImpl userDetailsService;

    @Autowired
    private AuthEntryPointJwt unauthorizedHandler;

    @Bean
    public AuthTokenFilter authenticationJwtTokenFilter() {
        return new AuthTokenFilter();
    }

    @Override
    public void configure(AuthenticationManagerBuilder authenticationManagerBuilder) throws Exception {
        authenticationManagerBuilder
                .userDetailsService(userDetailsService)
                .passwordEncoder(passwordEncoder());
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

//    @Bean
//    public UserDetailsService userDetailsService() {
//        Properties users = null;
//        try {
//            users = PropertiesLoaderUtils.loadAllProperties("users.properties");
//        } catch (Exception e) {
//            System.out.println(e.toString());
//        }
//        return new InMemoryUserDetailsManager(users);
//    }


    @Bean(BeanIds.AUTHENTICATION_MANAGER)
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .requestMatchers(req-> req.getRequestURI().contains("images")).permitAll()
                .requestMatchers(req-> req.getRequestURI().contains("download")).permitAll()
                .requestMatchers(req-> req.getRequestURI().contains("upload")).permitAll()
                .requestMatchers(req-> req.getRequestURI().contains("cover")).permitAll();
        http.cors().and().csrf().disable()
                .exceptionHandling().authenticationEntryPoint(unauthorizedHandler)
                .and()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests().antMatchers("/api/auth/**").permitAll()
//                .antMatchers("/api/test/**").permitAll()
//                .antMatchers("/api/albums/**").permitAll()
                .antMatchers("/api/categories/**").permitAll()
//                .antMatchers("/api/photographers/**").permitAll()
//                .antMatchers("/api/**").permitAll()
                .antMatchers("/admin/**").permitAll()
                .antMatchers("/api/users/**").permitAll()
                .antMatchers("/resources/**").permitAll()
                .antMatchers("/auth/**").permitAll()
                .antMatchers(
                        HttpMethod.GET,
                        "/",
                        "/csrf",
                        "/service-status/v1/task/status",
                        "/swagger-ui.html",
                        "/*.html",
                        "/*.js",
                        "/favicon.ico",
                        "/**/*.html",
                        "/**/*.css",
                        "/**/*.png",
                        "/webjars/**",
                        "/configuration/**",
                        "/v2/**",
                        "/swagger-resources/**",
                        "/**/*.js"
                ).permitAll()
                .anyRequest().authenticated()
                    .and()
                .formLogin()
                    .loginPage("/admin/login")
                    .permitAll()
                    .and()
                .logout()
                    .permitAll();
        http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().antMatchers(AUTH_WHITELIST);
    }
}