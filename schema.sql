-- Run this in Supabase: Dashboard → SQL Editor → New Query → paste → Run

create table if not exists items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  stock integer not null default 0,
  reorder integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists sales (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  item text not null,
  description text,
  color text,
  size text,
  qty numeric not null,
  buy_price numeric not null,
  sell_price numeric not null,
  profit numeric not null,
  profit_pct numeric not null,
  created_at timestamptz not null default now()
);

-- Row Level Security: only logged-in users of this app can read/write
alter table items enable row level security;
alter table sales enable row level security;

create policy "Authenticated users can manage items"
  on items for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

create policy "Authenticated users can manage sales"
  on sales for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

-- Enable realtime updates on both tables
alter publication supabase_realtime add table items;
alter publication supabase_realtime add table sales;
