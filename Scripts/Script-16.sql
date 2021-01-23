/*
[데이터베이스]
[하] 1. 설계의 정규화 과정에서 삽입,삭제,등록 이상이 무엇을 말하는지 기술하세요.
	1) 삽입 이상 : 데이터 입력시 특정 속성에 해당하는 값이 null로 입력되어 데이터의 낭비를 초래할 수 있다.
	2) 삭제 이상 : 데이터 row 단위 삭제시 저장된 다른 정보까지 연쇄적으로 삭제되어,
		추후에 해당 정보를 확인할 수 없는 상황이 발생한다.
	3) 수정 이상 : 수정시 중복된 데이터의 일부만 수정되어 데이터의 불일치 문제가 발생한다.
	
[중] 2. 아래와 같은 데이터를 테이블로 만들고, 정규화 과정을 거친 테이블로 구성하세요.
    회원아이디  패스워드  회원명 구매할물건명  구매갯수  물건가격  재고량
    himan     7777   홍길동  사과        3      3000     27
    higirl    8888   신미나  사과        2      3000     25

**/
CREATE TABLE info(
	id varchar2(30),
	pass varchar2(30),
	name varchar2(30),
	product varchar2(30),
	cnt NUMBER,
	price NUMBER,
	stock number
);
INSERT INTO info values('himan', 7777, '홍길동','사과',3,3000,27);
INSERT INTO info values('higirl', 8888, '신미나','사과',2,3000,25);
SELECT * FROM info;

-- 구매자정보
CREATE TABLE custoInfo
AS SELECT id,pass,name,product,cnt FROM info;
SELECT * FROM custoInfo;
-- 상품정보
CREATE TABLE prodInfo
AS SELECT DISTINCT product,price FROM info;
SELECT * FROM prodInfo;
-- 재고정보
CREATE TABLE stockInfo
AS SELECT DISTINCT product, stock FROM info
WHERE stock = (SELECT min(stock) FROM info);
SELECT * FROM stockInfo;



