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
alter table establishment
  add workforce_count integer default 0 not null;

-- 1 ou 2 salariés
update establishment set workforce_count = 1 where workforce_group = '01';
-- 3 à 5 salariés
update establishment set workforce_count = 4 where workforce_group = '02';
-- 6 à 9 salariés
update establishment set workforce_count = 7 where workforce_group = '03';
-- 10 à 19 salariés
update establishment set workforce_count = 15 where workforce_group = '11';
-- 20 à 49 salariés
update establishment set workforce_count = 35 where workforce_group = '12';
-- 50 à 99 salariés
update establishment set workforce_count = 75 where workforce_group = '21';
-- 100 à 199 salariés
update establishment set workforce_count = 150 where workforce_group = '22';
-- 200 à 249 salariés
update establishment set workforce_count = 225 where workforce_group = '31';
-- 250 à 499 salariés
update establishment set workforce_count = 375 where workforce_group = '32';
-- 500 à 999 salariés
update establishment set workforce_count = 750 where workforce_group = '41';
-- 1 000 à 1 999 salariés
update establishment set workforce_count = 1500 where workforce_group = '42';
-- 2 000 à 4 999 salariés
update establishment set workforce_count = 3500 where workforce_group = '51';
-- 5 000 à 9 999 salariés
update establishment set workforce_count = 7500 where workforce_group = '52';
-- 10 000 salariés et plus
update establishment set workforce_count = 10000 where workforce_group = '53';