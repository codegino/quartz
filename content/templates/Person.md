---
company: 
location: 
title: 
email: 
phone: 
aliases: 
languages:
  - English
date_last_spoken: 
birthday: 
type: person
---
# [[<% tp.file.title %>]]

<% await tp.file.move("/people/" + tp.file.title) %>

```dataview
TABLE date as "Date",summary as "Summary" from "meetings"
where contains(type, "meeting") and contains(attendees, [[<% tp.file.title %>]])
sort date desc
```