INSERT INTO Supplier ([Name])
VALUES ('Karabas'),
('Afisha.ua')

GO

INSERT INTO ProductType (ID, [Type])
VALUES (hierarchyid::GetRoot(), '�����')

GO

declare @Id hierarchyid

select @Id = MAX(ID)
from ProductType
where ID.GetAncestor(1) = hierarchyid::GetRoot()

insert into ProductType
values(hierarchyid::GetRoot().GetDescendant(@id, null), '����� �� �������');

GO

declare @Id hierarchyid

select @Id = MAX(ID)
from ProductType
where ID.GetAncestor(1) = hierarchyid::GetRoot()

insert into ProductType
values(hierarchyid::GetRoot().GetDescendant(@id, null), '����� � ����');

GO

declare @Id hierarchyid

select @Id = MAX(ID)
from ProductType
where ID.GetAncestor(1) = hierarchyid::GetRoot()

insert into ProductType
values(hierarchyid::GetRoot().GetDescendant(@id, null), '����� � �����');


GO

declare @Id hierarchyid

select @Id = MAX(ID)
from ProductType
where ID.GetAncestor(1) = hierarchyid::GetRoot()

insert into ProductType
values(hierarchyid::GetRoot().GetDescendant(@id, null), '����� �� ���������');

GO

DECLARE @ProductTypeID HIERARCHYID

SELECT @ProductTypeID = MAX(ID) FROM ProductType
WHERE [Type] = '����� �� �������'

INSERT INTO Product (ProductTypeID, ProductName, SupplierID)
VALUES (@ProductTypeID, 'Jah Khalib', 1),
(@ProductTypeID, '�������', 1),
(@ProductTypeID, '����', 1),
(@ProductTypeID, '������� �������', 1),
(@ProductTypeID, '��������', 1),
(@ProductTypeID, 'Lizer', 1),
(@ProductTypeID, '�����', 1),
(@ProductTypeID, 'Tayanna', 1)

GO

DECLARE @ProductTypeID HIERARCHYID

SELECT @ProductTypeID = MAX(ID) FROM ProductType
WHERE [Type] = '����� � ����'

INSERT INTO Product (ProductTypeID, ProductName, SupplierID)
VALUES (@ProductTypeID, '������', 1),
(@ProductTypeID, '������', 1),
(@ProductTypeID, '�� ����', 1),
(@ProductTypeID, '������ ���', 1),
(@ProductTypeID, '����� �����', 1),
(@ProductTypeID, '������ ������', 1)

GO

DECLARE @root hierarchyID;

SELECT @root = ID
FROM ProductType
WHERE [Type] = '�����'

SELECT *
FROM ProductType
WHERE ID.IsDescendantOf(@root) = 1 

GO

declare @Id hierarchyid
declare @phId hierarchyid
select @phId = (SELECT ID FROM ProductType WHERE [Type] = '����� �� ���������');

select @Id = MAX(pt.ID)
from ProductType pt
where pt.ID.GetAncestor(1) = @phId

insert into ProductType
values( @phId.GetDescendant(@id, null), '����� �� ��������� � �������� ���������');

GO

select ID.ToString(), ID.GetLevel(), * from ProductType

GO

DECLARE @ProductTypeID HIERARCHYID

SELECT @ProductTypeID = MAX(ID) FROM ProductType
WHERE [Type] = '����� �� ��������� ��� �������� �����'

INSERT INTO Product (ProductTypeID, ProductName, SupplierID)
VALUES (@ProductTypeID, '������� ��� BBQ', 2),
(@ProductTypeID, '��������� ������', 2),
(@ProductTypeID, 'Atlas Weekend', 2),
(@ProductTypeID, 'Outsider fest', 2)

GO

DECLARE @ProductTypeID HIERARCHYID

SELECT @ProductTypeID = MAX(ID) FROM ProductType
WHERE [Type] = '����� �� ��������� � �������� ���������'

INSERT INTO Product (ProductTypeID, ProductName, SupplierID)
VALUES (@ProductTypeID, 'Whisky dram', 2),
(@ProductTypeID, 'Happy scary', 2),
(@ProductTypeID, '��������� ���', 2)