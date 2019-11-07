INSERT INTO Supplier ([Name])
VALUES ('Karabas'),
('Afisha.ua')

GO

INSERT INTO ProductType (ID, [Type])
VALUES (hierarchyid::GetRoot(), 'Билет')

GO

declare @Id hierarchyid

select @Id = MAX(ID)
from ProductType
where ID.GetAncestor(1) = hierarchyid::GetRoot()

insert into ProductType
values(hierarchyid::GetRoot().GetDescendant(@id, null), 'Билет на концерт');

GO

declare @Id hierarchyid

select @Id = MAX(ID)
from ProductType
where ID.GetAncestor(1) = hierarchyid::GetRoot()

insert into ProductType
values(hierarchyid::GetRoot().GetDescendant(@id, null), 'Билет в кино');

GO

declare @Id hierarchyid

select @Id = MAX(ID)
from ProductType
where ID.GetAncestor(1) = hierarchyid::GetRoot()

insert into ProductType
values(hierarchyid::GetRoot().GetDescendant(@id, null), 'Билет в театр');


GO

declare @Id hierarchyid

select @Id = MAX(ID)
from ProductType
where ID.GetAncestor(1) = hierarchyid::GetRoot()

insert into ProductType
values(hierarchyid::GetRoot().GetDescendant(@id, null), 'Билет на фестиваль');

GO

DECLARE @ProductTypeID HIERARCHYID

SELECT @ProductTypeID = MAX(ID) FROM ProductType
WHERE [Type] = 'Билет на концерт'

INSERT INTO Product (ProductTypeID, ProductName, SupplierID)
VALUES (@ProductTypeID, 'Jah Khalib', 1),
(@ProductTypeID, 'Антитіла', 1),
(@ProductTypeID, 'Луна', 1),
(@ProductTypeID, 'Валерий Меладзе', 1),
(@ProductTypeID, 'Неангели', 1),
(@ProductTypeID, 'Lizer', 1),
(@ProductTypeID, 'Нервы', 1),
(@ProductTypeID, 'Tayanna', 1)

GO

DECLARE @ProductTypeID HIERARCHYID

SELECT @ProductTypeID = MAX(ID) FROM ProductType
WHERE [Type] = 'Билет в кино'

INSERT INTO Product (ProductTypeID, ProductName, SupplierID)
VALUES (@ProductTypeID, 'Джокер', 1),
(@ProductTypeID, 'Халепа', 1),
(@ProductTypeID, 'До зірок', 1),
(@ProductTypeID, 'Король Лев', 1),
(@ProductTypeID, 'Музей Прадо', 1),
(@ProductTypeID, 'Хороші хлопці', 1)

GO

DECLARE @root hierarchyID;

SELECT @root = ID
FROM ProductType
WHERE [Type] = 'Билет'

SELECT *
FROM ProductType
WHERE ID.IsDescendantOf(@root) = 1 

GO

declare @Id hierarchyid
declare @phId hierarchyid
select @phId = (SELECT ID FROM ProductType WHERE [Type] = 'Билет на фестиваль');

select @Id = MAX(pt.ID)
from ProductType pt
where pt.ID.GetAncestor(1) = @phId

insert into ProductType
values( @phId.GetDescendant(@id, null), 'Билет на фестиваль в закрытом помещении');

GO

select ID.ToString(), ID.GetLevel(), * from ProductType

GO

DECLARE @ProductTypeID HIERARCHYID

SELECT @ProductTypeID = MAX(ID) FROM ProductType
WHERE [Type] = 'Билет на фестиваль под открытым небом'

INSERT INTO Product (ProductTypeID, ProductName, SupplierID)
VALUES (@ProductTypeID, 'Уличная еда BBQ', 2),
(@ProductTypeID, 'Пекельний геловін', 2),
(@ProductTypeID, 'Atlas Weekend', 2),
(@ProductTypeID, 'Outsider fest', 2)

GO

DECLARE @ProductTypeID HIERARCHYID

SELECT @ProductTypeID = MAX(ID) FROM ProductType
WHERE [Type] = 'Билет на фестиваль в закрытом помещении'

INSERT INTO Product (ProductTypeID, ProductName, SupplierID)
VALUES (@ProductTypeID, 'Whisky dram', 2),
(@ProductTypeID, 'Happy scary', 2),
(@ProductTypeID, 'Фестиваль чаю', 2)