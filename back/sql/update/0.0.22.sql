/*************************************************************************
 *
 * OPEN STUDIO
 * __________________
 *
 *  [2020] - [2021] Open Studio All Rights Reserved.
 *
 * NOTICE: All information contained herein is, and remains the property of
 * Open Studio. The intellectual and technical concepts contained herein are
 * proprietary to Open Studio and may be covered by France and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is strictly
 * forbidden unless prior written permission is obtained from Open Studio.
 * Access to the source code contained herein is hereby forbidden to anyone except
 * current Open Studio employees, managers or contractors who have executed
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */
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