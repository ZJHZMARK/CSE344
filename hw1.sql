/* problem 1 */
 Create Table Edges( source int, Destination int);
 INSERT INTO Edges VALUES(10, 5);
 INSERT INTO Edges VALUES(6,25);
 INSERT INTO Edges VALUES(1,3);
 INSERT INTO Edges VAlUES(4,4);
 select * from Edges;
 select source from Edges;
 select * from Edges where source> Destination;
 Insert into Edges Values('-1','2000');
 /*database engine that used rigid typing will try to automatically convert values to appropriate datatype, String will be convert into integer in this case */

/* problem 2 */
 Create Table MyRestaurants( name VARCHAR(20), food VARCHAR(20), distance int, lastvisit VARCHAR(20), likeornot int);

/* problem 3 */
 INSERT INTO MyRestaurants VALUES('localpoint', 'bigcheeseburger', 5,'2017-10-06',0);
 INSERT INTO MyRestaurants VALUES('cultivate' , 'steak' , 4 , '2017-06-05', 1); 
  INSERT INTO MyRestaurants VALUES('cheesefactory', 'cheesecake' ,30,'2017-10-01',1);
 INSERT INTO MyRestaurants VALUES('Thainoodlehouse', 'noodles' ,20,'2017-10-04',0);
 INSERT INTO MyRestaurants VALUES('chinafirst' , 'tofu', 5 , '2017-10-05', null);

/* problem 4 */
.separator ,
 select * from MyRestaurants;

.separator |
 select * from MyRestaurants;

.mode column
.width 15 15 15 15 15
 select * from MyRestaurants;

.header on
 select * from MyRestaurants;

/*problem 5 */
 select name, distance from Myrestaurants where distance<=20 ORDER BY name;

/* problem 6 */
 select * from Myrestaurants where likeornot=1 and date('now','-3 month')>lastvisit;
