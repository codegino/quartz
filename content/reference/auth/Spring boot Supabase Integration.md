To use Supabase for authentication in your Java Spring Boot app, you can follow the steps below:

1. **Set Up a Supabase Project**: First, you need to set up a Supabase project. You can start with the free starter version and eventually switch to a paid account or set up your own self-hosted version [22] [23] .
    
2. **Configure Environment Values**: Set the following environment values so that Maven and Spring Boot can find them:
    
    - `SUPABASE_DATABASE_URL`: jdbc:postgresql://db.PROJECT.supabase.co/postgres
    - `SUPABASE_DATABASE_USER`: postgres
    - `SUPABASE_DATABASE_PASSWORD`: Same as your Supabase login password
    - `SUPABASE_URL`: [https://PROJECT.supabase.co](https://project.supabase.co/)
    - `SUPABASE_ANON_KEY`: A JWT with the role of anon. Verify it at [jwt.io](https://jwt.io/)
    - `SUPABASE_JWT_SIGNER`: The top-secret key used for signing JWT from Supabase. Do not share this [16] [19] .
3. **Integrate Supabase with Spring Boot**: You can use Supabase as the core for RDBMS, authentication, and storage in your Spring Boot application. This project specifically uses Supabase for authentication, including seamless Spring Security support, and as a hosted Postgres instance [26] .
    
4. **Use Supabase JWT for Authorization**: The project defaults to turning off Java sessions to improve ease of scaling and uses Supabase JWT for authorization. You can use service-level Spring Boot caching instead of the session API to take the load off a database [15] .
    
5. **Handle Authentication Flows**: The project includes JavaScript to handle the forgot password flow and provides logged-in Supabase information both via standard Spring Security and via a bean wrapper, making it easier to work with in Thymeleaf [20] .
    
6. **Remember Me Feature**: If you want to implement a “Remember Me” feature, you can store the JWT in a cookie, which will then allow the server to immediately render the logged-in user as long as the JWT has not expired. You can extend the JWT session by changing the JWT expiry settings in Supabase’s Authentication settings [23] .
    
7. **Database Configuration**: By default, the template points to the Supabase table and expects to find a user table and a todo table. You can create a matching table or delete the todo entity and query files if you are just playing around [25] .
    
8. **IntelliJ Setup**: Make sure to set up the Web module in IntelliJ to point at the src/main/resources/public directory to avoid errors related to paths in IntelliJ [21] .


## Links

https://github.com/ChangeNode/spring-boot-supabase
https://github.com/tschuehly/htmx-supabase-spring-boot-starter



