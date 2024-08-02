-- T E A M 1
--Member 1: Shiva Prakash Reddy Gopanpally
--Member 2: Bhairav Prasad Racharla
--Member 3: Kunal Rewade
--Member 4: Syamala Makireddi
--Member 5: Abdulai Ben Kamara
--Member 6: Rupesh Salapu

set SERVEROUTPUT ON

--drop table commands
drop table recommendations;
drop table reviews;
drop table orders;
drop Table customers;
drop table restaurant_inventory;
drop table menu_items;
drop table allwaiters;
drop table Restaurant;
drop table cuisine_type;

--Drop Stored Procedure
Drop Procedure add_cuisine;
Drop Procedure add_restaurant;
Drop Procedure hire_waiter;
Drop Procedure create_menu_item;
Drop Procedure Add_items_inventory;
Drop Procedure INSERT_CUSTOMERS;
Drop Procedure ADD_order;
Drop Procedure add_review;
Drop Procedure Buy_OR_Beware;
Drop Procedure restaurant_info;
DROP PROCEDURE cuisine_report_by_state;
DROP PROCEDURE show_tips_by_state;
drop procedure show_tips_by_waiter;
Drop Procedure Generate_report_menu_items;
Drop procedure UPDATE_MENU_ITEM_INVENTORY;
Drop Procedure report_top_restaurants;
Drop Procedure LIST_ORDERS;
Drop Procedure RECOMMEND_TO_CUSTOMER;
drop Procedure List_Recommendations;
DROP procedure most_profitable_res;
drop procedure report_customers;
drop procedure most_popular_restaurant;



--Drop Sequence commands

DROP SEQUENCE cuisine_type_id;
DROP SEQUENCE restaurant_id;
DROP SEQUENCE c_id;
DROP SEQUENCE menu_items_id_seq;
DROP SEQUENCE recomendation_id_seq;
DROP SEQUENCE restaurant_inventory_id_seq;
DROP SEQUENCE review_id_seq;
DROP SEQUENCE seq_orders;
DROP SEQUENCE w_id_seq;


--drop commands to drop functions
drop function FIND_RESTAURANT_ID;
drop function find_waiter_id;
drop function FIND_CUISINE_TYPE_ID;
drop function FIND_CUSTOMER_ID;
drop function FIND_MENU_ITEM_ID;


--Creating Sequences

CREATE SEQUENCE cuisine_type_id START WITH 1;
CREATE SEQUENCE restaurant_id START WITH 1;
CREATE SEQUENCE c_id START WITH 1;
CREATE SEQUENCE menu_items_id_seq START WITH 1;
CREATE SEQUENCE recomendation_id_seq START WITH 1;
CREATE SEQUENCE restaurant_inventory_id_seq START WITH 1;
CREATE SEQUENCE review_id_seq START WITH 1;
CREATE SEQUENCE seq_orders START WITH 1;
CREATE SEQUENCE w_id_seq START WITH 1;




--Create Tables command
CREATE TABLE cuisine_type(
    cuisine_type_id NUMBER PRIMARY KEY,
    cuisine_name VARCHAR(30)
);
/
CREATE TABLE restaurant (
    restaurant_id NUMBER PRIMARY KEY,
    restaurant_name VARCHAR(30),
    street_address VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20),
    zip int,
    cuisine_type_id INT,
    FOREIGN KEY (cuisine_type_id) REFERENCES cuisine_type(cuisine_type_id)
);
/
Create table Allwaiters ( w_id int not null primary key , w_Name Varchar(255), rest_id NUMBER,Foreign key(rest_id) references restaurant(restaurant_id));-- create waiters table
/
Create table Menu_Items (Cuisine_Type_id int, Menu_Items_ID int not null primary key , Name Varchar(255), Price decimal(10,2),foreign key (Cuisine_Type_id) references cuisine_type(cuisine_type_id));-- create menu items tables
/
Create Table Restaurant_Inventory (Restaurant_Inventory_id int not null primary key,Menu_Items_ID int, name varchar(255), Restaurant_ID int, QUANTITY INT, FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANT(RESTAURANT_ID),FOREIGN KEY (MENU_ITEMS_ID)REFERENCES MENU_ITEMS (MENU_ITEMS_ID));
/

CREATE TABLE Customers (
c_id INT PRIMARY KEY, 
c_name VARCHAR(100),
c_email VARCHAR(100) UNIQUE,
c_street_address VARCHAR(255),
c_city VARCHAR(100),
c_state VARCHAR(50),
c_Zip_code VARCHAR(7), 
credit_card_number Varchar(50))
;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    restaurant_id INT,
    c_id INT,
    order_date DATE,
    menu_items_id INT,
    w_id INT,
    amount_paid DECIMAL(10, 2),
    tip DECIMAL(10, 2),
    foreign key(c_id) references Customers (c_id),
    foreign key(w_id) references AllWaiters (w_id),
    foreign key(menu_items_id) references menu_items(menu_items_id),
    foreign key(restaurant_id) references  restaurant(restaurant_id));
    
CREATE TABLE Reviews (
    Review_ID INT PRIMARY KEY,
    Restaurant_ID INT,
    Reviewer_Emailid VARCHAR(255),
    Stars INT CHECK (Stars BETWEEN 1 AND 5),
    Review_Text VARCHAR(500),
    foreign key (Restaurant_id) references restaurant(restaurant_id)
);

CREATE TABLE Recommendations (
    Recommendation_ID INT PRIMARY KEY,
    C_ID INT,
    Restaurant_ID INT,
    Recommendation_Date DATE,
    Foreign key (C_id) references customers(C_id),
    Foreign key (restaurant_id) references restaurant(restaurant_id)
    );
    

--Creating Helper functions

--Creating function to cuisine type id when we get a input as the name pf cuisine
create or replace FUNCTION FIND_CUISINE_TYPE_ID(c_name VARCHAR)
RETURN NUMBER
IS  
cuisine_id NUMBER;
BEGIN
    SELECT cuisine_type_id INTO cuisine_id FROM cuisine_type WHERE cuisine_name = c_name;
	RETURN cuisine_id;
EXCEPTION
	when no_data_found then
        DBMS_OUTPUT.PUT_LINE('NO SUCH CUISINE FOUND IN THE CUISINE_TYPES TABLE..!');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('AN ERROR HAS OCCURRED.');
        RETURN -1;
END FIND_CUISINE_TYPE_ID;
/

create or replace FUNCTION FIND_CUSTOMER_ID (customer_name IN VARCHAR2) RETURN NUMBER
IS
    customer_id NUMBER;
BEGIN
    SELECT C_ID INTO customer_id 
    FROM Customers 
    WHERE c_name = customer_name;
    RETURN customer_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No such Customer');
        RETURN -1;
    WHEN OTHERS THEN 
        dbms_output.put_line('An unexpected error occurred');
        RETURN -1;
END FIND_CUSTOMER_ID;

/

--Function made by member 3
create or replace FUNCTION FIND_MENU_ITEM_ID (item IN VARCHAR2) RETURN NUMBER
IS
    item_id NUMBER;
BEGIN
    SELECT MENU_ITEMS_ID INTO item_id 
    FROM menu_items 
    WHERE name = item;     
    RETURN item_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No such Menu Item Found');
        RETURN -1;
    WHEN OTHERS THEN 
        dbms_output.put_line('An unexpected error occurred');
        RETURN -1;
END FIND_MENU_ITEM_ID;
/
create or replace FUNCTION FIND_RESTAURANT_ID(r_name VARCHAR)
RETURN NUMBER
IS  
r_id NUMBER;
BEGIN
    SELECT restaurant_id INTO r_id FROM restaurant WHERE restaurant_name = r_name;
	RETURN r_id;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO SUCH RESTAURANT FOUND IN THE RESTAURANTS TABLE..!');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('AN ERROR HAS OCCURRED.');
        RETURN -1;
END FIND_RESTAURANT_ID;
/

create or replace function find_waiter_id(
       p_w_name in varchar2
) return number
is
    p_w_id number;
begin
     select w_id into p_w_id
     from allwaiters
     where w_name=p_w_name;
     return p_w_id;
exception
    when no_data_found then
    return -1;
end find_waiter_id;


-- STORED Procedures for all members

-- Creating procedure to add cuisines
/
create or replace procedure add_cuisine(c_name varchar) --creating a procedure to add new restaurant to the table.
AS
BEGIN
   INSERT INTO cuisine_type VALUES (cuisine_type_id.NEXTVAL, c_name);
   DBMS_OUTPUT.PUT_LINE('Cuisine is successfully added to the CUISINE_TYPES TABLE');
END add_cuisine;

/
-- Creating stored procedure to add restaurants

create or replace PROCEDURE add_restaurant(r_name varchar, street varchar, city varchar, state varchar,zip int,  cid varchar)
AS
cuisine_id int;
BEGIN
    cuisine_id := FIND_CUISINE_TYPE_ID(cid);
    INSERT INTO restaurant VALUES (restaurant_id.NEXTVAL, r_name, street, city, state, zip, cuisine_id);
END add_restaurant;

/
--Creating stored procedure to add waiters
create or replace procedure hire_waiter
   ( p_w_name  varchar2,
    p_name varchar2)
as
 p_id number;
begin
p_id:= FIND_RESTAURANT_ID(p_name);
insert into allwaiters(w_id,w_name,rest_id)
values ( w_id_seq.nextval,p_w_name,p_ID);
end;
/


--Creating store procedures to add menu items

create or replace PROCEDURE create_menu_item(
    menuname VARCHAR2, 
    price NUMBER, 
    cuisine_type VARCHAR2
) AS
    cuisine_id NUMBER;
BEGIN
    cuisine_id := FIND_CUISINE_TYPE_ID(cuisine_type);

    INSERT INTO menu_items (menu_items_id, name, price, cuisine_type_id)
    VALUES (MENU_ITEMS_ID_SEQ.nextval, menuname, price, cuisine_id);

    -- Committing the transaction to make the change permanent
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE ('SQLCODE: ' || SQLCODE); -- Outputs the SQL error code
        DBMS_OUTPUT.PUT_LINE ('SQLERRM: ' || SQLERRM); -- Outputs the error message
END CREATE_MENU_ITEM;
/

-- Creating procedure to add inventory
create or replace PROCEDURE Add_items_inventory(
    menu_name VARCHAR2, 
    restaurant_name VARCHAR2,
    Quantity NUMBER 
) AS
    menu_items_id NUMBER;
    restaurant_id NUMBER;
BEGIN
    restaurant_id := FIND_RESTAURANT_ID (restaurant_name);
    menu_items_id :=FIND_MENU_ITEM_ID (menu_name);

    INSERT INTO RESTAURANT_INVENTORY (Restaurant_Inventory_ID, menu_items_id, name, restaurant_id, quantity)
    VALUES (RESTAURANT_INVENTORY_ID_SEQ.nextval,menu_items_id, menu_name,restaurant_id , Quantity);

    -- Committing the transaction to make the change permanent
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE ('SQLCODE: ' || SQLCODE); 
        DBMS_OUTPUT.PUT_LINE ('SQLERRM: ' || SQLERRM); 
END ADD_ITEMS_INVENTORY;

/
CREATE OR REPLACE PROCEDURE INSERT_CUSTOMERS (
    CUST_NAME_IN VARCHAR,
    CUST_EMAIL_IN VARCHAR, 
    CUST_STREETADD_IN VARCHAR, 
    CUST_CITY_IN VARCHAR, 
    CUST_STATE_IN VARCHAR, 
    CUST_ZIP_IN VARCHAR, 
    CUST_CCNO_IN Varchar) --INPUT PARAMETERS 
AS
BEGIN
    -- INSERT QUERY WITH SEQUENCE FOR INSERT CUSTOMERS STARTING FROM 600
    INSERT INTO CUSTOMERS VALUES (
    C_id.NEXTVAL, 
    CUST_NAME_IN, 
    CUST_EMAIL_IN, 
    CUST_STREETADD_IN, 
    CUST_CITY_IN, 
    CUST_STATE_IN, 
    CUST_ZIP_IN, 
    CUST_CCNO_IN);
    
    DBMS_OUTPUT.PUT_LINE('CUSTOMER ' || CUST_NAME_IN || ' ADDED SUCCESSFULLY');
    
EXCEPTION --EXCEPTION HANDLING
    WHEN OTHERS THEN -- USED TO HANDLE EXCEPTION AND PRINT THE SQL ERROR MESSAGE
    DBMS_OUTPUT.PUT_LINE('ERROR ADDING CUSTOMER. ERROR CODE : ' || SQLERRM);
END;
/



CREATE OR REPLACE PROCEDURE ADD_order(
    R_name VARCHAR2,
    C_name VARCHAR2,
    o_date DATE,
    menu_item_name VARCHAR2,
    w_name VARCHAR2,
    a_paid NUMBER
)
AS
    R_id NUMBER;
    C_id NUMBER;
    w_id NUMBER;
    menu_id NUMBER;
    p_tip NUMBER;
    AVAILABLE_QUANTITY NUMBER;
BEGIN
    -- Find IDs for restaurant, customer, waiter, and menu item
    R_id := find_restaurant_id(R_name);
    C_id := find_customer_id(C_name);
    w_id := find_waiter_id(w_name);
    menu_id := find_menu_item_id(menu_item_name);

    -- Calculate the tip which is 20% of the amount paid
    p_tip := a_paid * 0.2;

    -- Check inventory for the availability of the menu item
    SELECT QUANTITY INTO AVAILABLE_QUANTITY
    FROM RESTAURANT_INVENTORY
    WHERE RESTAURANT_ID = R_id AND MENU_ITEMS_ID = menu_id;

    IF AVAILABLE_QUANTITY > 0 THEN
        -- Insert the order if the item is available
        INSERT INTO ORDERS
        VALUES (SEQ_ORDERS.NEXTVAL, R_id, C_id, o_date, menu_id, w_id, a_paid, p_tip);

        -- Display success message
        DBMS_OUTPUT.PUT_LINE('Customer ' || C_name || ' placed an order at ' || R_name);
        
        -- Commit the transaction
        COMMIT;
    ELSE
        -- Inform user that the item is not available
        DBMS_OUTPUT.PUT_LINE('Order not placed: Item not available');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for input values');
        ROLLBACK;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('More than one row returned by a subquery');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ' SQLERRM: ' || SQLERRM);
        ROLLBACK;
END ADD_order;
/


create or replace PROCEDURE Add_Review(
    p_reviewer_email IN VARCHAR2,
    p_restaurant_name IN VARCHAR2,
    p_stars_given IN NUMBER,
    p_review_text IN VARCHAR2
)
IS
    v_review_id NUMBER;
    v_restaurant_id NUMBER;
BEGIN
    -- Find the restaurant ID using the helper function
    v_restaurant_id := find_restaurant_id(p_restaurant_name);

    IF v_restaurant_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Restaurant not found.');
        RETURN;
    END IF;

    -- Generate review ID using sequence
    SELECT review_id_seq.nextval INTO v_review_id FROM dual;

    -- Insert review into REVIEWS table
    INSERT INTO REVIEWS (REVIEW_ID, RESTAURANT_ID, REVIEWER_EMAILID, STARS, REVIEW_TEXT)
    VALUES (v_review_id, v_restaurant_id, p_reviewer_email, p_stars_given, p_review_text);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Review added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END ADD_REVIEW;
/
CREATE OR REPLACE PROCEDURE BUY_OR_BEWARE(NO_OF_REST IN NUMBER)
IS
COUNTER INTEGER := 0; -- INITIATE THE COUNTER TO 0, THE COUNTER IS USED TO RUN THE LOOP MULTIPLE TIMES AS PER THE INPUT (NO_OF_REST)
BEGIN
    DBMS_OUTPUT.PUT_LINE('TOP RATED RESTAURANTS');
    -- USED TO FIND THE DETAILS FOR THE BEST RESTAURANT
    FOR BUY_RESTAURANTS IN (
        SELECT AVG(REV.STARS) AS AVG_STARS,
               REV.RESTAURANT_ID,
               C.CUISINE_NAME,
               STDDEV(REV.STARS) AS STD_DEV
        FROM REVIEWS REV
        INNER JOIN RESTAURANT RES ON REV.RESTAURANT_ID = RES.RESTAURANT_ID
        INNER JOIN CUISINE_TYPE C ON RES.CUISINE_type_ID = C.CUISINE_type_ID
        GROUP BY REV.RESTAURANT_ID, C.CUISINE_NAME
        ORDER BY AVG_STARS DESC
    )
    LOOP
	EXIT WHEN COUNTER >= NO_OF_REST; -- THE LOOP WILL BE TERMINATED WHEN THE COUNTER VALUE EXCEEDS NO_OF_REST
        DBMS_OUTPUT.PUT_LINE ('AVERAGE STARS : ' || BUY_RESTAURANTS.AVG_STARS ||
                              ' / RESTAURANT ID : ' || BUY_RESTAURANTS.RESTAURANT_ID ||
                              ' / CUISINE NAME : ' || BUY_RESTAURANTS.CUISINE_NAME ||
                              ' / STANDARD DEVIATION ' || BUY_RESTAURANTS.STD_DEV);
        COUNTER := COUNTER + 1; -- COUNTER INCREMENT AND VALUE GOES TILL NO_OF_REST
    END LOOP;
    
    -- USED TO FIND THE DETAILS OF WORST RESTAURANTS
    DBMS_OUTPUT.PUT_LINE('BUYER BEWARE: STAY AWAY FROM...');
	COUNTER := 0; -- INITIALIZING THE COUNTER BACK TO 0 FOR COMPUTING THE WORST RESTAURANT
    FOR BEWARE_RESTAURANTS IN (
        SELECT AVG(REV.STARS) AS AVG_STARS,
               RES.RESTAURANT_ID,
               RES.RESTAURANT_NAME,
               C.CUISINE_NAME,
               STDDEV(REV.STARS) AS STD_DEV
        FROM REVIEWS REV
        INNER JOIN RESTAURANT RES ON REV.RESTAURANT_ID = RES.RESTAURANT_ID
        INNER JOIN CUISINE_TYPE C ON RES.CUISINE_type_ID = C.CUISINE_type_ID
        GROUP BY RES.RESTAURANT_ID, RES.RESTAURANT_NAME, C.CUISINE_NAME
        ORDER BY AVG_STARS ASC
    )
    LOOP
	EXIT WHEN COUNTER >= NO_OF_REST; -- THE LOOP WILL BE TERMINATED WHEN THE COUNTER VALUE EXCEEDS NO_OF_REST
        DBMS_OUTPUT.PUT_LINE ('AVERAGE STARS : ' || BEWARE_RESTAURANTS.AVG_STARS ||
                              ' / RESTAURANT ID : ' || BEWARE_RESTAURANTS.RESTAURANT_ID ||
                              ' / RESTAURANT NAME : ' || BEWARE_RESTAURANTS.RESTAURANT_NAME ||
                              ' / STANDARD DEVIATION ' || BEWARE_RESTAURANTS.STD_DEV);
        COUNTER := COUNTER + 1; -- COUNTER INCREMENT AND VALUE GOES TILL NO_OF_REST
    END LOOP;
END;
/

--Member 1 Scenerio stored procedure;
create or replace PROCEDURE restaurant_info(c_name IN varchar)
AS
    CURSOR C1 IS SELECT restaurant_name, street_address, city, state, zip
    FROM cuisine_type, restaurant
    WHERE lower(cuisine_name) = lower(c_name) AND cuisine_type.cuisine_type_id = restaurant.cuisine_type_id;

r_name    restaurant.restaurant_name%type; --Declaring the cursor varaiables or attributes
street    restaurant.street_address%type;
city_name restaurant.city%type;
state_name restaurant.state%type;
zip_code  restaurant.zip%type;

no_restaurant EXCEPTION; --Declaring the user defined exception

BEGIN
open C1; --Opening the cursor c1

LOOP --Starting the loop to fetch the data from cursor
    FETCH C1 into r_name, street, city_name,state_name, zip_code; --fetching the data into cursor variables

    IF C1%ROWCOUNT < 1 THEN --Checking the condition for Exception
     RAISE no_restaurant; --Raising the Exception 
    END IF;
    exit when c1%NOTFOUND; --Exit condition

    IF C1%ROWCOUNT < 2 THEN 
        DBMS_OUTPUT.PUT_LINE('Restaurant Name             Address'); --Header of the Output
        DBMS_OUTPUT.PUT_LINE(' ');
    end if;


    DBMS_OUTPUT.PUT_LINE(r_name || '           '|| street ||', '|| city_name ||', '|| state_name||', '|| zip_code||'.');
END LOOP; --Ending the loop

EXCEPTION
	WHEN no_restaurant THEN --Exception description
       DBMS_OUTPUT.PUT_LINE('NO RESTAURANT FOUND WITH THE GIVEN CUISINE NAME..! '); -- Printing the Error message 
CLOSE C1; -- closing the cursor
END restaurant_info; --End of the procedure

/
create or replace PROCEDURE cuisine_report_by_state
IS
    CURSOR C2 IS SELECT cuisine_name, sum(amount_paid), state
    FROM cuisine_type, restaurant, orders
    where cuisine_type.cuisine_type_id = restaurant.cuisine_type_id and restaurant.restaurant_id = orders.restaurant_id
    group by cuisine_name, state;

c_name               cuisine_type.cuisine_name%type; --Declaring the cursor varaiables or attributes
total_amount_paid    orders.amount_paid%type;
state_name           restaurant.state%type;

no_data EXCEPTION; --Declaring the user defined exception

BEGIN
open C2; --Opening the cursor c1

LOOP --Starting the loop to fetch the data from cursor
    FETCH C2 into c_name, total_amount_paid,state_name; --fetching the data into cursor variables

    IF C2%ROWCOUNT < 1 THEN --Checking the condition for Exception
     RAISE no_data; --Raising the Exception 
    END IF;

    exit when c2%NOTFOUND; --Exit condition

    IF C2%ROWCOUNT < 2 THEN 
        DBMS_OUTPUT.PUT_LINE('CUISINE NAME  TOTAL_AMOUNT_PAID   STATE'); --Header of the Output
        --DBMS_OUTPUT.PUT_LINE(' ');
    end if;


    DBMS_OUTPUT.PUT_LINE(c_name || '            '|| TOTAL_AMOUNT_PAID ||'            '|| state_name|| '.');
END LOOP; --Ending the loop

EXCEPTION
	WHEN no_data THEN --Exception description
       DBMS_OUTPUT.PUT_LINE('NO DATA FOUND TO GENERATE THE REPORT..! '); -- Printing the Error message 
CLOSE C2; -- closing the cursor
END cuisine_report_by_state; --End of the procedure

/
-- Stored Procedures for member 2 scenario 3
CREATE OR REPLACE PROCEDURE show_tips_by_state (
    state_name IN VARCHAR,
    state_tips OUT NUMBER
) IS
    total_tips NUMBER := 0; -- Initialize the total tips variable

BEGIN
    -- Single SQL query to sum up all tips for restaurants in a given state
    SELECT SUM(o.tip) INTO total_tips
    FROM orders o
    JOIN restaurant r ON o.restaurant_id = r.restaurant_id
    WHERE r.state = state_name;

    -- Output the total tips if any, otherwise output zero
    IF total_tips IS NULL THEN
        state_tips := 0;
        DBMS_OUTPUT.PUT_LINE('No tips collected in the state of ' || state_name);
    ELSE
        state_tips := total_tips;
        DBMS_OUTPUT.PUT_LINE('Total tips in ' || state_name || ': $' || total_tips);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        state_tips := 0;
        DBMS_OUTPUT.PUT_LINE('No data found for the state: ' || state_name);
    WHEN OTHERS THEN
        -- Handle other unexpected errors
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE show_tips_by_waiter(
    wait_name IN VARCHAR,
    wait_tips OUT NUMBER
) IS
    wait_id INT;
    total_tips NUMBER;
BEGIN
    -- Find waiter ID using the provided function
    wait_id := find_waiter_id(wait_name);

    -- Handle case where waiter is not found
    IF wait_id = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Waiter not found');
        wait_tips := 0;
        RETURN;
    END IF;

    -- Aggregate total tips for the waiter
    SELECT NVL(SUM(tip), 0) INTO total_tips
    FROM orders
    WHERE w_id = wait_id;

    -- Output the total tips
    wait_tips := total_tips;
    DBMS_OUTPUT.PUT_LINE(wait_name || 's Tips: $' || total_tips);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- This is handled by NVL in the SELECT, should not normally occur
        wait_tips := 0;
        DBMS_OUTPUT.PUT_LINE('No tips found for ' || wait_name);
    WHEN OTHERS THEN
        -- Generic error handling
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
--Member 3 scenario 3
create or replace PROCEDURE Generate_report_menu_items IS
  CURSOR c1 IS
    SELECT m.name, c.cuisine_name, NVL(ri.quantity, 0) AS quantity
    FROM menu_items m
    LEFT JOIN cuisine_type c ON c.cuisine_type_id = m.cuisine_type_id
    LEFT JOIN restaurant_inventory ri ON m.menu_items_id = ri.menu_items_id;

BEGIN
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('|               Menu Items Report                      |');
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('|      Menu Item       |      Cuisine      |  Quantity  |');
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');

  FOR item IN c1 LOOP  
      DBMS_OUTPUT.PUT_LINE('| ' || RPAD(item.name, 20) || ' | ' || RPAD(item.cuisine_name, 18) || ' | ' || TO_CHAR(item.quantity, '99999') || ' |');
    END LOOP;

  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
END;
/
create or replace PROCEDURE UPDATE_MENU_ITEM_INVENTORY(
    P_RESTAURANT_NAME IN VARCHAR2,
    P_MENU_ITEM_NAME IN VARCHAR2,
    P_QUANTITY IN NUMBER,
    P_ACTION IN VARCHAR2 -- 'REDUCE' or 'INCREASE'
)
IS
    P_RESTAURANT_ID NUMBER;
    P_MENU_ITEM_ID NUMBER;
    CHECK_QUANTITY NUMBER;
BEGIN
    -- Find the restaurant ID using the provided restaurant name
    P_RESTAURANT_ID := FIND_RESTAURANT_ID(P_RESTAURANT_NAME);

    -- Find the menu item ID using the provided menu item name
    P_MENU_ITEM_ID := FIND_MENU_ITEM_ID(P_MENU_ITEM_NAME);

    -- Retrieve the current quantity from the database
    SELECT QUANTITY INTO CHECK_QUANTITY FROM RESTAURANT_INVENTORY WHERE RESTAURANT_ID = P_RESTAURANT_ID AND MENU_ITEMS_ID = P_MENU_ITEM_ID;

    IF P_ACTION = 'REDUCE' THEN
        IF CHECK_QUANTITY - P_QUANTITY >= 0 THEN
            -- UPDATE THE QUANTITY TO REDUCE THE MENU ITEM IN THE INVENTORY
            UPDATE RESTAURANT_INVENTORY
            SET QUANTITY = QUANTITY - P_QUANTITY
            WHERE RESTAURANT_ID = P_RESTAURANT_ID
            AND MENU_ITEMS_ID = P_MENU_ITEM_ID;

            -- OUTPUT A MESSAGE INDICATING THAT THE MENU ITEM INVENTORY HAS BEEN UPDATED
            DBMS_OUTPUT.PUT_LINE('Menu item inventory reduced for Restaurant ' || P_RESTAURANT_NAME || ' and Menu Item ' || P_MENU_ITEM_NAME);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('There is not enough menu items to reduce the inventory.');
        END IF;
    ELSIF P_ACTION = 'INCREASE' THEN
        -- UPDATE THE QUANTITY TO INCREASE THE MENU ITEM IN THE INVENTORY
        UPDATE RESTAURANT_INVENTORY
        SET QUANTITY = QUANTITY + P_QUANTITY
        WHERE RESTAURANT_ID = P_RESTAURANT_ID
        AND MENU_ITEMS_ID = P_MENU_ITEM_ID;

        -- OUTPUT A MESSAGE INDICATING THAT THE MENU ITEM INVENTORY HAS BEEN UPDATED
        DBMS_OUTPUT.PUT_LINE('Menu item inventory increased for Restaurant ' || P_RESTAURANT_NAME || ' and Menu Item ' || P_MENU_ITEM_NAME);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid action. Please specify either "REDUCE" or "INCREASE".');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle case when no data is found for the provided names
        DBMS_OUTPUT.PUT_LINE('Restaurant or Menu Item not found.');
    WHEN OTHERS THEN
        -- OUTPUT AN ERROR MESSAGE IF AN EXCEPTION OCCURS DURING THE UPDATE
        DBMS_OUTPUT.PUT_LINE('Error updating menu item inventory: ' || SQLERRM);
END;


/

-- MEMBER 4 SCENERIO 3
CREATE OR REPLACE PROCEDURE report_top_restaurants IS

  CURSOR top_restaurants_cur IS
    SELECT 
      state,
      restaurant_name,
      total_amount_paid,
      restaurant_rank
    FROM (
      SELECT 
        res.state,
        res.restaurant_name,
        SUM(ord.amount_paid) AS total_amount_paid,
        DENSE_RANK() OVER (PARTITION BY res.state ORDER BY SUM(ord.amount_paid) DESC) as restaurant_rank
      FROM 
        orders ord
        JOIN restaurant res ON ord.restaurant_id = res.restaurant_id
      GROUP BY 
        res.state, 
        res.restaurant_name
    ) WHERE restaurant_rank <= 3
    ORDER BY state, restaurant_rank;

  rec top_restaurants_cur%ROWTYPE;

BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('State', 15) || RPAD('Restaurant Name', 30) || RPAD('Total Amount Paid', 20) || 'Rank');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 15, '-') || RPAD('-', 30, '-') || RPAD('-', 20, '-') || '----');

  OPEN top_restaurants_cur;

  LOOP
    FETCH top_restaurants_cur INTO rec;
    EXIT WHEN top_restaurants_cur%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      RPAD(rec.state, 15) || 
      RPAD(rec.restaurant_name, 30) || 
      LPAD(TO_CHAR(rec.total_amount_paid, '999G999G999D99', 'NLS_NUMERIC_CHARACTERS='',.'''), 20) || 
      LPAD(rec.restaurant_rank, 4)
    );
  END LOOP;

  CLOSE top_restaurants_cur;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No data found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END report_top_restaurants;
/
-- CREATE PROCEDURE TO LIST ORDERS AT A GIVEN RESTAURANT ON A GIVEN DATE
CREATE OR REPLACE PROCEDURE LIST_ORDERS(
    REST_NAME IN VARCHAR2,
    ORD_DATE IN DATE
)
IS
    CURSOR orders_cur IS
        SELECT ORDER_ID, C_ID, MENU_ITEMS_ID, AMOUNT_PAID, TIP
        FROM ORDERS o
        JOIN RESTAURANT r ON o.RESTAURANT_ID = r.RESTAURANT_ID
        WHERE r.RESTAURANT_NAME = REST_NAME
        AND o.ORDER_DATE = ORD_DATE;

    order_rec orders_cur%ROWTYPE;
BEGIN
    -- Open the cursor
    OPEN orders_cur;
    
    -- Fetch orders and print details
    DBMS_OUTPUT.PUT_LINE('Orders at ' || REST_NAME || ' on ' || TO_CHAR(ORD_DATE, 'YYYY-MM-DD') || ':');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
    LOOP
        FETCH orders_cur INTO order_rec;
        EXIT WHEN orders_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Order ID: ' || order_rec.ORDER_ID);
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || order_rec.C_ID);
        DBMS_OUTPUT.PUT_LINE('Menu Item ID: ' || order_rec.MENU_ITEMS_ID);
        DBMS_OUTPUT.PUT_LINE('Amount Paid: $' || order_rec.AMOUNT_PAID);
        DBMS_OUTPUT.PUT_LINE('Tip: $' || order_rec.TIP);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
    END LOOP;
    
    -- Close the cursor
    CLOSE orders_cur;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No orders found at ' || REST_NAME || ' on ' || TO_CHAR(ORD_DATE, 'YYYY-MM-DD'));
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE RECOMMEND_TO_CUSTOMER (
    P_CUSTOMER_NAME IN VARCHAR2,
    P_CUISINE_NAME IN VARCHAR2
)
AS
    V_RESTAURANT_ID NUMBER;
    V_RESTAURANT_NAME VARCHAR2(50);
    V_AVG_STARS NUMBER;
    V_ORDER_COUNT NUMBER;
    V_CUISINE_TYPE_ID NUMBER;
    V_CUSTOMER_ID NUMBER;
BEGIN
    -- FIND THE BEST RATED RESTAURANT FOR THE GIVEN CUISINE TYPE
    V_CUISINE_TYPE_ID := FIND_CUISINE_TYPE_ID(P_CUISINE_NAME);
    IF V_CUISINE_TYPE_ID < 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: CUISINE NOT FOUND.');
        RETURN;
    END IF;
    
    V_CUSTOMER_ID := FIND_CUSTOMER_ID(P_CUSTOMER_NAME);
    IF V_CUSTOMER_ID < 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: CUSTOMER NOT FOUND.');
        RETURN;
    END IF;
    
    SELECT R.RESTAURANT_ID, R.RESTAURANT_NAME, AVG(RV.STARS)
    INTO V_RESTAURANT_ID, V_RESTAURANT_NAME, V_AVG_STARS
    FROM RESTAURANT R
    JOIN REVIEWS RV ON R.RESTAURANT_ID = RV.RESTAURANT_ID
    WHERE R.CUISINE_TYPE_ID = V_CUISINE_TYPE_ID
    GROUP BY R.RESTAURANT_ID, R.RESTAURANT_NAME
    ORDER BY AVG(RV.STARS) DESC;
    
    
    
    DBMS_OUTPUT.PUT_LINE('Best rated RESTAURANT for ' ||  P_CUISINE_NAME || ' is : ' || V_RESTAURANT_NAME);

     -- CHECK IF THE CUSTOMER HAS VISITED THE BEST RATED RESTAURANT SERVING THIS CUISINE TYPE IN THE PAST
    SELECT COUNT(*)
    INTO V_ORDER_COUNT
    FROM ORDERS O
    JOIN MENU_ITEMS M ON O.MENU_ITEMS_ID = M.MENU_ITEMS_ID
    WHERE O.C_ID = V_CUSTOMER_ID
    AND O.RESTAURANT_ID = V_RESTAURANT_ID;

    IF V_ORDER_COUNT = 0 THEN
        -- INSERT RECOMMENDATION IF THE CUSTOMER HAS NOT VISITED THE BEST RATED RESTAURANT SERVING THIS CUISINE TYPE BEFORE
        INSERT INTO RECOMMENDATIONS (RECOMMENDATION_ID, C_ID,RESTAURANT_ID, RECOMMENDATION_DATE)
        VALUES (RECOMENDATION_ID_SEQ.NEXTVAL, V_CUSTOMER_ID, V_RESTAURANT_ID, SYSDATE);
        DBMS_OUTPUT.PUT_LINE('INSERTING RECOMMENDATION AS THE CUSTOMER HAS NOT VISITED THE BEST RATED RESTAURANT SERVING ' ||  P_CUISINE_NAME || ' CUISINE TYPE BEFORE');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('CUSTOMER HAS ALREADY VISITED THE BEST RATED RESTAURANT SERVING THIS CUISINE TYPE: ' || P_CUISINE_NAME);
    END IF;
    DBMS_OUTPUT.PUT_LINE('RECOMMEND_TO_CUSTOMER EXECUTED SUCCESSFULLY');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO RECOMMENDATIONS FOUND FOR THE GIVEN CRITERIA.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR OCCURRED: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE List_Recommendations IS
    col_customer_name_width INT := 25;
    col_restaurant_name_width INT := 25;
    col_cuisine_type_width INT := 20;
    col_avg_stars_width INT := 15;

    -- Header strings for the report
    header_customer_name VARCHAR2(25) := RPAD('Customer Name', col_customer_name_width);
    header_restaurant_name VARCHAR2(25) := RPAD('Recommended Restaurant', col_restaurant_name_width);
    header_cuisine_type VARCHAR2(20) := RPAD('Cuisine Type', col_cuisine_type_width);
    header_avg_stars VARCHAR2(15) := RPAD('Average Stars', col_avg_stars_width);

    -- Separator line
    separator_line VARCHAR2(100) := RPAD('-', col_customer_name_width + col_restaurant_name_width + col_cuisine_type_width + col_avg_stars_width, '-');

BEGIN
    DBMS_OUTPUT.PUT_LINE(header_customer_name || header_restaurant_name || header_cuisine_type || header_avg_stars);
    DBMS_OUTPUT.PUT_LINE(separator_line);

    FOR rec IN (
        SELECT cust.c_name AS CustomerName,
               rest.restaurant_name AS RestaurantName,
               ctype.cuisine_name AS CuisineType,
               AVG(rev.stars) AS AverageStars
        FROM customers cust
        JOIN recommendations recom ON cust.c_id = recom.c_id
        JOIN restaurant rest ON recom.restaurant_id = rest.restaurant_id
        JOIN cuisine_type ctype ON rest.cuisine_type_id = ctype.cuisine_type_id
        LEFT JOIN reviews rev ON rest.restaurant_id = rev.restaurant_id
        GROUP BY cust.c_name, rest.restaurant_name, ctype.cuisine_name
        ORDER BY cust.c_name, AverageStars DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.CustomerName, col_customer_name_width) ||
            RPAD(rec.RestaurantName, col_restaurant_name_width) ||
            RPAD(rec.CuisineType, col_cuisine_type_width) ||
            LPAD(TO_CHAR(NVL(rec.AverageStars, 0), 'FM999D9'), col_avg_stars_width) -- Handle possible NULL values for average stars
        );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No recommendations found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END List_Recommendations;
/

-- MEMBER 6 SCENERIO 3
/* for each cusine type get the most profitable restaurant
based on the amounts paid*/ 
CREATE OR REPLACE PROCEDURE most_profitable_res AS
  CURSOR c1 IS
    SELECT ct.Cuisine_Type_ID, ct.Cuisine_name, r.Restaurant_NAME AS Restaurant_name, SUM(o.amount_paid) AS total_earnings
    FROM Orders o
    JOIN RESTAURANT r ON o.Restaurant_id = r.Restaurant_ID
    JOIN Cuisine_Type ct ON r.cuisine_type_id = ct.Cuisine_Type_ID
    GROUP BY ct.Cuisine_Type_ID, ct.Cuisine_name, r.Restaurant_NAME
    ORDER BY ct.Cuisine_Type_ID, total_earnings DESC;

  v_cuisine_type_id Cuisine_Type.Cuisine_Type_ID%TYPE;
  v_cuisine_name Cuisine_Type.Cuisine_name%TYPE;
  v_restaurant_name RESTAURANT.Restaurant_NAME%TYPE;
  v_total_earnings NUMBER;
  v_max_earnings NUMBER := 0;
  v_prev_cuisine_type_id Cuisine_Type.Cuisine_Type_ID%TYPE;

BEGIN
  v_prev_cuisine_type_id := NULL;

  OPEN c1;
  LOOP
    FETCH c1 INTO v_cuisine_type_id, v_cuisine_name, v_restaurant_name, v_total_earnings;
    EXIT WHEN c1%NOTFOUND;

    IF v_cuisine_type_id != v_prev_cuisine_type_id THEN
      v_max_earnings := v_total_earnings;
      DBMS_OUTPUT.PUT_LINE('Cuisine Type ID: ' || v_cuisine_type_id || 
                           ', Cuisine Name: ' || v_cuisine_name || 
                           ', Restaurant: ' || v_restaurant_name || 
                           ', Total Earnings: $' || v_total_earnings);
    ELSIF v_total_earnings > v_max_earnings THEN
      v_max_earnings := v_total_earnings;
      DBMS_OUTPUT.PUT_LINE('Cuisine Type ID: ' || v_cuisine_type_id || 
                           ', Cuisine Name: ' || v_cuisine_name || 
                           ', Restaurant: ' || v_restaurant_name || 
                           ', Total Earnings: $' || v_total_earnings);
    END IF;

    v_prev_cuisine_type_id := v_cuisine_type_id;
  END LOOP;

  CLOSE c1;
END;
/

/* Report: Generate a report with the names of customers who spent the most money (top 3) so we can send them discount coupons, 
and also the names of the most frugal customers (bottom 3) */
CREATE OR REPLACE PROCEDURE report_customers AS
  -- Cursor to fetch the top 3 customers who have spent the most
  CURSOR c1 IS
    SELECT c.c_name AS customer_name, SUM(o.amount_paid + o.tip) AS amount_spent
    FROM Customers c
    JOIN Orders o ON c.c_ID = o.c_id
    GROUP BY c.c_name
    ORDER BY amount_spent DESC;

  -- Cursor to fetch the bottom 3 customers who have spent the least
  CURSOR c2 IS
    SELECT c.c_name AS customer_name, SUM(o.amount_paid + o.tip) AS amount_spent
    FROM Customers c
    JOIN Orders o ON c.c_ID = o.c_id
    GROUP BY c.c_name
    ORDER BY amount_spent;

  top_customer_name VARCHAR(20);
  top_amount_spent NUMBER;
  bottom_customer_name VARCHAR(20);
  least_amount_spent NUMBER;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Top 3:');
  OPEN c1;
  LOOP
    FETCH c1 INTO top_customer_name, top_amount_spent;
    EXIT WHEN c1%NOTFOUND OR c1%ROWCOUNT > 3; -- Exit loop after top 3 rows
    DBMS_OUTPUT.PUT_LINE(top_customer_name || ' - $' || top_amount_spent);
  END LOOP;
  CLOSE c1;

  DBMS_OUTPUT.PUT_LINE('Bottom 3:');
  OPEN c2;
  LOOP
    FETCH c2 INTO bottom_customer_name, least_amount_spent;
    EXIT WHEN c2%NOTFOUND OR c2%ROWCOUNT > 3; -- Exit loop after bottom 3 rows
    DBMS_OUTPUT.PUT_LINE(bottom_customer_name || ' - $' || least_amount_spent);
  END LOOP;
  CLOSE c2;
END;

/

CREATE OR REPLACE PROCEDURE most_popular_restaurant AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Most popular restaurant(s):');

    -- Using a cursor FOR loop to implicitly handle cursor operations
    FOR rec IN (
        SELECT r.restaurant_name, COUNT(*) AS order_count
        FROM orders o
        JOIN restaurant r ON o.restaurant_id = r.restaurant_id
        GROUP BY r.restaurant_name
        ORDER BY COUNT(*) DESC
    ) LOOP
        -- Assuming we only want to display the top result
        DBMS_OUTPUT.PUT_LINE(rec.restaurant_name || ' with ' || rec.order_count || ' orders.');
        EXIT; -- Exit after the first row to mimic FETCH FIRST 1 ROW ONLY behavior
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END most_popular_restaurant;
/

/
CREATE OR REPLACE TRIGGER UPDATE_INVENTORY_AFTER_ORDER
AFTER INSERT ON ORDERS
FOR EACH ROW
BEGIN
    -- REDUCE THE INVENTORY BY 1 WHENEVER AN ORDER IS PLACED
    UPDATE RESTAURANT_INVENTORY
    SET QUANTITY = QUANTITY - 1
    WHERE RESTAURANT_ID = :NEW.RESTAURANT_ID AND MENU_ITEMS_ID = :NEW.MENU_ITEMS_ID; 
    
    IF SQL%ROWCOUNT = 0 THEN
        -- IF NO ROWS ARE UPDATED, IT COULD MEAN INVENTORY IS NOT TRACKED
        DBMS_OUTPUT.PUT_LINE('INVENTORY UPDATE FAILED: NO INVENTORY RECORD.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('INVENTORY UPDATED SUCCESSFULLY.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR OCCURRED IN UPDATING INVENTORY: ' || SQLERRM);
END UPDATE_INVENTORY_AFTER_ORDER;
/


--Adding Data
Begin
 Add_Cuisine('American');
 Add_Cuisine('Italian');
 Add_Cuisine('Indian');
 Add_Cuisine('BBQ');
 Add_Cuisine('Ethiopian');
End;
/

Begin
    Add_restaurant('RIBS_R_US', '123 MAIN ST', 'LOS ANGELES', 'CA', 21250, 'American');
    Add_restaurant('BELLA ITALIA', '456 ELM ST', 'SAN FRANCISCO', 'CA', 21043, 'Italian');
    Add_restaurant('SELASIE', '782 PARK AVE', 'PHILI', 'PA', 16822, 'Ethiopian');
    Add_restaurant('ROMA', '987 ROMA AVE', 'CHICAGO', 'IL', 21043, 'Italian');
    ADD_RESTAURANT('TAJ MAHAL','MAIDEN ST','BROOKLYN ','NY','10013','Indian');
    ADD_RESTAURANT('BULL ROAST','CHOICE ST','QUEENS','NY','10013','BBQ');
    ADD_RESTAURANT('ETHIOP','PANNIER ST','PITTSBURGH ','PA','16822','Ethiopian');

End;

/

Begin 
    Hire_WAITER('JACK','RIBS_R_US');
    hire_WAITER('JILL', 'RIBS_R_US');
    hire_WAITER('WENDY', 'RIBS_R_US');
    hire_WAITER('HAILEY', 'RIBS_R_US');
    hire_WAITER('MARY', 'BELLA ITALIA');
    hire_WAITER('PAT', 'BELLA ITALIA');
    hire_WAITER('MICHAEL', 'BELLA ITALIA');
    hire_WAITER('RAKESH', 'BELLA ITALIA');
    hire_WAITER('VERMA', 'BELLA ITALIA');
    hire_WAITER('MIKE', 'ROMA');
    hire_WAITER('JUDY', 'ROMA');
    hire_WAITER('TREVOR', 'SELASIE');
    HIRE_WAITER('TRISHA', 'ETHIOP');
    HIRE_WAITER('HANNAH', 'BULL ROAST');
    HIRE_WAITER('GUPTA', 'TAJ MAHAL');


end;
/

--ADD DATA IN MENU ITEM TABLE
Begin
CREATE_MENU_ITEM('BURGER', 10, 'American');
CREATE_MENU_ITEM('FRIES', 5, 'American');
CREATE_MENU_ITEM('PASTA', 15, 'American');
CREATE_MENU_ITEM('SALAD', 10, 'American');
CREATE_MENU_ITEM('SALMON', 20, 'American');
-- ADD MENU ITEMS FOR ITALIAN CUISINE
CREATE_MENU_ITEM('LASAGNA', 15, 'Italian');
CREATE_MENU_ITEM('MEATBALLS', 10, 'Italian');
CREATE_MENU_ITEM('SPAGHETTI', 15, 'Italian');
CREATE_MENU_ITEM('PIZZA', 20, 'Italian');

-- ADD MENU ITEMS FOR ETHIOPIAN CUISINE
CREATE_MENU_ITEM('MEAT CHUNKS', 12, 'Ethiopian');
CREATE_MENU_ITEM('LEGUME STEW', 10, 'Ethiopian');
CREATE_MENU_ITEM('FLATBREAD', 3, 'Ethiopian');

-- ADD MENU ITEMS FOR BBQ CUISINE
CREATE_MENU_ITEM('STEAK', 25, 'BBQ');
CREATE_MENU_ITEM('PORK LOIN', 15, 'BBQ');
CREATE_MENU_ITEM('FILET MIGNON', 30, 'BBQ');
 
-- ADD MENU ITEMS FOR INDIAN CUISINE
CREATE_MENU_ITEM('DAL SOUP', 10, 'Indian');
CREATE_MENU_ITEM('RICE', 5, 'Indian');
CREATE_MENU_ITEM('TANDOORI CHICKEN', 10, 'Indian');
CREATE_MENU_ITEM('SAMOSA', 8, 'Indian');

end;

/
begin
    --ADD MENU ITEM DATA TO INVENTORY
 ADD_ITEMS_INVENTORY('BURGER', 'RIBS_R_US', 50);
 ADD_ITEMS_INVENTORY('FRIES', 'RIBS_R_US', 150);
 ADD_ITEMS_INVENTORY('LASAGNA', 'BELLA ITALIA', 10);
 ADD_ITEMS_INVENTORY('MEATBALLS', 'BELLA ITALIA', 5);
 ADD_ITEMS_INVENTORY('MEAT CHUNKS', 'SELASIE', 150);
 ADD_ITEMS_INVENTORY('LEGUME STEW', 'SELASIE', 150);
 ADD_ITEMS_INVENTORY('FLATBREAD', 'SELASIE', 500);
 ADD_ITEMS_INVENTORY('PIZZA', 'BELLA ITALIA', 100);
 ADD_ITEMS_INVENTORY('SPAGHETTI', 'BELLA ITALIA', 100);
 

ADD_ITEMS_INVENTORY('STEAK', 'BULL ROAST', 15);
ADD_ITEMS_INVENTORY('PORK LOIN', 'BULL ROAST', 50);
ADD_ITEMS_INVENTORY('FILET MIGNON', 'BULL ROAST', 5);
ADD_ITEMS_INVENTORY('DAL SOUP', 'TAJ MAHAL', 50);
ADD_ITEMS_INVENTORY('RICE', 'TAJ MAHAL', 500);
ADD_ITEMS_INVENTORY('SAMOSA', 'TAJ MAHAL', 150);

ADD_ITEMS_INVENTORY('MEAT CHUNKS', 'ETHIOP', 150);
ADD_ITEMS_INVENTORY('LEGUME STEW', 'ETHIOP', 150);
ADD_ITEMS_INVENTORY('FLATBREAD', 'ETHIOP', 500);

END;
/

BEGIN
    INSERT_CUSTOMERS('CUST1', 'CUST1@GMAIL.COM', '401 S BEECHFIELD', 'BALTIMORE', 'MD', '21045', '1234 1234 1234 1324');
    INSERT_CUSTOMERS('CUST11', 'CUST11@GMAIL.COM', '411 S BEECHFIELD', 'BALTIMORE', 'MD', '21045', '1234 1234 1234 1324');
    INSERT_CUSTOMERS('CUST3', 'CUST3@GMAIL.COM', '403 S BEECHFIELD', 'BALTIMORE', 'MD', '21046', '1234 1234 1234 1324');
    INSERT_CUSTOMERS('CUST111', 'CUST111@GMAIL.COM', '4111 S BEECHFIELD', 'BALTIMORE', 'MD', '21045', '1234 1234 1234 1324');
    INSERT_CUSTOMERS('CUSTNY1', 'CUSTNY1@GMAIL.COM', '4111 S BEECHFIELD', 'BALTIMORE', 'MD', '10045', '1234 1234 1234 1324');
    INSERT_CUSTOMERS('CUSTNY2', 'CUSTNY2GMAIL.COM', '1020 Maple Drive', 'Phoenix', 'AZ', '10045', '2345 2345 2345 2345');
    INSERT_CUSTOMERS('CUSTNY3', 'CUSTNY3@GMAIL.COM', '1100 Oak Lane', 'Atlanta', 'GA', '10045', '3456 3456 3456 3456');
    INSERT_CUSTOMERS('CUSTPA1', 'CUSTPA1@GMAIL.COM', '1122 Birch Road', 'Austin', 'TX', '16822', '4567 4567 4567 4567');
    INSERT_CUSTOMERS('CUSTPA2', 'CUSTPA2@GMAIL.COM', '1188 Cedar St.', 'Seattle', 'WA', '16822', '5678 5678 5678 5678');
    INSERT_CUSTOMERS('CUSTPA3', 'CUSTPA3@GMAIL.COM', '1234 Pine Street', 'Chicago', 'IL', '16822', '6789 6789 6789 6789');
    INSERT_CUSTOMERS('CUSTPA4', 'CUSTOMERPA4@GMAIL.COM', '545 ITSROADWAY', 'PHILI', 'MD', '16822', '2433222');
INSERT_CUSTOMERS('CUSTPA5', 'CUSTOMERPA5@GMAIL.COM', '1234 LIBERTY AVE', 'PHILI', 'MD', '16822', '2556654');
Insert_CUSTOMERS('CUSTPA6', 'CUSTOMERPA6@GMAIL.COM', '6789 FREEDOM LN', 'PHILI', 'MD', '16822', '3667788');




End;
/

Begin

 -- ADD DATA TO ORDER TABLE
    
add_ORDER('BELLA ITALIA', 'CUST1', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'PIZZA', 'MARY', 10);
add_ORDER('BELLA ITALIA', 'CUST1', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'PIZZA', 'MARY', 10);
add_ORDER('BELLA ITALIA', 'CUST11', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'SPAGHETTI', 'MARY', 15);
add_ORDER('BELLA ITALIA', 'CUST11', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'SPAGHETTI', 'MARY', 15);
add_ORDER('BELLA ITALIA', 'CUST11', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'PIZZA', 'MARY', 10);
add_ORDER('BELLA ITALIA', 'CUST11', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'PIZZA', 'MARY', 10);
add_ORDER('BULL ROAST', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'FILET MIGNON', 'HANNAH', 30);
add_ORDER('BULL ROAST', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'FILET MIGNON', 'HANNAH', 30);
add_ORDER('BULL ROAST', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'FILET MIGNON', 'HANNAH', 30);
add_ORDER('BULL ROAST', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'FILET MIGNON', 'HANNAH', 30);
add_ORDER('BULL ROAST', 'CUSTNY1', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'FILET MIGNON', 'HANNAH', 30);
add_ORDER('BULL ROAST', 'CUSTNY1', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'FILET MIGNON', 'HANNAH', 30);
add_ORDER('BULL ROAST', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'PORK LOIN', 'HANNAH', 15);

add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('SELASIE', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TREVOR', 12);
add_ORDER('SELASIE', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TREVOR', 12);
add_ORDER('SELASIE', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TREVOR', 12);
add_ORDER('SELASIE', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TREVOR', 12);


add_ORDER('RIBS_R_US', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'BURGER', 'JACK', 10);
add_ORDER('RIBS_R_US', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'BURGER', 'JACK', 10);
add_ORDER('RIBS_R_US', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'BURGER', 'JACK', 10);
add_ORDER('RIBS_R_US', 'CUSTNY1', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'BURGER', 'JACK', 10);
add_ORDER('RIBS_R_US', 'CUSTNY1', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'BURGER', 'JILL', 10);
add_ORDER('RIBS_R_US', 'CUSTNY1', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'BURGER', 'JILL', 10);
add_ORDER('RIBS_R_US', 'CUSTNY1', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'BURGER', 'JILL', 10);
add_ORDER('RIBS_R_US', 'CUSTNY1', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'BURGER', 'JILL', 10);
add_ORDER('BULL ROAST', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'PORK LOIN', 'HANNAH', 15);
add_ORDER('SELASIE', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TREVOR', 12);
add_ORDER('SELASIE', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TREVOR', 12);
add_ORDER('SELASIE', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TREVOR', 12);
add_ORDER('SELASIE', 'CUSTNY2', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TREVOR', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);
add_ORDER('ETHIOP', 'CUSTPA1', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'MEAT CHUNKS', 'TRISHA', 12);


add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);
add_ORDER('SELASIE', 'CUSTPA2', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'LEGUME STEW', 'TREVOR', 10);

add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);
add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);
add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);
add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);
add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);
add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);
add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);
add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);
add_ORDER('TAJ MAHAL', 'CUSTPA2', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'SAMOSA', 'GUPTA', 8);



End;
/


Begin
    ADD_REVIEW('CUST1@GMAIL.COM', 'RIBS_R_US', 4, 'Wonderful place, but expensive');
    ADD_REVIEW('CUST1@GMAIL.COM', 'BELLA ITALIA', 2, 'Verybad food. Im Italian and Bella Italia does NOT give you authentic Italian food');
    ADD_REVIEW('ABC@ABC.COM', 'RIBS_R_US', 4,'I liked the food. Good experience');
    ADD_REVIEW('DCE@ABC.COM', 'RIBS_R_US', 5, 'Excellent');
    ADD_REVIEW('ABC@ABC.COM', 'BELLA ITALIA', 4, 'So-So');
    ADD_REVIEW('ABC@ABC.COM', 'SELASIE', 4,'I liked the food. Authentic Ethiopian experience');
    Add_Review('CUST1@GMAIL.COM', 'SELASIE', 5, 'Excellent flavor. Highly recommended');
    Add_Review('ABC@ABC.COM', 'RIBS_R_US', 2, 'So-so. Low quality beef');
    ADD_REVIEW('ABC@ABC.COM', 'SELASIE', 4, 'I LIKED THE FOOD. AUTHENTIC ETHIOPIAN EXPERIENCE');
ADD_REVIEW('CUST1@GMAIL.COM', 'SELASIE', 5, 'EXCELLENT FLAVOR. HIGHLY RECOMMENDED');
ADD_REVIEW('ABC@ABC.COM', 'RIBS_R_US', 2, 'SO-SO. LOW QUALITY BEEF');
ADD_REVIEW('CUST1@GMAIL.COM', 'TAJ MAHAL', 4, 'I ENJOYED THEIR SAMOSAS, BUT DID NOT LIKE THE DAL');
ADD_REVIEW('ZZZ@ABC.COM', 'TAJ MAHAL', 5, 'EXCELLENT SAMOSAS');
ADD_REVIEW('SURAJIT@ABC.COM', 'TAJ MAHAL', 3, 'NOT REALLY AUTHENTIC');


end;
/


declare
t_tip number;
tips number;

BEGIN
dbms_output.put_line('=================================');
dbms_output.put_line('=====Member 1 Operations ========');
dbms_output.put_line('=================================');

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');


restaurant_info('Ethiopian');

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

restaurant_info('Italian');

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

cuisine_report_by_state;

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');




dbms_output.put_line('=================================');
dbms_output.put_line('=====Member 2 Operations ========');
dbms_output.put_line('=================================');

show_tips_by_state('CA',tips);
DBMS_OUTPUT.PUT_LINE('Total Tips for California: $' || tips);
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

    
show_tips_by_waiter('MARY',t_tip);


DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

DBMS_OUTPUT.PUT_LINE('Waiters at Bella Italia:');
    -- Loop to show waiters at Bella Italia
    FOR rec IN (
        SELECT w.w_Name
        FROM AllWaiters w
        JOIN Restaurant r ON w.rest_id = r.restaurant_id
        WHERE UPPER(r.restaurant_name) = 'BELLA ITALIA'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.w_Name);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(' ');  -- Adding space for better readability
    DBMS_OUTPUT.PUT_LINE('Waiters at Taj Mahal:');

    -- Loop to show waiters at Taj Mahal
    FOR rec IN (
        SELECT w.w_Name
        FROM AllWaiters w
        JOIN Restaurant r ON w.rest_id = r.restaurant_id
        WHERE UPPER(r.restaurant_name) = 'TAJ MAHAL'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.w_Name);
    END LOOP;

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');





    -- Display initial header for operations
    DBMS_OUTPUT.PUT_LINE('=================================');
    DBMS_OUTPUT.PUT_LINE('===== Member 3 Operations ========');
    DBMS_OUTPUT.PUT_LINE('=================================');
    DBMS_OUTPUT.PUT_LINE(' ');

    -- Call to generate initial report of menu items
    Generate_report_menu_items;

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(' ');

    -- Update inventory items
    UPDATE_MENU_ITEM_INVENTORY('TAJ MAHAL', 'RICE', 25, 'REDUCE');
    UPDATE_MENU_ITEM_INVENTORY('SELASIE', 'MEAT CHUNKS', 50, 'REDUCE');
    UPDATE_MENU_ITEM_INVENTORY('BELLA ITALIA', 'LASAGNA', 2, 'REDUCE');
    UPDATE_MENU_ITEM_INVENTORY('BULL ROAST', 'FILET MIGNON', 4, 'REDUCE');

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Initial ETHIOP inventory');
       DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(' ');


    -- Query to display initial ETHIOP inventory
    FOR rec IN (
        SELECT r.restaurant_name, ri.name, ri.quantity
        FROM restaurant_inventory ri
        JOIN restaurant r ON ri.restaurant_id = r.restaurant_id
        WHERE r.restaurant_name = 'ETHIOP'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Restaurant: ' || rec.restaurant_name || 
                             ', Item: ' || rec.name || 
                             ', Quantity: ' || rec.quantity);
    END LOOP;

    -- Additional updates
    DBMS_OUTPUT.PUT_LINE(' ');
    UPDATE_MENU_ITEM_INVENTORY('ETHIOP', 'MEAT CHUNKS', 60, 'REDUCE');
    UPDATE_MENU_ITEM_INVENTORY('ETHIOP', 'LEGUME STEW', 20, 'REDUCE');

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(' FINAL ETHIOP INVENTORY ');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(' ');


    -- Query to display final ETHIOP inventory
    FOR recc IN (
        SELECT r.restaurant_name, ri.name, ri.quantity
        FROM restaurant_inventory ri
        JOIN restaurant r ON ri.restaurant_id = r.restaurant_id
        WHERE r.restaurant_name = 'ETHIOP'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Restaurant: ' || recc.restaurant_name || 
                             ', Item: ' || recc.name || 
                             ', Quantity: ' || recc.quantity);
    END LOOP;

 -- Call to generate final report of menu items
Generate_report_menu_items;

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');



dbms_output.put_line('=================================');
dbms_output.put_line('=====Member 4 Operations ========');
dbms_output.put_line('=================================');

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

report_top_restaurants;

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

LIST_ORDERS('SELASIE',TO_DATE('2024-04-01', 'YYYY-MM-DD'));

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

LIST_ORDERS('RIBS_R_US',TO_DATE('2024-04-01', 'YYYY-MM-DD'));

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');


dbms_output.put_line('=================================');
dbms_output.put_line('=====Member 5 Operations ========');
dbms_output.put_line('=================================');


RECOMMEND_TO_CUSTOMER('CUST111','BBQ');

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

RECOMMEND_TO_CUSTOMER('CUST111','Indian');

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

buy_or_beware(2);

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');


List_Recommendations;

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

dbms_output.put_line('=================================');
dbms_output.put_line('=====Member 6 Operations ========');
dbms_output.put_line('=================================');

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

most_profitable_res;

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

report_customers;

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');

DBMS_OUTPUT.PUT_LINE('Customers in zip code 21045:');
    -- Loop to show customer names in the specific zip code
    FOR reccc IN (
        SELECT c_name
        FROM Customers
        WHERE c_Zip_code = 21045
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(reccc.c_name);
    END LOOP;
    
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE(' ');
    
most_popular_restaurant;

END;

/







