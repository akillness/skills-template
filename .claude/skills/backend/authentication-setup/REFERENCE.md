# Authentication Setup Reference

## 베스트 프랙티스 (Best Practices)

1. **Password Rotation Policy**: 주기적인 비밀번호 변경 권장
   - 90일마다 변경 알림
   - 이전 5개 비밀번호 재사용 방지

2. **Multi-Factor Authentication (MFA)**: 중요 계정에 2FA 적용
   - Google Authenticator, Authy 등 TOTP 앱 사용
   - Backup codes 제공

3. **Audit Logging**: 모든 인증 이벤트 로깅
   - 로그인 성공/실패, IP 주소 기록
   - 이상 탐지 및 사후 분석

## 자주 발생하는 문제 (Common Issues)

### 문제 1: "JsonWebTokenError: invalid signature"

**증상**: 토큰 검증 시 에러 발생

**원인**: Access Token과 Refresh Token의 SECRET 키가 다른데, 같은 키로 검증 시도

**해결방법**: 
- 환경변수 확인: `ACCESS_TOKEN_SECRET`, `REFRESH_TOKEN_SECRET`
- 각 토큰 타입에 맞는 SECRET 사용

### 문제 2: CORS 에러로 프론트엔드에서 로그인 불가

**증상**: 브라우저 콘솔에 "CORS policy" 에러

**해결방법**:
```typescript
import cors from 'cors';
app.use(cors({
    origin: process.env.FRONTEND_URL,
    credentials: true
}));
```

## 참고 자료 (References)

- [JWT.io - JSON Web Token Introduction](https://jwt.io/introduction)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [OAuth 2.0 RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
- [bcrypt (Node.js)](https://github.com/kelektiv/node.bcrypt.js)
