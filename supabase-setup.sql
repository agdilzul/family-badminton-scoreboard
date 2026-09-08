-- Family Badminton League V4
-- Run this in Supabase SQL Editor.
-- Safe to run if you already used the previous version.

create extension if not exists pgcrypto;

create table if not exists public.teams (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  team_a uuid not null references public.teams(id) on delete cascade,
  team_b uuid not null references public.teams(id) on delete cascade,
  score_a integer not null check (score_a >= 0),
  score_b integer not null check (score_b >= 0),
  created_at timestamptz not null default now(),
  check (team_a <> team_b)
);

-- Detailed badminton match fields
alter table public.matches add column if not exists game_scores jsonb;
alter table public.matches add column if not exists round_name text;
alter table public.matches add column if not exists match_date date;

alter table public.teams enable row level security;
alter table public.matches enable row level security;

-- Remove old policies so this file can be safely re-run
drop policy if exists "Anyone can read teams" on public.teams;
drop policy if exists "Anyone can read matches" on public.matches;
drop policy if exists "Allow team entry" on public.teams;
drop policy if exists "Allow match entry" on public.matches;
drop policy if exists "Allow team update" on public.teams;
drop policy if exists "Allow team delete" on public.teams;
drop policy if exists "Allow match update" on public.matches;
drop policy if exists "Allow match delete" on public.matches;

-- Public viewing
create policy "Anyone can read teams"
on public.teams for select
to anon
using (true);

create policy "Anyone can read matches"
on public.matches for select
to anon
using (true);

-- Website organizer actions
create policy "Allow team entry"
on public.teams for insert
to anon
with check (true);

create policy "Allow team update"
on public.teams for update
to anon
using (true)
with check (true);

create policy "Allow team delete"
on public.teams for delete
to anon
using (true);

create policy "Allow match entry"
on public.matches for insert
to anon
with check (true);

create policy "Allow match update"
on public.matches for update
to anon
using (true)
with check (true);

create policy "Allow match delete"
on public.matches for delete
to anon
using (true);

-- Enable realtime updates if not already enabled
do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'teams'
  ) then
    alter publication supabase_realtime add table public.teams;
  end if;

  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'matches'
  ) then
    alter publication supabase_realtime add table public.matches;
  end if;
end $$;
