/*
    建立管理服务器数据脚本，终端数据库
    2018.5.12
    使用MySQL
*/
Drop DATABASE  if exists masterfreezer1;
CREATE DATABASE masterfreezer1;

USE masterfreezer1;

SET autocommit=1;	-- 自动事务模式
set global log_bin_trust_function_creators=1;

/***************************************************************************/
/*							数据字典建立部分 							   */
/***************************************************************************/

/************************************/
/*       创建序列（流水）号字典表   */
/************************************/
/*创建系列号表*/
DELIMITER //  
create table TB_SerialNumber (
  Id int NOT NULL auto_increment PRIMARY KEY,  /*编号*/
  Name varchar(20),  /*序列号类型名*/
  Value bigint not null default 1 /*当前序列值*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //  

/*初始化对象序列号过程*/
DELIMITER //  
create procedure InitialSerialNumber()
begin
	insert into TB_SerialNumber values (0,'管理员',1),(0,'投递员',1),(0,'物流公司',1),
    (0,'柜子',1),(0,'抽屉',1),(0,'订单',1),(0,'终端',1),(0,'屏保文件',1);
end;
//
DELIMITER //  

DROP PROCEDURE IF EXISTS InitMasterFreezer1;
//
/*初始化数据库*/
CREATE PROCEDURE InitMasterFreezer1()
	BEGIN
     INSERT INTO tb_administrator(RealName, PhoneNumber, MyPassword) VALUES('admin', '123456', '123456');
	END
//

CALL init();

/*初始化对象序列号*/
DELIMITER //  
call InitialSerialNumber();
//
DELIMITER //  

/*根据序列（流水）号类型名称获取序列号*/
DELIMITER //  
CREATE function GetSerialNumber(type_name varchar(20))
returns int
BEGIN 
  declare currentnumber int;
  declare curid int;
  set curid = (select Id from TB_SerialNumber where Name=ltrim(rtrim(type_name))); 
  Set currentnumber = (select Value from TB_SerialNumber where Name=ltrim(rtrim(type_name)));
  Update TB_SerialNumber set Value=(currentnumber+1) where Id=curid; 
  return currentnumber; 
END;
//
DELIMITER //  


/*根据类型名称复位序列号,将序列号复位为1*/
DELIMITER //  
CREATE PROCedure ResetSerialNumber( IN type_name varchar(20))
BEGIN 
	Update TB_SerialNumber set Value=1 where Name=ltrim(rtrim(@type_name));  /*用户变量*/
END;
//
DELIMITER // 




/*****************************************/
/*		创建投递员状态数据字典			 */
/*****************************************/
DELIMITER //
CREATE TABLE TB_PostmanState(
	ID int NOT NULL PRIMARY KEY,	/*ID*/
    Name varchar(20) NOT NULL 	/*状态名*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据投递员状态ID获取投递员状态名称*/
DELIMITER //
CREATE FUNCTION GetPostmanStateByID(IDvalue int)
Returns varchar(20)
Begin 
    declare name  nvarchar(20);
    
    Set name = Null;

    If (IDvalue Is Not Null) then
		Set name = (Select Name from TB_PostmanState Where (ID=IDvalue) limit 1 );
    End if;
    
    Return name;
End ;
//
DELIMITER //  

/*初始化投递员状态数据字典*/
DELIMITER //
create PROCedure InitialPostmanState()
begin 
	insert into TB_PostmanState values ('0','未激活');
    insert into TB_PostmanState values ('1','激活');
end;
//
DELIMITER //

/*初始化投递员状态*/
DELIMITER //
call InitialPostmanState();
//
DELIMITER //

CREATE VIEW View_PostmanState
AS
	SELECT ID,Name
    FROM TB_PostmanState
    ORDER BY ID DESC ;
    
//
DELIMITER //


/*****************************************/
/*		创建柜子启动模式数据字典		 */
/*****************************************/
DELIMITER //
create table TB_StartMode (
	ID int NOT NULL PRIMARY KEY,/*启动模式ID*/
    Name varchar(20) NOT NULL	/*启动模式名称*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

DELIMITER //
create function GetStartModeNameByID(IDvalue int)
returns varchar(20)
Begin 
	declare Name varchar(20);
    
    SET Name = NULL;
    
    if (IDvalue is NOT NULL ) THEN
    SET Name = (select Name from TB_StartMode where (ID=IDvalue) limit 1);
    end if;
    return Name;
END;
//
DELIMITER //

/*初始化启动模式数据字典*/
DELIMITER //
Create PROCedure InitialStartMode()
Begin
	insert into TB_StartMode values ('0','手动');
    insert into TB_StartMode values ('1','远程');
    insert into TB_StartMode values ('2','策略');
END;
//
DELIMITER //

/*初始化启动模式*/
DELIMITER //
call InitialStartMode();
//
DELIMITER //

CREATE VIEW View_StartMode
AS 
	SELECT ID,Name
    FROM 	TB_StartMode
    ORDER BY ID DESC ;
//
DELIMITER //

/*****************************************/
/*		创建冷冻柜类型数据字典			 */
/*****************************************/
DELIMITER //
Create table TB_FreezerMode (
	ID int NOT NULL PRIMARY KEY, 	/*冷冻柜模式ID*/
    Name varchar(20) NOT NULL 	/*冷冻柜模式名称*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据指定冷冻柜模式ID获取冷冻柜模式名称*/
DELIMITER //
CREATE FUNCTION GetFreezerModeByID(IDvalue int)
Returns varchar(20)
Begin 
    declare name  nvarchar(20);
    
    Set name = Null;

    If (IDvalue Is Not Null) then
		Set name = (Select Name from TB_FreezerMode Where (ID=IDvalue) limit 1 );
    End if;  
    
    Return name;
End ;
//
DELIMITER //

/*初始化冷冻柜模式数据字典*/
DELIMITER //
Create PROCedure InitialFreezerMode()
BEGIN
	insert into TB_FreezerMode values ('0','冷藏');
    insert into TB_FreezerMode values ('1','冷冻');
END;
//
DELIMITER //

/*初始化冷冻柜模式*/
DELIMITER //
CALL InitialFreezerMode();
//
DELIMITER //

DELIMITER //
CREATE VIEW View_FreezerMode
AS
	SELECT	ID,Name
    FROM 	TB_FreezerMode
    ORDER BY ID DESC limit 100;
    
//
DELIMITER //


/*****************************************/
/*		创建波特率数据字典		 		 */
/*****************************************/
DELIMITER //
create table TB_BaudRate (
	ID int NOT NULL PRIMARY KEY,/*ID*/
    Name varchar(20) NOT NULL	/*名称*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

DELIMITER //
create function GetBaudRateNameByID(IDvalue int)
returns varchar(20)
Begin 
	declare Name varchar(20);
    
    SET Name = NULL;
    
    if (IDvalue is NOT NULL ) THEN
    SET Name = (select Name from TB_BaudRate where (ID=IDvalue) limit 1);
    end if;
    return Name;
END;
//
DELIMITER //

/*初始化波特率数据字典*/
DELIMITER //
Create PROCedure InitialBaudRate()
Begin
	insert into TB_BaudRate values ('0','9600');
    insert into TB_BaudRate values ('1','19200');
    insert into TB_BaudRate values ('2','38400');
    insert into TB_BaudRate values ('3','57600');
    insert into TB_BaudRate values ('4','115200');
END;
//
DELIMITER //

/*初始化波特率*/
DELIMITER //
call InitialBaudRate();
//
DELIMITER //

CREATE VIEW View_Baudrate
AS 
	SELECT ID,Name
    FROM 	TB_Baudrate
    ORDER BY ID DESC ;
//
DELIMITER //

/*****************************************/
/*		创建数据位数据字典		 		 */
/*****************************************/
DELIMITER //
create table TB_DataByte (
	ID int NOT NULL PRIMARY KEY,/*ID*/
    Name varchar(20) NOT NULL	/*名称*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

DELIMITER //
create function GetDataByteNameByID(IDvalue int)
returns varchar(20)
Begin 
	declare Name varchar(20);
    
    SET Name = NULL;
    
    if (IDvalue is NOT NULL ) THEN
    SET Name = (select Name from TB_DataByte where (ID=IDvalue) limit 1);
    end if;
    return Name;
END;
//
DELIMITER //

/*初始化数据位数据字典*/
DELIMITER //
Create PROCedure InitialDataByte()
Begin
	insert into TB_DataByte values ('0','5');
    insert into TB_DataByte values ('1','6');
    insert into TB_DataByte values ('2','7');
    insert into TB_DataByte values ('3','8');
END;
//
DELIMITER //

/*初始化数据位*/
DELIMITER //
call InitialDataByte();
//
DELIMITER //


CREATE VIEW View_DataByte
AS 
	SELECT ID,Name
    FROM 	TB_DataByte
    ORDER BY ID DESC ;
//
DELIMITER //

/*****************************************/
/*		创建停止位数据字典		 		 */
/*****************************************/
DELIMITER //
create table TB_StopByte (
	ID int NOT NULL PRIMARY KEY,/*ID*/
    Name varchar(20) NOT NULL	/*名称*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

DELIMITER //
create function GetStopByteNameByID(IDvalue int)
returns varchar(20)
Begin 
	declare Name varchar(20);
    
    SET Name = NULL;
    
    if (IDvalue is NOT NULL ) THEN
    SET Name = (select Name from TB_StopByte where (ID=IDvalue) limit 1);
    end if;
    return Name;
END;
//
DELIMITER //

/*初始化停止位数据字典*/
DELIMITER //
Create PROCedure InitialStopByte()
Begin
	insert into TB_StopByte values ('0','1');
    insert into TB_StopByte values ('1','1.5');
    insert into TB_StopByte values ('2','2');
END;
//
DELIMITER //

/*初始化停止位*/
DELIMITER //
call InitialStopByte();
//
DELIMITER //


CREATE VIEW View_StopByte
AS 
	SELECT ID,Name
    FROM 	TB_StopByte
    ORDER BY ID DESC ;
//
DELIMITER //

/*****************************************/
/*		创建校验位数据字典		 		 */
/*****************************************/
DELIMITER //
create table TB_ParityByte (
	ID int NOT NULL PRIMARY KEY,/*ID*/
    Name varchar(20) NOT NULL	/*名称*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

DELIMITER //
create function GetParityByteNameByID(IDvalue int)
returns varchar(20)
Begin 
	declare Name varchar(20);
    
    SET Name = NULL;
    
    if (IDvalue is NOT NULL ) THEN
    SET Name = (select Name from TB_ParityByte where (ID=IDvalue) limit 1);
    end if;
    return Name;
END;
//
DELIMITER //

/*初始化数据位数据字典*/
DELIMITER //
Create PROCedure InitialParityByte()
Begin
	insert into TB_ParityByte values ('0','N');	-- 无校验 
    insert into TB_ParityByte values ('1','E');	-- 偶校验 
    insert into TB_ParityByte values ('2','O');	-- 奇校验 
END;
//
DELIMITER //

/*初始化数据位*/
DELIMITER //
call InitialParityByte();
//
DELIMITER //


CREATE VIEW View_ParityByte
AS 
	SELECT ID,Name
    FROM 	TB_ParityByte
    ORDER BY ID DESC ;
//
DELIMITER //

/*****************************************/
/*			创建状态数据字典		 */
/*****************************************/
DELIMITER //
CREATE table TB_State(
	ID int NOT NULL PRIMARY KEY,	/*ID*/
    Name varchar(20) NOT NULL	/*状态名*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据状态ID获取状态名称*/
CREATE function GetStateByID(IDvalue int)
Returns varchar(20) 
Begin 
	declare name nvarchar(20);
    
    SET name = NULL;
	
    IF(IDvalue IS NOT NULL) THEN
		SET name = (SELECT Name FROM TB_FreezerState where (ID = IDvalue) LIMIT 1);
	END IF;
    
    RETURN name;
END;
//
DELIMITER //

/*初始化状态数据字典*/
DELIMITER //
 CREATE PROCedure InitialState()
 begin
	insert into TB_State values ('0','离线');
    insert into TB_State values ('1','在线');
    insert into TB_State values ('2','故障');
end;
//
DELIMITER //

/*初始化冷冻柜状态*/
DELIMITER //
call InitialState();
//
DELIMITER //

DELIMITER //
CREATE VIEW View_State
AS 
	SELECT ID,Name
    FROM TB_State
    ORDER BY ID DESC;
//
DELIMITER //

/*****************************************/
/*		创建抽屉状态数据字典			 */
/*****************************************/
DELIMITER //
CREATE table TB_DrawerState(
	ID int NOT NULL PRIMARY KEY,	/*ID*/
    Name varchar(20) NOT NULL 	/*状态名*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据抽屉状态ID获取抽屉状态名称*/
DELIMITER //
CREATE FUNCTION GetDrawerStateByID(IDvalue int )
returns varchar(20)
Begin
	declare name varchar(20);
    
    SET name = NULL;
    
    if (IDvalue IS NOT NULL)THEN
		SET name = (SELECT Name FROM TB_DrawerState WHERE (ID = IDvalue) limit 1);
	end if;
    
    return name;
END;
//
DELIMITER //

/*初始化抽屉状态数据字典*/
DELIMITER //
CREATE PROCedure InitialDrawerState()
BEGIN
	insert into TB_DrawerState values ('0','空闲');
    insert into TB_DrawerState values ('1','占用');
END;
//
DELIMITER //

/*初始化抽屉状态*/
DELIMITER //
call InitialDrawerState();
//
DELIMITER //

DELIMITER //
CREATE VIEW View_DrawerState
AS 
	SELECT ID,Name
    FROM TB_DrawerState
    ORDER BY ID DESC ;
    
//
DELIMITER //

/*****************************************/
/*		创建订单状态数据字典			 */
/*****************************************/
DELIMITER //
CREATE TABLE TB_OrderState(
	ID int NOT NULL PRIMARY KEY,	/*ID*/
    Name varchar(20) NOT NULL 	/*状态名*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据订单状态ID获取订单状态名称*/
DELIMITER //
CREATE FUNCTION GetOrderStateByID(IDvalue int)
Returns varchar(20)
Begin 
    declare name  nvarchar(20);
    
    Set name = Null;

    If (IDvalue Is Not Null) then
		Set name = (Select Name from TB_OrderState Where (ID=IDvalue) limit 1 );
    End if;
    
    Return name;
End ;
//
DELIMITER //  

/*初始化订单状态数据字典*/
DELIMITER //
CREATE PROCedure InitialOrderState()
begin
	insert into TB_OrderState values ('0','待取');
    insert into TB_OrderState values ('1','已取');
end;
//
DELIMITER //

/*初始化订单状态*/
DELIMITER //
CALL InitialOrderState();
//
DELIMITER //

DELIMITER //
CREATE VIEW View_OrderState
AS 
	SELECT ID,Name
    FROM TB_OrderState
    ORDER BY ID DESC;

//
DELIMITER //

/*****************************************/
/*		创建是否主柜数据字典			 */
/*****************************************/
DELIMITER //
CREATE TABLE TB_IsMaingui(
	ID int NOT NULL PRIMARY KEY,	/*ID*/
    Name varchar(20) NOT NULL 	/*状态名*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据ID获取状态名称*/
DELIMITER //
CREATE FUNCTION GetIsMainguiByID(IDvalue int)
Returns varchar(20)
Begin 
    declare name  nvarchar(20);
    
    Set name = Null;

    If (IDvalue Is Not Null) then
		Set name = (Select Name from TB_IsMaingui Where (ID=IDvalue) limit 1 );
    End if;
    
    Return name;
End ;
//
DELIMITER //  

/*初始化是否主柜数据字典*/
DELIMITER //
CREATE PROCedure InitialIsMaingui()
begin
	insert into TB_IsMaingui values ('0','不是主柜');
    insert into TB_IsMaingui values ('1','是主柜');
end;
//
DELIMITER //

/*初始化是否主柜*/
DELIMITER //
CALL InitialIsMaingui();
//
DELIMITER //

DELIMITER //
CREATE VIEW View_IsMaingui
AS 
	SELECT ID,Name
    FROM TB_IsMaingui
    ORDER BY ID DESC;

//
DELIMITER //


/****************************************************************************/
/*							数据表建立部分  								*/
/****************************************************************************/

/*****************************************/
/*			创建管理员信息表			 */
/*****************************************/
DELIMITER //
create table TB_Administrator(
	ID bigint not null auto_increment primary key,	-- 编号 
    RealName varchar(20) not null default '',	-- 真实姓名
    PhoneNumber varchar(20) not null unique default '',		-- 电话号码 
    MyPassword varchar(20) not null default '',		-- 密码 
    Memo varchar(100) null ,	-- 备注 
    Valid bit not null default 1	-- 有效标志位 
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //


/* 获取指定管理员ID的姓名，用法：Select dbo.GetRealNameByID(1) */
DELIMITER //  
Create Function GetAdminNameByID (IDvalue bigint)
Returns varchar(20)
Begin 
    declare name  varchar(20);
    
    Set name = Null;

    If (IDvalue Is Not Null) then
		set name = (Select RealName From TB_Administrator Where (ID=IDvalue) and (Valid=1)  limit 1); 
    End if;   
    
    Return name;
End ;
//
DELIMITER //  

/* 获取指定管理员ID的手机号，用法：Select dbo.GetAdminTeleByID(1) */
DELIMITER //  
Create Function GetAdminTeleByID (IDvalue bigint)
Returns varchar(20)
Begin 
    declare tele  varchar(20);
    
    Set tele = Null;

    If (IDvalue Is Not Null) then
		set tele = (Select PhoneNumber From TB_Administrator Where (ID=IDvalue) and (Valid=1)  limit 1); 
    End if;   
    
    Return name;
End ;
//
DELIMITER //  

/* 获取指定管理员姓名的管理员ID，用法：Select dbo.GetAdministratorIDByName(姓名) */
DELIMITER //  
Create Function GetAdministratorIDByName (Namevalue varchar(20))
Returns bigint
Begin 
    declare ID  bigint;
    
    Set ID = Null;

    If (Namevalue Is Not Null) then
		Set ID = (Select ID From TB_Administrator Where (RealName=Namevalue) and (Valid=1) );
    End if;   
    
    Return ID;
End ;
//
DELIMITER //  


/*创建查询所有管理员的视图*/
/* ID, 真实姓名，电话*/
DELIMITER // 
CREATE VIEW View_Administrator
AS
    SELECT     ID,  RealName, PhoneNumber
    FROM        TB_Administrator 
    WHERE       (Valid=1) 
    ORDER BY RealName DESC;
//
DELIMITER //  
  

/*修改管理员密码存储过程*/
DELIMITER //  
Create PROCedure UpdateAdministratorPassword (
    IN IDvalue bigint,  -- 用户ID
    IN MyPasswordvalue varchar(8),
    IN NewMyPassword varchar(8),
    OUT err int -- 返回代码
    )
begin 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
    
    SET @errorSum=0;
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    UPDATE TB_Administrator SET MyPassword = NewMyPassword
    WHERE (Valid =1)  and (ID = IDvalue) and (MyPassword=MyPasswordvalue);
    
	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //
 

/*判定管理员的合法性，用法：Select * From IsValidAdministrator(名称,密码) */
DELIMITER //  
Create Function IsValidAdministrator(LoginNamevalue varchar(20),MyPasswordvalue varchar(8))
Returns int
Begin 
    declare typename  varchar(20);
    declare myresult int;
    
    Set typename = Null;
    Set myresult=0;
    
    If (Namevalue Is Not Null) then
		Set typename = ( Select LoginName from TB_Administrator Where (Valid =1)  and (LoginName=LoginNamevalue) and (MyPassword=MyPasswordvalue) limit 1);
    End if;    
    
    If (typename Is Not Null) then
        Set myresult=1;
	end if;
    
    Return myresult;
End ;
//
DELIMITER //  


/*根据手机号判定用户的合法性，用法：Select * From IsValidUserByTele(手机号码,密码) */
DELIMITER //  
Create Function IsValidAdminByTele(Televalue varchar(20),MyPasswordvalue varchar(8))
Returns int
Begin 
    declare typename  varchar(20);
    declare myresult int;
    
    Set typename = Null;
    Set myresult=0;
    
    If (Televalue Is Not Null) then 
		Set typename = ( Select Name from TB_Administrator Where (Valid =1)  and (PhoneNumber=Televalue) and (MyPassword=MyPasswordvalue) limit 1 );
    End if;  
    
    If (typename Is Not Null) then
        Set myresult=1;
	end if;
    
    Return myresult;
End ;
//
DELIMITER // 



/*********************************************************************************/
/*			创建管理员操作日志表，只是记录操作痕迹，服务器不做进一步处理		 */
/*********************************************************************************/
DELIMITER \\
create table TB_AdminOperationLog(
    OperationTime datetime,	/*操作时间*/
    AdministratorID bigint NOT NULL,	/*管理员ID*/
    FOREIGN KEY fk_adminid(AdminID) REFERENCES TB_Administrator(ID),
    OprationType varchar(20) NULL,	/*操作类型*/
    Memo nvarchar(200) NOT NULL,	/*操作明细*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*插入新操作日志*/
DELIMITER //  
Create PROCedure InsertAdminOperationLog(
    IN AdministratorIDvalue bigint, -- 管理员ID
    IN OperationTypevalue varchar(20),	-- 操作类型 
    IN Memovalue varchar(100), -- 操作明细
    OUT err int -- 返回代码
    )
begin     
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
    
    Set @errorSum=0;
    
    insert into TB_AdminOperationLog values (NOW(),AdministratorIDvalue,OperationTypevalue,Memovalue);   
    
    IF @errorSum=2 then
		set err = 1;
	ELSE 
		set err = 0;
	END if;
end;
//
DELIMITER //  

/*清空指定管理员的操作日志*/
DELIMITER // 
Create PROCedure ClearAdminOperationLog (
    IN AdministratorIDvalue bigint, -- 管理员ID
    OUT err int -- 返回代码
    )
begin   
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务
    
    Delete From TB_AdminOperationLog Where (AdministratorID=AdministratorIDvalue);
    
    IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  

/*删除指定ID的管理员，及其操作日志*/
DELIMITER //  
Create PROCedure DeleteAdministrator(
    IN Idvalue bigint,
    OUT err int -- 返回代码
    )
begin   
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

	Delete From TB_AdminOperationLog Where (AdiministratorID=Idvalue);
	Delete From TB_Administrator Where (ID=Idvalue);
	
    IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  


/*****************************************/
/*			创建物流公司信息表			 */
/*****************************************/
DELIMITER //
CREATE TABLE TB_ExpressCompany(
	ID int NOT NULL PRIMARY KEY,		/*编号*/
    Name varchar(20) NOT NULL,	/*名称*/
    -- Contact varchar(20) NOT NULL,	/*联系人*/
    -- Telephone varchar(20) NOT NULL,		/*联系电话*/
    Memo varchar(200)	/*说明*/
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //


/*初始化快递公司表*/
DELIMITER //
CREATE PROCedure InitialExpressCompany()
BEGIN
	INSERT into TB_ExpressCompany values ('0','无','默认');
END;
//
DELIMITER //

/*初始化快递公司*/
DELIMITER //
CALL InitialExpressCompany();
//
DELIMITER //


/*根据快递公司ID获取快递公司名称*/
DELIMITER //
create function GetExpressCompanyNameByID(IDvalue int)
Returns varchar(20)
Begin 
    declare name  nvarchar(20);
    
    Set name = Null;

    If (IDvalue Is Not Null) then
		Set name = (Select Name from TB_ExpressCompany Where (ID=IDvalue) limit 1 );
    End if;
    
    Return name;
End ;
//
DELIMITER //  

/*根据快递公司名字获取快递公司联系人电话*/
DELIMITER //
create function GetExpressCompanyTelephoneName(Namevalue varchar(20))
Returns varchar(20)
Begin 
    declare telephone  nvarchar(20);
    
    Set telephone = Null;

    If (Namevalue Is Not Null) then
		Set telephone = (Select Telephone from TB_ExpressCompany Where (Name=Namevalue) limit 1 );
    End if;
    
    Return name;
End ;
//
DELIMITER //  

/*更新物流公司信息*/
DELIMITER //  
Create PROCedure UpdateExpressCompany(
    IN IDvalue int,
    IN Namevalue varchar(20),
    -- IN Contactvalue varchar(20),
    -- IN Telephonevalue varchar(20),
    IN Memovalue nvarchar(200),
    OUT err int -- 返回代码
    )
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    set err = 0;

    IF (IDvalue Is Not Null) then
		SET autocommit=0; 
		START TRANSACTION;  -- 开始事务

		Update TB_ExpressCompany  Set
			Name=Namevalue , 
			-- Contact=Contactvalue,
			-- Telephone=Telephonevalue , 
			Memo=Memovalue 
			where   ID=IDvalue;

		IF @errorSum=2 then
			ROLLBACK; -- 事务回滚语句 
			set err = 1;
		ELSE 
			Commit; -- 事务提交语句 
			set err = 0;
		END if;
        
        SET autocommit=1; 
    END if;
END;
//
DELIMITER //  

/*保存物流公司信息*/
DELIMITER //  
Create PROCedure SaveExpressCompany(
    IN Namevalue varchar(20), -- 名称 	
    -- IN Contactvalue varchar(20),	-- 联系人
    -- IN Telephonevalue varchar(20),  -- 联系电话
    IN Memovalue nvarchar(200),
    OUT err int -- 返回代码
    )
begin 
    DECLARE TempID int;  
    DECLARE currentnumber bigint;  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;

    Set TempID = (Select ID From TB_ExpressCompany Where (Name = Namevalue) limit 1);

	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    IF (TempID Is Not Null) then -- 物流公司已经存在，更新物流公司信息
		call UpdateExpressCompany( TempID,Namevalue,Contactvalue,Telephonevalue,Memovalue);
	Else
		SET currentnumber = GetSerialNumber ('物流公司');
		
        insert into TB_ExpressCompany values (currentnumber,Namevalue,Contactvalue,Telephonevalue,Memovalue);   
    End if;

	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  

/*创建物流公司视图*/
DELIMITER //
CREATE VIEW View_ExpressCompany
AS 
	SELECT ID,Name
    FROM TB_ExpressCompany
    ORDER BY ID DESC;

//
DELIMITER //



/*****************************************/
/*			创建投递员信息表			 */
/*****************************************/
DELIMITER //
create table TB_Postman(
	ID bigint not null auto_increment primary key,	-- 投递员ID
    PostmanCode  varchar(20) null,	-- 工号,投递员编码
    Name varchar(20) not null default '',	-- 姓名
    PhoneNumber varchar(20) not null default '' unique,	-- 电话号码 
    MyPassword varchar(20) not null default '', 	-- 密码 
    ExpressCompanyID int not null default 0,	-- 快递公司
    FOREIGN KEY fk_expresscompanyid(ExpressCompanyID) REFERENCES TB_ExpressCompany(ID),
    StateID int not null default 0,	-- 状态 （激活，未激活）
    FOREIGN KEY fk_stateid(StateID) REFERENCES TB_PostmanState(ID),
    Registertime datetime not null default '0000-00-00 00:00:00',	-- 注册时间 
	Memo varchar(200), -- 描述
	Valid bit not null default 1 -- 有效性标志
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //
  
/*根据投递员工号获取投递员ID*/
DELIMITER //
Create Function GetPostmanIDByCode
  (codevalue varchar(20))
Returns bigint
Begin 
    declare tmp bigint;
    
    Set tmp = Null;

    If (codevalue Is Not Null) then
		Set tmp = (Select ID from TB_Postman Where (PostmanCode = codevalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if; 
    
    Return tmp;
End;
//
DELIMITER //  


/* 获取指定投递员ID的工号*/
DELIMITER // 
Create Function GetPostmanCodeByID
  (Idvalue bigint)
Returns nvarchar(20)
Begin 
    declare tmp nvarchar(20);
    
    Set tmp = Null;

    If (Idvalue Is Not Null) then
		Set tmp = (Select PostmanCode from TB_Postman Where (ID = Idvalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if;   
    
    Return tmp;
End;  
//
DELIMITER //  

/*根据投递员ID获取投递员名称*/
DELIMITER //  
Create Function GetPostmanNameByID
  (Idvalue bigint)
Returns nvarchar(20)
Begin 
    declare tmp nvarchar(20);
    
    Set tmp = Null;

    If (Idvalue Is Not Null) then
		Set tmp = (Select Name from TB_Postman Where (ID = Idvalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if;
    
    Return tmp;
End;
//
DELIMITER // 

/*根据投递员名称获取投递员电话*/
DELIMITER //
Create Function GetPostmanTelephoneByName
  (namevalue varchar(20))
Returns varchar(20)
Begin 
    declare tmp varchar(20);
    
    Set tmp = Null;

    If (codevalue Is Not Null) then
		Set tmp = (Select Telephone from TB_Postman Where (Name = namevalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if; 
    
    Return tmp;
End;
//
DELIMITER //  


/*更新投递员信息*/
DELIMITER //  
Create PROCedure UpdatePostman(
    IN IDvalue bigint,
	IN PostmanCodevalue varchar(20),-- 工号
    IN Namevalue nvarchar(20), -- 姓名
    IN PhoneNumbervalue varchar(20),  -- 电话
    IN MyPassword varchar(20),	-- 密码 
    IN ExpressCompanyIDvalue int ,	-- 物流公司 
    IN StateIDvalue int,	-- 状态 
    IN Memovalue nvarchar(200),
    OUT err int -- 返回代码
    )
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    set err = 0;

    IF (IDvalue Is Not Null) then
		SET autocommit=0; 
		START TRANSACTION;  -- 开始事务

		Update TB_Postman  Set
			PostmanCode=PostmanCodevalue , 
			Name=Namevalue , 
			PhoneNumber=PhoneNumbervalue , 
            MyPassword=MyPasswordvalue,
			ExpressCompanyID=ExpressCompanyIDvalue,
            StateID=StateIDvalue,
			Memo=Memovalue 
			where   ID=IDvalue;

		IF @errorSum=2 then
			ROLLBACK; -- 事务回滚语句 
			set err = 1;
		ELSE 
			Commit; -- 事务提交语句 
			set err = 0;
		END if;
        
        SET autocommit=1; 
    END if;
END;
//
DELIMITER //  

/*保存快递员信息*/
DELIMITER //  
Create PROCedure SavePostman(
    IN PostmanCodevalue varchar(20),-- 快递员工号
    IN Namevalue varchar(20), -- 姓名	
    IN PhoneNumbervalue varchar(20),  -- 电话
    IN MyPasswordvalue varchar(20),	-- 密码
	IN ExpressCompanyIDvalue int ,	-- 物流公司 
    IN StateIDvalue int,	-- 状态 
    IN RegisterTimevalue datetime,	-- 注册时间
    IN Memovalue nvarchar(200),
    OUT err int -- 返回代码
    )
begin 
    DECLARE TempID bigint;  
    DECLARE currentnumber bigint;  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;

    Set TempID = (Select ID From TB_Postman Where (PhoneNumber =PhoneNumbervalue) limit 1);

	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    IF (TempID Is Not Null) then -- 投递员已经存在，更新投递员信息
		call UpdatePostman( TempID,PostmanCodevalue,Namevalue,PhoneNumbervalue,
				MyPasswordvalue,ExpressCompanyIDvalue,StateIDvalue,Memovalue);
	Else
		SET currentnumber = GetSerialNumber ('投递员');
		
        insert into TB_Postman values (currentnumber,PostmanCodevalue,Namevalue,PhoneNumbervalue,
				MyPasswordvalue,ExpressCompanyIDvalue,StateIDvalue,now(),Memovalue,1);   
    End if;

	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  

/*修改投递员密码存储过程*/
DELIMITER //  
Create PROCedure UpdatePostmanMyPassword (
    IN IDvalue bigint,  -- 投递员ID
    IN MyPasswordvalue varchar(20),
    IN NewMyPassword varchar(20),
    OUT err int -- 返回代码
    )
begin 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
    
    SET @errorSum=0;
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    UPDATE TB_Postman SET MyPassword = NewMyPassword
    WHERE (Valid =1)  and (ID = IDvalue) and (MyPassword=MyPasswordvalue);
    
	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //

/*修改投递员手机号存储过程*/
DELIMITER //  
Create PROCedure UpdatePostmanTele (
    IN IDvalue bigint,  -- 投递员ID
    IN PhoneNumbervalue varchar(20),
    IN NewPhoneNumber varchar(20),
    OUT err int -- 返回代码
    )
begin 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
    
    SET @errorSum=0;
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    UPDATE TB_Postman SET PhoneNumber = NewPhoneNumber
    WHERE (Valid =1)  and (ID = IDvalue) and (PhoneNumber=PhoneNumbervalue);
    
	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //

/*创建查询所有投递员的视图*/
DELIMITER //  
CREATE VIEW View_Postman
AS
    SELECT     ID, PostmanCode,Name, PhoneNumber,GetExpressCompanyNameByID(ExpressCompanyID) as ExpressCompanyName,
				GetPostmanStateByID(StateID) as State,Registertime,Memo
    FROM        TB_Postman 
    WHERE       (Valid=1)
    ORDER BY ID DESC 

//
DELIMITER //  

/*根据手机号判定投递员的合法性，用法：Select * From IsValidPostmanByTele(手机号码,密码) */
DELIMITER //  
Create Function IsValidPostmanByTele(Televalue varchar(20),MyPasswordvalue varchar(8))
Returns int
Begin 
    declare typename  varchar(20);
    declare myresult int;
    
    Set typename = Null;
    Set myresult=0;
    
    If (Televalue Is Not Null) then 
		Set typename = ( Select Name from TB_Administrator Where (Valid =1)  and (PhoneNumber=Televalue) and (MyPassword=MyPasswordvalue) limit 1 );
    End if;  
    
    If (typename Is Not Null) then
        Set myresult=1;
	end if;
    
    Return myresult;
End ;
//
DELIMITER // 

/*判定投递员的合法性，用法：Select * From IsValidPostman(名称,密码) */
DELIMITER //  
Create Function IsValidPostman(Namevalue varchar(20),MyPasswordvalue varchar(8))
Returns int
Begin 
    declare typename  varchar(20);
    declare myresult int;
    
    Set typename = Null;
    Set myresult=0;
    
    If (Namevalue Is Not Null) then
		Set typename = ( Select RealName from TB_Administrator Where (Valid =1)  and (RealName=Namevalue) and (MyPassword=MyPasswordvalue) limit 1);
    End if;    
    
    If (typename Is Not Null) then
        Set myresult=1;
	end if;
    
    Return myresult;
End ;
//
DELIMITER //  


/*****************************************/
/*			创建终端记录信息表			 */
/*****************************************/
DELIMITER //
CREATE TABLE TB_Terminal(
	ID bigint NOT NULL PRIMARY KEY,		-- ID
    TerminalName nvarchar(26),-- 设备名称
    State int not null default 0,	-- 状态 （离线，在线，故障）
    FOREIGN KEY fk_state(State) REFERENCES TB_State(ID),
    CupboardNumber int NOT NULL,	-- 柜子数量 
	Longitude decimal(12,6) default 0.0, -- 经度
	Latitude decimal(12, 6) default 0.0, -- 纬度
	SoftVer varchar(20),-- 软件版本  
	ServerIP varchar(20), -- 服务器IP地址
    ServerPort int, -- 服务器端口
	-- ServerDNS varchar(100), -- 项目服务器DNS
	-- EncryptionFlag bit, -- 应用服务器加密传输标志
	-- SecretKey varchar(32), -- 密钥
    ColdstorageSettingTemperature decimal(3,1) default 0.0,	-- 冷藏设定温度
    FreezingSettingTemperature decimal(3,1) default 0.0,	-- 冷冻设定温度
	TemperatureControlDeviation decimal(3,1) default 0.0,	-- 温度控制偏差 
    ProvinceID int NOT NULL,	-- 省
    -- FOREIGN KEY fk_provinceid(ProvinceID) REFERENCES TB_Province(ID),
    CityID int NOT NULL,	-- 市
    -- FOREIGN KEY fk_city(CityID) REFERENCES TB_City(ID),
    CountyID int NOT NULL,	-- 县
    -- FOREIGN KEY fk_countyid(CountyID) REFERENCES TB_County(ID),
    Region varchar(100) NOT NULL	-- 区域
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据ID获取终端名称*/
DELIMITER //
create function GetTerminalNameByID(IDvalue int)
Returns varchar(20)
Begin 
    declare name  nvarchar(20);
    
    Set name = Null;

    If (IDvalue Is Not Null) then
		Set name = (Select TerminalName from TB_Terminal Where (ID=IDvalue) limit 1 );
    End if;
    
    Return name;
End ;
//
DELIMITER //  

/*更新终端*/
DELIMITER //  
Create PROCedure UpdateTerminal(
    IN IDvalue bigint,
	IN TerminalNamevalue varchar(20),	-- 终端名称 
	IN Statevalue varchar(20), 	-- 状态  
    IN CupboardNumbervalue int,	-- 柜子数量  
    IN Longitudevalue decimal(12,6), -- 经度  
    IN Latitudevalue decimal(12,6),	-- 纬度  
    IN SoftVervalue varchar(20),		-- 软件版本  
    IN ServerIPvalue varchar(20),		-- 服务器IP地址 
    IN ServerPortvalue int,		-- 服务器端口 
    IN ColdstorageSettingTemperaturevalue decimal(12,6),	-- 冷藏设定温度 
    IN FreezingSettingTemperaturevalue decimal(12,6),		-- 冷冻设定温度
    IN TemperatureControlDeviationvalue decimal(12,6),		-- 温度控制偏差  
    IN ProvinceIDvalue int,		-- 省 
    IN CityIDvalue int,		-- 市 
    IN CountyIDvalue int,	-- 县 
    IN Regionvalue varchar(100),	-- 区域 
    IN Memovalue nvarchar(200),		-- 备注 
    OUT err int -- 返回代码
    )
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    set err = 0;

    IF (IDvalue Is Not Null) then
		SET autocommit=0; 
		START TRANSACTION;  -- 开始事务

		Update TB_Order  Set
			Terminal=TerminalNamevalue,
            State=Statevalue,
            CupboardNumber=CupboardNumbervalue,
            Longitude=Longitudevalue,
            Latitude=Latitudevalue,
			SoftVer=SoftVervalue,
            ServerIP=ServerIPvalue,
            ServerPort=ServerPortvalue,
            ColdstorageSettingTemperature=ColdstorageSettingTemperaturevalue,
            FreezingSettingTemperature=FreezingSettingTemperaturevalue,
            TemperatureControlDeviation=TemperatureControlDeviationvalue,
            ProvinceID=ProvinceIDvalue,
            CityID=CityIDvalue,
            CountyID=CountyIDvalue,
            Region=Regionvalue,
			Memo=Memovalue 
			where   ID=IDvalue;

		IF @errorSum=2 then
			ROLLBACK; -- 事务回滚语句 
			set err = 1;
		ELSE 
			Commit; -- 事务提交语句 
			set err = 0;
		END if;
        
        SET autocommit=1; 
    END if;
END;
//
DELIMITER //  

/*保存终端信息*/
DELIMITER //  
Create PROCedure SaveTerminal(
	IN TerminalNamevalue varchar(20),	-- 终端名称 
	IN Statevalue varchar(20), 	-- 状态  
    IN CupboardNumbervalue int,	-- 柜子数量  
    IN Longitudevalue decimal(12,6), -- 经度  
    IN Latitudevalue decimal(12,6),	-- 纬度  
    IN SoftVervalue varchar(20),		-- 软件版本  
    IN ServerIPvalue varchar(20),		-- 服务器IP地址 
    IN ServerPortvalue int,		-- 服务器端口 
    IN ColdstorageSettingTemperaturevalue decimal(12,6),	-- 冷藏设定温度 
    IN FreezingSettingTemperaturevalue decimal(12,6),		-- 冷冻设定温度
    IN TemperatureControlDeviationvalue decimal(12,6),		-- 温度控制偏差  
    IN ProvinceIDvalue int,		-- 省 
    IN CityIDvalue int,		-- 市 
    IN CountyIDvalue int,	-- 县 
    IN Regionvalue varchar(100),	-- 区域 
    IN Memovalue nvarchar(200),		-- 备注 
    OUT err int -- 返回代码
    )
begin 
    DECLARE TempID bigint;  
    DECLARE currentnumber bigint;  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
    Set TempID = (Select ID From TB_Terminal Where (TerminalName =TerminalNamevalue) limit 1);
    
	Set @errorSum = 0;
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    IF (TempID Is Not Null) then -- 终端已经存在，更新终端信息，确保终端不重复 
		call UpdateTerminal( TempID,TerminalNamevalue,Statevalue,CupboardNumbervalue,Longitudevalue,Latitudevalue,
							SoftVervalue,ServerIPvalue,ServerPortvalue,ColdstorageSettingTemperaturevalue,
                            FreezingSettingTemperaturevalue,TemperatureControlDeviationvalue,
                            ProvinceIDvalue,CityIDvalue,CountyIDvalue,Regionvalue,Memovalue);
	Else
		SET currentnumber = GetSerialNumber ('终端');
		
        insert into TB_Terminal values (currentnumber,TerminalNamevalue,Statevalue,CupboardNumbervalue,Longitudevalue,Latitudevalue,
							SoftVervalue,ServerIPvalue,ServerPortvalue,ColdstorageSettingTemperaturevalue,
                            FreezingSettingTemperaturevalue,TemperatureControlDeviationvalue,
                            ProvinceIDvalue,CityIDvalue,CountyIDvalue,Regionvalue,Memovalue,1);   
    End if;

	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  


/*创建终端信息的视图*/
DELIMITER //
CREATE VIEW View_Order
AS
	SELECT ID,TerminalName,GetStateByID(ID) as State,CupboardNumber,Longitude,Latitude,
			SoftVer,ServerIP,ServerPort,ColdstorageSettingTemperature,
			FreezingSettingTemperature,TemperatureControlDeviation,
			ProvinceID,CityID,CountyID,Region,Memo
	FROM        TB_Terminal
    WHERE       (Valid=1)
    ORDER BY ID DESC 



/*****************************************/
/*			创建柜子信息表			 	 */
/*****************************************/
DELIMITER //
create table TB_Cupboard(
	ID bigint not null auto_increment primary key,	-- 编号 
    CupboardCode varchar(20) not null default '' unique,	-- 柜子型号 
	DrawerNumber int NOT NULL,	-- 抽屉数量 
    Mode int not null,	-- 柜子类型 （冷藏，冷冻）
    FOREIGN KEY fk_freezermode(Mode) REFERENCES TB_FreezerMode(ID),
    StartMode int not null default 2,		-- 启动模式（手动/远程/策略）
    FOREIGN KEY fk_startmode(StartMode) REFERENCES TB_StartMode(ID),
	TerminalID bigint not null,		-- 终端ID 
    FOREIGN KEY fk_terminalid(TerminalID) REFERENCES TB_Terminal(ID),
    SerialName varchar(20) NOT NULL,	-- 串口名
    BaudRate int NOT NULL default 0,	-- 波特率 （是指串行端口每秒内可以传输的波特位数）
    FOREIGN KEY fk_baudrateid(BaudRate) REFERENCES TB_BaudRate(ID),
    DataByte int NOT NULL default 3,	-- 数据位
    FOREIGN KEY fk_databyte(DataByte) REFERENCES TB_DataByte(ID),
    StopByte int NOT NULL default 0,	-- 停止位 
    FOREIGN KEY fk_stopbyte(StopByte) REFERENCES TB_StopByte(ID),
    ParityByte int NOT NULL default 1,	-- 校验位
    FOREIGN KEY fk_paritybyte(ParityByte) REFERENCES TB_ParityByte(ID),
    Memo varchar(200) null, 	-- 备注 
    Valid bit not null default 1 -- 有效性标志
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据柜子型号获取柜子ID*/
DELIMITER //
Create Function GetCupboardIDByCode
  (codevalue varchar(20))
Returns bigint
Begin 
    declare tmp bigint;
    
    Set tmp = Null;

    If (codevalue Is Not Null) then
		Set tmp = (Select ID from TB_Cupboard Where (CupboardCode = codevalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if; 
    
    Return tmp;
End;
//
DELIMITER //  

/* 获取指定柜子ID的型号*/
DELIMITER // 
Create Function GetCupboardCodeByID
  (Idvalue bigint)
Returns nvarchar(20)
Begin 
    declare tmp nvarchar(20);
    
    Set tmp = Null;

    If (Idvalue Is Not Null) then
		Set tmp = (Select CupboardCode from TB_Cupboard Where (ID = Idvalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if;   
    
    Return tmp;
End;  
//
DELIMITER //  


/*更新柜子信息*/
DELIMITER //  
Create PROCedure UpdateCupboard(
    IN IDvalue bigint,
	IN CupboardCodevalue varchar(10),-- 型号
	IN DrawerNumbervalue int,	-- 抽屉数量  
    IN Modevalue int,		-- 柜子类型 
    IN StartModevalue int,		-- 启动模式 
    IN TerminalIDvalue bigint,	-- 终端ID
    IN SerialNamevalue varchar(20),	-- 串口名
    IN BaudRatevalue int,	-- 波特率 
    IN DataBytevalue int,	-- 数据位 
    IN StopBytevalue int,	-- 停止位 
    IN ParityBytevalue int,	-- 校验位
    IN Memovalue nvarchar(200),		-- 备注 
    OUT err int -- 返回代码
    )
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    set err = 0;

    IF (IDvalue Is Not Null) then
		SET autocommit=0; 
		START TRANSACTION;  -- 开始事务

		Update TB_Cupboard  Set
			CupboardCode=CupboardCodevalue , 
			DrawerNumber=DrawerNumbervalue,
            Mode=Modevalue,
            StartMode=StartModevalue,
            TerminalID=TerminalIDvalue,
            BaudRate=BaudRatevalue,
            DataByte=DataBytevalue,
            StopByte=StopBytevalue,
            ParityByte=ParityBytevalue,
			Memo=Memovalue 
			where   ID=IDvalue;

		IF @errorSum=2 then
			ROLLBACK; -- 事务回滚语句 
			set err = 1;
		ELSE 
			Commit; -- 事务提交语句 
			set err = 0;
		END if;
        
        SET autocommit=1; 
    END if;
END;
//
DELIMITER //  

/*保存柜子信息*/
DELIMITER //  
Create PROCedure SaveCupboard(
	IN CupboardCodevalue varchar(20),-- 型号
	IN DrawerNumbervalue varchar(20),	-- 抽屉数量 
    IN Modevalue int,		-- 模式 
    IN StartModevalue int,		-- 启动模式 
    IN TerminalIDvalue bigint,		-- 终端ID 
    IN SerialNamevalue varchar(20),	-- 串口名
    IN BaudRatevalue int,	-- 波特率 
    IN DataBytevalue int,	-- 数据位 
    IN StopBytevalue int,	-- 停止位 
    IN ParityBytevalue int,	-- 校验位
    IN Memovalue nvarchar(200),		-- 备注 
    OUT err int -- 返回代码
    )
begin 
    DECLARE TempID bigint;  
    DECLARE currentnumber int;  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
    Set TempID = (Select ID From TB_Cupboard Where (CupboardCode =CupboardCodevalue) limit 1);
    
	Set @errorSum = 0;
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    IF (TempID Is Not Null) then -- 柜子已经存在，更新柜子信息
		call UpdateCupboard( TempID, CupboardCodevalue,DrawerNumbervalue,Modevalue,StartModevalue,
					TerminalIDvalue,SerialNamevalue,BaudRatevalue,DataBytevalue,StopBytevalue,
                    ParityBytevalue,Memovalue);
	Else
		SET currentnumber = GetSerialNumber ('柜子');
		
        insert into TB_Cupboard values (currentnumber,CupboardCodevalue,DrawerNumbervalue,Modevalue,
							StartModevalue,TerminalIDvalue,SerialNamevalue,BaudRatevalue,DataBytevalue,
                            StopBytevalue,ParityBytevalue,Memovalue,1);   
    End if;

	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  


/*创建查询所有柜子的视图*/
DELIMITER //  
CREATE VIEW View_Cupboard
AS
    SELECT     ID, CupboardCode,DrawerNumber,GetFreezerModeByID(Mode) as Mode,
				GetStartModeNameByID(StartMode) as StartMode,
                GetTerminalNameByID(TerminalID) as Terminal,SerialName,
                GetBaudRateNameByID(BaudRate) as BaudRate,
                GetDataByteNameByID(DataByte) as DataByte,
                GetStopByteNameByID(StopByte) as StopByte,
                GetParityByteNameByID(ParityByte) as ParityByte,Memo
    FROM        TB_Cupboard 
    WHERE       (Valid=1)
    ORDER BY ID DESC 

//
DELIMITER //  


/*****************************************/
/*			创建柜子运行日志信息表		 */
/*****************************************/
DELIMITER //
CREATE TABLE TB_CupboardRunningLog(
	CupboardID bigint NOT NULL,	-- 柜子ID 
    FOREIGN KEY fk_cupboardid(CupboardID) REFERENCES TB_Cupboard(ID),
    State int not null default 0,	-- 柜子状态 （离线/在线/故障）
    FOREIGN KEY fk_freezerstate(State) REFERENCES TB_State(ID),
    Starttime datetime not null default '0000-00-00 00:00:00',		-- 启动时间 
    Endtime datetime not null default '0000-00-00 00:00:00',	-- 停止时间
    Temperature decimal(3,1) default 0.0,	-- 温度
    Memo varchar(200) NULL 	-- 备注 
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*插入新运行日志*/
DELIMITER //  
Create PROCedure InsertCupboardRunningLog(
	IN Starttimevalue datetime, -- 启动时间 
    IN CupboardIDvalue bigint, -- 柜子ID
    IN Statevalue int,	-- 柜子状态 
    IN Temperaturevalue decimal(3,1),	-- 温度 
    IN Memovalue varchar(200), -- 操作明细
    OUT err int -- 返回代码
    )
begin     
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
    
    Set @errorSum=0;
    
    insert into TB_CupboardRunningLog values (NOW(),CupboardIDvalue,Statevalue,Temperaturevalue,
										Memovalue);   
    
    IF @errorSum=2 then
		set err = 1;
	ELSE 
		set err = 0;
	END if;
end;
//
DELIMITER //  

/*清空指定柜子的运行日志*/
DELIMITER // 
Create PROCedure ClearCupboardRunningLog (
    IN CupboardIDvalue bigint, -- 柜子ID
    OUT err int -- 返回代码
    )
begin   
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务
    
    Delete From TB_CupboardRunningLog Where (CupboardID=CupboardIDvalue);
    
    IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  

/*删除指定柜子ID的柜子，及其运行日志*/
DELIMITER //  
Create PROCedure DeleteCupboard(
    IN Idvalue bigint,
    OUT err int -- 返回代码
    )
begin   
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

	Delete From TB_CupboardRunningLog Where (CupboardID=Idvalue);
	Delete From TB_Cupboard Where (ID=Idvalue);
	
    IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  


/*****************************************/
/*			创建订单信息表				 */
/*****************************************/
DELIMITER //
create table TB_Order(
	ID bigint auto_increment primary key,		-- 编号
    OrderCode varchar(20) not null unique,	-- 订单编码 
    -- Uname varchar(20) not null default '',		-- 收件人姓名 （不一定有）
    Uphone varchar(20) not null,		-- 收件人电话 
    PostmanID bigint not null,		-- 投递员ID
    FOREIGN KEY fk_postmanid(PostmanID) REFERENCES TB_Postman(ID),
    Delivertime datetime NOT NULL,		-- 投递时间 
    Pickuptime datetime not null default '0000-00-00 00:00:00',	-- 取货时间
    OrderState int not null, 	-- 订单状态(待取/已取)
    FOREIGN KEY fk_ordersate(OrderState) REFERENCES TB_OrderState(ID),
	IdentifyingCode varchar(10) not null,		-- 验证码字段
	DrawerNumber int not null,		-- 存货抽屉数量
	NumberOfMessageNotificationsToDeliveries int NOT NULL default 0,	-- 短信通知投递员次数 
    NumberOfMessageNotificationsConsignees int NOT NULL default 0,	-- 短信通知收货人次数 
    Memo varchar(200) not null, 	-- 备注 
	Valid bit not null default 1 -- 有效性标志
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据ID获取订单编号*/
DELIMITER //
create function GetOrderCodeByID(IDvalue bigint)
Returns varchar(20)
Begin 
    declare name  nvarchar(20);
    
    Set name = Null;

    If (IDvalue Is Not Null) then
		Set name = (Select OrderCode from TB_Order Where (ID=IDvalue) limit 1 );
    End if;
    
    Return name;
End ;
//
DELIMITER //  

/*更新订单*/
DELIMITER //  
Create PROCedure UpdateOrder(
    IN IDvalue int,
	IN OrderCodevalue varchar(20),-- 订单编码
	-- IN Unamevalue varchar(20), 	-- 收件人姓名 
    IN Uphonevalue varchar(20),	-- 收件人电话 
    IN PostmanIDvalue bigint,	-- 投递员ID
    IN Delivertimevalue datetime,		-- 投递时间 
    IN Pickuptimevalue datetime,		-- 取件时间 
    IN OrderStatevalue int,	-- 订单状态 
    IN IdentifyingCodevalue int,		-- 验证码 
    IN DrawerNumbervalue int,		-- 抽屉数量  
    IN NumberOfMessageNotificationsToDeliveriesvalue int,		-- 短信通知投递员次数
    IN NumberOfMessageNotificationsConsigneesvalue varchar(30),		-- 短信通知收货人次数 
    IN Memovalue nvarchar(200),		-- 备注 
    OUT err int -- 返回代码
    )
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    set err = 0;

    IF (IDvalue Is Not Null) then
		SET autocommit=0; 
		START TRANSACTION;  -- 开始事务

		Update TB_Order  Set
			OrderCode=OrderCodevalue,
			Uphone=Uphonevalue,	
			PostmanID=PostmanIDvalue ,  
			Delivertime=Delivertimevalue,	 
			Pickuptime=Pickuptimevalue,		
			OrderState=OrderStatevalue,
			IdentifyingCode=IdentifyingCodevalue,
			DrawerNumber=DrawerNumbervalue,
			NumberOfMessageNotificationsToDeliveries=NumberOfMessageNotificationsToDeliveriesvalue,
			NumberOfMessageNotificationsConsignees=NumberOfMessageNotificationsConsigneesvalue,
			Memo=Memovalue 
			where   ID=IDvalue;

		IF @errorSum=2 then
			ROLLBACK; -- 事务回滚语句 
			set err = 1;
		ELSE 
			Commit; -- 事务提交语句 
			set err = 0;
		END if;
        
        SET autocommit=1; 
    END if;
END;
//
DELIMITER //  

/*保存订单信息*/
DELIMITER //  
Create PROCedure SaveOrder(
	IN OrderCodevalue varchar(20),-- 订单编码
	-- IN Unamevalue varchar(20), 	-- 收件人姓名 
    IN Uphonevalue varchar(20),	-- 收件人电话 
    IN PostmanIDvalue bigint,	-- 投递员ID
    IN Delivertimevalue datetime,		-- 投递时间 
    IN Pickuptimevalue datetime,		-- 取件时间 
    IN OrderStatevalue int,	-- 订单状态 
    IN IdentifyingCodevalue int,		-- 验证码 
    IN DrawerNumbervalue int,		-- 抽屉数量  
    IN NumberOfMessageNotificationsToDeliveriesvalue int,		-- 短信通知投递员次数
    IN NumberOfMessageNotificationsConsigneesvalue varchar(30),		-- 短信通知收货人次数  
    IN Memovalue nvarchar(200),		-- 备注 
    OUT err int -- 返回代码
    )
begin 
    DECLARE TempID bigint;  
    DECLARE currentnumber bigint;  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
    Set TempID = (Select ID From TB_Order Where (OrderCode =OrderCodevalue) limit 1);
    
	Set @errorSum = 0;
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    IF (TempID Is Not Null) then -- 订单已经存在，更新订单信息
		call UpdateOrder( TempID,Unamevalue,Uphonevalue,PostmanIDvalue,Delivertimevalue,Pickuptimevalue,
							OrderStatevalue,IdentifyingCodevalue,DrawerNumbervalue,
                            NumberOfMessageNotificationsToDeliveriesvalue,
                            NumberOfMessageNotificationsConsigneesvalue,Memovalue);
	Else
		SET currentnumber = GetSerialNumber ('订单');
		
        insert into TB_Order values (currentnumber,Unamevalue,Uphonevalue,PostmanIDvalue,Delivertimevalue,Pickuptimevalue,
							OrderStatevalue,IdentifyingCodevalue,DrawerNumbervalue,
                            NumberOfMessageNotificationsToDeliveriesvalue,
                            NumberOfMessageNotificationsConsigneesvalue,Memovalue,1);   
    End if;

	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  


/*创建订单信息的视图*/
DELIMITER //
CREATE VIEW View_Order
AS
	SELECT ID,Uname,Uphone,Postman,Delivertime,Pickuptime,GetOrderStateByID(OrderState) as 
		OrderState,IdentifyingCode,DrawerNumber,NumberOfMessageNotificationsToDeliveries,
                            NumberOfMessageNotificationsConsignees,Memo
	FROM        TB_Order 
    WHERE       (Valid=1)
    ORDER BY ID DESC 


/*****************************************/
/*			创建抽屉信息表			 	 */
/*****************************************/
DELIMITER //
create table TB_Drawer(
	ID bigint not null primary key,		-- ID
    DrawerCode varchar(20) NOT NULL,	-- 抽屉编号
    CupboardID bigint not null,	-- 柜子ID 
    FOREIGN KEY fk_cupboardid1(CupboardID) REFERENCES TB_Cupboard(ID),
    State int not null default 0,		-- 状态（空闲/占用）
    FOREIGN KEY fk_drawerstate(State) REFERENCES TB_DrawerState(ID),
    IsMaingui int not null default 0,		-- 是否主柜
    FOREIGN KEY fk_ismaingui(IsMaingui) REFERENCES TB_IsMaingui(ID),
    Memo varchar(200) null, 	-- 备注
    Valid bit not null default 1 -- 有效性标志
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据抽屉ID获取柜子ID*/
DELIMITER //
Create Function GetCupboardIDByDrawerID
  (IDvalue bigint)
Returns bigint
Begin 
    declare tmp bigint;
    
    Set tmp = Null;

    If (codevalue Is Not Null) then
		Set tmp = (Select CupboardID from TB_Drawer Where (ID = IDvalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if; 
    
    Return tmp;
End;
//
DELIMITER //  


/*保存抽屉信息*/
DELIMITER //  
Create PROCedure SaveDrawer(
	IN IDvalue bigint,
    IN DrawerCode varchar(20),	-- 抽屉编号 
	IN CupboardIDvalue int,		-- 柜子ID
    IN Statevalue int,		-- 状态 
    IN IsMainguivalue int,	-- 是否主柜 
    IN Memovalue nvarchar(200),		-- 备注
    OUT err int -- 返回代码
    )
begin 
    DECLARE currentnumber bigint;  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;

	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

   
	SET currentnumber = GetSerialNumber ('抽屉');
		
	insert into TB_Drawer values (currentnumber,DrawerCodevalue,CupboardIDvalue,Statevalue,IsMainguivalue,Memovalue,1);   
    

	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  

/*更新抽屉信息*/
DELIMITER //  
Create PROCedure UpdateDrawer(
    IN IDvalue bigint,
    IN DrawerCode varchar(20),	-- 抽屉编号 
	IN CupboardIDvalue int,		-- 柜子ID
    IN Statevalue int,		-- 状态 
    IN IsMainguivalue int,	-- 是否主柜 
    IN Memovalue nvarchar(200),		-- 备注
    OUT err int -- 返回代码
    )
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    set err = 0;

    IF (IDvalue Is Not Null) then
		SET autocommit=0; 
		START TRANSACTION;  -- 开始事务

		Update TB_Drawer  Set
			DrawerCode=DrawerCodevalue,
			CupboardID=CupboardIDvalue,
            State=Statevalue,
            IsMaingui=IsMainguivalue,
			Memo=Memovalue 
			where   ID=IDvalue;

		IF @errorSum=2 then
			ROLLBACK; -- 事务回滚语句 
			set err = 1;
		ELSE 
			Commit; -- 事务提交语句 
			set err = 0;
		END if;
        
        SET autocommit=1; 
    END if;
END;
//
DELIMITER //

/*创建查询所有抽屉的视图*/
DELIMITER //  
CREATE VIEW View_Drawer
AS
    SELECT     ID, DrawerCode,CupboardID,GetDrawerStateByID(State) as State,GetFreezerModeByID(GetCupboardIDByDrawerID(ID) ) 
						as Mode, IsMaingui,Memo
    FROM        TB_Drawer 
    WHERE       (Valid=1)
    ORDER BY ID DESC 

//
DELIMITER //  




/*****************************************/
/*			创建抽屉日志信息表			 */
/*****************************************/
DELIMITER //
CREATE TABLE TB_DrawerLog(
	DrawerID bigint NOT NULL,	/*抽屉ID*/
    FOREIGN KEY fk_drawerid(DrawerID) REFERENCES TB_Drawer(ID),
	OrderID bigint NOT NULL,	/*订单ID*/
    FOREIGN KEY fk_orderid(OrderID) REFERENCES TB_Order(ID),
    StateChangeTime datetime NOT NULL,	/*状态变化时间*/
	State int not null default 0,		-- 状态（空闲/占用）
    FOREIGN KEY fk_DrawerState1(State) REFERENCES TB_DrawerState(ID),
	Memo varchar(200) null	-- 备注
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/*根据订单ID获取抽屉ID*/
DELIMITER //
Create Function GetDrawerIDByOrderID
  (IDvalue bigint)
Returns bigint
Begin 
    declare tmp bigint;
    
    Set tmp = Null;

    If (codevalue Is Not Null) then
		Set tmp = (Select DrawerID from TB_DrawerLog Where (ID = IDvalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if; 
    
    Return tmp;
End;
//
DELIMITER //  

/*插入新抽屉变化日志*/
DELIMITER //  
Create PROCedure InsertDrawerLog(
    IN DrawerIDvalue bigint, -- 抽屉ID
    IN OrderIDvalue bigint,	-- 订单ID 
    IN StateChangeTimevalue datetime,	-- 状态改变时间 
    IN Statevalue int,		-- 状态 
    IN Memovalue varchar(200), -- 操作明细
    OUT err int -- 返回代码
    )
begin     
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
    
    Set @errorSum=0;
    
    insert into TB_DrawerLog values (NOW(),DrawerIDvalue,OrderIDvalue,Statevalue,Memovalue);   
    
    IF @errorSum=2 then
		set err = 1;
	ELSE 
		set err = 0;
	END if;
end;
//
DELIMITER //  

/*清空指定抽屉的日志*/
DELIMITER // 
Create PROCedure ClearDrawerLog (
    IN DrawerIdvalue bigint, -- 抽屉ID
    OUT err int -- 返回代码
    )
begin   
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务
    
    Delete From TB_DrawerLog Where (DrawerID=DrawerIdvalue);
    
    IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  

/*删除指定抽屉ID的抽屉，及其运行日志*/
DELIMITER //  
Create PROCedure DeleteDrawer(
    IN Idvalue bigint,
    OUT err int -- 返回代码
    )
begin   
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    
	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

	Delete From TB_DrawerLog Where (DrawerID=Idvalue);
	Delete From TB_Drawer Where (ID=Idvalue);
	
    IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  




/*****************************************/
/*			创建屏保文件信息表			 */
/*****************************************/
DELIMITER //
CREATE TABLE TB_ScreenSaverFile(
	ID int NOT NULL PRIMARY KEY,
    FileName varchar(20) NOT NULL,	-- 文件名 
    TerminalID bigint NOT NULL,		-- 终端ID 
    FOREIGN KEY fk_terminalid1(TerminalID) REFERENCES TB_Terminal(ID),
    PlayTime datetime,	-- 播放时间
	Memo varchar(200) not null, 	-- 备注 
	Valid bit not null default 1 -- 有效性标志
)ENGINE = MYISAM DEFAULT CHARSET=utf8 ;
//
DELIMITER //

/* 获取指定屏保文件ID的名称*/
DELIMITER // 
Create Function GetScreenSaverFileNameByID
  (Idvalue int)
Returns nvarchar(20)
Begin 
    declare tmp nvarchar(20);
    
    Set tmp = Null;

    If (Idvalue Is Not Null) then
		Set tmp = (Select FileName from TB_ScreenSaverFile Where (ID = Idvalue) and (Valid = 1) ORDER BY ID DESC limit 1);
    End if;   
    
    Return tmp;
End;  
//
DELIMITER //  

/*更新屏保文件信息*/
DELIMITER //  
Create PROCedure UpdateScreenSaverFile(
    IN IDvalue int,
    IN FileNamevalue varchar(20),	-- 名称
	IN TerminalIDvalue bigint,	-- 终端IP 
	IN Playtimevalue datetime,	-- 播放时间 
    IN Memovalue nvarchar(200),		-- 备注 
    OUT err int -- 返回代码
    )
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;
    set err = 0;

    IF (IDvalue Is Not Null) then
		SET autocommit=0; 
		START TRANSACTION;  -- 开始事务

		Update TB_ScreenSaverFile  Set
			FileName=FileNamevalue , 
			TerminalID=TerminalIDvalue,
            Playtime=Playtimevalue,
			Memo=Memovalue 
			where   ID=IDvalue;

		IF @errorSum=2 then
			ROLLBACK; -- 事务回滚语句 
			set err = 1;
		ELSE 
			Commit; -- 事务提交语句 
			set err = 0;
		END if;
        
        SET autocommit=1; 
    END if;
END;
//
DELIMITER //  

/*保存屏保文件信息*/
DELIMITER //  
Create PROCedure SaveScreenSaverFile(
    IN FileNamevalue varchar(20),	-- 名称
	IN TerminalIDvalue bigint,	-- 终端IP 
	IN Playtimevalue datetime,	-- 播放时间 
    IN Memovalue nvarchar(200),		-- 备注 
    OUT err int -- 返回代码
    )
begin 
    DECLARE TempID int;  
    DECLARE currentnumber bigint;  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @errorSum=2;
	
	Set @errorSum = 0;

    Set TempID = (Select ID From TB_ScreenSaverFile Where (FileName =FileNamevalue) limit 1);

	SET autocommit=0; 
	START TRANSACTION;  -- 开始事务

    IF (TempID Is Not Null) then -- 屏保文件已经存在，更新屏保文件信息
		call UpdateScreenSaverFile( TempID, FileNamevalue，TerminalIDvalue，Playtimevalue,Memovalue);
	Else
		SET currentnumber = GetSerialNumber ('屏保文件');
		
        insert into TB_ScreenSaverFile values (currentnumber,FileNamevalue，TerminalIDvalue，Playtimevalue,Memovalue,1);   
    End if;

	IF @errorSum=2 then
		ROLLBACK; -- 事务回滚语句 
		set err = 1;
	ELSE 
		Commit;  -- 事务提交语句 
		set err = 0;
	END if;
    
    SET autocommit=1;
end;
//
DELIMITER //  


/*创建查询所有屏保文件的视图*/
DELIMITER //  
CREATE VIEW View_ScreenSaverFile
AS
    SELECT     ID,FileName,TerminalID,GetTerminalNameByID(TerminalID) as Terminal,Playtime,Memo
    FROM        TB_ScreenSaverFile 
    WHERE       (Valid=1)
    ORDER BY ID DESC 

//
DELIMITER //  




