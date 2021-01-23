SELECT * FROM dictionary;
SELECT table_name FROM user_tables;
SELECT owner,table_name
FROM all_tables;
SELECT * FROM dba_tables;
/*
# 데이터 사전
1. 데이터사전이란?
	1) 오라클 데이터베이스를 구성하고 운영하는 데이터를 저장하는 특수한 테이블
	2) 오라클 사용자가 직접 접근할 수는 없다.
	3) select문으로 열람은 가능하다.
2. 종류
	1) USER_복수명사 : 현재 접속한 사용자가 소유하는 테이블 목록
	2) ALL_복수명사 : 사용자가 소유하는 테이블을 포함해 다른 사용자가 소유한 테이블 중 현재 사용자에게 사용
		허가가 되어 있는 테이블
# 인덱스
1. 인덱스란?
	1) 데이터 검색 성능의 향상을 위해 테이블 열에 사용하는 객체
	2) 특정 행의 데이터 주소를 책 페이지처럼 목록으로 만들어 놓은 것
	3) user_indexes, user_ind_columns를 이용하여 인덱스 정보 열람 가능
2. 인덱스 생성
	1) 형식
	create index 인덱스이름
		on 테이블이름(열이름)
3. 인덱스 삭제
	1) 형식
	drop index 인덱스이름
**/
-- 인덱스 열람
SELECT * FROM USER_INDEXES;
-- 인덱스 생성
CREATE INDEX idx_emp_sal
	ON emp(sal);
SELECT * FROM USER_IND_COLUMNS;
-- 인덱스 삭제
DROP INDEX idx_emp_sal;
/*
# 뷰
1. 뷰란?
	1) 가상테이블. 하나 이상의 테이블을 조회하는 select문을 저장한 객체
2. 뷰 생성
	1) 형식
	create|replace [force|noforce] view 뷰이름 (열이름1, 열이름2, ..)
		as (저장할 select문)
	[with check option [constraint 제약조건]]
	[with read only [constraint 제약조건]]
	
	- replace : 같은 이름의 뷰가 존재할 경우 현재 생성할 뷰로 대체하여 생성
	- force : 뷰가 저장할 select문의 기반 테이블이 존재하지 않아도 강제로 생성
	- noforce : 뷰가 저장할 select문의 기반 테이블이 존재할 경우에 생성(기본값)
	- with check option : 지정한 제약 조건을 만족하는 데이터에 한해 DML 작업이 가능하도록 뷰 생성
	- with read only : 뷰의 열람, 즉 select만 가능하도록 뷰 생성
3. 뷰 삭제
	1) 형식
	drop view 뷰이름
**/
-- 뷰 생성
CREATE VIEW vw_emp20
	AS (SELECT empno, ename, job, deptno
			FROM emp
		WHERE deptno=20);
SELECT * FROM user_views;
SELECT * FROM vw_emp20;
-- 부서번호가 30인 사원 정보의 모든 열을 출력하는 뷰 생성
CREATE VIEW vm_emp30all
	AS (SELECT *
		FROM emp
		WHERE deptno=30);
SELECT * FROM vm_emp30all;
-- 뷰 삭제
DROP VIEW vw_emp20;
/*
4. 인라인 뷰
	1) SQL문에서 일회성으로 만들어서 사용하는 뷰
		ex) 서브쿼리, with절에서 미리 이름을 정의해두고 사용하는 select문
	2) rownum
		- 테이블에 저장된 행이 조회된 순서대로 매겨진 일련 번호
		- order by를 이용하여 정렬해도 유지되는 특성
**/
-- rownum을 추가로 조회하기
SELECT rownum, e.*
FROM emp e;
SELECT rownum, e.*
FROM emp e
ORDER BY sal DESC;
-- 서브쿼리 사용 인라인뷰
SELECT rownum, e.*
FROM (SELECT *
		FROM EMP
		ORDER BY sal desc) e;
-- with절 사용 인라인뷰
WITH e AS (SELECT * FROM emp ORDER BY sal desc)
SELECT rownum, e.*
FROM e;
-- 인라인 뷰를 이용하여 sal가 높은 세명을 출력하기(서브쿼리)
SELECT rownum, e.*
FROM (SELECT *
		FROM EMP e2
		ORDER BY sal desc) e
WHERE rownum<=3;
-- 인라인 뷰를 이용하여 sal가 높은 세명을 출력하기(with절)
WITH e AS (SELECT * FROM emp ORDER BY sal desc)
SELECT rownum, e.*
FROM e 
WHERE rownum<=3;
/*
# 시퀀스
1. 시퀀스란?
	1) 특정 규칙에 맞는 연속 숫자를 생성하는 객체
	2) 은행이나 병원의 대기 순번표
2. 시퀀스 생성
	1) 형식
	create sequence 시퀀스이름
	increment by n
	start with n
	minvalue
	maxvalue
	cycle
**/
-- dept 테이블 복사
CREATE TABLE dept_sequence
AS SELECT * FROM dept WHERE 1=0;
SELECT * FROM dept_sequence;
-- deptno가 10씩 증가하도록 sequence 생성
CREATE SEQUENCE seq_dept_sequence
	INCREMENT BY 10
	START WITH 10
	MINVALUE 0
	MAXVALUE 90;
SELECT * FROM user_sequences;
-- 시퀀스 사용
INSERT INTO dept_sequence values(seq_dept_sequence.nextval, 'DATABASE','SEOUL');
SELECT * FROM dept_sequence;
/*
3. 시퀀스 수정
	1) create 대신 alter를 사용하여 수정
	2) start with 값은 변경할 수 없음
4. 시퀀스 삭제
	1) drop sequence
**/
-- dept_sequence 수정하기 (최대값:99, 증가값:3)
ALTER sequence seq_dept_sequence
	INCREMENT BY 3
	MAXVALUE 99
	CYCLE;
INSERT INTO dept_sequence values(seq_dept_sequence.nextval, 'DATABASE','SEOUL');
SELECT * FROM dept_sequence;
/*
# 동의어
1. 동의어란?
	1) 테이블, 뷰, 시퀀스 등 객체 이름 대신 사용할 수 있는 다른 이름을 부여하는 객체
	2) from에서의 별칭과 차이점 : 일회성이 아니다.
	3) select, insert, update, delete 등 다양한 select문에서 사용할 수 있다.
	4) 형식
		create [public] synonym 동의어이름
		for [사용자.][객체이름]
2. 동의어 삭제
	1) 형식
	drop synonym 동의어이름;
**/
-- 동의어 e 생성
CREATE synonym e
FOR emp;
SELECT * FROM e;

-- 연습문제1
-- empidx 테이블 만들기
CREATE TABLE EMPIDX
AS SELECT * FROM emp;
SELECT * FROM empidx;
-- idx_empidx_empno 인덱스 만들기
CREATE INDEX IDX_EMPIDX_EMPNO 
ON empidx(empno);
-- 인덱스 생성 확인하기
SELECT * FROM user_indexes;
-- 연습문제2
SELECT empno, ename, job, deptno, sal, NVL2(comm,'X','O') AS comm
FROM empidx;
CREATE VIEW empidx_over15k
	AS (SELECT empno, ename, job, deptno, sal, 
			NVL2(comm,'O','X') AS comm
			FROM empidx
			WHERE sal>1500);
SELECT * FROM empidx_over15k;
-- 연습문제3
-- deptseq 생성
CREATE TABLE DEPTSEQ 
AS SELECT * FROM dept WHERE 1=0;
SELECT * FROM deptseq;
-- 시퀀스 생성
CREATE SEQUENCE seq_dept_ch13
	INCREMENT BY 1
	START WITH 1
	MAXVALUE 99
	MINVALUE 1
	nocycle;




