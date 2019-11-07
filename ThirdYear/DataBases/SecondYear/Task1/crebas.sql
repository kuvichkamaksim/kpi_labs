/*==============================================================*/
/* Database name:  stationery                                   */
/* DBMS name:      PosgreSQL Version 10.9                       */
/* Created on:     24.09.2019 16:54:33                          */
/*==============================================================*/

DROP TABLE invoice CASCADE;

DROP TABLE sales CASCADE;

DROP TABLE store CASCADE;

/*==============================================================*/
/* Table: invoice                                               */
/*==============================================================*/
CREATE TABLE invoice
(
    id_stuff     VARCHAR(128) NOT NULL,
    staff_name   VARCHAR(128),
    e_mail       VARCHAR(128),
    invoice      VARCHAR(128),
    supplier     VARCHAR(128),
    product      VARCHAR(128),
    quantity     VARCHAR(128),
    price        VARCHAR(128),
    invoice_date VARCHAR(128)
);

COMMENT ON TABLE invoice IS
'���������� ��� ����������.';

COMMENT ON COLUMN invoice.id_stuff IS
'��������� ������������� ������.';

COMMENT ON COLUMN invoice.e_mail IS
'��� ��������� ������.';

/*==============================================================*/
/* Table: sales                                                 */
/*==============================================================*/
CREATE TABLE sales
(
    id_stuff               VARCHAR(128) NOT NULL,
    staff_name             VARCHAR(128),
    product                VARCHAR(128),
    sold_in_january_2013   VARCHAR(128),
    sold_in_february_2013  VARCHAR(128),
    sold_in_march_2013     VARCHAR(128),
    sold_in_april_2013     VARCHAR(128),
    sold_in_may_2013       VARCHAR(128),
    sold_in_june_2013      VARCHAR(128),
    sold_in_july_2013      VARCHAR(128),
    sold_in_august_2013    VARCHAR(128),
    sold_in_september_2013 VARCHAR(128),
    sold_in_october_2013   VARCHAR(128),
    sold_in_november_2013  VARCHAR(128),
    sold_in_december_2013  VARCHAR(128)
);

COMMENT ON TABLE sales IS
'���������� ��� ������.';

COMMENT ON COLUMN sales.id_stuff IS
'��������� ������������� ������.';

COMMENT ON COLUMN sales.staff_name IS
'����� ������.';

COMMENT ON COLUMN sales.product IS
'������� �����.';

COMMENT ON COLUMN sales.sold_in_january_2013 IS
'���� ������.';

COMMENT ON COLUMN sales.sold_in_february_2013 IS
'ֳ�� ������.';

COMMENT ON COLUMN sales.sold_in_march_2013 IS
'������������.';

COMMENT ON COLUMN sales.sold_in_april_2013 IS
'��� ������.';

/*==============================================================*/
/* Table: store                                                 */
/*==============================================================*/
CREATE TABLE store
(
    stuff_name VARCHAR(124) NOT NULL,
    supplier   VARCHAR(124),
    shelf      VARCHAR(124),
    product    VARCHAR(124),
    quantity   VARCHAR(124),
    oper_type  VARCHAR(124),
    store_date VARCHAR(124)
);

COMMENT ON TABLE store IS
'���������� ��� �����';

COMMENT ON COLUMN store.stuff_name IS
'��������� ������������� �������.';

COMMENT ON COLUMN store.supplier IS
'����� ������ ������.';

COMMENT ON COLUMN store.shelf IS
'ʳ������ ������.';
