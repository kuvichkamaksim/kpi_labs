/*==============================================================*/
/* Database name:  SALE                                         */
/* DBMS name:      ORACLE Version 10gR2                         */
/* Created on:     13.02.2014 19:12:34                          */
/*==============================================================*/


drop table INVOICE cascade constraints;

drop table SALES cascade constraints;

drop table STORE cascade constraints;

/*==============================================================*/
/* Database: SALE                                               */
/*==============================================================*/
create database SALE;

/*==============================================================*/
/* Table: INVOICE                                               */
/*==============================================================*/
create table INVOICE  (
   ID_STUFF             varchar2(128)                   not null,
   STAFF_NAME           varchar2(128),
   E_MAIL               varchar2(128),
   INVOICE              varchar2(128),
   SUPPLIER             varchar2(128),
   PRODUCT              varchar2(128),
   QUANTITY             varchar2(128),
   PRICE                varchar2(128),
   INVOICE_DATE         varchar2(128)
);

comment on table INVOICE is
'���������� ��� ����������.';

comment on column INVOICE.ID_STUFF is
'��������� ������������� ������.';

comment on column INVOICE.E_MAIL is
'��� ��������� ������.';

/*==============================================================*/
/* Table: SALES                                                 */
/*==============================================================*/
create table SALES  (
   ID_STUFF             VARCHAR2(128)                   not null,
   STAFF_NAME           varchar2(128),
   PRODUCT              VARCHAR2(128),
   SOLD_IN_JANUARY_2013 varchar2(128),
   SOLD_IN_FEBRUARY_2013 VARCHAR2(128),
   SOLD_IN_MARCH_2013   varchar2(128),
   SOLD_IN_APRIL_2013   varchar2(128),
   SOLD_IN_MAY_2013     VARCHAR2(128),
   SOLD_IN_JUNE_2013    VARCHAR2(128),
   SOLD_IN_JULY_2013    VARCHAR2(128),
   SOLD_IN_AUGUST_2013  VARCHAR2(128),
   SOLD_IN_SEPTEMBER_2013 VARCHAR2(128),
   SOLD_IN_OCTOBER_2013 VARCHAR2(128),
   SOLD_IN_NOVEMBER_2013 VARCHAR2(128),
   SOLD_IN_DECEMBER_2013 VARCHAR2(128)
);

comment on table SALES is
'���������� ��� ������.';

comment on column SALES.ID_STUFF is
'��������� ������������� ������.';

comment on column SALES.STAFF_NAME is
'����� ������.';

comment on column SALES.PRODUCT is
'������� �����.';

comment on column SALES.SOLD_IN_JANUARY_2013 is
'���� ������.';

comment on column SALES.SOLD_IN_FEBRUARY_2013 is
'ֳ�� ������.';

comment on column SALES.SOLD_IN_MARCH_2013 is
'������������.';

comment on column SALES.SOLD_IN_APRIL_2013 is
'��� ������.';

/*==============================================================*/
/* Table: STORE                                                 */
/*==============================================================*/
create table STORE  (
   STUFF_NAME           varchar2(124)                   not null,
   SUPPLIER             varchar2(124),
   SHELF                varchar2(124),
   PRODUCT              varchar2(124),
   QUANTITY             varchar2(124),
   OPER_TYPE            varchar2(124),
   STORE_DATE           varchar2(124)
);

comment on table STORE is
'���������� ��� �����';

comment on column STORE.STUFF_NAME is
'��������� ������������� �������.';

comment on column STORE.SUPPLIER is
'����� ������ ������.';

comment on column STORE.SHELF is
'ʳ������ ������.';

