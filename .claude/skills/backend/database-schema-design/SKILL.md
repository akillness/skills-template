---
name: database-schema-design
description: Design and optimize database schemas for SQL and NoSQL databases. Use when creating new databases, designing tables, defining relationships, indexing strategies, or database migrations. Handles PostgreSQL, MySQL, MongoDB, normalization, and performance optimization.
tags: [database, schema, SQL, NoSQL, PostgreSQL, MySQL, MongoDB, migration]
platforms: [Claude, ChatGPT, Gemini]
---

# Database Schema Design

## 목적 (Purpose)

효율적이고 확장 가능한 데이터베이스 스키마를 설계하고 최적화합니다.

이 스킬은 다음을 도와줍니다:
- 정규화/비정규화된 스키마 설계
- 관계형 및 NoSQL 데이터베이스 모델링
- 인덱스 전략 수립
- 마이그레이션 스크립트 작성
- 성능 최적화

## 사용 시점 (When to Use)

이 스킬을 트리거해야 하는 구체적인 상황을 나열합니다:

- **신규 프로젝트**: 새 애플리케이션의 데이터베이스 스키마 설계
- **스키마 리팩토링**: 기존 스키마를 성능이나 확장성을 위해 재설계
- **관계 정의**: 테이블 간 1:1, 1:N, N:M 관계 구현
- **마이그레이션**: 스키마 변경사항을 안전하게 적용
- **성능 문제**: 느린 쿼리를 해결하기 위한 인덱스 및 스키마 최적화

## 입력 형식 (Input Format)

사용자로부터 받아야 할 입력의 형식과 필수/선택 정보입니다. 구체적인 예시는 [EXAMPLES.md](./EXAMPLES.md)를 참고하세요.

### 필수 정보
- **데이터베이스 종류**: PostgreSQL, MySQL, MongoDB, SQLite 등
- **도메인 설명**: 어떤 데이터를 저장할 것인지 (예: 전자상거래, 블로그, SNS)
- **주요 엔티티**: 핵심 데이터 객체들 (예: User, Product, Order)

### 선택 정보
- **예상 데이터량**: 작음(<10K rows), 중간(10K-1M), 대용량(>1M) (기본값: 중간)
- **읽기/쓰기 비율**: Read-heavy, Write-heavy, Balanced (기본값: Balanced)
- **트랜잭션 요구사항**: ACID 필요 여부 (기본값: true)
- **샤딩/파티셔닝**: 대용량 데이터 분산 필요 여부 (기본값: false)

## 작업 절차 (Procedure)

단계별로 정확하게 따라야 할 작업 순서입니다. 각 단계별 코드 예제는 [EXAMPLES.md](./EXAMPLES.md)를 참고하세요.

### 1단계: 엔티티 및 속성 정의

핵심 데이터 객체와 그 속성을 식별합니다.

**작업 내용**:
- 비즈니스 요구사항에서 명사 추출 → 엔티티
- 각 엔티티의 속성(칼럼) 나열
- 데이터 타입 결정 (VARCHAR, INTEGER, TIMESTAMP, JSON 등)
- Primary Key 지정 (UUID vs Auto-increment ID)

👉 **상세 코드**: [EXAMPLES.md > Entity Definition Example](./EXAMPLES.md#1-entity-definition-example-e-commerce)

### 2단계: 관계 설계 및 정규화

테이블 간의 관계를 정의하고 정규화를 적용합니다.

**작업 내용**:
- 1:1 관계: Foreign Key + UNIQUE 제약
- 1:N 관계: Foreign Key
- N:M 관계: 중간(Junction) 테이블 생성
- 정규화 레벨 결정 (1NF ~ 3NF)

**판단 기준**:
- OLTP 시스템 → 3NF까지 정규화 (데이터 무결성)
- OLAP/분석 시스템 → 비정규화 허용 (쿼리 성능)
- 읽기 중심 → 일부 비정규화로 JOIN 최소화
- 쓰기 중심 → 완전 정규화로 중복 제거

👉 **상세 코드**: [EXAMPLES.md > Relationship & Normalization](./EXAMPLES.md#2-relationship--normalization-mermaid-erd)

### 3단계: 인덱스 전략 수립

쿼리 성능을 위한 인덱스를 설계합니다.

**작업 내용**:
- Primary Key는 자동으로 인덱스 생성됨
- WHERE 절에 자주 사용되는 칼럼 → 인덱스 추가
- JOIN에 사용되는 Foreign Key → 인덱스
- 복합 인덱스 고려 (WHERE col1 = ? AND col2 = ?)
- UNIQUE 인덱스 (email, username 등)

**확인 사항**:
- [x] 자주 조회되는 칼럼에 인덱스
- [x] Foreign Key 칼럼에 인덱스
- [x] 복합 인덱스 순서 최적화 (선택도 높은 칼럼 먼저)
- [x] 과도한 인덱스 지양 (INSERT/UPDATE 성능 저하)

👉 **상세 코드**: [EXAMPLES.md > Index Strategy](./EXAMPLES.md#3-index-strategy-postgresql)

### 4단계: 제약조건 및 트리거 설정

데이터 무결성을 위한 제약조건을 추가합니다.

**작업 내용**:
- NOT NULL: 필수 칼럼
- UNIQUE: 중복 불가 칼럼
- CHECK: 값 범위 제한 (예: price >= 0)
- Foreign Key + CASCADE 옵션
- Default 값 설정

👉 **상세 코드**: [EXAMPLES.md > Constraints & Triggers](./EXAMPLES.md#4-constraints--triggers)

### 5단계: 마이그레이션 스크립트 작성

스키마 변경사항을 안전하게 적용하는 마이그레이션을 작성합니다.

**작업 내용**:
- UP 마이그레이션: 변경 적용
- DOWN 마이그레이션: 롤백
- 트랜잭션으로 래핑
- 데이터 손실 방지 (ALTER TABLE 신중히)

👉 **상세 코드**: [EXAMPLES.md > Migration Scripts](./EXAMPLES.md#5-migration-scripts)

## 출력 포맷 (Output Format)

결과물이 따라야 할 정확한 형식을 정의합니다. 구체적인 예시는 [EXAMPLES.md](./EXAMPLES.md)를 참고하세요.

### 기본 구조
프로젝트 루트 내 `database/` 디렉토리에 스키마, 마이그레이션, 시드 데이터, 문서를 포함하는 구조여야 합니다.

### 문서화
- **ERD**: Mermaid 형식을 사용하여 관계 시각화
- **스키마 설명**: 각 테이블의 목적, 인덱스 정보, 예상 데이터량 명시

## 제약사항 (Constraints)

반드시 지켜야 할 규칙과 금지 사항입니다.

### 필수 규칙 (MUST)

1. **Primary Key 필수**: 모든 테이블에 Primary Key 정의
   - 레코드 고유 식별
   - 참조 무결성 보장

2. **Foreign Key 명시**: 관계가 있는 테이블은 반드시 Foreign Key 설정
   - ON DELETE CASCADE/SET NULL 옵션 명시
   - Orphan 레코드 방지

3. **NOT NULL 적절히 사용**: 필수 칼럼은 NOT NULL
   - NULL 허용 여부 명확히
   - 기본값 제공 권장

### 금지 사항 (MUST NOT)

1. **EAV 패턴 남용**: Entity-Attribute-Value 패턴은 특별한 경우에만
   - 쿼리 복잡도 급증
   - 성능 저하

2. **과도한 비정규화**: 성능을 위한 비정규화는 신중히
   - 데이터 일관성 문제
   - 업데이트 이상 발생 위험

3. **민감정보 평문 저장**: 비밀번호, 카드번호 등은 절대 평문 저장 금지
   - 해싱/암호화 필수
   - 법적 책임 문제

### 보안 규칙

- **최소 권한 원칙**: 애플리케이션 DB 계정은 필요한 권한만 부여
- **SQL Injection 방지**: Prepared Statements/Parameterized Queries 사용
- **민감 칼럼 암호화**: 개인정보는 암호화 저장 고려

## 메타데이터

### 버전
- **현재 버전**: 1.0.0
- **최종 업데이트**: 2025-01-01
- **호환 플랫폼**: Claude, ChatGPT, Gemini

### 관련 스킬
- [api-design](../api-design/SKILL.md): API와 함께 스키마 설계
- [performance-optimization](../../code-quality/performance-optimization/SKILL.md): 쿼리 성능 최적화

### 태그
`#database` `#schema` `#PostgreSQL` `#MySQL` `#MongoDB` `#SQL` `#NoSQL` `#migration` `#ERD`
