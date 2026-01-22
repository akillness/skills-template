---
name: vercel-react-best-practices
description: React/Next.js performance optimization (45 rules, 8 categories)
---

# React Best Practices (Vercel)

## Priority Categories

| Priority | Category | Impact |
|----------|----------|--------|
| 1 | Eliminating Waterfalls | CRITICAL |
| 2 | Bundle Size | CRITICAL |
| 3 | Server-Side | HIGH |
| 4 | Client Data Fetching | MEDIUM-HIGH |
| 5 | Re-render Optimization | MEDIUM |
| 6 | Rendering Performance | MEDIUM |
| 7 | JavaScript Performance | LOW-MEDIUM |
| 8 | Advanced Patterns | LOW |

## CRITICAL Rules

### 1. Promise.all for Independent Operations
```typescript
// ❌ Sequential
const user = await fetchUser()
const posts = await fetchPosts()

// ✅ Parallel
const [user, posts] = await Promise.all([fetchUser(), fetchPosts()])
```

### 2. Avoid Barrel File Imports
```tsx
// ❌ Imports entire library
import { Check } from 'lucide-react'

// ✅ Direct import
import Check from 'lucide-react/dist/esm/icons/check'
```

### 3. Dynamic Imports for Heavy Components
```tsx
// ❌ Bundles with main chunk
import { MonacoEditor } from './monaco-editor'

// ✅ Loads on demand
const MonacoEditor = dynamic(() => import('./monaco-editor'), { ssr: false })
```

### 4. Suspense Boundaries
```tsx
// ✅ Wrapper shows immediately, data streams in
<Suspense fallback={<Skeleton />}>
  <DataDisplay />
</Suspense>
```

### 5. Minimize RSC Serialization
```tsx
// ❌ Serializes 50 fields
<Profile user={user} />

// ✅ Serializes only needed
<Profile name={user.name} />
```

## HIGH Rules

### 6. React.cache() for Deduplication
```typescript
export const getCurrentUser = cache(async () => {
  return await db.user.findUnique({ where: { id: session.user.id } })
})
```

### 7. LRU Cache for Cross-Request
```typescript
const cache = new LRUCache<string, any>({ max: 1000, ttl: 5 * 60 * 1000 })
```

### 8. Parallel Component Composition
```tsx
// ✅ Both fetch simultaneously
<Header />  // async fetch inside
<Sidebar /> // async fetch inside
```

## MEDIUM Rules

### 9. Functional setState
```tsx
// ✅ Stable callback
setItems(curr => [...curr, ...newItems])
```

### 10. Lazy State Initialization
```tsx
// ✅ Runs only once
const [index] = useState(() => buildSearchIndex(items))
```

### 11. content-visibility for Long Lists
```css
.item { content-visibility: auto; contain-intrinsic-size: 0 80px; }
```

### 12. Use toSorted() for Immutability
```typescript
// ✅ Creates new array
const sorted = items.toSorted((a, b) => a.value - b.value)
```

## Full Document
See `AGENTS.md` for all 45 rules with detailed examples.
