-- DATABASE
set sql_safe_updates = 0;

create database Hotel_System_Linked_With_Drone_Delivery_System ;
use             Hotel_System_Linked_With_Drone_Delivery_System ;
-- S-ENTITIES
--          Customers h

create table Room_types(
	croom_id int primary key auto_increment,
    croom_type varchar(50)
);
create table Customer_Phone_no(
	cphone_id int primary key  auto_increment,
    cphone_no int
);
create table customer_is_active(
	cactiveid int primary key  auto_increment,
	cactive_notactive int
);
create table Customer_Details(
	ccnic int primary key,
    cname varchar(50),
    cno_of_members int,
    cno_of_rooms int,
    cdays_of_duration int,
    creservation_date date,
    cemail varchar(50),
    caddress varchar(50),
    cdob date,
    cservice_charges int,
    cactiveid int,
    foreign key (cactiveid) references customer_is_active(cactiveid)
);
create table Room_Connection(
	cRCid int primary key  auto_increment,
    ccnic int,
    croom_id int,
    foreign key(ccnic) references Customer_Details(ccnic) on delete cascade,
    foreign key(croom_id) references Room_types(croom_id) on delete cascade
    );
create table customer_Phone_Connection(
	cPCid int primary key  auto_increment,
    ccnic int,
    cphone_id int,
    foreign key(ccnic) references Customer_Details(ccnic) on delete cascade,
    foreign key(cphone_id) references Customer_Phone_no(cphone_id) on delete cascade
);

--          WORKER    h
create table designation(
	wdesignationid int primary key auto_increment,
    wdesignation_name varchar(50)
);

create table backup_designation(
	bdesignationid int primary key auto_increment,
    designation_name varchar(50)
);


create table worker_phone_no(
	wphone_id int primary key auto_increment,
    wphone_no int 
);

create table backup_worker_phone_no(
	bphone_id int primary key auto_increment,
    phone_no int 
);

delimiter //
create trigger after_deleted_worker_phone_no
after delete on worker_phone_no
for each row
begin
	insert into deleted_worker_phone_no(dphone_id,dstatus) values
    (old.wphone_id,CONCAT('Phone No deleted:  ', old.wphone_no));

end //
delimiter ;

create table deleted_worker_phone_no(
	dphone_id int primary key,
    dstatus varchar(100)
);

create table worker_is_active(
	wactiveid int primary key  auto_increment,
	wactive_notactive int
);
create table worker_details(
	wcnic int primary key,
    wname varchar(50),
    wdob date,
    waddress varchar(50),
    wdesignationid int,
    wactiveid int,
    foreign key (wdesignationid) references designation(wdesignationid) on delete cascade,
    foreign key (wactiveid) references worker_is_active(wactiveid) on delete cascade
);
create table backup_worker_details(
	bwcnic int primary key,
    wname varchar(50),
    wdob date,
    waddress varchar(50),
    wdesignationid int,
    wactiveid int
);

delimiter //
create trigger after_deleted_worker_details
after delete on worker_details
for each row
begin
	insert into deleted_worker_details(dwcnic,dstatus) values
    (old.wcnic,CONCAT('Worker ',old.wname,' record deleted at :  ', current_timestamp));
end //
delimiter ;

create table deleted_worker_details(
	dwcnic int primary key,
    dstatus varchar(100)
);

create table worker_Phone_Connection(
	wPCid int primary key  auto_increment,
    wcnic int,
    wphone_id int,
    foreign key(wcnic) references worker_details(wcnic) on delete cascade,
    foreign key(wphone_id) references worker_phone_no(wphone_id) on delete cascade
);

--          LOGS      h


create table gym_log(
	gym_id int primary key auto_increment,
    checkin_time int not null,
    checkout_time int not null,
    ccnic int,
    wcnic int,
    foreign key(ccnic) references customer_details(ccnic) on delete cascade,
    foreign key(wcnic) references worker_details(wcnic) on delete cascade
);

-- inserting data

insert into Room_types(croom_type)values
("Single"),
("Double"),
("Master"),
("Suite"),
("Penthouse");

insert into Customer_Phone_no(cphone_no) values
(0335348),
(0323432),
(0323432),
(0323432),
(0323432);

insert into customer_is_active(cactive_notactive) values
(1),
(0);

insert into Customer_Details(ccnic,cname,cno_of_members,cno_of_rooms,cdays_of_duration,creservation_date,cemail,caddress,cdob,cservice_charges,cactiveid) values
(123,"Saffi",3,2,5,'2017-06-15',"saffisardar2012@gmail.com","Valancia", '2003-12-12',12,1),
(456, "John", 5, 3, 7, '2019-02-28', "john@example.com", "New York", '1990-05-20', 8, 1),
(789, "Alice", 2, 6, 4, '2020-10-10', "alice@example.com", "London", '1985-09-15', 6, 2),
(101, "Bob", 4, 8, 1, '2018-12-25', "bob@example.com", "Paris", '1978-07-30', 10, 1),
(222, "Emma", 6, 1, 9, '2021-04-05', "emma@example.com", "Los Angeles", '1988-11-10', 7, 2);

insert into Customer_phone_Connection(ccnic,cphone_id)values
(123,1),
(456,3),
(789,4),
(222,2),
(101,5);

insert into Room_Connection(ccnic,croom_id) values
(123,5),
(456,4),
(789,4),
(101,2),
(222,1);

delimiter //
create trigger after_worker_phone_no
after insert on worker_phone_no
for each row
begin
	insert into backup_worker_phone_no(phone_no) values
    (new.wphone_no);
end //
delimiter ;

insert into worker_phone_no(wphone_no)values
(033321456),
(032564864),
(057851858),
(049735447),
(072948548),
(088487487),
(059475684),
(091635493);

insert into worker_is_active(wactive_notactive)
values
(1),
(0);

insert into designation(wdesignation_name)values
('Manager'),
('Cook'),
('Engineer'),
('Receptionist'),
('pieon');

delimiter //
create trigger after_designation
after insert on designation
for each row
begin
	insert into backup_designation(designation_name) values
    (new.wdesignation_name);
end //
delimiter ;



insert into worker_details(wcnic,wname,wdob,waddress,wdesignationid,wactiveid)values
(711,'Haris','2003-05-30','XYZ',1,1),
(712,'Marukh','2005-05-30','ZSW',2,2),
(713,'Saffi','2000-06-25','Val',3,1),
(714,'Ammar','2000-07-26','WWW',4,2),
(715,'Sharukh','2000-09-19','LLB',5,2);

DELIMITER //
CREATE TRIGGER after_worker_details
after INSERT ON worker_details
FOR EACH ROW
BEGIN
    INSERT INTO backup_worker_details (bwcnic,wname,wdob,waddress,wdesignationid,wactiveid) VALUES 
    (new.wcnic,new.wname,new.wdob,new.waddress,new.wdesignationid,new.wactiveid);
END //
Delimiter ;


insert into worker_Phone_Connection(wcnic,wphone_id)values
(711,1),
(711,2),
(712,3),
(713,4),
(713,5),
(714,6),
(715,7),
(715,8);

insert into gym_log(checkin_time,checkout_time,ccnic,wcnic) values
(12,15,123,711),
(13,16,456,712),
(14,20,789,713),
(15,19,101,714),
(12,18,222,715);


--  select * from backup_worker_phone_no;
-- select * from backup_designation;
-- select * from backup_worker_details;
-- delete from worker_details;
-- delete from worker_phone_no where phone_id = 3;
-- select * from deleted_worker_phone_no;
-- select * from deleted_worker_details;
-- select * from worker_details;
-- select * from worker_phone_no;
-- STORED PROCEDURES 

-- 1
Delimiter //
create procedure Modify_Worker(operation varchar(1) , id int , name varchar(30) , Dob date , Address varchar(30),DID int, AID int)
begin
set operation = upper(operation);
if operation = 'I' Then
 INSERT INTO worker_details (wcnic, wname, wdob, waddress, wdesignationid, wactiveid)
        VALUES (id, name, Dob, Address, DID, AID);
Elseif operation = 'U' Then
update Worker_Details
set 
    wname = coalesce(name,wname)
    , wdob = coalesce(Dob,wdob),
    waddress = coalesce(Address,waddress)
where  wcnic = id;
Elseif operation = 'D' then
delete from worker_details
where wcnic = id;
elseif operation = 'S' then
select  * from worker_details 
where wcnic = id;
else
select 'WRONG VALUE' as error;
end if;
end //
delimiter ;

-- 2
delimiter //
create procedure Modify_Designation(operation varchar(1) , DID int , Dname varchar(30))
begin
set operation = upper(operation);
if operation = 'I' Then
insert into designation(wdesignation_name)values(Dname);
elseif operation = 'U' Then
Update designation
set wdesignation_name = coalesce(Dname,wdesignation_name)
where wdesignationid = DID;
elseif operation = 'D' Then
delete from designation
where wdesignationid = DID;
elseif operation = 'S' Then
select wdesignation_name from designation where
wdesignationid = DID
limit 1;
else
select 'Invalid Input' as ErrorMessege;
end if;
end //
delimiter ;
-- 3
delimiter //
create procedure Modify_PhoneNO(operation varchar(1),pid int , phoneno int)
begin
set operation = upper(operation);
if operation = 'I' Then
insert into worker_phone_no(wphone_no)values(phoneno);
elseif operation = 'U' then
update worker_phone_no
set wphone_no = coalesce(phoneno,wphone_no)
where wphone_id = pid;
elseif operation = 'D ' Then
delete from worker_phone_no
where wphone_id = pid;
elseif operation = 'S' Then
select wphone_no from worker_phone_no where
wphone_id = pid;
else
select 'Invalind entry' as error;
end if;
end //
delimiter ;
-- 4
delimiter //
create procedure Modify_Room_Type(operation varchar(1), Rid int , Rtype varchar(30))
begin
set operation = upper(operation);
if operation = 'I' Then
insert into  Room_types(croom_type)values(Rtype);
elseif operation = 'U' Then
update Room_types
set croom_type = coalesce(Rtype,croom_type)
where croom_id = Rid;
elseif operation = 'D' Then
delete from Room_types where
croom_id = Rid;
elseif operation = 'S' Then
select croom_type from Room_types where croom_id = Rid;
else
select 'Invalid Input' as error;
end if;
end //
delimiter ;

-- 5
delimiter //
create procedure Modify_Customer_Details(operation varchar(1),cnic int , name varchar (30),num_mem int , num_rooms int , d_dur int , reserve date , email varchar(30), address varchar(30) , dob date , service int , Aid int)
begin
set operation = upper(operation);
if operation = 'I' Then
  INSERT INTO Customer_Details(ccnic, cname, cno_of_members, cno_of_rooms, cdays_of_duration, creservation_date, cemail, caddress, cdob, cservice_charges, cactiveid) 
        VALUES (cnic, name, num_mem, num_rooms, d_dur, reserve, email, address, dob, service, Aid);
elseif operation = 'U' Then
Update Customer_Details
set cname = coalesce(name,cname),cno_of_members = coalesce(num_mem,cno_of_members),cno_of_rooms = coalesce(num_rooms,cno_of_rooms),
cdays_of_duration = coalesce(d_dur,cdays_of_duration),creservation_date = coalesce(reserve,creservation_date),cemail = coalesce(email,cemail),
caddress = coalesce(address,caddress),cdob = coalesce(dob,cdob),cservice_charges = coalesce(service,cservice_charges),cactiveid = coalesce(Aid,cactiveid)
where ccnic = cnic;
elseif operation = 'D' Then
delete from Customer_Details
where ccnic = cnic;
elseif operation = 'S' Then
select *from Customer_Details 
where ccnic = cnic;
else
select 'Invalid entry' as Error;
end if; 
end //
delimiter ;
-- VIEW [11 JOINS]
create view DB_DATA as
select CD.ccnic,CD.cname,CD.cno_of_members,CD.cno_of_rooms,
CD.cdays_of_duration,CD.creservation_date,CD.cemail,
CD.caddress,CD.cdob,CD.cservice_charges,CD.cactiveid,
CA.cactive_notactive,RT.croom_type,CPC.cPCid,
CPC.cphone_id,CPN.cphone_no,GL.gym_id,GL.checkin_time,
GL.checkout_time,GL.wcnic,WD.wname,WD.wdob,WD.waddress,
WD.wdesignationid,WD.wactiveid,DD.wdesignation_name,
WA.wactive_notactive,WPC.wPCid,WPC.wphone_id,
WPN.wphone_no from Customer_Details CD
inner join customer_is_active CA on CD.cactiveid=CA.cactiveid
inner join Room_Connection RC on CD.ccnic = RC.ccnic
inner join Room_types      RT on RC.croom_id = RT.croom_id
inner join customer_Phone_Connection CPC on CD.ccnic = CPC.ccnic
inner join Customer_Phone_no CPN on CPC.cphone_id = CPN.cphone_id
inner join gym_log GL on CD.ccnic = GL.ccnic
inner join worker_details WD on GL.wcnic = WD.wcnic
inner join designation DD on WD.wdesignationid = DD.wdesignationid
inner join worker_is_active WA on WD.wactiveid = WA.wactiveid
inner join worker_Phone_Connection WPC on WD.wcnic = WPC.wcnic
inner join worker_phone_no WPN on WPC.wphone_id = WPN.wphone_id;

-- Functions 

-- 1
 Delimiter $$
create function cal_charges(days_of_duration int,service_charges int)
returns int
deterministic
begin
	declare total_charges int;
    set total_charges=days_of_duration*service_charges;
    return total_charges;
end $$
Delimiter ;

select  cal_charges(2,5);
-- 2

Delimiter $$
create function cal_time(checkin_time int,checkout_time int )
returns int
deterministic
begin
	 declare total_time int;
     set total_time=checkout_time - checkin_time;
     return total_time;
end $$
Delimiter ;

select  cal_time(15,14);

Delimiter $$
-- 3
create function cal_avg_duration(no_of_members int, days_of_duration int)
returns float
deterministic
begin
    declare average_duration float;
    set average_duration=days_of_duration/no_of_members;
    return average_duration;
end $$
Delimiter ;

select cal_avg_duration(4, 7);

Delimiter $$
create function workers_Active(cnic int)
returns varchar(50)
deterministic
begin
      declare activity_status int;
    declare status_message varchar(50);
    select worker_is_active.wactive_notactive into activity_status from worker_details 
    inner join worker_is_active  on worker_details.wactiveid = worker_is_active.wactiveid
    where worker_details.wcnic = cnic;
    if activity_status = 1 then 
        set status_message = 'Active';
    else 
        set status_message = 'Non_Active';
    end if;
    return status_message;
end $$
Delimiter ;

-- Indexes
create index index_room on Room_types(croom_type);
create index index_phone on Customer_Phone_no(cphone_no);
create index indx_customer on Customer_Details(cname);
create index index_designation on designation(wdesignation_name);
create index index_worker on worker_phone_no(wphone_no);
create index index_active on worker_is_active(wactive_notactive);
create index index_detailsn on worker_details(wname);
create index index_gym on gym_log(gym_id,checkin_time,checkout_time);



-- S-Entities          15
-- H-Stored Procedures 5 
-- S-Triggers          5 
-- H-Views             11 
-- I-Functions         3
-- I-Indexes		   9