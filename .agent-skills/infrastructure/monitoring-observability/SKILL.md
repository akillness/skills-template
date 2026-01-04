---
name: monitoring-observability
description: Set up monitoring, logging, and observability for applications and infrastructure. Use when implementing health checks, metrics collection, log aggregation, or alerting systems. Handles Prometheus, Grafana, ELK Stack, Datadog, and monitoring best practices.
tags: [monitoring, observability, logging, metrics, Prometheus, Grafana, alerts]
platforms: [Claude, ChatGPT, Gemini]
---

# Monitoring & Observability

## 목적 (Purpose)

애플리케이션 및 인프라의 상태를 실시간으로 모니터링하고 문제를 조기에 발견합니다.

이 스킬은 다음을 도와줍니다:
- 메트릭 수집 (Prometheus, CloudWatch)
- 로그 집계 (ELK, Loki)
- 대시보드 구축 (Grafana)
- 알림 설정 (PagerDuty, Slack)
- 분산 추적 (Jaeger, Zipkin)

## 사용 시점 (When to Use)

- **프로덕션 배포 전**: 모니터링 시스템 필수 구축
- **성능 문제 발생**: 병목 지점 식별
- **장애 대응**: 빠른 원인 파악
- **SLA 준수**: 가용성/응답시간 추적

## 작업 절차 (Procedure)

### 1단계: 메트릭 수집 (Prometheus)

**애플리케이션 계측** (Node.js):
```typescript
import express from 'express';
import promClient from 'prom-client';

const app = express();

// Default metrics (CPU, Memory, etc.)
promClient.collectDefaultMetrics();

// Custom metrics
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

const httpRequestTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Middleware to track requests
app.use((req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    const labels = {
      method: req.method,
      route: req.route?.path || req.path,
      status_code: res.statusCode
    };

    httpRequestDuration.observe(labels, duration);
    httpRequestTotal.inc(labels);
  });

  next();
});

// Metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
});

app.listen(3000);
```

**prometheus.yml**:
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['localhost:3000']
    metrics_path: '/metrics'

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['localhost:9093']

rule_files:
  - 'alert_rules.yml'
```

### 2단계: 알림 규칙

**alert_rules.yml**:
```yaml
groups:
  - name: application_alerts
    interval: 30s
    rules:
      # High error rate
      - alert: HighErrorRate
        expr: |
          (
            sum(rate(http_requests_total{status_code=~"5.."}[5m]))
            /
            sum(rate(http_requests_total[5m]))
          ) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }}% (threshold: 5%)"

      # Slow response time
      - alert: SlowResponseTime
        expr: |
          histogram_quantile(0.95,
            sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
          ) > 1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Slow response time"
          description: "95th percentile is {{ $value }}s"

      # Pod down
      - alert: PodDown
        expr: up{job="my-app"} == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Pod is down"
          description: "{{ $labels.instance }} has been down for more than 2 minutes"

      # High memory usage
      - alert: HighMemoryUsage
        expr: |
          (
            node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes
          ) / node_memory_MemTotal_bytes > 0.90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage"
          description: "Memory usage is {{ $value }}%"
```

### 3단계: 로그 집계 (Structured Logging)

**Winston (Node.js)**:
```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: {
    service: 'my-app',
    environment: process.env.NODE_ENV
  },
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      )
    }),
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error'
    }),
    new winston.transports.File({
      filename: 'logs/combined.log'
    })
  ]
});

// Usage
logger.info('User logged in', { userId: '123', ip: '1.2.3.4' });
logger.error('Database connection failed', { error: err.message, stack: err.stack });

// Express middleware
app.use((req, res, next) => {
  logger.info('HTTP Request', {
    method: req.method,
    path: req.path,
    ip: req.ip,
    userAgent: req.get('user-agent')
  });
  next();
});
```

### 4단계: Grafana 대시보드

**dashboard.json** (예시):
```json
{
  "dashboard": {
    "title": "Application Metrics",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{method}} {{route}}"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status_code=~\"5..\"}[5m])",
            "legendFormat": "Errors"
          }
        ]
      },
      {
        "title": "Response Time (p95)",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))"
          }
        ]
      },
      {
        "title": "CPU Usage",
        "type": "gauge",
        "targets": [
          {
            "expr": "rate(process_cpu_seconds_total[5m]) * 100"
          }
        ]
      }
    ]
  }
}
```

### 5단계: Health Checks

**Advanced Health Check**:
```typescript
interface HealthStatus {
  status: 'healthy' | 'degraded' | 'unhealthy';
  timestamp: string;
  uptime: number;
  checks: {
    database: { status: string; latency?: number; error?: string };
    redis: { status: string; latency?: number };
    externalApi: { status: string; latency?: number };
  };
}

app.get('/health', async (req, res) => {
  const startTime = Date.now();
  const health: HealthStatus = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    checks: {
      database: { status: 'unknown' },
      redis: { status: 'unknown' },
      externalApi: { status: 'unknown' }
    }
  };

  // Database check
  try {
    const dbStart = Date.now();
    await db.raw('SELECT 1');
    health.checks.database = {
      status: 'healthy',
      latency: Date.now() - dbStart
    };
  } catch (error) {
    health.status = 'unhealthy';
    health.checks.database = {
      status: 'unhealthy',
      error: error.message
    };
  }

  // Redis check
  try {
    const redisStart = Date.now();
    await redis.ping();
    health.checks.redis = {
      status: 'healthy',
      latency: Date.now() - redisStart
    };
  } catch (error) {
    health.status = 'degraded';
    health.checks.redis = { status: 'unhealthy' };
  }

  const statusCode = health.status === 'healthy' ? 200 : health.status === 'degraded' ? 200 : 503;
  res.status(statusCode).json(health);
});
```

## 출력 포맷 (Output Format)

### 모니터링 대시보드 구성

```
Golden Signals:
1. Latency (응답 시간)
   - P50, P95, P99 percentiles
   - API 엔드포인트별

2. Traffic (요청량)
   - Requests per second
   - 엔드포인트별, 상태 코드별

3. Errors (에러율)
   - 5xx error rate
   - 4xx error rate
   - 에러 타입별

4. Saturation (리소스 사용률)
   - CPU 사용률
   - 메모리 사용률
   - Disk I/O
   - Network bandwidth
```

## 제약사항 (Constraints)

### 필수 규칙 (MUST)

1. **Structured Logging**: JSON 형식 로그
2. **Metric Labels**: 고유성 유지 (high cardinality 주의)
3. **Alert Fatigue 방지**: 중요한 알림만

### 금지 사항 (MUST NOT)

1. **민감정보 로깅 금지**: 비밀번호, API 키 절대 로깅하지 않음
2. **과도한 메트릭**: 불필요한 메트릭은 리소스 낭비

## 베스트 프랙티스 (Best Practices)

1. **SLO 정의**: Service Level Objectives 명확히
2. **Runbook 작성**: 알림별 대응 절차 문서화
3. **Dashboards**: 팀별 필요한 대시보드 커스터마이징

## 참고 자료 (References)

- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Google SRE Book](https://sre.google/books/)

## 메타데이터

### 버전
- **현재 버전**: 1.0.0
- **최종 업데이트**: 2025-01-01
- **호환 플랫폼**: Claude, ChatGPT, Gemini

### 관련 스킬
- [deployment](../deployment/SKILL.md): 배포와 함께 모니터링
- [security](../security/SKILL.md): 보안 이벤트 모니터링

### 태그
`#monitoring` `#observability` `#Prometheus` `#Grafana` `#logging` `#metrics` `#infrastructure`
