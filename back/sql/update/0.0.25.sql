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
DROP VIEW IF EXISTS vw_proximity_123;

CREATE VIEW vw_proximity_123 as
With recursive tree as (
    select npp.main_product_code_hs4 hs4, npp.main_product_code_hs4 hs4_start, npp.secondary_product_code_hs4 hs4_dest, npp.proximity, 1 as lvl
    from   nomenclature_product_proximity npp
    where npp.proximity>0.6
      and exists (
            SELECT 1
            FROM nomenclature_product_relationship npr
            WHERE npr.main_product_code_hs4::text = npp.secondary_product_code_hs4::text
               OR npr.secondary_product_code_hs4::text = npp.secondary_product_code_hs4::text
        )
    UNION ALL
    select tree.hs4, npp.main_product_code_hs4 hs4_start, npp.secondary_product_code_hs4 hs4_dest,
           cast(npp.proximity * tree.proximity as numeric(7,6)) proximity,
           tree.lvl+1 lvl
    from tree
             inner join nomenclature_product_proximity npp
                        on npp.main_product_code_hs4 = tree.hs4_dest
                            and npp.secondary_product_code_hs4 != tree.hs4_start
    where tree.lvl<3
      AND npp.proximity>0.6
      and exists (
            SELECT 1
            FROM nomenclature_product_relationship npr
            WHERE npr.main_product_code_hs4::text = npp.secondary_product_code_hs4::text
               OR npr.secondary_product_code_hs4::text = npp.secondary_product_code_hs4::text
        )
)
select * from tree;