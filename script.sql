CREATE TABLE job_recruiter(
    recruiterid bigserial primary key not null,
    firstname varchar(255) not null,
    lastname varchar(255) not null,
    email varchar(255) not null,
    phoneno varchar(255) not null
);

CREATE TABLE job_posting(
    jobid bigserial primary key NOT NULL,
    title varchar(255) NOT NULL,
    description text NOT NULL,
    open_date timestamp NOT NULL,
    close_date timestamp NOT NULL,
    job_status varchar(255) NOT NULL,
    recruiterid bigserial NOT NULL references job_recruiter(recruiterid)
);

CREATE TABLE job_candidate(
    candidateid bigserial primary key not null,
    firstname varchar(255) not null,
    lastname varchar(255) not null,
    email varchar(255) not null,
    phoneno varchar(255) not null,
    resumelink varchar(255) not null
);

CREATE TABLE job_candidate_documents(
    candidateid bigserial not null references job_candidate(candidateid),
    documentid bigserial primary key not null,
    documentnames text,
    documentlinks text
);

CREATE TABLE job_application(
    applicationid bigserial primary key not null,
    candidateid bigserial not null references job_candidate(candidateid),
    jobid bigserial not null references job_posting(jobid),
    applicationdate timestamp not null,
    applicationstatus varchar(255) not null
);

CREATE TABLE job_interview(
    interviewid bigserial primary key not null,
    applicationid bigserial not null references job_application(applicationid),
    interviewdate timestamp not null,
    interviewer_name varchar(255) not null,
    interview_stage varchar(255) not null,
    interview_url varchar(255) not null,
    notes text not null
);



##Query 1 for job id 10;
SELECT c.firstname, c.lastname, c.email, c.phoneno, c.resumelink, a.applicationdate, a.applicationstatus
FROM job_application a
JOIN job_candidate c ON a.candidateid = c.candidateid
WHERE a.jobid = 10;

##Query 2 for input search 'io'
SELECT c.firstname, c.lastname, c.email, j.title
FROM job_candidate c
JOIN job_application a ON c.candidateid = a.candidateid
JOIN job_posting j ON a.jobid = j.jobid
WHERE c.email ILIKE '%io%' OR c.firstname ILIKE '%io%' OR c.lastname ILIKE '%io%' OR j.title ILIKE '%io%';

