
alter table establishment
  add department_code text default '' not null;

create index establishment_search_idx
  on establishment (enabled desc, department_code asc, workforce_group asc);


alter table nomenclature_link_activity_rome
  add factor NUMERIC(7, 6) default 0.0;

create index nomenclature_link_activity_rome_activity_naf_code_idx
  on nomenclature_link_activity_rome (activity_naf_code);