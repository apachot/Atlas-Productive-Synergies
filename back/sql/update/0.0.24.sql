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
CREATE INDEX ia_establishment_potential_partners_partner_id_idx
    ON ia_establishment_potential_partners (partner_id);

drop view if exists vw_nomenclature_product_harvard ;

create view vw_nomenclature_product_harvard as
select np.id, np.code_hs4, nps.macro_sector_id as sector_id, np.name
     , exists(select 1
              from nomenclature_product_relationship npr
              where npr.main_product_code_hs4 = np.code_hs4
                 or npr.secondary_product_code_hs4 = np.code_hs4) is_harvard
from nomenclature_product np
         LEFT JOIN nomenclature_product_chapter npc ON npc.id = np.product_chapter_id
         LEFT JOIN nomenclature_product_section nps ON nps.id = npc.product_section_id
where np.code_nc =np.code_hs4