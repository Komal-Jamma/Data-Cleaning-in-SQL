
Select * 
from PortfolioProject..Nashville_Data_Cleaning

--Converting Date format of column Sale Date into the Standard Date format

select SaleDate from PortfolioProject..Nashville_Data_Cleaning

Alter table PortfolioProject..Nashville_Data_Cleaning
Add SaleDateConverted Date;

update PortfolioProject..Nashville_Data_Cleaning
set SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted from PortfolioProject..Nashville_Data_Cleaning

--Populating Property Address(Replacing NULL values)

Select *
from PortfolioProject..Nashville_Data_Cleaning
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..Nashville_Data_Cleaning a
Join PortfolioProject..Nashville_Data_Cleaning b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID]<>b.[UniqueID]
	where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..Nashville_Data_Cleaning a
Join PortfolioProject..Nashville_Data_Cleaning b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID]<>b.[UniqueID]
	where a.PropertyAddress is null

--Splitting PropertyAddress by into individual clumn(Address, City, State) 

Select PropertyAddress
from PortfolioProject..Nashville_Data_Cleaning

select 
substring (PropertyAddress, 1, charindex(',',PropertyAddress) -1) as Address,
substring(PropertyAddress, charindex(',',PropertyAddress) +1,
LEN(PropertyAddress)) as Address
From PortfolioProject..Nashville_Data_Cleaning

Alter Table PortfolioProject..Nashville_Data_Cleaning 
Add PropertySplitAddress Nvarchar(255);

update PortfolioProject..Nashville_Data_Cleaning
set PropertySplitAddress = Substring (PropertyAddress, 1, 
charindex(',',PropertyAddress) -1)

Alter Table PortfolioProject..Nashville_Data_Cleaning 
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..Nashville_Data_Cleaning
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * From PortfolioProject..Nashville_Data_Cleaning

--Change Y and N to Yes and No in 'SoldAsVacant' Column

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..Nashville_Data_Cleaning
Group by SoldAsVacant

select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant 
	 End
From PortfolioProject..Nashville_Data_Cleaning

update PortfolioProject..Nashville_Data_Cleaning
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant 
	 End

Select * From PortfolioProject..Nashville_Data_Cleaning

-- Removing Duplicate Data

with RowNumCTE As(
Select *,
	ROW_NUMBER() OVER(
	                  Partition by ParcelID, PropertyAddress, SalePrice, 
					  SaleDate, LegalReference
	                  order by UniqueID
					 ) row_num
			from PortfolioProject..NashVille_Data_Cleaning
			)
Select * From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select * From PortfolioProject..Nashville_Data_Cleaning

--Dleting non required columns

Select * From PortfolioProject..Nashville_Data_Cleaning

Alter table PortfolioProject..Nashville_Data_Cleaning
DROP column OwnerAddress, TaxDistrict, SaleDate