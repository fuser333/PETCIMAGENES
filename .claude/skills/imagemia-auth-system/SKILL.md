---
name: imagemia-auth-system
description: This skill should be used when building or modifying authentication systems for Imagem.ia. It provides templates, Supabase configuration, and workflows for creating login pages that connect landing pages to the AgentKit dashboard. Use this skill when creating /empresas login page, setting up Supabase auth, or organizing the multi-page authentication flow.
---

# Imagem.ia Authentication System

## Overview

This skill enables the construction of a complete authentication system for Imagem.ia that connects the public landing page (imagemia.com) through a login interface (/empresas) to the AgentKit dashboard (localhost:8080). The system uses Supabase for authentication and follows a three-page architecture: Landing → Login → Dashboard.

## Project Architecture

### Three-Page Flow

1. **Landing Page** (`imagemia.com`)
   - Public-facing marketing site
   - Already deployed and functioning
   - Captures leads through contact form
   - Directs qualified clients to /empresas

2. **Login Page** (`imagemia.com/empresas`)
   - Authentication gateway for clients
   - Left side: Imagem.ia logo and company info
   - Right side: Welcome message and login form (email/password)
   - Powered by Supabase Auth
   - Redirects authenticated users to dashboard

3. **Dashboard** (`localhost:8080` → production URL TBD)
   - AgentKit chat interface
   - Protected route - requires authentication
   - Client interaction with AI system
   - Currently running locally, needs production deployment

### Directory Structure

```
AgentkitV1/
├── web/
│   ├── deploy/                    # Landing page (imagemia.com)
│   │   ├── index.html
│   │   └── assets/
│   ├── empresas/                  # Login page (to be created)
│   │   ├── index.html
│   │   ├── login.js
│   │   └── assets/
│   └── dashboard/                 # AgentKit dashboard
│       └── (existing localhost:8080 files)
├── backend/                       # Node.js backend
└── .claude/
    └── skills/
        └── imagemia-auth-system/  # This skill
```

## Core Workflow

### Step 1: Create Login Page Structure

Use the login page template from `assets/login-template/` as the base for `/empresas`:

```bash
# Copy template to project
cp -r assets/login-template/ ../../web/empresas/
```

The template includes:
- Responsive split layout (logo left, form right)
- Email/password input fields
- Supabase integration code
- Error handling and validation
- Redirect logic after successful login
- Mobile-optimized design

### Step 2: Configure Supabase Authentication

Reference `references/supabase-setup.md` for complete Supabase configuration instructions.

Key configuration steps:
1. Create Supabase project
2. Configure authentication providers (Email/Password)
3. Set up redirect URLs
4. Configure Row Level Security (RLS)
5. Add environment variables

Required environment variables:
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_KEY=your-service-key
```

### Step 3: Implement Authentication Flow

The authentication flow works as follows:

1. **User arrives at `/empresas`**
   - Check if already authenticated (Supabase session)
   - If yes → redirect to dashboard
   - If no → show login form

2. **User submits credentials**
   - Validate email format
   - Call `supabase.auth.signInWithPassword()`
   - Handle success → redirect to dashboard
   - Handle error → display error message

3. **Dashboard protection**
   - Check authentication on page load
   - If no session → redirect to `/empresas`
   - If session exists → load dashboard

### Step 4: Connect to AgentKit Dashboard

The dashboard (currently localhost:8080) needs to:

1. **Check authentication status**:
```javascript
const { data: { session } } = await supabase.auth.getSession()
if (!session) {
  window.location.href = '/empresas'
}
```

2. **Display user info**:
```javascript
const user = session.user
// Show user.email in UI
// Use user.id for chat history/personalization
```

3. **Implement logout**:
```javascript
await supabase.auth.signOut()
window.location.href = '/empresas'
```

### Step 5: Deploy Login Page

Use `scripts/deploy-login-page.sh` to deploy the login page to Spaceship hosting:

```bash
./scripts/deploy-login-page.sh
```

The script:
- Uploads files to `/home/fwrikwglvd/imagemia.com/empresas/`
- Sets correct file permissions
- Verifies deployment
- Tests authentication endpoints

## Security Considerations

### Frontend Security
- Never expose `SUPABASE_SERVICE_KEY` in frontend code
- Only use `SUPABASE_ANON_KEY` in client-side JavaScript
- Validate all input fields before submission
- Use HTTPS in production
- Implement CSRF protection

### Supabase Security
- Enable Row Level Security (RLS) on all tables
- Configure appropriate authentication policies
- Set up email verification (optional but recommended)
- Enable MFA for admin accounts
- Monitor authentication logs

### Session Management
- Set appropriate session timeout
- Implement refresh token rotation
- Clear sessions on logout
- Handle expired sessions gracefully

## Customization Guide

### Branding
All brand assets are in `assets/login-template/`:
- Logo: Use existing `imagemia-logo-horizontal-final.svg`
- Colors: Match landing page (--primary: #2563EB, --accent: #06B6D4)
- Typography: Inter font family (already used in landing)

### Company Information Panel (Left Side)
Edit `assets/login-template/index.html` to customize:
- Company description
- Value proposition for logged-in users
- Contact information
- Support links

### Welcome Message (Right Side)
Customize the welcome message to:
- Explain what users can do after login
- Set expectations for dashboard functionality
- Provide helpful onboarding tips

## Testing Workflow

1. **Local Testing**:
   ```bash
   # Serve login page locally
   cd web/empresas
   python3 -m http.server 3000
   # Open http://localhost:3000
   ```

2. **Test Authentication Flow**:
   - Try invalid credentials → should show error
   - Try valid credentials → should redirect to dashboard
   - Check session persistence → refresh page, stay logged in
   - Test logout → should redirect to login page

3. **Test on Mobile**:
   - Responsive layout works correctly
   - Touch targets are appropriate size
   - Forms are easy to use on small screens

## Common Tasks

### Add New User
See `references/supabase-setup.md` section "User Management" for instructions on:
- Creating users through Supabase dashboard
- Sending invitation emails
- Managing user roles and permissions

### Update Login Page Styling
1. Edit `web/empresas/index.html` CSS section
2. Test locally
3. Deploy using `scripts/deploy-login-page.sh`

### Change Authentication Provider
See `references/supabase-setup.md` section "Authentication Providers" to:
- Add Google OAuth
- Add GitHub OAuth
- Add Magic Link authentication

### Debug Authentication Issues
1. Check browser console for JavaScript errors
2. Check Supabase dashboard → Authentication → Logs
3. Verify environment variables are correct
4. Test with Supabase Test email feature

## Project Organization

### Menu Structure
Organize the Imagem.ia project menu as follows:

```
Imagem.ia Project/
│
├── 📄 Landing Page (Public)
│   ├── URL: https://imagemia.com
│   ├── Purpose: Lead capture, marketing
│   ├── Location: /web/deploy/
│   └── Status: ✅ Deployed
│
├── 🔐 Login Portal (Protected)
│   ├── URL: https://imagemia.com/empresas
│   ├── Purpose: Client authentication
│   ├── Location: /web/empresas/
│   └── Status: ⏳ To be created with this skill
│
├── 💬 Dashboard (Authenticated)
│   ├── URL: TBD (currently localhost:8080)
│   ├── Purpose: AgentKit chat interface
│   ├── Location: /web/dashboard/ or /backend/
│   └── Status: ✅ Running locally
│
├── ⚙️ Backend Services
│   ├── API endpoints
│   ├── Supabase integration
│   ├── Location: /backend/
│   └── Status: ✅ Running locally
│
└── 📚 Documentation
    ├── Landing optimization (RESUMEN-2025-10-25.md)
    ├── Authentication (this skill)
    └── Deployment guides
```

### File Organization Best Practices

1. **Keep related files together**
   - Each page has its own directory
   - Assets are colocated with the page that uses them

2. **Use clear naming conventions**
   - `deploy/` for production-ready landing
   - `empresas/` for login page
   - `dashboard/` for authenticated app

3. **Maintain documentation**
   - README.md in each directory
   - RESUMEN files for session summaries
   - Configuration examples (`.env.example`)

4. **Version control**
   - Commit logical changes together
   - Use descriptive commit messages
   - Tag releases

## Resources

### Templates
- `assets/login-template/` - Complete login page template with Supabase integration

### References
- `references/supabase-setup.md` - Detailed Supabase configuration guide
- `references/project-architecture.md` - Complete system architecture documentation

### Scripts
- `scripts/deploy-login-page.sh` - Deploy login page to Spaceship hosting
- `scripts/test-auth.sh` - Test authentication flow locally
- `scripts/create-supabase-env.sh` - Generate .env file with Supabase credentials

## Next Steps After Using This Skill

1. ✅ Create `/empresas` login page using template
2. ⚙️ Configure Supabase project
3. 🔗 Connect dashboard to authentication
4. 🚀 Deploy login page to production
5. 👥 Create initial user accounts
6. 🧪 Test complete authentication flow
7. 📊 Set up analytics/monitoring
8. 📧 Configure email templates (welcome, password reset)

## Support

For issues or questions:
- Review `references/` documentation first
- Check Supabase logs for auth errors
- Review existing implementation in localhost:8080
- Consult session summaries (RESUMEN-*.md files)
