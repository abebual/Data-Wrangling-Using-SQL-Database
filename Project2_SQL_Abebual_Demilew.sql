
/* ************ Mini Project 2 - SQL Excercise **************
 ************** Author - Abebual Demilew ********************


SQL data wrangling excercise using 'country_club' database. This database contains three tables:
i) the 'Bookings' table
ii) the 'Facilities' table
iii) the 'Members' table

********************************************************************
Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do.
********************************************************************
*/

SELECT facid,
    name,
    membercost
    FROM Facilities
    WHERE membercost > 0

/* Names of the facilites that charge fees:
1. Tennis Court 1
2. Tennis Court2
3. Massage Room 1
4. Massage Room 2
5. Squash Court */

/*
********************************************************************
Q2: How many facilities do not charge a fee to members?
********************************************************************
*/


SELECT COUNT(name) AS "Count of Facility"
FROM Facilities
    WHERE membercost = 0

/*
********************************************************************
 4 faciliteis do not charge a fee to memebers
********************************************************************
*/

/*
*******************************************************************
Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question.
*******************************************************************
*/

SELECT facid,
    name,
    membercost,
    monthlymaintenance
FROM Facilities
where membercost < (monthlymaintenance * 0.2)

/*
*******************************************************************
Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator.
*******************************************************************
*/

SELECT *
FROM Facilities
WHERE facid BETWEEN 1 AND 6


/*
*******************************************************************
Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question.
*******************************************************************
*/

SELECT name,
    monthlymaintenance
    CASE WHEN monthlymaintenance > 100 THEN 'expensive'
    ELSE 'cheap' END AS facility_is
FROM Facilities


/*
*******************************************************************
Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution.
*******************************************************************
*/

SELECT firstname,
    surname,
    MAX(joindate) AS member_joined_last
FROM Members


/*
*******************************************************************
Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name.
*******************************************************************
*/

SELECT DISTINCT f.name AS facilityname,
    CONCAT(m.firstname, ' ' , m.surname) AS membername
FROM Bookings b
INNER JOIN Facilities f
ON b.facid = f.facid
INNER JOIN Members m
ON b.memid = m.memid
WHERE f.name LIKE 'Tennis Court%'
ORDER BY membername

/*
*******************************************************************
Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries.
*******************************************************************
*/

SELECT f.name AS facilityname,
    CONCAT(m.firstname, ' ' , m.surname) AS membername,
    f.membercost,
    f.guestcost
FROM Bookings b
INNER JOIN Facilities f
ON b.facid = f.facid
INNER JOIN Members m
ON b.memid = m.memid
WHERE b.starttime LIKE '2012-09-14%'
    AND (f.membercost / b.slots > 30  OR f.guestcost / b.slots > 30)
ORDER BY f.membercost, guestcost DESC

/*
*******************************************************************
Q9: This time, produce the same result as in Q8, but using a subquery.
*******************************************************************
*/

SELECT f.name AS facilityname,
    CONCAT(m.firstname, ' ' , m.surname) AS membername,
    f.membercost,
    f.guestcost
FROM Bookings b
INNER JOIN Facilities f
ON b.facid = f.facid
INNER JOIN Members m
ON b.memid = m.memid
WHERE b.starttime LIKE '2012-09-14%'
    AND (f.membercost / b.slots > 30  OR f.guestcost / b.slots > 30)
ORDER BY f.membercost, guestcost DESC


/*
*******************************************************************
Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members!
*******************************************************************
*/

SELECT f.name AS facilityname,
	SUM(CASE WHEN b.memid = 0 THEN f.guestcost *b.slots
        ELSE f.membercost * b.slots END
        ) AS total_revenue
FROM Bookings b
INNER JOIN Facilities f
ON b.facid = f.facid
INNER JOIN Members m
ON b.memid = m.memid
GROUP BY facilityname
HAVING total_revenue < 1000
ORDER BY total_revenue DESC
