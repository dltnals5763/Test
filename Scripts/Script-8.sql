/*
[데이터베이스]
[하] 1. 테이블 구조변경 형식을 기본 예제와 함께 기술하세요.
		alter table 테이블명
		modify 컬럼 데이터유형 옵션1
		옵션1 (default 기본데이터)
		
[하] 2. 테이블 구조변경의 한계(데이터 입력, 유형, 크기 별로)를 기술하세요.
1) 데이터 입력
	- 작은 크기에서 큰 크기로의 변경은 가능하다.
	- 하지만 있는 데이터의 범위보다 작게 변경하면 에러가 발생한다.
2) 데이터 유형
	- varchar2 <=> char 간의 유형 변경은 가능하다.
	- 그 외에 유형이 달라질 때 에러가 발생한다 
3) 데이터 크기
	- 숫자형 데이터의 경우 작은 데이터로의 변경이 불가능하다.
	- 정밀도가 한번 커지면 할당 데이터와 상관 없이 작은 크기로의 변경이 불가능하다.

[중] 3. 테이블 구조복사 종합예제
    1) emp54으로 구조복사해서 테이블 만들고,
    2) 테이블을 dname, postion 를 추가. 
       grade char(1) 추가
       tmp_empno char(8)로 추가
    3) 입사년월(4)부서번호(2)사원번호(4) 로 tmp_empno 할당 처리,
    4) subquery를 이용해서 해당 데이터에 맞게 데이터를 입력처리.
        grade는 sal의 등급에 따라 5000이상 A, B, C...로 할당 처리.
    5) hiredate는 credte로 변경 char(8)  YYYYMMDD  변경처리
    6) empno 컬럼 삭제 처리, tmp_empno는 empno로 변경

**/
-- 1번
CREATE TABLE EMP60 
AS SELECT * FROM emp WHERE 1=0;
SELECT * FROM emp60;
ALTER TABLE EMP60 
MODIFY ename varchar2(50);

---- 3번
--1)
DROP TABLE emp54;
CREATE TABLE emp54 
AS SELECT * FROM emp WHERE 1=0;
SELECT * FROM emp54;
--2)
ALTER TABLE emp54
ADD dname varchar2(30)
ADD POSITION varchar2(30)
ADD grade char(1)
ADD tmp_empno char(10);
SELECT * FROM emp54;
--3,4)
INSERT INTO emp54
(SELECT e.*, d.dname, d.deptno, 
	CASE 
	WHEN e.sal>=5000 THEN 'A'
	WHEN e.sal>=4000 THEN 'B'
	WHEN e.sal>=3000 THEN 'C'
	ELSE 'D'
	END AS grade,
	TO_CHAR(e.hiredate,'YYYY')||d.deptno||e.empno AS tmp_empno
FROM emp e, dept d, salgrade s
WHERE e.deptno=d.deptno 
	AND e.sal BETWEEN s.losal AND s.hisal);
SELECT * FROM emp54;
--5)
ALTER TABLE emp54
RENAME COLUMN hiredate TO credte;
UPDATE emp54
SET credte=NULL;
ALTER TABLE emp54
MODIFY credte char(8);
UPDATE emp54 b
SET credte = 
	(SELECT TO_CHAR(hiredate,'YYYYMMDD')
		FROM emp a
	WHERE a.empno=b.empno);
SELECT * FROM emp54;









