create database atsrecruiter;
\c atsrecruiter

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
  userid bigint references users(id),
  company_name varchar(255) not null
);

create table candidates (
  id bigserial primary key not null,
  userid bigint references users(id),
  resume_link varchar(255) not null
);

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

ALTER TABLE job_postings
ADD CONSTRAINT check_closing_date CHECK (
  (status = 'closed' AND closing_date IS NOT NULL) OR 
  (status = 'open' AND closing_date IS NULL)
);

ALTER TABLE job_postings
ADD CONSTRAINT closing_gte_opening_date CHECK (
  (job_status = 'closed' AND closing_date >= posting_date) OR 
  (job_status = 'open' AND closing_date IS NULL)
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

ALTER TABLE job_applications
ADD CONSTRAINT check_applied_status CHECK (
  last_updated >= applied_date
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

create index locations_country_state_city_idx on locations(country,state,city);
create index idx_addresses_location_id on addresses(location_id);
create index recruiters_idx on recruiters(id,company_name);
create index candidates_idx on candidates(id,resume_link);
create index job_postings_idx on job_postings(id,posting_date,job_status,closing_date);
create index jobopening_levels_idx on jobopening_levels(id,jobid,skills);
create index interview_stages_idx on interview_stages(id,levelid,stage);
create index job_applications_idx on job_applications(jobid,candidateid,applied_date,applied_status);
create index job_interviews_idx on job_interviews(jobid,applicationid,stageid);