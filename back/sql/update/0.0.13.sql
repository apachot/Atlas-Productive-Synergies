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
-- Add missing FK
ALTER TABLE nomenclature_product_section
    ADD CONSTRAINT nomenclature_product_section_macro_sector_id_fk
        FOREIGN KEY (macro_sector_id)
            REFERENCES macro_sector(id) ;

-- Add missing index
CREATE INDEX address_city_id_idx
    ON address (city_id asc) ;

CREATE INDEX city_department_id_idx
    ON city(department_id asc);

CREATE INDEX city_industry_territory_id_idx
    ON city(industry_territory_id asc);

CREATE INDEX company_address_id_idx
    ON company (address_id asc) ;

CREATE INDEX department_code_idx
    ON department (code asc) ;

CREATE INDEX department_region_id_idx
    ON department (region_id asc) ;

CREATE INDEX establishment_address_id_idx
    on establishment(address_id) ;

CREATE INDEX establishment_company_id_idx
    on establishment(company_id) ;

CREATE INDEX establishment_main_activity_id_idx
    on establishment(main_activity_id) ;

CREATE INDEX establishment_secondary_address_id_idx
    on establishment(secondary_address_id) ;

CREATE INDEX nomenclature_activity_section_id_idx
    ON nomenclature_activity (section_id asc);

CREATE INDEX nomenclature_activity_parent_activity_id_idx
    ON nomenclature_activity (parent_activity_id asc);

CREATE INDEX nomenclature_product_product_chapter_id_idx
    ON nomenclature_product (product_chapter_id asc);

CREATE INDEX nomenclature_product_macro_sector_id_idx
    ON nomenclature_product (macro_sector_id asc);

CREATE INDEX nomenclature_product_chapter_product_section_id_idx
    ON nomenclature_product_chapter (product_section_id asc);

CREATE INDEX nomenclature_product_proximity_main_product_code_hs4_idx
    ON nomenclature_product_proximity (main_product_code_hs4 asc);

CREATE INDEX nomenclature_product_section_macro_sector_id_idx
    ON nomenclature_product_section (macro_sector_id asc);

CREATE INDEX nomenclature_rome_professional_domain_id_idx
    ON nomenclature_rome (professional_domain_id asc);

CREATE INDEX nomenclature_rome_professional_domain_main_domaine_id_idx
    ON nomenclature_rome_professional_domain (main_domaine_id asc);

CREATE INDEX product_establishment_id_idx
    ON product (establishment_id ASC);

CREATE INDEX product_nomenclature_product_id_idx
    ON product (nomenclature_product_id asc) ;

CREATE INDEX recommendation_establishment_id_idx
    ON recommendation (establishment_id asc) ;

CREATE INDEX region_country_id_idx
    ON region (country_id asc) ;

/* update for creating missing lines in nomenclature_product
   when the product have a level 00 (or 00 00) the first line is not present
   correction by adding a "false" line without the 00 indices
   */
insert into nomenclature_product (code_cpf4, code_cpf6, code_hs4, code_nc, macro_sector_id, "name", product_chapter_id,
                                  created_at, updated_at, deleted_at, updated_by)
select np.code_cpf4, np.code_cpf6, np.code_hs4, left(np.code_nc,7), np.macro_sector_id, np."name", np.product_chapter_id
     , now(), now(), null , 0
from nomenclature_product np
    left join nomenclature_product np2
    on np2.code_nc = left(np.code_nc,7)
where np.code_nc like '____ 00 00'
  and np2.id is null;

insert into nomenclature_product (code_cpf4, code_cpf6, code_hs4, code_nc, macro_sector_id, "name", product_chapter_id,
                                  created_at, updated_at, deleted_at, updated_by)
select np.code_cpf4, np.code_cpf6, np.code_hs4, left(np.code_nc,4), np.macro_sector_id, np."name", np.product_chapter_id
                   , now(), now(), null , 0
from nomenclature_product np
         left join nomenclature_product np2
                   on np2.code_nc = left(np.code_nc,4)
where np.code_nc like '____ 00'
  and np2.id is null;
