# database-schema-design

> Design and optimize database schemas for SQL and NoSQL databases. Use when creating new databases, designing tables, defining relationships, indexi...

## When to use this skill
이 스킬을 트리거해야 하는 구체적인 상황을 나열합니다:
• **신규 프로젝트**: 새 애플리케이션의 데이터베이스 스키마 설계
• **스키마 리팩토링**: 기존 스키마를 성능이나 확장성을 위해 재설계
• **관계 정의**: 테이블 간 1:1, 1:N, N:M 관계 구현
• **마이그레이션**: 스키마 변경사항을 안전하게 적용
• **성능 문제**: 느린 쿼리를 해결하기 위한 인덱스 및 스키마 최적화

## Instructions
단계별로 정확하게 따라야 할 작업 순서를 명시합니다.
▶ S1: 엔티티 및 속성 정의
핵심 데이터 객체와 그 속성을 식별합니다.
**작업 내용**:
• 비즈니스 요구사항에서 명사 추출 → 엔티티
• 각 엔티티의 속성(칼럼) 나열
• 데이터 타입 결정 (VARCHAR, INTEGER, TIMESTAMP, JSON 등)
• Primary Key 지정 (UUID vs Auto-increment ID)
**예시** (전자상거래):
▶ S2: 관계 설계 및 정규화
테이블 간의 관계를 정의하고 정규화를 적용합니다.
**작업 내용**:
• 1:1 관계: Foreign Key + UNIQUE 제약
• 1:N 관계: Foreign Key
• N:M 관계: 중간(Junction) 테이블 생성
• 정규화 레벨 결정 (1NF ~ 3NF)
**판단 기준**:
• OLTP 시스템 → 3NF까지 정규화 (데이터 무결성)
• OLAP/분석 시스템 → 비정규화 허용 (쿼리 성능)
• 읽기 중심 → 일부 비정규화로 JOIN 최소화
• 쓰기 중심 → 완전 정규화로 중복 제거
**예시** (ERD Mermaid):
▶ S3: 인덱스 전략 수립
쿼리 성능을 위한 인덱스를 설계합니다.
**작업 내용**:
• Primary Key는 자동으로 인덱스 생성됨
• WHERE 절에 자주 사용되는 칼럼 → 인덱스 추가
• JOIN에 사용되는 Foreign Key → 인덱스
• 복합 인덱스 고려 (WHERE col1 = ? AND col2 = ?)
• UNIQUE 인덱스 (email, username 등)
**확인 사항**:
• [x] 자주 조회되는 칼럼에 인덱스
• [x] Foreign Key 칼럼에 인덱스
• [x] 복합 인덱스 순서 최적화 (선택도 높은 칼럼 먼저)
• [x] 과도한 인덱스 지양 (INSERT/UPDATE 성능 저하)
**예시** (PostgreSQL):
▶ S4: 제약조건 및 트리거 설정
데이터 무결성을 위한 제약조건을 추가합니다.
**작업 내용**:
• NOT NULL: 필수 칼럼
• UNIQUE: 중복 불가 칼럼
• CHECK: 값 범위 제한 (예: price >= 0)
• Foreign Key + CASCADE 옵션
• Default 값 설정
**예시**:
▶ S5: 마이그레이션 스크립트 작성
스키마 변경사항을 안전하게 적용하는 마이그레이션을 작성합니다.
**작업 내용**:
• UP 마이그레이션: 변경 적용
• DOWN 마이그레이션: 롤백
• 트랜잭션으로 래핑
• 데이터 손실 방지 (ALTER TABLE 신중히)
**예시** (SQL 마이그레이션):

## Best practices
1. 명명 규칙 일관성
2. Soft Delete 고려
3. Timestamp 필수
