/*
Cleaning Nashville Housing Data.
*/

-- Select all Data from the Table.
SELECT *
FROM nashville;


------------------------------------------------------------------------------
-- Standardize sale_date Format.
SELECT sale_date
FROM nashville;

-- Alter the sale_date to date format
ALTER Table nashville
ALTER COLUMN sale_date TYPE DATE using to_date(sale_date, 'Month DD, YYYY');

--Set the date to DD/MM/YYYY.
SET datestyle TO DMY, SQL;


------------------------------------------------------------------------------
-- Populate Property Address having Null with Address of Simialr Parcel ID. 
SELECT a.unique_id, a.parcel_id, a.property_address, b.parcel_id, b.property_address,
		COALESCE(a.property_address, b.property_address)
FROM nashville AS a
JOIN nashville AS b
ON a.parcel_id = b.parcel_id
AND a.unique_id != b.unique_id
WHERE a.property_address IS null;

-- Update the Table with 30 Missing Property Addresses.
-- Replace the Missing rows(null) with Address having the same Parcel id.
UPDATE nashville 
SET property_address = CASE unique_id 
						WHEN 14753 THEN '908  PATIO DR, NASHVILLE'
						WHEN 8126 THEN '700  GLENVIEW DR, NASHVILLE'
						WHEN 46919 THEN '2524  VAL MARIE DR, MADISON'
						WHEN 11478 THEN '237  37TH AVE N, NASHVILLE'
						WHEN 36531 THEN '2117  PAULA DR, MADISON'
						WHEN 27140 THEN '815  31ST AVE N, NASHVILLE'
						WHEN 51930 THEN '7601  CHIPMUNK LN, NASHVILLE'
						WHEN 3299 THEN '726  IDLEWILD DR, MADISON'
						WHEN 43151 THEN '608  SANDY SPRING TRL, MADISON'
						WHEN 48731 THEN '438  W CAMPBELL RD, GOODLETTSVILLE'
						WHEN 43076 THEN '410  ROSEHILL CT, GOODLETTSVILLE'
						WHEN 32385 THEN '311  35TH AVE N, NASHVILLE'
						WHEN 49886 THEN '2721  HERMAN ST, NASHVILLE'
						WHEN 24197 THEN '2704  ALVIN SPERRY PASS, MOUNT JULIET'
						WHEN 15886 THEN '2537  JANALYN TRCE, HERMITAGE'
						WHEN 46919 THEN '2524 VAL MARIE  DR, MADISON'
						WHEN 45349 THEN '224  HICKORY ST, MADISON'
						WHEN 40678 THEN '222  FOXBORO DR, MADISON'
						WHEN 44264 THEN '213  WARREN CT, OLD HICKORY'
						WHEN 22775 THEN '213 B  LOVELL ST, MADISON'
						WHEN 45290 THEN '208  EAST AVE, GOODLETTSVILLE'
						WHEN 50927 THEN '202  KEETON AVE, OLD HICKORY'
						WHEN 39432 THEN '141  TWO MILE PIKE, GOODLETTSVILLE'
						WHEN 45298 THEN '1289  GOODMORNING DR, NASHVILLE'
						WHEN 45774 THEN '1205  THOMPSON PL, NASHVILLE'
						WHEN 43080 THEN '1129  CAMPBELL RD, GOODLETTSVILLE'
						WHEN 47293 THEN '112  HILLER DR, OLD HICKORY'
						WHEN 45295 THEN '1116  CAMPBELL RD, GOODLETTSVILLE'
						WHEN 51703 THEN '109  CEDAR PLACE BND, NASHVILLE'
						ELSE '109  CANTON CT, GOODLETTSVILLE'
						END
WHERE unique_id IN (14753, 8126, 46919, 11478, 36531, 27140, 51930, 3299, 43151, 48731,
				   43076, 32385, 49886, 24197, 15886, 46919, 45349, 40678, 44264, 
				   22775, 45290, 50927, 39432, 45298, 45774, 43080, 47293, 45295, 
				   51703, 53147)
						

------------------------------------------------------------------------------
-- Breaking out Address into Individual Column (Address, City, State)  
SELECT property_address, owner_address
FROM nashville

-- For Property Address.
SELECT property_address,
		LEFT(property_address, POSITION(',' IN property_address) -1) AS address, 
		SUBSTRING(property_address, POSITION(',' IN property_address) +2, LENGTH(property_address)) AS city
FROM nashville

--ADD property_split_address column to the Table. 
ALTER Table nashville
Add property_split_address varchar(255);

--Update the property_split_address column with the Splitted Address.
Update nashville 
SET property_split_address = LEFT(property_address, POSITION(',' IN property_address) -1)

--ADD property_split_city column to the Table. 
ALTER Table nashville
Add property_split_city varchar(100);

--Update the property_split_city column with the Splitted City.
UPDATE nashville 
SET property_split_city = SUBSTRING(property_address, POSITION(',' IN property_address) +2, LENGTH(property_address))


--For Owner Address.
SELECT owner_address,
	SUBSTRING(owner_address, 1, POSITION(',' IN owner_address) -1) as address, 
	split_part(owner_address, ', ', 2) AS city,
	RIGHT(owner_address, 2) AS state
FROM nashville

--ADD owner_split_address column to the Table.
ALTER Table nashville
Add owner_split_address varchar(255);

--Update the owner_split_address column with the Splitted Address.
UPDATE nashville 
SET owner_split_address = SUBSTRING(owner_address, 1, POSITION(',' IN owner_address) -1)

--ADD owner_split_city column to the Table.
ALTER Table nashville
Add owner_split_city varchar(100);

--Update the owner_split_city column with the Splitted City
UPDATE nashville 
SET owner_split_city = split_part(owner_address, ', ', 2)

--ADD owner_split_state column to the Table.
ALTER Table nashville
Add owner_split_state varchar(5);

--Update the owner_split_state column with the Splitted State.
UPDATE nashville 
SET owner_split_state = RIGHT(owner_address, 2)

-- Check for property_address and owner_address column.
SELECT *
FROM nashville


------------------------------------------------------------------------------
--Change Y or N to Yes and No in sold_as_vacant column.
SELECT sold_as_vacant, CASE When sold_as_vacant = 'Y' Then 'Yes'
							When sold_as_vacant = 'N' Then 'No'
							ELSE sold_as_vacant
							END
FROM nashville

UPDATE nashville
SET sold_as_vacant = CASE When sold_as_vacant = 'Y' Then 'Yes'
							When sold_as_vacant = 'N' Then 'No'
							ELSE sold_as_vacant
							END

-- Check all sold_as_vacant column to ensure the changes are made.
SELECT sold_as_vacant
FROM nashville


------------------------------------------------------------------------------
--Delete Unused Colums.
SELECT *
FROM nashville

ALTER Table nashville
DROP COLUMN property_address, 
DROP COLUMN owner_address

-- Check for deleted columns.
SELECT *
FROM nashville
