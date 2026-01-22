---
name: cs-tool-dashboard
description: Supercent CS Tool 대시보드 개발 - FAQ 시스템, 티켓 관리, Firebase 기반 인프라
globs: ["src/**/*.ts", "src/**/*.tsx", "functions/**/*.ts"]
alwaysApply: false
---

# CS Tool Dashboard Development Guide

## Project Overview
게임 클라이언트 → FAQ 페이지 → 문의 폼 → 관리자 대시보드 흐름의 CS 시스템

## Tech Stack
- **Frontend**: React/Next.js + TypeScript + Tailwind CSS
- **Backend**: Firebase Cloud Functions (Node.js)
- **Database**: Firestore
- **Auth**: Firebase Authentication
- **Storage**: Firebase Storage (첨부파일)
- **Email**: SendGrid 또는 Firebase Extensions

## Core Features

### 1. User Side - FAQ Page
- 게임별 FAQ 검색/필터링
- 카테고리 탭 (수평 스크롤)
- 검색 결과 하이라이트
- 문의 페이지 연결

### 2. User Side - Contact Form
- 계층형 카테고리 드롭다운 (최대 3단계)
- 필수 필드: 이메일, OS, 게임버전, 카테고리, 설명
- 첨부파일 업로드 (이미지/영상, 5MB 제한)
- 개인정보처리방침 동의

### 3. Admin Side - Dashboard
- 티켓 리스트 (필터, 정렬, 페이지네이션)
- 티켓 상세 (3-column 레이아웃)
- 답변 작성 및 이메일 발송
- 티켓 상태 관리 (pending → in_progress → resolved → closed)
- 실시간 업데이트 (onSnapshot)

## Data Models

### FAQ Collection
```typescript
interface FAQItem {
  id: string;
  gameId: string;
  category: string;
  question: string;
  answer: string;
  keywords: string[];
  order: number;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

### Ticket Collection
```typescript
interface Ticket {
  id: string;
  gameId: string;
  email: string;
  os: 'iOS' | 'Android';
  gameVersion: string;
  category: string;
  subCategory: string;
  subSubCategory?: string;
  description: string;
  attachments: string[];
  status: 'pending' | 'in_progress' | 'resolved' | 'closed';
  priority: 'low' | 'medium' | 'high';
  assignee: string | null;
  createdAt: Timestamp;
  updatedAt: Timestamp;
  history: TicketHistory[];
}
```

## Category Hierarchy
```typescript
const categories = {
  account: {
    label: '계정',
    subCategories: {
      save: '계정 저장',
      profile: '프로필 세부 정보 변경',
      appeal: '차단/정지 이의제기'
    }
  },
  account_recovery: {
    label: '계정 복구',
    subCategories: {
      restore: '계정을 복구하려 합니다',
      security: '계정의 보안 문제/해킹'
    }
  },
  player_report: {
    label: '플레이어 신고',
    subCategories: {
      cheating: '부정행위',
      harassment: '부적절한 언행/괴롭힘',
      inappropriate_name: '부적절한 사용자 이름'
    }
  },
  billing: {
    label: '청구 및 결제',
    subCategories: {
      gem_purchase: '보석/코인 구매',
      real_purchase: '실제 구매',
      refund: '환불',
      subscription: '구독 관련 문제'
    }
  },
  bug_report: {
    label: '버그 신고',
    subCategories: {
      ads: '광고',
      events: '이벤트',
      characters: '캐릭터',
      chat: '채팅',
      items: '아이템/무기/업그레이드'
    }
  },
  technical: {
    label: '기술 문제',
    subCategories: {
      crash: '크래시 또는 끊김',
      lag: '렉 현상 또는 연결 해제'
    },
    // 3단계: 빈도
    frequency: ['단 한 번', '가끔', '자주', '항상']
  }
};
```

## Folder Structure
```
cs-tool-dashboard/
├── apps/
│   ├── web/                 # FAQ + 문의 폼 (Next.js)
│   └── admin/               # 관리자 대시보드 (Next.js)
├── packages/
│   ├── ui/                  # 공통 컴포넌트
│   ├── firebase-config/     # Firebase 설정
│   └── types/               # 공유 타입
├── functions/               # Cloud Functions
└── firebase.json
```

## Instructions

### When developing FAQ page:
1. gameId로 FAQ 필터링 구현
2. 검색은 keywords 배열 + question 필드 대상
3. 카테고리 탭은 동적으로 Firestore에서 로드
4. 모바일 우선 반응형 디자인

### When developing Contact form:
1. react-hook-form + zod로 유효성 검증
2. 카테고리 선택시 하위 카테고리 동적 렌더링
3. 파일 업로드는 Firebase Storage, 5MB 제한
4. 제출 시 Cloud Function 호출 → Firestore 저장

### When developing Admin dashboard:
1. Firebase Auth로 관리자 인증 (role: 'admin')
2. onSnapshot으로 실시간 티켓 리스트 동기화
3. 답변 전송 시 SendGrid로 이메일 발송
4. 티켓 상태 변경 시 history 배열에 기록

## Constraints
- TypeScript 필수
- Firebase SDK v9+ (modular syntax)
- 한국어 주석, 영어 코드
- 30+ 게임 지원 (gameId로 분기)
- 확장성 고려한 설계