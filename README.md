# Family Badminton League V3

This version is designed for easier tournament review.

## New features

- Actual badminton game scores
  - Example: 21–17, 18–21, 21–15
- Automatic match calculation
  - The website converts the games into 2–0 or 2–1
- Dedicated Match Results section
- Tournament Review section
- Round / Stage field
- Match Date field
- Edit and delete teams
- Edit and delete match results
- Live shared standings
- Automatic ranking recalculation

## Upgrade from the previous version

1. Open Supabase.
2. Go to SQL Editor.
3. Run the NEW `supabase-setup.sql`.
4. Replace your old `index.html` with this new one.
5. Reinsert your:
   - Supabase Project URL
   - Supabase Publishable Key
   - Organizer PIN
6. Redeploy to Vercel.

Running the SQL does NOT delete your existing teams or matches.

Old match records will still work, but they will show:
"Detailed game scores not recorded"
until you edit them and add individual game scores.

## Recommended match entry

For a standard best-of-3 badminton match:

Game 1: 21–17
Game 2: 18–21
Game 3: 21–15

The website automatically saves the match result as 2–1.


## Dashboard terminology update

`Games Played` now counts completed match records, not individual sets.

Example: a 2–1 match with set scores 21–18, 18–21, 21–15 counts as **1 game played** on the dashboard.
