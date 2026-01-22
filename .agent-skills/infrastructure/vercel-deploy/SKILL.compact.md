---
name: vercel-deploy
description: Deploy to Vercel instantly, no auth required
---

# Vercel Deploy

## Workflow
1. Package project (excludes node_modules, .git)
2. Auto-detect framework from package.json
3. Upload to deployment service
4. Returns Preview URL + Claim URL

## Usage
```bash
# Deploy current directory
bash /mnt/skills/user/vercel-deploy/scripts/deploy.sh

# Deploy specific path
bash /mnt/skills/user/vercel-deploy/scripts/deploy.sh /path/to/project
```

## Supported Frameworks
- **React**: Next.js, Gatsby, CRA, Remix
- **Vue**: Nuxt, Vitepress
- **Svelte**: SvelteKit
- **Other**: Astro, Angular, Vite, Express, Hono

## Output
```
✓ Deployment successful!
Preview URL: https://skill-deploy-abc123.vercel.app
Claim URL: https://vercel.com/claim-deployment?code=...
```

## Troubleshooting
Network error on claude.ai:
1. Settings → Capabilities
2. Add *.vercel.com to allowed domains
