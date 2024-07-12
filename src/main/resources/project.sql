-- 테이블 삭제
DROP TABLE PARENT;
DROP TABLE CHILD;
DROP TABLE PARENT_POST;
DROP TABLE PARENT_COMMENT;
DROP TABLE PARENT_FILE;
DROP TABLE PARENT_REPORT;
DROP TABLE PARENT_NOTE;
DROP TABLE PRO;
DROP TABLE PRO_POST;
DROP TABLE PRO_COMMENT;
DROP TABLE PRO_FILE;
DROP TABLE PRO_REPORT;
DROP TABLE CLASS;
DROP TABLE CLASS_SAVE;
DROP TABLE REVIEW;
DROP TABLE IMG;
DROP TABLE RESERVATION;
DROP TABLE RESERVATION_DATE;
DROP TABLE RESERVATION_TIME;
DROP TABLE QUESTION;
DROP TABLE ANSWER;

-- 부모 테이블
CREATE TABLE PARENT(
	PARENT_NUMBER NUMBER PRIMARY KEY, 			-- PK
	PARENT_EMAIL VARCHAR2(100) NOT NULL,		-- 이메일
	PARENT_PASSWORD VARCHAR2(100) NOT NULL,		-- 비밀번호
	PARENT_NAME VARCHAR2(100) NOT NULL,			-- 이름
	PARENT_NICKNAME VARCHAR2(100),				-- 닉네임, NOT NULL 제약조건 삭제
	PARENT_PHONE_NUMBER VARCHAR2(100) NOT NULL,	-- 휴대전화
	PARENT_ADDRESS VARCHAR2(100) NOT NULL,		-- 주소
	PARENT_PROFILE_IMAGE_URL VARCHAR2(100), 	-- 프로필 이미지, NOT NULL 제약조건 삭제
	PARENT_REPORT_COUNT NUMBER					-- 신고 당한 횟수 
);

-- 아이 테이블
CREATE TABLE CHILD(
	CHILD_NUMBER NUMBER PRIMARY KEY,				-- PK
	CHILD_NAME VARCHAR2(50) NOT NULL,				-- 이름
	CHILD_AGE NUMBER NOT NULL,						-- 나이
	CHILD_GENDER VARCHAR2(10) NOT NULL,				-- 성별
	CHILD_SPECIAL_ISSUES VARCHAR2(500) NOT NULL,	-- 특이사항
	PARENT_NUMBER NUMBER, 							-- FK (부모 테이블)
	CONSTRAINT FK_PARENT_TO_CHILD FOREIGN KEY(PARENT_NUMBER)
	REFERENCES PARENT(PARENT_NUMBER)
);

-- 부모 게시판 테이블
CREATE TABLE PARENT_POST(
	PARENT_POST_NUMBER NUMBER PRIMARY KEY,			-- PK
	PARENT_POST_TITLE VARCHAR2(100) NOT NULL,		-- 게시글 제목
	PARENT_POST_CONTENT VARCHAR2(1000) NOT NULL,	-- 게시글 내용
	PARENT_POST_VIEWS NUMBER DEFAULT 0 NOT NULL,	-- 게시글 조회 수, DEFAULT 값 0으로 설정 
	PARENT_POST_REGISTER_DATE DATE DEFAULT SYSDATE, -- 등록일, DEFAULT 값 현재 날짜로 설정
	PARENT_POST_UPDATE_DATE DATE DEFAULT SYSDATE,	-- 수정일
	PARENT_NUMBER NUMBER,							-- FK (부모 테이블)
	CONSTRAINT FK_PARENT_TO_POST FOREIGN KEY(PARENT_NUMBER)
	REFERENCES PARENT(PARENT_NUMBER)
);

-- 댓글 (부모) 테이블
CREATE TABLE PARENT_COMMENT(
	PARENT_COMMENT_NUMBER NUMBER PRIMARY KEY,			-- PK
	PARENT_COMMENT_CONTENT VARCHAR2(1000) NOT NULL,		-- 댓글 내용
	PARENT_COMMENT_REGISTER_DATE DATE DEFAULT SYSDATE,	-- 댓글 등록일, DEFAULT 값 현재 날짜로 설정
	PARENT_COMMENT_UPDATE_DATE DATE DEFAULT SYSDATE,	-- 댓글 수정일
	PARENT_NUMBER NUMBER,								-- FK (부모 테이블)
	PARENT_POST_NUMBER NUMBER,							-- FK (부모 게시판 테이블)
	CONSTRAINT FK_PARENT_TO_COMMENT_NUMBER FOREIGN KEY(PARENT_NUMBER)
	REFERENCES PARENT(PARENT_NUMBER),
	CONSTRAINT FK_PARENT_TO_COMMENT_POST FOREIGN KEY(PARENT_POST_NUMBER)
	REFERENCES PARENT_POST(PARENT_POST_NUMBER)
);

-- 첨부파일 (부모) 테이블
CREATE TABLE PARENT_FILE(
    PARENT_FILE_NUMBER NUMBER PRIMARY KEY,				-- PK
    PARENT_FILE_NAME VARCHAR2(100) NOT NULL,			-- 첨부파일 이름
    PARENT_FILE_SIZE NUMBER NOT NULL,					-- 첨부파일 용량
    PARENT_FILE_URL VARCHAR2(500) NOT NULL,				-- 첨부파일 주소
    PARENT_FILE_UPLOAD_TIME DATE DEFAULT SYSDATE,		-- 첨부파일 업로드 시간
    PARENT_POST_NUMBER NUMBER,							-- FK (부모 게시판 테이블)
    CONSTRAINT FK_PARENT_TO_FILE FOREIGN KEY(PARENT_POST_NUMBER)
    REFERENCES PARENT_POST(PARENT_POST_NUMBER)
);

-- 신고하기 ( 부모 ) 테이블
CREATE TABLE PARENT_REPORT(
	PARENT_REPORT_NUMBER NUMBER PRIMARY KEY,			-- PK
	PARENT_REPORT_TYPE VARCHAR2(100) NOT NULL,			-- 신고 유형
	PARENT_REPORT_CONTENT VARCHAR2(1000) NOT NULL,		-- 신고 내용
	PARENT_REPORT_REGISTER_DATE DATE DEFAULT SYSDATE,	-- 등록일
	PARENT_POST_NUMBER NUMBER,							-- FK (부모 게시판 테이블)
	CONSTRAINT FK_PARENT_TO_REPORT FOREIGN KEY(PARENT_POST_NUMBER)
	REFERENCES PARENT_POST(PARENT_POST_NUMBER)
);

-- 쪽지 (부모) 테이블
CREATE TABLE PARENT_NOTE(	
	PARENT_NOTE_NUMBER NUMBER PRIMARY KEY,				-- PK
	PARENT_NOTE_CONTENT VARCHAR2(1000) NOT NULL,		-- 쪽지 내용
	PARENT_NOTE_SEND_TIME DATE DEFAULT SYSDATE,			-- 쪽지 전송 시간, TIME 데이터 타입도 있지만 적용이 되지 않음. (DEFAULT 값 현재 날짜로 설정)
	PARENT_NOTE_ALARM_CHECK VARCHAR2(20) NOT NULL,		-- 쪽지 알림 체크 여부, DEFAULT 값이 들어가야 되는데 뭔지???
	PARENT_NUMBER NUMBER,								-- FK (부모 테이블)
	PRO_NUMBER NUMBER,									-- FK (전문가 테이블)
	CONSTRAINT FK_PARENT_TO_NOTE FOREIGN KEY(PARENT_NUMBER)
	REFERENCES PARENT(PARENT_NUMBER),
	CONSTRAINT FK_PRO_TO_NOTE FOREIGN KEY(PRO_NUMBER)
	REFERENCES PRO(PRO_NUMBER)
);

-- 전문가 테이블
CREATE TABLE PRO(
	PRO_NUMBER NUMBER PRIMARY KEY,									-- PK
	PRO_EMAIL VARCHAR2(100) NOT NULL,								-- 이메일
	PRO_PASSWORD VARCHAR2(100) NOT NULL,						-- 비밀번호
	PRO_NAME VARCHAR2(100) NOT NULL,								-- 이름
	PRO_NICKNAME VARCHAR2(100),											-- 별명, NOT NULL 제약조건 삭제
	PRO_PHONE_NUMBER VARCHAR2(100) NOT NULL,				-- 휴대전화
	PRO_ADDRESS VARCHAR2(300) NOT NULL,							-- 주소
	PRO_PROFILE_IMAGE_URL VARCHAR2(500),						-- 프로필 이미지, NOT NULL 제약조건 삭제
	PRO_FILE VARCHAR2(500),													-- 첨부 파일, NOT NULL 제약조건 삭제
	PRO_INTRO VARCHAR2(1000) NOT NULL								-- 자기 소개
);

-- 전문가 게시판 테이블
CREATE TABLE PRO_POST(
	PRO_POST_NUMBER NUMBER PRIMARY KEY,					-- PK
	PRO_POST_TITLE VARCHAR2(100) NOT NULL,				-- 게시글 제목
	PRO_POST_CONTENT VARCHAR2(1000) NOT NULL,			-- 게시글 내용
	PRO_POST_VIEWS NUMBER DEFAULT 0 NOT NULL,			-- 게시글 조회 수
	PRO_POST_REGISTER_DATE DATE DEFAULT SYSDATE,		-- 등록일
	PRO_POST_UPDATE_DATE DATE DEFAULT SYSDATE,			-- 수정일
	PRO_NUMBER NUMBER,									-- FK (전문가 테이블)
	CONSTRAINT FK_PRO_TO_POST FOREIGN KEY(PRO_NUMBER)
	REFERENCES PRO(PRO_NUMBER)
);

-- 댓글 ( 전문가 ) 테이블
CREATE TABLE PRO_COMMENT(
	PRO_COMMENT_NUMBER NUMBER PRIMARY KEY,				-- PK
	PRO_COMMENT_CONTENT VARCHAR2(1000) NOT NULL,		-- 댓글 내용
	PRO_COMMENT_REGISTER_DATE DATE DEFAULT SYSDATE,		-- 등록일
	PRO_COMMENT_UPDATE_DATE DATE DEFAULT SYSDATE,		-- 수정일
	PRO_POST_NUMBER NUMBER,								-- FK (전문가 게시판 테이블)
	PRO_NUMBER NUMBER,									-- FK (전문가 테이블)
	CONSTRAINT FK_PRO_TO_COMMENT_NUMBER FOREIGN KEY(PRO_POST_NUMBER)
	REFERENCES PRO_POST(PRO_POST_NUMBER),
	CONSTRAINT FK_PRO_TO_COMMENT_POST FOREIGN KEY(PRO_NUMBER)
	REFERENCES PRO(PRO_NUMBER)
);

-- 첨부파일 ( 전문가 ) 테이블
CREATE TABLE PRO_FILE(
	PRO_FILE_NUMBER NUMBER PRIMARY KEY,					-- PK
	PRO_FILE_NAME VARCHAR2(100) NOT NULL,				-- 첨부파일 이름
	PRO_FILE_URL VARCHAR2(500) NOT NULL,				-- 첨부파일 주소
	PRO_FILE_SIZE NUMBER NOT NULL,						-- 첨부파일 용량
	PRO_FILE_UPLOAD_TIME DATE DEFAULT SYSDATE,			-- 첨부파일 업로드 시간
	PRO_POST_NUMBER NUMBER,								-- FK (전문가 게시판 테이블)
	CONSTRAINT FK_PRO_TO_FILE FOREIGN KEY(PRO_POST_NUMBER)
	REFERENCES PRO_POST(PRO_POST_NUMBER)
);

-- 신고하기 ( 전문가 ) 테이블
CREATE TABLE PRO_REPORT(
	PRO_REPORT_NUMBER NUMBER PRIMARY KEY,				-- PK
	PRO_REPORT_TYPE VARCHAR2(200) NOT NULL,				-- 신고 유형
	PRO_REPORT_CONTENT VARCHAR2(1000) NOT NULL,			-- 신고 내용
	PRO_REPORT_REGISTER_DATE DATE DEFAULT SYSDATE,		-- 신고 등록일
	PRO_POST_NUMBER NUMBER,								-- FK (전문가 게시판 테이블)
	CONSTRAINT FK_PRO_TO_REPORT FOREIGN KEY(PRO_POST_NUMBER)
	REFERENCES PRO_POST(PRO_POST_NUMBER)
);

-- 수업 테이블
CREATE TABLE CLASS(
	CLASS_NUMBER NUMBER PRIMARY KEY,								-- PK
	CLASS_NAME VARCHAR2(100) NOT NULL,							-- 수업 이름
	CLASS_CATEGORY_BIG VARCHAR2(100) NOT NULL,			-- 수업 카테고리(대)
	CLASS_CATEGORY_SMALL VARCHAR2(100) NOT NULL, 		-- 수업 카테고리(소)
	CLASS_CONTENT VARCHAR2(1000) NOT NULL,					-- 수업 내용 (썸머 노트)
	CLASS_PAYMENT_ACCOUNT NUMBER NOT NULL,					-- 결제 금액
	CLASS_REGISTER_DATE DATE DEFAULT SYSDATE,				-- 수업 등록일
	PRO_NUMBER NUMBER,															-- FK (전문가 테이블)
	CONSTRAINT FK_PRO_TO_CLASS FOREIGN KEY(PRO_NUMBER)
	REFERENCES PRO(PRO_NUMBER)
);

ALTER TABLE CLASS ADD CLASS_REGISTER_DATE DATE DEFAULT SYSDATE;

-- 수업 찜 테이블
CREATE TABLE CLASS_SAVE(
	CLASS_NUMBER NUMBER,								-- FK (수업 테이블)
	PARENT_NUMBER NUMBER NOT NULL,			-- FK (부모 테이블), NOT NULL 제약조건 추가
	CONSTRAINT FK_CLASS_TO_SAVE FOREIGN KEY(CLASS_NUMBER)
	REFERENCES CLASS(CLASS_NUMBER),
	CONSTRAINT FK_PARENT_TO_SAVE FOREIGN KEY(PARENT_NUMBER)
	REFERENCES PARENT(PARENT_NUMBER)
);

-- 수업 리뷰 테이블 
CREATE TABLE REVIEW(
	REVIEW_NUMBER NUMBER PRIMARY KEY,			-- PK
	REVIEW_CONTENT VARCHAR2(1000) NOT NULL,		-- 리뷰 내용
	REVIEW_EVALUTION_POINT NUMBER NOT NULL,		-- 리뷰 별점
	REVIEW_REGISTER_DATE DATE DEFAULT SYSDATE,	-- 등록일
	REVIEW_UPDATE_DATE DATE DEFAULT SYSDATE,	-- 수정일
	PARENT_NUMBER NUMBER,						-- FK (부모 테이블)
	CLASS_NUMBER NUMBER,						-- FK (수업 테이블)
	CONSTRAINT FK_PARENT_TO_REVIEW FOREIGN KEY(PARENT_NUMBER)
	REFERENCES PARENT(PARENT_NUMBER),
	CONSTRAINT FK_CLASS_TO_REVIEW FOREIGN KEY(CLASS_NUMBER)
	REFERENCES CLASS(CLASS_NUMBER)
);

-- 이미지 테이블
CREATE TABLE IMG(
	IMAGE_NUMBER NUMBER PRIMARY KEY,			-- PK
	IMAGE_FILE_URL VARCHAR2(500) NOT NULL,		-- 이미지 파일 경로
	CLASS_NUMBER NUMBER,						-- FK (수업 테이블)
	CONSTRAINT FK_CLASS_TO_IMG FOREIGN KEY(CLASS_NUMBER)
	REFERENCES CLASS(CLASS_NUMBER)
);

-- 예약 날짜 테이블 
CREATE TABLE RESERVATION_DATE(
	RESERVATION_DATE_NUMBER NUMBER PRIMARY KEY,		-- PK
	RESERVATION_DATE DATE DEFAULT SYSDATE,			-- 예약 날짜
	CLASS_NUMBER NUMBER,							-- FK (수업 테이블)
	CONSTRAINT FK_CLASS_TO_RESERVATION_DATE FOREIGN KEY(CLASS_NUMBER)
	REFERENCES CLASS(CLASS_NUMBER)
);

-- 예약 시간 테이블
CREATE TABLE RESERVATION_TIME(
	RESERVATION_TIME_NUMBER NUMBER PRIMARY KEY,		-- PK 
	RESERVATION_TIME DATE DEFAULT SYSDATE,			-- 예약 시간
	RESERVATION_DATE_NUMBER NUMBER,					-- FK (예약 날짜 테이블)
	CONSTRAINT FK_DATE_TO_TIME FOREIGN KEY(RESERVATION_DATE_NUMBER)
	REFERENCES RESERVATION_DATE(RESERVATION_DATE_NUMBER)
);

-- 예약 내역 (결제 내역) 테이블
CREATE TABLE RESERVATION(
	RESERVATION_DATE_NUMBER NUMBER,					-- FK (예약 날짜 테이블)
	RESERVATION_TIME_NUMBER NUMBER,					-- FK (예약 시간 테이블)
	PARENT_NUMBER NUMBER,							-- FK (부모 테이블)
	CHILD_NUMBER NUMBER,							-- FK (아이 테이블)
	CONSTRAINT FK_DATE_TO_RESERVATION FOREIGN KEY(RESERVATION_DATE_NUMBER)
	REFERENCES RESERVATION_DATE(RESERVATION_DATE_NUMBER),
	CONSTRAINT FK_TIME_TO_RESERVATION FOREIGN KEY(RESERVATION_TIME_NUMBER)
	REFERENCES RESERVATION_TIME(RESERVATION_TIME_NUMBER),
	CONSTRAINT FK_PARENT_TO_RESERVATION FOREIGN KEY(PARENT_NUMBER)
	REFERENCES PARENT(PARENT_NUMBER),
	CONSTRAINT FK_CHILD_TO_RESERVATION FOREIGN KEY(CHILD_NUMBER)
	REFERENCES CHILD(CHILD_NUMBER)
);

-- 문의하기 테이블
CREATE TABLE QUESTION(
	QUESTION_NUMBER NUMBER PRIMARY KEY,				-- PK
	QUESTION_TITLE VARCHAR2(100) NOT NULL,			-- 문의하기 제목
	QUESTION_CONTENT VARCHAR2(1000) NOT NULL,		-- 문의하기 내용
	QUESTION_REGISTER_DATE DATE NOT NULL,			-- 등록일
	QUESTION_READING_CHECK VARCHAR2(50) NOT NULL,	-- 문의하기 게시글 열람 가능 여부 
	QUESTION_STATUS VARCHAR2(50) NOT NULL,			-- 문의하기 상태 (미완, 완료)
	PARENT_NUMBER NUMBER,							-- FK (부모 테이블)
	CONSTRAINT FK_PARENT_TO_QUESTION FOREIGN KEY(PARENT_NUMBER)
	REFERENCES PARENT(PARENT_NUMBER)
);

-- 문의 답변하기 테이블
CREATE TABLE ANSWER (
	ANSWER_NUMBER NUMBER PRIMARY KEY,				-- PK
	ANSWER_CONTENT VARCHAR2(1000) NOT NULL,			-- 답변 내용
	QUESTION_NUMBER NUMBER,							-- FK (문의하기 테이블)
	CONSTRAINT FK_QUESTION_TO_ANSWER FOREIGN KEY(QUESTION_NUMBER)
	REFERENCES QUESTION(QUESTION_NUMBER)
);

-- 시퀀스 생성
CREATE SEQUENCE SEQ_PROJECT
START WITH 1
INCREMENT BY 1
NOCACHE;

-- 시퀀스 삭제
DROP SEQUENCE SEQ_PROJECT;


-- 테이블 조회
SELECT * FROM PARENT;
SELECT * FROM CHILD;
SELECT * FROM PARENT_POST;
SELECT * FROM PARENT_COMMENT;
SELECT * FROM PARENT_FILE;
SELECT * FROM PARENT_REPORT;
SELECT * FROM PARENT_NOTE;
SELECT * FROM PRO;
SELECT * FROM PRO_POST;
SELECT * FROM PRO_COMMENT;
SELECT * FROM PRO_FILE;
SELECT * FROM PRO_REPORT;
SELECT * FROM CLASS;
SELECT * FROM CLASS_SAVE;
SELECT * FROM REVIEW;
SELECT * FROM IMG;
SELECT * FROM RESERVATION;
SELECT * FROM RESERVATION_DATE;
SELECT * FROM RESERVATION_TIME;
SELECT * FROM QUESTION;
SELECT * FROM ANSWER;

-- 모든 테이블 INSERT 쿼리문
INSERT INTO PARENT
(PARENT_NUMBER, PARENT_EMAIL, PARENT_PASSWORD, PARENT_NAME, PARENT_NICKNAME, PARENT_PHONE_NUMBER, PARENT_ADDRESS, PARENT_PROFILE_IMAGE_URL, PARENT_REPORT_COUNT)
VALUES(0, '', '', '', '', '', '', '', 0);

INSERT INTO CHILD
(CHILD_NUMBER, CHILD_NAME, CHILD_AGE, CHILD_GENDER, CHILD_SPECIAL_ISSUES, PARENT_NUMBER)
VALUES(0, '', 0, '', '', 0);

INSERT INTO PARENT_POST
(PARENT_POST_NUMBER, PARENT_POST_TITLE, PARENT_POST_CONTENT, PARENT_POST_VIEWS, PARENT_POST_REGISTER_DATE, PARENT_POST_UPDATE_DATE, PARENT_NUMBER)
VALUES(0, '', '', 0, '', '', 0);

INSERT INTO PARENT_COMMENT
(PARENT_COMMENT_NUMBER, PARENT_COMMENT_CONTENT, PARENT_COMMENT_REGISTER_DATE, PARENT_COMMENT_UPDATE_DATE, PARENT_NUMBER, PARENT_POST_NUMBER)
VALUES(0, '', '', '', 0, 0);

INSERT INTO PARENT_FILE
(PARENT_FILE_NUMBER, PARENT_FILE_NAME, PARENT_FILE_SIZE, PARENT_FILE_UPLOAD_TIME, PARENT_POST_NUMBER)
VALUES(0, '', 0, '', 0);

INSERT INTO PARENT_REPORT
(PARENT_REPORT_NUMBER, PARENT_REPORT_TYPE, PARENT_REPORT_CONTENT, PARENT_REPORT_REGISTER_DATE, PARENT_POST_NUMBER)
VALUES(0, '', '', '', 0);

INSERT INTO PARENT_NOTE
(PARENT_NOTE_NUMBER, PARENT_NOTE_CONTENT, PARENT_NOTE_SEND_TIME, PARENT_NOTE_ALARM_CHECK, PARENT_NUMBER, PRO_NUMBER)
VALUES(0, '', '', '', 0, 0);

INSERT INTO PRO
(PRO_NUMBER, PRO_EMAIL, PRO_PASSWORD, PRO_NAME, PRO_NICKNAME, PRO_PHONE_NUMBER, PRO_ADDRESS, PARENT_PROFILE_IMAGE_URL, PRO_FILE, PRO_INTRO)
VALUES(0, '', '', '', '', '', '', '', '', '');

INSERT INTO PRO_POST
(PRO_POST_NUMBER, PRO_POST_TITLE, PRO_POST_CONTENT, PRO_POST_VIEWS, PRO_POST_REGISTER_DATE, PRO_POST_UPDATE_DATE, PRO_NUMBER)
VALUES(0, '', '', 0, '', '', 0);

INSERT INTO PRO_COMMENT
(PRO_COMMENT_NUMBER, PRO_COMMENT_CONTENT, PRO_COMMENT_REGISTER_DATE, PRO_COMMENT_UPDATE_DATE, PRO_POST_NUMBER, PRO_NUMBER)
VALUES(0, '', '', '', 0, 0);

INSERT INTO PRO_FILE
(PRO_FILE_NUMBER, PRO_FILE_NAME, PRO_FILE_URL, PRO_FILE_SIZE, PRO_FILE_UPLOAD_TIME, PRO_POST_NUMBER)
VALUES(0, '', '', 0, '', 0);

INSERT INTO PRO_REPORT
(PRO_REPORT_NUMBER, PRO_REPORT_TYPE, PRO_REPORT_CONTENT, PRO_REPORT_REGISTER_DATE, PRO_POST_NUMBER)
VALUES(0, '', '', '', 0);

INSERT INTO CLASS
(CLASS_NUMBER, CLASS_NAME, CLASS_CATEGORY_BIG, CLASS_CATEGORY_SMALL, CLASS_CONTENT, CLASS_PAYMENT_ACCOUNT, PRO_NUMBER)
VALUES(0, '', '', '', '', 0, 0);

INSERT INTO CLASS_SAVE
(CLASS_NUMBER, PARENT_NUMBER)
VALUES(0, 0);

INSERT INTO REVIEW
(REVIEW_NUMBER, REVIEW_CONTENT, REVIEW_EVALUTION_POINT, REVIEW_REGISTER_DATE, REVIEW_UPDATE_DATE, PARENT_NUMBER, CLASS_NUMBER)
VALUES(0, '', 0, '', '', 0, 0);

INSERT INTO IMG
(IMAGE_NUMBER, IMAGE_FILE_URL, CLASS_NUMBER)
VALUES(0, '', 0);

INSERT INTO RESERVATION
(RESERVATION_DATE_NUMBER, RESERVATION_TIME_NUMBER, PARENT_NUMBER, CHILD_NUMBER)
VALUES(0, 0, 0, 0);

INSERT INTO RESERVATION_DATE
(RESERVATION_DATE_NUMBER, RESERVATION_DATE, CLASS_NUMBER)
VALUES(0, '', 0);

INSERT INTO RESERVATION_TIME
(RESERVATION_TIME_NUMBER, RESERVATION_TIME, RESERVATION_DATE_NUMBER)
VALUES(0, '', 0);

INSERT INTO QUESTION
(QUESTION_NUMBER, QUESTION_TITLE, QUESTION_CONTENT, QUESTION_REGISTER_DATE, QUESTION_READING_CHECK, QUESTION_STATUS, PARENT_NUMBER)
VALUES(0, '', '', '', '', '', 0);

INSERT INTO ANSWER
(ANSWER_NUMBER, ANSWER_CONTENT, QUESTION_NUMBER)
VALUES(0, '', 0);

SELECT * FROM USER_SEQUENCES;

SELECT *
FROM class_save cv
         JOIN class cl ON cv.class_number = cl.class_number
         JOIN img it ON it.class_number = cv.class_number
WHERE cv.parent_number = 4;


SELECT
    rd.reservation_date,
    cv.class_number,
    cv.class_name,
    cv.class_payment_account,
FROM
    reservation rv
        JOIN
    reservation_date rd ON rv.reservation_date_number = rd.reservation_date_number
        JOIN
    class cv ON rd.class_number = cv.class_number
WHERE
    rv.parentNumber = #{parentNumber}


















