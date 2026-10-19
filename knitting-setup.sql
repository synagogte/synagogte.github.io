-- Run once in the existing Supabase project's SQL Editor.
-- No email, password, Auth user, or replacements needed.
-- This intentionally allows anyone with the page URL to read and edit the board.
begin;
create table if not exists public.knitting_board (
  id text primary key check (id = 'main'),
  data jsonb,
  revision integer not null default 0 check (revision >= 0),
  updated_at timestamptz not null default now(),
  constraint knitting_board_size check (data is null or octet_length(data::text) <= 22000000)
);
-- Also works if the earlier owner-only setup has already been run.
alter table public.knitting_board add column if not exists owner_id uuid;
alter table public.knitting_board alter column owner_id drop not null;
alter table public.knitting_board enable row level security;
revoke all on public.knitting_board from public, anon, authenticated;
grant select (id, data, revision, updated_at) on public.knitting_board to anon, authenticated;
grant update (data, revision, updated_at) on public.knitting_board to anon, authenticated;
drop policy if exists knitting_owner_read on public.knitting_board;
drop policy if exists knitting_owner_update on public.knitting_board;
drop policy if exists knitting_shared_read on public.knitting_board;
create policy knitting_shared_read on public.knitting_board for select to anon, authenticated using (id = 'main');
drop policy if exists knitting_shared_update on public.knitting_board;
create policy knitting_shared_update on public.knitting_board for update to anon, authenticated using (id = 'main') with check (id = 'main');
create or replace function public.knitting_guard_revision()
returns trigger language plpgsql set search_path = '' as $$
begin
  if new.revision <> old.revision + 1 then
    raise exception 'Each board save must advance its revision by one';
  end if;
  new.updated_at = now();
  return new;
end;
$$;
revoke all on function public.knitting_guard_revision() from public, anon, authenticated;
drop trigger if exists knitting_revision on public.knitting_board;
create trigger knitting_revision before update on public.knitting_board
  for each row execute function public.knitting_guard_revision();
insert into public.knitting_board(id) values ('main') on conflict (id) do nothing;
notify pgrst, 'reload schema';
commit;
