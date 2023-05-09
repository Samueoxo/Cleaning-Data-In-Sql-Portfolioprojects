select*
from portfolioproject.dbo.NashvilleHousing

--Standardize Data Format

select SaleDateConverted, CONVERT(Date,SaleDate)
from portfolioproject.dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate Property Address Data

select*
from portfolioproject.dbo.NashvilleHousing
Where PropertyAddress is null
Order by ParcelID


select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleHousing a
JOIN  portfolioproject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleHousing a
JOIN  portfolioproject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address Into Individual Columns(Address,city,State)

select PropertyAddress
from portfolioproject.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) as Address
from portfolioproject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress))


Select*
from portfolioproject.dbo.NashvilleHousing


Select OwnerAddress
from portfolioproject.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from portfolioproject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add ownerSplitAddress nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

update NashvilleHousing
SET PropertySplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select*
from portfolioproject.dbo.NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldASVacant),COUNT(SoldAsVacant)
from portfolioproject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


select SoldASVacant,
CASE When SoldASVacant = 'Y' THEN 'YES'
     When SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldASVacant
	 END
from portfolioproject.dbo.NashvilleHousing

update NashvilleHousing
 SET SoldASVacant = CASE When SoldASVacant = 'Y' THEN 'YES'
     When SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldASVacant
	 END


	 --Remove Duplicates

WITH RowNumCTE AS(
	 Select*,
	 ROW_NUMBER()OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  saleDate,
				  LegalReference
				  ORDER By
				  UniqueID
				  ) row_num




from portfolioproject.dbo.NashvilleHousing
--order by ParcelID
)
Select*
from RowNumCTE
Where row_num > 1
--order by PropertyAddress

--Delete Unused Columns

Select*
from portfolioproject.dbo.NashvilleHousing

ALTER TABLE portfolioproject.dbo.NashvilleHousing
DROP Column OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE portfolioproject.dbo.NashvilleHousing
DROP Column SaleDate


	 


















