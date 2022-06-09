
update establishment
set enabled=false
where enabled=true
  and (
        coalesce(workforce_group,'') = ''
        or meta->'sector' is null
        or meta->'lat' is null
        or meta->'lng' is null
    );

ALTER TABLE nomenclature_link_activity_rome add rome_chapter varchar(1) GENERATED ALWAYS AS (left(rome_code,1)) STORED ;
ALTER TABLE establishment add it_code varchar(8) GENERATED ALWAYS AS (replace(replace(meta->'ti', '{', ''), '}', '')) STORED ;
ALTER TABLE establishment add sector_id integer GENERATED ALWAYS AS ((meta->'sector')::integer) STORED ;


DROP INDEX if exists establishment_meta_search_idx;
CREATE INDEX establishment_meta_search_idx ON establishment ( enabled , administrative_status, department_code, it_code) include (workforce_group, sector_id);

DROP INDEX if exists nomenclature_link_activity_rome_chapter_idx;
CREATE INDEX nomenclature_link_activity_rome_chapter_idx ON nomenclature_link_activity_rome ( rome_chapter);