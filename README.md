# DBAMaintenance
This is a project that I am using for a client, it's a general purpose DBA database used for helping to manage the SQL Server estate.

Unlike a lot of other deployments, this focuses on not having sysadmin or being able to write to the filesystem due to the operating model that the client currently has in place. Principals will be using least privilege and events will be logged to tables. This is not anticipated to be a busy database however due care and attention is recommended to review the throughput and also archive data appropriately.

Some of the items to be tracked:

- Failed logins (include IP address, DNS name and if possible any details of what the request was to help identify who or what is failing) 
- If any new objects (databases, logins, users, tables, stored procedures, views, jobs etc) are created, modified or deleted and who did it and when
- If any permissions on an object is added, modified or removed and who did it and when
- Database alterations and backups/restores along with who did it and when including database file resizes
- If any SQL instance settings are changed including traces, extended event sessions and instance restarts. Again who did it and when
- I also want to track if someone logs into the SQL instance using SSMS and a SQL authenticated account as Windows Authentication is the default and approved method of user access. Using a SQL authenticated account, apart from some limited scenarios, can be seen as trying to circumvent access controls.

The databases are backed up by an external product/team so we don’t do anything with them other than check that they are still being taken - we look at this in DBADash

Regular tasks to be carried out:

All nodes (have steps prior to the task to check whether the database is on the primary node where applicable e.g. index maintenance):
- Daily recycling of the errorlog with these going back 2 weeks
- Index maintenance (rebuild over 30% fragmented, reorg between 30-15%)
- Statistics Updates (using best practice parameters for general purpose databases)
- Integrity checks of user databases (I want to run full CheckDB on the secondary and physical only on the primary)

Notifications for:

- If a job fails for whatever reason
- If there is potential corruption
- If there is a login from someone using SSMS and a SQL Authenticated account
- If there are objects or permissions being altered by an account other than a designated deployment account





