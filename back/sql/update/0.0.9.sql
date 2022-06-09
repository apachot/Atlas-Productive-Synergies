
alter table establishment
  add enabled bool default true not null;

alter table establishment
  add meta hstore;

create index establishment_enabled_idx
  on establishment (enabled desc);