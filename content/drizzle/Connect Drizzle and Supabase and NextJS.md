---
title: Connect Drizzle and Supabase
---

## Links
- https://orm.drizzle.team/docs/get-started-postgresql#supabase
- https://supabase.com/docs/guides/database/connecting-to-postgres#connecting-with-drizzle

## Notes
- When transaction is set to true, copy the correct port
- Strict drizzle config don't allow `serial` type when running `drizzle-kit`


### Authentication Flow
- Frontend login using supabase client
- When making HTTP request from from FE to BE
	- FE will get the supabase access token(JWT)
	- FE will send a request togethen will access token attached to a header
	- BE will get the header
	- BE will verify the JWT using the JWT secret provided by supabase
	- If valid, BE will perform the request and respond to FE