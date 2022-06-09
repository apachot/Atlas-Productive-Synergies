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
insert into nomenclature_product(code_hs4, code_nc, name, product_chapter_id, updated_by)
select hs4, nc, n, chapter_id, 0
from (values ('1519', '1519', cast('"fr"=>"Acide stéarique"' as hstore),15)
           ,('6908', '6908', cast('"fr"=>"Pavés en céramique émaillée"' as hstore), 69)
           ,('8485', '8485', cast('"fr"=>"Pièces de machines, ne contenant pas de caractéristiques électriques, n.c.a."' as hstore), 83)
           ,('8524', '8524', cast('"fr"=>"Bandes, cassettes, disques et disques compacts"' as hstore), 84)
     ) t (hs4, nc, n, chapter_id)
where not exists (select 1 from nomenclature_product where code_hs4=t.hs4)