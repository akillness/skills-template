# References for Database Schema Design

## 베스트 프랙티스 (Best Practices)

### 품질 향상

1. **명명 규칙 일관성**: 테이블/칼럼 이름은 snake_case 사용을 권장합니다.
   - 예: `users`, `post_tags`, `created_at`
   - 테이블명은 복수형(`users`), 칼럼명은 단수형(`user_id`)과 같이 일관성을 유지하세요.

2. **Soft Delete 고려**: 중요 데이터는 물리적 삭제(DELETE) 대신 논리적 삭제(Soft Delete)를 고려하세요.
   - `deleted_at` TIMESTAMP 칼럼 추가 (NULL이면 활성, 값이 있으면 삭제됨)
   - 실수로 인한 데이터 삭제 복구 가능
   - 감사(Audit) 추적 용이

3. **Timestamp 필수**: `created_at`, `updated_at`은 거의 모든 테이블에 포함하는 것이 좋습니다.
   - 데이터 생성 및 수정 시점 추적
   - 디버깅 및 시계열 분석에 유용

### 효율성 개선

- **Partial Indexes**: 모든 행에 인덱스를 걸지 않고, 특정 조건(예: `active = true` 또는 `published_at IS NOT NULL`)에 맞는 행에만 인덱스를 생성하여 크기를 최소화하고 성능을 높입니다.
- **Materialized Views**: 복잡하고 비용이 많이 드는 집계 쿼리 결과는 Materialized View로 캐싱하여 조회 성능을 높일 수 있습니다.
- **Partitioning**: 수억 건 이상의 대용량 테이블은 날짜나 범위를 기준으로 파티셔닝하여 관리 효율성과 쿼리 성능을 개선하세요.

## 자주 발생하는 문제 (Common Issues)

### 문제 1: N+1 쿼리 문제
**증상**: 하나의 목록을 조회하는 데 필요한 쿼리가 데이터 개수(N)만큼 추가로 발생하여 성능이 급격히 저하됨.
**원인**: ORM 사용 시 연관 데이터를 `JOIN`이나 `Eager Loading` 없이 반복문 안에서 개별적으로 조회할 때 발생.
**해결**: `JOIN`을 사용하여 한 번의 쿼리로 데이터를 가져오거나, ORM의 `include`/`prefetch` 기능을 사용합니다.

### 문제 2: 인덱스 없는 Foreign Key로 인한 느린 JOIN
**증상**: 두 테이블을 JOIN하는 쿼리가 매우 느리게 실행됨.
**원인**: 참조되는 Foreign Key 칼럼에 인덱스가 없어 Full Table Scan이 발생.
**해결**: JOIN 조건이나 WHERE 절에 사용되는 모든 Foreign Key 칼럼에 명시적으로 인덱스를 생성합니다.

### 문제 3: UUID vs Auto-increment 성능
**증상**: 랜덤 UUID를 Primary Key로 사용할 때 데이터가 많아질수록 INSERT 성능이 저하됨.
**원인**: 랜덤 UUID는 정렬되어 있지 않아 B-Tree 인덱스의 잦은 페이지 분할(Page Split)과 랜덤 I/O를 유발함.
**해결**:
- PostgreSQL: `uuid_generate_v7()`과 같이 시간 순서가 포함된 UUID(v7) 사용.
- MySQL: `UUID_TO_BIN(UUID(), 1)` 등으로 순차적 저장 유도.
- 또는 내부적으로는 Auto-increment BIGINT를 사용하고 외부 노출용으로만 UUID 사용.

## 참고 자료 (References)

### 공식 문서
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MongoDB Schema Design Best Practices](https://www.mongodb.com/docs/manual/core/data-modeling-introduction/)

### 도구
- [dbdiagram.io](https://dbdiagram.io/) - 온라인 ERD 다이어그램 작성 도구
- [PgModeler](https://pgmodeler.io/) - PostgreSQL 전문 모델링 도구
- [Prisma](https://www.prisma.io/) - Node.js/TypeScript용 차세대 ORM 및 마이그레이션 도구

### 학습 자료
- [Database Design Course (freecodecamp)](https://www.youtube.com/watch?v=ztHopE5Wnpc) - 데이터베이스 설계 기초 강좌
- [Use The Index, Luke](https://use-the-index-luke.com/) - 개발자를 위한 SQL 인덱싱 및 성능 최적화 가이드
