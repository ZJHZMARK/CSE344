Create table Customer{
handle varchar(20) unique not null,
fullName varchar(20) Not null,
password varchar(20) Not null,
Customer_id int primary key
};


Create table Reservation{
Customer_id int references Customer(Customer_id),
year int,
month int,
dayOfMonth int,
fightID int,
primary key(customer_id, fightID)
};
