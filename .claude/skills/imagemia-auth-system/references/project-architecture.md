# Imagem.ia Project Architecture

## System Overview

Imagem.ia is a multi-page web application that provides AI-powered insights to medical imaging centers. The system consists of three main components organized in a funnel architecture:

```
Public Landing → Authentication Gateway → Protected Dashboard
  (imagemia.com)    (imagemia.com/empresas)   (Dashboard + AgentKit)
```

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    IMAGEMIA.COM (Public)                     │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                 Landing Page                          │  │
│  │  - Marketing content                                  │  │
│  │  - Lead capture form                                  │  │
│  │  - ROI calculator                                     │  │
│  │  - CTA: "Solicitar Auditoría"                        │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                        │
│                     │ Qualified clients click                │
│                     │ "Portal de Clientes"                   │
│                     ▼                                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │          /empresas (Login Portal)                     │  │
│  │                                                        │  │
│  │  Left Panel:                Right Panel:              │  │
│  │  - Imagem.ia logo           - Email input             │  │
│  │  - Company info             - Password input          │  │
│  │  - Value prop               - Login button            │  │
│  │  - Benefits                 - Forgot password         │  │
│  │                                                        │  │
│  │  Powered by: Supabase Auth                            │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                        │
│                     │ Successful auth redirects to           │
│                     ▼                                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│              DASHBOARD (Protected - Authenticated)           │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              AgentKit Chat Interface                  │  │
│  │                                                        │  │
│  │  - AI conversation interface                          │  │
│  │  - Medical imaging domain expertise                   │  │
│  │  - Personalized recommendations                       │  │
│  │  - Session history (per user)                         │  │
│  │  - Logout functionality                               │  │
│  │                                                        │  │
│  │  Currently: localhost:8080                            │  │
│  │  Production: TBD                                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘

                         ┌──────────────┐
                         │   Supabase   │
                         │              │
                         │ - Auth       │
                         │ - Database   │
                         │ - Storage    │
                         └──────────────┘
```

## Component Details

### 1. Landing Page (Public)

**URL**: `https://imagemia.com`
**Location**: `/web/deploy/`
**Status**: ✅ Deployed and live

**Purpose**: Attract and convert potential clients

**Key Features**:
- Hero section with animated money counter
- Interactive ROI calculator
- Problem/solution presentation
- Trust badges and statistics
- Modal contact form
- Mobile-optimized responsive design

**Technologies**:
- Pure HTML/CSS/JavaScript
- No framework dependencies
- Hosted on Spaceship (cPanel)
- FTP deployment

**User Journey**:
1. User discovers Imagem.ia via marketing/SEO
2. Reads about value proposition
3. Uses ROI calculator
4. Submits contact form OR
5. Clicks CTA to portal (if existing client)

### 2. Login Portal (Authentication Gateway)

**URL**: `https://imagemia.com/empresas`
**Location**: `/web/empresas/` (to be created)
**Status**: ⏳ To be implemented with this skill

**Purpose**: Authenticate existing clients before dashboard access

**Key Features**:
- Split-panel design (info left, form right)
- Email/password authentication
- "Forgot password" functionality
- Session management
- Auto-redirect if already authenticated
- Mobile-responsive

**Technologies**:
- HTML/CSS/JavaScript
- Supabase Auth SDK (CDN)
- LocalStorage for session persistence
- Same hosting as landing (Spaceship)

**Authentication Flow**:
```
User enters /empresas
    │
    ├─> Has valid session?
    │   ├─> YES: Redirect to /dashboard
    │   └─> NO:  Show login form
    │
User submits credentials
    │
    ├─> Valid credentials?
    │   ├─> YES: Create session → Redirect to /dashboard
    │   └─> NO:  Show error message
    │
```

**Security**:
- HTTPS only in production
- Supabase handles password hashing
- Session tokens stored securely
- CSRF protection
- Rate limiting (via Supabase)

### 3. Dashboard (Protected Application)

**URL**: Currently `http://localhost:8080`, Production TBD
**Location**: `/backend/` (Node.js server) + frontend files
**Status**: ✅ Running locally

**Purpose**: Provide AI-powered insights to authenticated clients

**Key Features**:
- AgentKit chat interface
- Conversation history per user
- User profile display
- Logout functionality
- Session validation on every page load

**Technologies**:
- Frontend: HTML/CSS/JavaScript
- Backend: Node.js + Express
- AI: OpenAI API + AgentKit
- Database: Supabase (user data, chat history)
- WebSockets: Real-time chat updates

**Protection Mechanism**:
```javascript
// On dashboard page load
const { data: { session } } = await supabase.auth.getSession()

if (!session) {
  // No valid session - redirect to login
  window.location.href = '/empresas'
  return
}

// Valid session - load dashboard
const user = session.user
loadDashboard(user)
```

**User Context**:
- User ID from Supabase auth
- Email address
- Company name (from profiles table)
- Role (client/admin)
- Chat history specific to user

## Data Flow

### User Authentication Flow

```
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │
       │ 1. Submit email/password
       ▼
┌─────────────────────────┐
│  /empresas login page   │
│  (Supabase Auth SDK)    │
└──────┬──────────────────┘
       │
       │ 2. Call signInWithPassword()
       ▼
┌─────────────────────────┐
│   Supabase Auth API     │
│  - Verify credentials   │
│  - Generate JWT token   │
└──────┬──────────────────┘
       │
       │ 3. Return session + user
       ▼
┌─────────────────────────┐
│   Browser Storage       │
│  - Save session token   │
│  - Save user object     │
└──────┬──────────────────┘
       │
       │ 4. Redirect to dashboard
       ▼
┌─────────────────────────┐
│   /dashboard            │
│  - Validate session     │
│  - Load user data       │
│  - Initialize chat      │
└─────────────────────────┘
```

### Chat Message Flow

```
User types message
       │
       ▼
Frontend validates session
       │
       ▼
Send to Node.js backend
       │
       ▼
Backend validates JWT
       │
       ▼
Process with AgentKit
       │
       ▼
Call OpenAI API
       │
       ▼
Stream response to frontend
       │
       ▼
Save to Supabase (chat_history table)
       │
       ▼
Display to user
```

## Database Schema

### Supabase Tables

#### auth.users (managed by Supabase)
```sql
- id (uuid, primary key)
- email (text)
- encrypted_password (text)
- email_confirmed_at (timestamp)
- created_at (timestamp)
- last_sign_in_at (timestamp)
```

#### public.profiles (custom)
```sql
- id (uuid, foreign key → auth.users)
- email (text)
- full_name (text)
- company_name (text)
- role (text: 'client' | 'admin' | 'demo')
- created_at (timestamp)
- updated_at (timestamp)

RLS Policies:
- Users can view own profile
- Users can update own profile
```

#### public.chat_history (custom)
```sql
- id (uuid, primary key)
- user_id (uuid, foreign key → auth.users)
- message (text)
- response (text)
- created_at (timestamp)

RLS Policies:
- Users can only view their own chat history
- Users can only insert their own messages
```

## File Structure

```
AgentkitV1/
│
├── web/
│   ├── deploy/                      # Landing page (LIVE)
│   │   ├── index.html
│   │   ├── assets/
│   │   │   └── logos/
│   │   │       ├── imagemia-logo-horizontal-final.svg
│   │   │       └── imagemia-favicon.svg
│   │   └── RESUMEN-2025-10-25.md   # Mobile optimization docs
│   │
│   ├── empresas/                    # Login portal (TO BE CREATED)
│   │   ├── index.html               # From skill template
│   │   └── assets/                  # Shared with landing
│   │
│   └── dashboard/                   # Dashboard frontend (or in backend/)
│       ├── index.html
│       ├── chat.js
│       └── styles.css
│
├── backend/                         # Node.js backend
│   ├── server.js                    # Express server
│   ├── routes/
│   │   ├── auth.js
│   │   └── chat.js
│   ├── controllers/
│   │   └── agentkit.js
│   ├── .env                         # Supabase credentials (DO NOT COMMIT)
│   ├── package.json
│   └── node_modules/
│
├── .claude/
│   └── skills/
│       └── imagemia-auth-system/    # This skill
│           ├── SKILL.md
│           ├── assets/
│           │   └── login-template/
│           ├── references/
│           │   ├── supabase-setup.md
│           │   └── project-architecture.md (this file)
│           └── scripts/
│               ├── deploy-login-page.sh
│               └── create-supabase-env.sh
│
├── .env.example                     # Template for credentials
├── .gitignore                       # Ignore .env, node_modules, etc.
└── README.md
```

## Deployment Architecture

### Current State

```
┌──────────────────────────────────────┐
│   Spaceship Hosting (imagemia.com)  │
│                                      │
│   ├── / (landing)        ✅ LIVE    │
│   └── /empresas (login)  ❌ TODO    │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│   Local Development                  │
│                                      │
│   └── localhost:8080    ✅ RUNNING   │
│       (AgentKit dashboard)           │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│   Supabase (Cloud)                   │
│                                      │
│   ├── Auth          ⏳ TO SETUP      │
│   ├── Database      ⏳ TO SETUP      │
│   └── Storage       ⏳ FUTURE         │
└──────────────────────────────────────┘
```

### Target Production State

```
┌──────────────────────────────────────┐
│   Spaceship Hosting (imagemia.com)  │
│                                      │
│   ├── / (landing)        ✅ LIVE    │
│   └── /empresas (login)  🎯 DEPLOY   │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│   Cloud Hosting (Vercel/Railway)    │
│   OR                                 │
│   VPS (DigitalOcean/AWS)            │
│                                      │
│   └── dashboard.imagemia.com         │
│       (AgentKit dashboard)           │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│   Supabase (Cloud)                   │
│                                      │
│   ├── Auth          ✅ CONFIGURED    │
│   ├── Database      ✅ TABLES        │
│   └── Storage       ⏳ FUTURE         │
└──────────────────────────────────────┘
```

## Environment Configuration

### Development
```bash
# .env.development
SUPABASE_URL=https://xxxxx-dev.supabase.co
SUPABASE_ANON_KEY=eyJ...
NODE_ENV=development
DASHBOARD_URL=http://localhost:8080
```

### Production
```bash
# .env.production
SUPABASE_URL=https://xxxxx-prod.supabase.co
SUPABASE_ANON_KEY=eyJ...
NODE_ENV=production
DASHBOARD_URL=https://dashboard.imagemia.com
```

## Security Considerations

### Authentication Security
- ✅ Passwords hashed by Supabase (bcrypt)
- ✅ JWT tokens for session management
- ✅ HTTPS enforced in production
- ✅ Row Level Security on database
- ⏳ Email verification (optional)
- ⏳ Multi-factor authentication (future)

### API Security
- ✅ CORS configuration
- ✅ Rate limiting (Supabase)
- ✅ Input validation
- ✅ SQL injection prevention (Supabase)
- ⏳ API key rotation (future)

### Data Security
- ✅ Environment variables for secrets
- ✅ .gitignore for sensitive files
- ✅ User data isolation (RLS)
- ⏳ Encryption at rest (Supabase default)
- ⏳ Backup strategy (future)

## Monitoring and Analytics

### Recommended Tools

**Authentication Monitoring**:
- Supabase Dashboard (built-in auth logs)
- Failed login attempts tracking
- User activity monitoring

**Application Monitoring**:
- Error tracking: Sentry
- Performance: Vercel Analytics or Google Analytics
- Uptime: UptimeRobot

**User Analytics**:
- Google Analytics for landing page
- PostHog for dashboard usage
- Supabase for user metrics

## Scaling Considerations

### Current Capacity
- Supabase Free tier: 50,000 monthly active users
- Spaceship hosting: Shared hosting limits
- localhost:8080: Single instance, local only

### Future Scaling Path

**Phase 1** (0-100 users):
- Current architecture sufficient
- Supabase free tier
- Basic hosting

**Phase 2** (100-1000 users):
- Upgrade Supabase to Pro ($25/month)
- Move dashboard to cloud hosting
- Add CDN for static assets

**Phase 3** (1000+ users):
- Supabase Team plan
- Dedicated server for dashboard
- Load balancing
- Caching layer (Redis)
- Database read replicas

## Next Implementation Steps

1. ✅ Create skill structure
2. ✅ Document architecture (this file)
3. ⏳ Set up Supabase project
4. ⏳ Deploy login page template
5. ⏳ Configure authentication
6. ⏳ Connect dashboard to auth
7. ⏳ Test complete flow
8. ⏳ Deploy dashboard to production
9. ⏳ Set up monitoring
10. ⏳ Train client support team

## Support and Maintenance

### Regular Maintenance Tasks
- Monitor Supabase logs weekly
- Review failed login attempts
- Update dependencies monthly
- Backup user data weekly
- Test auth flow monthly

### Emergency Contacts
- Supabase Support: support@supabase.com
- Spaceship Hosting: Via cPanel
- Domain: TBD

### Documentation
- Keep this file updated with architecture changes
- Document all environment variables
- Maintain runbook for common issues
- Update README with setup instructions
