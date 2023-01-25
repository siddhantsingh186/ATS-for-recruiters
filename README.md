# ATS-for-recruiters
### Repository for a management system on ATS for recruiters 
### Data Models and their Description -
### locations
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| country | [varchar(255), not null][PlGh]|
| state | [varchar(255), not null][PlGd] |
| city | [varchar(255), not null][PlOd] |

### addresses
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| location_id | [bigint, not null,foreign key][PlGh]|
| housenumber | [varchar(255), not null][PlGd] |
| pincode | [varchar(255), not null][PlOd] |

### users
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| name | [varchar(255), not null][PlGh]|
| email | [varchar(255), not null][PlGd] |
| password | [varchar(255), not null][PlOd] |
| addressid | [bigint, not null, foreign key][PlMe] |

### recruiters
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| userid | [bigint, foreign key][PlGh]|
| company_name | [varchar(255), not null][PlGd] |

### candidates
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| userid | [bigint, foreign key][PlGh]|
| resume_link | [varchar(255), not null][PlGd] |

### job_postings
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| recruiterid | [bigint, not null, foreign key][PlGh]|
| title | [varchar(255), not null][PlGh]|
| description | [varchar(255)][PlGd] |
| work_location | [varchar(255)][PlGh]|
| posting_date | [timestamp, not null][PlOd] |
| closing_date | [timestamp][PlMe] |
| job_state | [varchar(255),not null][PlGa] |
| posted_through | [varchar(255)][PlGa]|

### jobopening_levels
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| jobid | [bigint, not null, foreign key][PlGh]|
| seniority_level | [varchar(255), not null][PlGh]|
| worktype | [varchar(255), not null][PlGd] |
| skills | [varchar(255), not null][PlOd] |
| salary | [bigint, not null][PlMe] |
| interview_rounds | [bigint,not null][PlGa] |

### interview_stages
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| jobid | [bigint, not null, foreign key][PlGd] |
| levelid | [bigint, not null, foreign key][PlGh]|
| stage | [varchar(255), not null][PlGh]|
| description | [varchar(255), not null][PlGd] |

### job_contracts
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| jobid | [bigint, not null, foreign key][PlGd] |
| levelid | [bigint, not null, foreign key][PlGh]|
| candidateid | [bigint, not null, foreign key][PlGh]|
| startdate | [timestamp, not null][PlGh]|
| enddate | [timestamp, not null][PlGh]|
| terms | [varchar(255), not null][PlGh]|

### job_applications
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| jobid | [bigint, not null, foreign key][PlGd] |
| candidateid | [bigint, not null, foreign key][PlGh]|
| applied_date | [timestamp][PlGh]|
| documents | [varchar(255)][PlGh]|
| applied_state | [varchar(255)][PlGh]|
| last_updated | [timestamp, not null][PlGh]|

### job_interviews
| Fields | characteristics |
| ------ | ------ |
| id | [bigserial, primary key, not null][PlGh]|
| jobid | [bigint, not null, foreign key][PlGh]|
| applicationid | [bigint, not null, foreign key][PlGh]|
| stageid | [bigint, not null, foreign key][PlGh]|
| interview_date | [timestamp, not null][PlGd] |
| interviewer | [varchar(255), not null][PlOd] |
| interview_stage | [varchar(255), not null][PlMe] |
| meet_url | [varchar(255), not null][PlGa] |
| notes | [varchar(255)][PlGa]|



   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
