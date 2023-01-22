create table locations (
  id bigserial primary key,
  country varchar(255) not null,
  state varchar(255) not null,
  city varchar(255) not null,
  unique (country,state,city)
);

create table addresses(
  id bigserial primary key not null,
  location_id bigint not null,
  housenumber varchar(255) not null,
  pincode varchar(255) not null,
  foreign key (location_id) references locations(id) on delete set null
);

create table users(
  id bigserial primary key not null,
  name varchar(255),
  email varchar(255) unique,
  password varchar(255),
  phoneno varchar(255),
  addressid bigint references addresses(id) on delete set null,
  check (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

create table recruiters (
    id bigserial primary key not null,
    company_name varchar(255) not null
) inherits (users);

create table candidates (
    id bigserial primary key not null,
    resume_link varchar(255) not null
) inherits (users);

create table job_postings(
  id bigserial primary key not null,
  recruiterid bigint not null,
  title varchar(255) not null,
  description varchar(255),
  work_location varchar(255),
  posting_date timestamp not null default now(),
  job_status varchar(255) not null,
  closing_date timestamp,
  posted_through varchar(255),
  check (job_status in ('open','closed')),
  foreign key (recruiterid) references recruiters(id) on delete set null
);

create table jobopening_levels(
  id bigserial primary key not null,
  jobid bigint not null references job_postings(id),
  seniority_level varchar(255) not null,
  worktype varchar(255) not null,
  skills varchar(255) not null,
  salary bigint not null,
  check (seniority_level in ('Entry level','Mid-Senior Level','Senior Level')),
  check (worktype in ('Hybrid' , 'Remote', 'Onsite')),
  interview_rounds bigint not null
);

create table interview_stages(
  id bigserial primary key not null,
  jobid bigint not null references job_postings(id),
  levelid bigint not null references jobopening_levels(id),
  stage varchar(255) not null,
  check (stage in ('Technical','HR','Managerial')),
  description varchar(255)
);

create table job_contracts(
  id bigserial primary key not null,
  jobid bigint not null references job_postings(id),
  levelid bigint not null references jobopening_levels(id),
  candidateid bigint not null references candidates(id),
  startdate timestamp not null,
  enddate timestamp not null,
  terms varchar(255) not null
);

create table job_applications(
  id bigserial primary key not null,
  jobid bigint not null references job_postings(id),
  candidateid bigint not null references candidates(id),
  applied_date timestamp,
  documents varchar(255),
  applied_status varchar(255),
  last_updated timestamp not null default now()
);

create table job_interviews(
  id bigserial primary key not null,
  jobid bigint not null references job_postings(id),
  applicationid bigint not null references job_applications(id),
  stageid bigint not null references interview_stages(id),
  interview_date timestamp not null,
  interviewer varchar(255) not null,
  meet_url varchar(255) not null,
  notes varchar(255)
);



##Query 1 for job id 10;
SELECT c.name, c.email, c.phoneno, c.resume_link, a.applied_date, a.applied_status
FROM job_applications a
JOIN candidates c ON a.candidateid = c.id
WHERE a.jobid = 10;

##Query 2 for input search 'io'
SELECT c.name, c.email, j.title as job_title
FROM candidates c
JOIN job_applications a ON c.id = a.candidateid
JOIN job_postings j ON a.jobid = j.id
WHERE c.email ILIKE '%io%' OR c.name ILIKE '%io%' OR j.title ILIKE '%io%';

##Query 3 is pending
WITH last_6_months AS (
    SELECT date_trunc('month', NOW()) - INTERVAL '6 month' as start_date,
           date_trunc('month', NOW()) as end_date
)

SELECT
(SELECT COUNT(*) FROM job_openings WHERE job_postings.posting_date BETWEEN last_6_months.start_date AND last_6_months.end_date) AS job_openings_created,
(SELECT COUNT(*) from job_openings WHERE ((job_postings.posting_date <= last_6_months.end_date ) OR (job_postings.posting_date >= last_6_months.start_date AND job_postings.posting_date <= last_6_months.end_date)) AND  job_postings.job_status = 'closed') AS job_openings_closed,
(SELECT COUNT(*) FROM job_applications WHERE job_applications.applied_date BETWEEN last_6_months.start_date AND last_6_months.end_date) AS job_applications_received,
(SELECT COUNT(*) FROM job_applications WHERE job_applications.applied_date BETWEEN last_6_months.start_date AND last_6_months.end_date AND job_applications.status = 'Recruited') AS number_of_candidates_recruited,
(SELECT COUNT(*) FROM job_applications WHERE job_applications.applied_date BETWEEN last_6_months.start_date AND last_6_months.end_date AND job_applications.status = 'Rejected') AS number_of_candidates_rejected,
(SELECT COUNT(*) FROM job_application WHERE job_applications.jobid IN (SELECT job_postings.id FROM job_postings WHERE job_postings.posting_date BETWEEN last_6_months.start_date AND last_6_months.end_date))/
(SELECT COUNT(*) FROM job_postings WHERE job_postings.posting_date BETWEEN last_6_months.start_date AND last_6_months.end_date) AS average_applications_per_job_opening;

##Query 4
SELECT j.title as job_title, s.stage as stage_name
FROM candidates c
join job_applications a on c.id = a.candidateid
join job_postings j on a.jobid = j.id 
join job_interviews i on a.id = i.applicationid
join interview_stages s on i.stageid = s.id
where c.id = 10;

##Query 5
SELECT j.title as job_title, s.stage as stage_name, count(s.stage) as number_of_candidates
FROM job_postings j
join job_applications a on j.id = a.jobid
join job_interviews i on a.id = i.applicationid
join interview_stages s on i.stageid = s.id
where j.id = 10
GROUP BY s.stage, j.title
ORDER BY s.stage;