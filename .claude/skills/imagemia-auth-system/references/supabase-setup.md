# Supabase Setup Guide for Imagem.ia

## Overview

This guide provides step-by-step instructions for configuring Supabase authentication for the Imagem.ia multi-page application.

## Prerequisites

- Supabase account (free tier is sufficient for development)
- Access to Imagem.ia project repository
- Basic understanding of environment variables

## Step 1: Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Click "Start your project" or "New Project"
3. Fill in project details:
   - **Organization**: Create or select existing
   - **Project Name**: `imagemia-production` (or `imagemia-dev` for testing)
   - **Database Password**: Generate strong password (save this!)
   - **Region**: Choose closest to your users (e.g., `South America (São Paulo)` for LATAM)
   - **Pricing Plan**: Free (sufficient for starting out)

4. Click "Create new project"
5. Wait 1-2 minutes for project to be provisioned

## Step 2: Get API Credentials

Once your project is ready:

1. Navigate to **Settings** (gear icon) → **API**

2. Copy these credentials (you'll need them):
   ```
   Project URL: https://xxxxxxxxxxxxx.supabase.co
   Project API keys:
     - anon (public): eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
     - service_role (secret): eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

3. **IMPORTANT**:
   - `anon` key = Safe to use in frontend (login page)
   - `service_role` key = NEVER expose in frontend, only use in backend

## Step 3: Configure Authentication

1. Go to **Authentication** → **Providers**

2. **Enable Email Provider**:
   - Toggle "Enable Email provider" to ON
   - **Confirm email**: Toggle ON (recommended for production)
   - **Secure email change**: Toggle ON
   - **Secure password change**: Toggle ON
   - Click "Save"

3. **Configure Email Templates** (optional but recommended):
   - Go to **Authentication** → **Email Templates**
   - Customize templates for:
     - Confirm signup
     - Magic Link
     - Change Email Address
     - Reset Password
   - Use Imagem.ia branding (colors, logo)

4. **Configure Site URL**:
   - Go to **Authentication** → **URL Configuration**
   - **Site URL**: `https://imagemia.com`
   - **Redirect URLs**: Add these:
     ```
     https://imagemia.com/empresas
     https://imagemia.com/dashboard
     http://localhost:3000 (for local testing)
     http://localhost:8080 (for local dashboard testing)
     ```

## Step 4: Set Up User Table (Optional)

If you want to store additional user data beyond authentication:

1. Go to **Table Editor** → **Create a new table**

2. Create `profiles` table:
   ```sql
   create table public.profiles (
     id uuid references auth.users on delete cascade not null primary key,
     email text,
     full_name text,
     company_name text,
     role text default 'client',
     created_at timestamp with time zone default timezone('utc'::text, now()) not null,
     updated_at timestamp with time zone default timezone('utc'::text, now()) not null
   );

   -- Set up Row Level Security (RLS)
   alter table public.profiles enable row level security;

   -- Policy: Users can view their own profile
   create policy "Users can view own profile"
     on public.profiles for select
     using ( auth.uid() = id );

   -- Policy: Users can update their own profile
   create policy "Users can update own profile"
     on public.profiles for update
     using ( auth.uid() = id );

   -- Function to automatically create profile on signup
   create function public.handle_new_user()
   returns trigger as $$
   begin
     insert into public.profiles (id, email, full_name)
     values (new.id, new.email, new.raw_user_meta_data->>'full_name');
     return new;
   end;
   $$ language plpgsql security definer;

   -- Trigger the function every time a user is created
   create trigger on_auth_user_created
     after insert on auth.users
     for each row execute procedure public.handle_new_user();
   ```

3. Click "Run" to execute

## Step 5: Configure Environment Variables

### For Login Page (Frontend)

Create or update `web/empresas/.env` (or add directly to HTML):

```bash
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**In the HTML file**, replace these lines (around line 367-368):
```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL'
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'
```

With your actual credentials:
```javascript
const SUPABASE_URL = 'https://xxxxxxxxxxxxx.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

### For Backend (Node.js)

Update `backend/.env`:

```bash
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Step 6: Create Initial Users

### Option A: Via Supabase Dashboard (Recommended for first users)

1. Go to **Authentication** → **Users**
2. Click "Add user" → "Create new user"
3. Enter:
   - **Email**: client@example.com
   - **Password**: (generate strong password)
   - **Auto Confirm User**: Toggle ON (for testing)
4. Click "Create user"
5. **Send credentials to user securely** (never via plain email)

### Option B: Via Sign Up Page (To be implemented)

Create a separate signup page for admins to invite new users, or use the Supabase API:

```javascript
const { data, error } = await supabase.auth.admin.createUser({
  email: 'newclient@example.com',
  password: 'temporaryPassword123!',
  email_confirm: true,
  user_metadata: {
    full_name: 'Client Name',
    company_name: 'Their Company'
  }
})
```

## User Management

### Manually Creating Users

Best practices:
1. Create user in Supabase dashboard
2. Generate strong temporary password
3. Send credentials via secure channel (Signal, WhatsApp)
4. Force password change on first login (to be implemented)

### User Roles

If using the `profiles` table, assign roles:
- `client` - Standard client access
- `admin` - Full access to all features
- `demo` - Limited demo access

Update role in **Table Editor** → `profiles` → Edit user row

### Disabling Users

1. Go to **Authentication** → **Users**
2. Find user
3. Click three dots → **Disable User**
4. User cannot login until re-enabled

### Deleting Users

1. Go to **Authentication** → **Users**
2. Find user
3. Click three dots → **Delete User**
4. **WARNING**: This is permanent and cascades to `profiles` table

## Security Best Practices

### Row Level Security (RLS)

ALWAYS enable RLS on all tables:

```sql
alter table public.your_table enable row level security;
```

### Policies

Create restrictive policies:

```sql
-- Only allow users to see their own data
create policy "Users can only view own data"
  on public.your_table
  for select
  using ( auth.uid() = user_id );
```

### API Keys

- ✅ Use `anon` key in frontend
- ❌ NEVER use `service_role` key in frontend
- ✅ Store keys in environment variables
- ❌ NEVER commit keys to git
- ✅ Use different projects for dev/staging/production

### Email Verification

For production:
1. Enable "Confirm email" in **Authentication** → **Providers**
2. Customize email template with Imagem.ia branding
3. Users must click link in email before they can log in

### Password Requirements

Configure in **Authentication** → **Policies**:
- Minimum password length: 12 characters (recommended)
- Require numbers, symbols, uppercase (optional)

## Testing Authentication Flow

### Local Testing

1. Start local server for login page:
   ```bash
   cd web/empresas
   python3 -m http.server 3000
   ```

2. Open browser to `http://localhost:3000`

3. Try logging in with test user

4. Check browser console for any errors

5. Verify redirect to dashboard works

### Common Issues

**"Invalid login credentials"**
- Check email/password are correct
- Verify user exists in Supabase dashboard
- Check if email confirmation is required but not completed

**"Cross-origin" errors**
- Add localhost URLs to Redirect URLs in Supabase dashboard
- Ensure CORS is properly configured

**Session not persisting**
- Check browser cookies are enabled
- Verify Supabase client is initialized correctly
- Check localStorage in browser dev tools

## Advanced: OAuth Providers

### Adding Google OAuth

1. Create Google OAuth app:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create project → APIs & Services → Credentials
   - Create OAuth 2.0 Client ID
   - Add authorized redirect URI: `https://xxxxx.supabase.co/auth/v1/callback`

2. In Supabase:
   - Go to **Authentication** → **Providers** → **Google**
   - Toggle "Enable Google provider"
   - Add Google Client ID and Client Secret
   - Click "Save"

3. Update login page to add Google button

### Adding GitHub OAuth

Similar process:
1. Create GitHub OAuth app in GitHub Settings
2. Enable in Supabase **Authentication** → **Providers** → **GitHub**
3. Add GitHub button to login page

## Monitoring and Logs

### View Authentication Logs

1. Go to **Authentication** → **Logs**
2. See all login attempts, successes, failures
3. Filter by event type
4. Export logs if needed

### User Analytics

1. Go to **Authentication** → **Users**
2. See:
   - Total users
   - New users (last 7 days)
   - Active users
   - User growth chart

## Production Checklist

Before going live:

- [ ] Email verification enabled
- [ ] Custom email templates configured with branding
- [ ] RLS enabled on all tables
- [ ] Policies tested and working
- [ ] Site URL and Redirect URLs configured for production domain
- [ ] Test user accounts created
- [ ] Password requirements set appropriately
- [ ] Service role key secured (not in frontend)
- [ ] Monitoring/alerts configured
- [ ] Backup strategy in place

## Support Resources

- **Supabase Docs**: https://supabase.com/docs/guides/auth
- **Discord Community**: https://discord.supabase.com
- **GitHub Discussions**: https://github.com/supabase/supabase/discussions

## Troubleshooting

### Check Supabase Status

If authentication suddenly stops working:
1. Check [Supabase Status Page](https://status.supabase.com/)
2. Verify your project is not paused (free tier pauses after 7 days of inactivity)

### Restore Paused Project

1. Go to Supabase dashboard
2. Click "Restore project"
3. Wait 1-2 minutes for restoration

### Contact Support

For critical issues:
1. Log in to Supabase
2. Go to your project
3. Click support icon (bottom right)
4. Submit ticket with details
