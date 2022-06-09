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

DROP TABLE if exists rank_green_production ;

CREATE TABLE rank_green_production (hs4 varchar(4), green_norm numeric(14,13)) ;
insert into rank_green_production VALUES
('8402',1), ('8404',1), ('8406',1), ('8411',1), ('8412',1), ('8417',1), ('8419',1), ('8421',1), ('8474',1), ('8479',1), ('8501',1), ('8502',1),
('8503',1), ('8504',1), ('8514',1), ('8541',1), ('8543',1), ('9013',1), ('9015',1), ('9026',1), ('9027',1), ('9031',1), ('9032',1), ('9033',1) ;
