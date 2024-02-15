---
fields:
  - name: attendees
    type: Multi
    options:
      valuesList: {}
      sourceType: ValuesFromDVQuery
      valuesListNotePath: test/Sample Peeps.md
      valuesFromDVQuery: dv.pages('"people"').map(p => [p.file.link])
    path: ""
    id: eJZOiW
    display: asList
  - name: summary
    type: Input
    options: {}
    path: ""
    id: 2kvW2A
  - name: date
    type: DateTime
    options:
      dateFormat: YYYY-MM-DD
      defaultInsertAsLink: "false"
    path: ""
    id: 16pMS3
version: "2.46"
limit: 20
mapWithTag: true
icon: package
tagNames: 
filesPaths: 
bookmarksGroups: 
excludes: 
extends: 
savedViews: []
favoriteView: 
fieldsOrder:
  - 16pMS3
  - 2kvW2A
  - eJZOiW
---
