SELECT *
  FROM [PortfolioProject].[dbo].[NashvilleHousing]


-- date format

SELECT SaleDate, SaleDateconverted
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

Alter table NashvilleHousing
add SaleDateconverted Date

UPDATE NashvilleHousing
SET SaleDateconverted = convert (date, SaleDate)


--POPULATE PROPERTY ADDRESS DATA
Select *, PropertyAddress
from NashvilleHousing
--where propertyAddress is NULL
order by parcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID= b.ParcelID
	and a.UniqueID <> b.UniqueID
	where a.propertyAddress is null
-- IN THE ABOVE QUERY IN ISNULL WE HAVE ENTERED THE PROPERTY ADDRESS WHICH IS NULL AND WE WILL REPLACE IT WITH THE OTHER PART OF THE COMMA, FOR EXAMPLE IN THIS ONE
--WE HAD NULL VALUES IN PROPERTY, WE FOUND OUT THE NULL VALUES BY SELF CMOPARING / SELF JOIN, and from here we can update the new column in property adress.



UPDATE a
set PropertyAddress= ISNULL (a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID= b.ParcelID
	and a.UniqueID <> b.UniqueID
	where a.propertyAddress is null

-- in the above query we have updated the property address with the new column which we had created after comparing it with self join,
-- and now if we check there is no null values in the property address 

Select PropertyAddress
from NashvilleHousing

Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Town
from NashvilleHousing

-- in the query above we differenciated the complete address with the home address or street/town in this case it will be better for us to filter according to the town
--in future

Alter table NashvilleHousing
add PropertySplitAddress nvarchar(255)

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) 

Alter table NashvilleHousing
add PropertySplitCity nvarchar(255)

update NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

Select 
PARSENAME (REPLACE(OwnerAddress, ',' , '.') , 3),
PARSENAME (REPLACE(OwnerAddress, ',' , '.') , 2),
PARSENAME (REPLACE(OwnerAddress, ',' , '.') , 1)

from NashvilleHousing

-- PARSENAME is the substitute of the substring in the easier way but it wors backwords so no they will make branches like in this whenever there is a ,

Alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
SET OwnerSplitAddress =  PARSENAME (REPLACE(OwnerAddress, ',' , '.') , 3)

Alter table NashvilleHousing
add OwnerSplitCity nvarchar(255)

update NashvilleHousing
SET OwnerSplitCity =  PARSENAME (REPLACE(OwnerAddress, ',' , '.') , 2)

Alter table NashvilleHousing
add OwnerSplitState nvarchar(255)

update NashvilleHousing
SET OwnerSplitState =  PARSENAME (REPLACE(OwnerAddress, ',' , '.') , 1)


Select DISTINCT (SoldAsVacant), COUNT (SoldAsVacant)
from NashvilleHousing
GROUP BY SoldAsVacant
order by 2



SELECT SoldAsVacant, CONVERT (nvarchar, SoldAsVacant) 
FROM NashvilleHousing

Alter table NashvilleHousing
Alter Column SoldAsVacant nvarchar(255)

update NashvilleHousing
SET SoldAsVacant =  CONVERT (nvarchar, SoldAsVacant)

Select SoldAsVacant ,
CASE when SoldAsVacant = 1 then 'Yes'
	when SoldAsVacant = 0 then 'No'
	Else SoldAsVacant
	End

from NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 1 then 'Yes'
	when SoldAsVacant = 0 then 'No'
	Else SoldAsVacant
	End

	SELECT *
  FROM [PortfolioProject].[dbo].[NashvilleHousing]


-- now er will be removing duplicates from the entire database
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID) row_num
  FROM NashvilleHousing
  )
Select * from RowNumCTE
where row_num >1
order by PropertyAddress

-- in the above query we found out the duplicates by ordering it by unique id and creating a function as run_number where the system will end us the details about
-- the rows which are mulitple and we added that in a cte so that we can use where funtionality properly, also the rows which are shown here will be deleted after
-- we create the delete query.

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID) row_num
  FROM NashvilleHousing
  )
Delete from RowNumCTE
where row_num >1


--DELETE UNSED COLUMNS

Select * from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN TaxDistrict, PropertyAddress, OwnerAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate
