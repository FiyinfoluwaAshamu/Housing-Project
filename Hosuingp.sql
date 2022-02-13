
--Cleaning Data in SQL

SELECT *
FROM HousingProject..Nathousing


--Standadize date format

SELECT SalesDateConverted, CONVERT(Date, SaleDate)
FROM HousingProject..Nathousing

ALTER TABLE HousingProject..Nathousing
ADD SalesDateConverted DATE;

UPDATE HousingProject..Nathousing
SET SalesDateConverted = CONVERT(Date, SaleDate)

-- Populate property address

SELECT a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM HousingProject..Nathousing as a
JOIN HousingProject..Nathousing as b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingProject..Nathousing as a
JOIN HousingProject..Nathousing as b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

--Crosschecking
SELECT PropertyAddress
FROM HousingProject..Nathousing
--WHERE PropertyAddress is NULL

--Break address in to; Address, city & state.
 SELECT
 SUBSTRING (PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address
 , SUBSTRING (PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) as City
 FROM HousingProject..Nathousing


ALTER TABLE HousingProject..Nathousing
ADD Address NVARCHAR(255);

UPDATE HousingProject..Nathousing
SET Address = SUBSTRING (PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) 

ALTER TABLE HousingProject..Nathousing
ADD City NVARCHAR(255);

UPDATE HousingProject..Nathousing
SET City = SUBSTRING (PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) 


SELECT OwnerAddress
 FROM HousingProject..Nathousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),  2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),  1)
FROM HousingProject..Nathousing

ALTER TABLE HousingProject..Nathousing
ADD OwnerNewAddress NVARCHAR(255);

UPDATE HousingProject..Nathousing
SET OwnerNewAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) 

ALTER TABLE HousingProject..Nathousing
ADD OwnerCity NVARCHAR(255);

UPDATE HousingProject..Nathousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),  2)

ALTER TABLE HousingProject..Nathousing
ADD OwnerState NVARCHAR(255);

UPDATE HousingProject..Nathousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),  1)

SELECT *
 FROM HousingProject..Nathousing

ALTER TABLE HousingProject..Nathousing 
DROP COLUMN PropertyNewAddress;

--Change y/n to yes/no in 'sold as vacant'


SELECT DISTINCT(SoldAsVacant), COUNT (SoldAsVacant)
 FROM HousingProject..Nathousing
 GROUP BY SoldAsVacant
 ORDER BY 2

 SELECT SoldAsVacant
 , CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
  FROM HousingProject..Nathousing


UPDATE HousingProject..Nathousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END


-- Remove Duplicates
WITH RowNumCTE AS (
SELECT *,
        ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
		             PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY 
					    UniqueID
						) row_num
					    
FROM HousingProject..Nathousing
)
DELETE
FROM RownumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


--Delete unused column

SELECT *
FROM HousingProject..Nathousing


ALTER TABLE HousingProject..Nathousing
DROP COLUMN  OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

--ALTER TABLE HousingProject..Nathousing
--RENAME COLUMN Address To PropertyNewAddress;



