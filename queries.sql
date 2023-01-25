## Query 1 for jobid = 7

select u.name, u.email, u.phoneno, c.resume_link, a.applied_date, a.applied_state
from candidates c 
join users u on c.userid = u.id
join job_applications a
on a.candidateid = c.id
where a.jobid = 7;


## Query 2 for search input 'io'

select u.name, u.email, j.title as job_title
from candidates c
join users u on c.userid = u.id
join job_applications a on c.id = a.candidateid
join job_postings j on a.jobid = j.id
where u.email ILIKE '%io%' or u.name ILIKE '%io%' or j.title ILIKE '%io%';

##Query 3 

WITH last_6_months AS (
    SELECT *
    FROM job_postings
    WHERE posting_date >= NOW() - INTERVAL '6 months'
)

SELECT
    (SELECT COUNT(*) FROM last_6_months WHERE job_state = 'open') as "Number of job openings created",
    (SELECT COUNT(*) FROM last_6_months WHERE job_state = 'closed') as "Number of job openings closed",
    (SELECT COUNT(*) FROM job_applications WHERE jobid in (SELECT id FROM last_6_months)) as "Number of applications received",
    (SELECT COUNT(DISTINCT candidateid) FROM job_applications WHERE jobid in (SELECT id FROM last_6_months) AND applied_state = 'Recruited') as "Number of candidates recruited",
    (SELECT COUNT(DISTINCT candidateid) FROM job_applications WHERE jobid in (SELECT id FROM last_6_months) AND applied_state = 'Rejected') as "Number of candidates rejected",
    (SELECT COUNT(*) FROM job_applications WHERE jobid in (SELECT id FROM last_6_months))/(SELECT COUNT(*) FROM last_6_months WHERE job_state = 'open') as "Average number of applications per job opening";


##Query 4 for candidate id 8

select j.title as job_title, s.stage as stage_name
from candidates c
join job_applications a on c.id = a.candidateid
join job_postings j on a.jobid = j.id 
join job_interviews i on a.id = i.applicationid
join interview_stages s on i.stageid = s.id
where c.id = 8;

##Query 5 for job id 5

select j.title as job_title, s.stage as stage_name, count(s.stage) as number_of_candidates
from job_postings j
join job_applications a on j.id = a.jobid
join job_interviews i on a.id = i.applicationid
join interview_stages s on i.stageid = s.id
where j.id = 5
group by s.stage, j.title
order by s.stage;