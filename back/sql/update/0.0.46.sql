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
drop table if exists raw_iot_secteur_nace;
create table raw_iot_secteur_nace
(
    nace varchar(5),
    "01.11" numeric(21,19), "01.12" numeric(21,19), "01.13" numeric(21,19), "01.14" numeric(21,19), "01.15" numeric(21,19), "01.16" numeric(21,19), "01.19" numeric(21,19),
    "01.20" numeric(21,19), "01.21" numeric(21,19), "01.22" numeric(21,19), "01.23" numeric(21,19), "01.24" numeric(21,19), "01.25" numeric(21,19), "01.26" numeric(21,19),
    "01.27" numeric(21,19), "01.28" numeric(21,19), "01.29" numeric(21,19), "01.30" numeric(21,19), "01.41" numeric(21,19), "01.42" numeric(21,19), "01.43" numeric(21,19),
    "01.44" numeric(21,19), "01.45" numeric(21,19), "01.46" numeric(21,19), "01.47" numeric(21,19), "01.49" numeric(21,19), "01.50" numeric(21,19), "01.61" numeric(21,19),
    "01.62" numeric(21,19), "01.63" numeric(21,19), "01.64" numeric(21,19), "01.70" numeric(21,19), "02.10" numeric(21,19), "02.20" numeric(21,19), "02.30" numeric(21,19),
    "02.40" numeric(21,19), "03.11" numeric(21,19), "03.12" numeric(21,19), "03.21" numeric(21,19), "03.22" numeric(21,19), "05.10" numeric(21,19), "05.20" numeric(21,19),
    "06.10" numeric(21,19), "06.20" numeric(21,19), "07.10" numeric(21,19), "07.21" numeric(21,19), "07.29" numeric(21,19), "08.11" numeric(21,19), "08.12" numeric(21,19),
    "08.91" numeric(21,19), "08.92" numeric(21,19), "08.93" numeric(21,19), "08.99" numeric(21,19), "09.10" numeric(21,19), "09.90" numeric(21,19), "10.11" numeric(21,19),
    "10.12" numeric(21,19), "10.13" numeric(21,19), "10.20" numeric(21,19), "10.31" numeric(21,19), "10.32" numeric(21,19), "10.39" numeric(21,19), "10.41" numeric(21,19),
    "10.42" numeric(21,19), "10.51" numeric(21,19), "10.52" numeric(21,19), "10.61" numeric(21,19), "10.62" numeric(21,19), "10.71" numeric(21,19), "10.72" numeric(21,19),
    "10.73" numeric(21,19), "10.81" numeric(21,19), "10.82" numeric(21,19), "10.83" numeric(21,19), "10.84" numeric(21,19), "10.85" numeric(21,19), "10.86" numeric(21,19),
    "10.89" numeric(21,19), "10.91" numeric(21,19), "10.92" numeric(21,19), "11.01" numeric(21,19), "11.02" numeric(21,19), "11.03" numeric(21,19), "11.04" numeric(21,19),
    "11.05" numeric(21,19), "11.06" numeric(21,19), "11.07" numeric(21,19), "12.00" numeric(21,19), "13.10" numeric(21,19), "13.20" numeric(21,19), "13.30" numeric(21,19),
    "13.91" numeric(21,19), "13.92" numeric(21,19), "13.93" numeric(21,19), "13.94" numeric(21,19), "13.95" numeric(21,19), "13.96" numeric(21,19), "13.99" numeric(21,19),
    "14.11" numeric(21,19), "14.12" numeric(21,19), "14.13" numeric(21,19), "14.14" numeric(21,19), "14.19" numeric(21,19), "14.20" numeric(21,19), "14.31" numeric(21,19),
    "14.39" numeric(21,19), "15.11" numeric(21,19), "15.12" numeric(21,19), "15.20" numeric(21,19), "16.10" numeric(21,19), "16.21" numeric(21,19), "16.22" numeric(21,19),
    "16.23" numeric(21,19), "16.24" numeric(21,19), "16.29" numeric(21,19), "17.11" numeric(21,19), "17.12" numeric(21,19), "17.21" numeric(21,19), "17.22" numeric(21,19),
    "17.23" numeric(21,19), "17.24" numeric(21,19), "17.29" numeric(21,19), "18.11" numeric(21,19), "18.12" numeric(21,19), "18.13" numeric(21,19), "18.14" numeric(21,19),
    "18.20" numeric(21,19), "19.10" numeric(21,19), "19.20" numeric(21,19), "20.11" numeric(21,19), "20.12" numeric(21,19), "20.13" numeric(21,19), "20.14" numeric(21,19),
    "20.15" numeric(21,19), "20.16" numeric(21,19), "20.17" numeric(21,19), "20.20" numeric(21,19), "20.30" numeric(21,19), "20.41" numeric(21,19), "20.42" numeric(21,19),
    "20.51" numeric(21,19), "20.52" numeric(21,19), "20.53" numeric(21,19), "20.59" numeric(21,19), "20.60" numeric(21,19), "21.10" numeric(21,19), "21.20" numeric(21,19),
    "22.11" numeric(21,19), "22.19" numeric(21,19), "22.21" numeric(21,19), "22.22" numeric(21,19), "22.23" numeric(21,19), "22.29" numeric(21,19), "23.11" numeric(21,19),
    "23.12" numeric(21,19), "23.13" numeric(21,19), "23.14" numeric(21,19), "23.19" numeric(21,19), "23.20" numeric(21,19), "23.31" numeric(21,19), "23.32" numeric(21,19),
    "23.41" numeric(21,19), "23.42" numeric(21,19), "23.43" numeric(21,19), "23.44" numeric(21,19), "23.49" numeric(21,19), "23.51" numeric(21,19), "23.52" numeric(21,19),
    "23.61" numeric(21,19), "23.62" numeric(21,19), "23.63" numeric(21,19), "23.64" numeric(21,19), "23.65" numeric(21,19), "23.69" numeric(21,19), "23.70" numeric(21,19),
    "23.91" numeric(21,19), "23.99" numeric(21,19), "24.10" numeric(21,19), "24.20" numeric(21,19), "24.31" numeric(21,19), "24.32" numeric(21,19), "24.33" numeric(21,19),
    "24.34" numeric(21,19), "24.41" numeric(21,19), "24.42" numeric(21,19), "24.43" numeric(21,19), "24.44" numeric(21,19), "24.45" numeric(21,19), "24.46" numeric(21,19),
    "24.51" numeric(21,19), "24.52" numeric(21,19), "24.53" numeric(21,19), "24.54" numeric(21,19), "25.11" numeric(21,19), "25.12" numeric(21,19), "25.21" numeric(21,19),
    "25.29" numeric(21,19), "25.30" numeric(21,19), "25.40" numeric(21,19), "25.50" numeric(21,19), "25.61" numeric(21,19), "25.62" numeric(21,19), "25.71" numeric(21,19),
    "25.72" numeric(21,19), "25.73" numeric(21,19), "25.91" numeric(21,19), "25.92" numeric(21,19), "25.93" numeric(21,19), "25.94" numeric(21,19), "25.99" numeric(21,19),
    "26.11" numeric(21,19), "26.12" numeric(21,19), "26.20" numeric(21,19), "26.30" numeric(21,19), "26.40" numeric(21,19), "26.51" numeric(21,19), "26.52" numeric(21,19),
    "26.60" numeric(21,19), "26.70" numeric(21,19), "26.80" numeric(21,19), "27.11" numeric(21,19), "27.12" numeric(21,19), "27.20" numeric(21,19), "27.31" numeric(21,19),
    "27.32" numeric(21,19), "27.33" numeric(21,19), "27.40" numeric(21,19), "27.51" numeric(21,19), "27.52" numeric(21,19), "27.90" numeric(21,19), "28.11" numeric(21,19),
    "28.12" numeric(21,19), "28.13" numeric(21,19), "28.14" numeric(21,19), "28.15" numeric(21,19), "28.21" numeric(21,19), "28.22" numeric(21,19), "28.23" numeric(21,19),
    "28.24" numeric(21,19), "28.25" numeric(21,19), "28.29" numeric(21,19), "28.30" numeric(21,19), "28.41" numeric(21,19), "28.49" numeric(21,19), "28.91" numeric(21,19),
    "28.92" numeric(21,19), "28.93" numeric(21,19), "28.94" numeric(21,19), "28.95" numeric(21,19), "28.96" numeric(21,19), "28.99" numeric(21,19), "29.10" numeric(21,19),
    "29.20" numeric(21,19), "29.31" numeric(21,19), "29.32" numeric(21,19), "30.11" numeric(21,19), "30.12" numeric(21,19), "30.20" numeric(21,19), "30.30" numeric(21,19),
    "30.40" numeric(21,19), "30.91" numeric(21,19), "30.92" numeric(21,19), "30.99" numeric(21,19), "31.01" numeric(21,19), "31.02" numeric(21,19), "31.03" numeric(21,19),
    "31.09" numeric(21,19), "32.11" numeric(21,19), "32.12" numeric(21,19), "32.13" numeric(21,19), "32.20" numeric(21,19), "32.30" numeric(21,19), "32.40" numeric(21,19),
    "32.50" numeric(21,19), "32.91" numeric(21,19), "32.99" numeric(21,19), "33.11" numeric(21,19), "33.12" numeric(21,19), "33.13" numeric(21,19), "33.14" numeric(21,19),
    "33.15" numeric(21,19), "33.16" numeric(21,19), "33.17" numeric(21,19), "33.19" numeric(21,19), "33.20" numeric(21,19), "35.11" numeric(21,19), "35.12" numeric(21,19),
    "35.13" numeric(21,19), "35.14" numeric(21,19), "35.21" numeric(21,19), "35.22" numeric(21,19), "35.23" numeric(21,19), "35.30" numeric(21,19), "36.00" numeric(21,19),
    "37.00" numeric(21,19), "38.11" numeric(21,19), "38.12" numeric(21,19), "38.21" numeric(21,19), "38.22" numeric(21,19), "38.31" numeric(21,19), "38.32" numeric(21,19),
    "39.00" numeric(21,19), "41.10" numeric(21,19), "41.20" numeric(21,19), "42.11" numeric(21,19), "42.12" numeric(21,19), "42.13" numeric(21,19), "42.21" numeric(21,19),
    "42.22" numeric(21,19), "42.91" numeric(21,19), "42.99" numeric(21,19), "43.11" numeric(21,19), "43.12" numeric(21,19), "43.13" numeric(21,19), "43.21" numeric(21,19),
    "43.22" numeric(21,19), "43.29" numeric(21,19), "43.31" numeric(21,19), "43.32" numeric(21,19), "43.33" numeric(21,19), "43.34" numeric(21,19), "43.39" numeric(21,19),
    "43.91" numeric(21,19), "43.99" numeric(21,19), "45.11" numeric(21,19), "45.19" numeric(21,19), "45.20" numeric(21,19), "45.31" numeric(21,19), "45.32" numeric(21,19),
    "45.40" numeric(21,19), "46.11" numeric(21,19), "46.12" numeric(21,19),	"46.13" numeric(21,19),	"46.14" numeric(21,19),	"46.15" numeric(21,19),	"46.16" numeric(21,19),
    "46.17" numeric(21,19),	"46.18" numeric(21,19),	"46.19" numeric(21,19),	"46.21" numeric(21,19),	"46.22" numeric(21,19),	"46.23" numeric(21,19),	"46.24" numeric(21,19),
    "46.31" numeric(21,19),	"46.32" numeric(21,19),	"46.33" numeric(21,19),	"46.34" numeric(21,19),	"46.35" numeric(21,19),	"46.36" numeric(21,19),	"46.37" numeric(21,19),
    "46.38" numeric(21,19),	"46.39" numeric(21,19),	"46.41" numeric(21,19),	"46.42" numeric(21,19),	"46.43" numeric(21,19),	"46.44" numeric(21,19),	"46.45" numeric(21,19),
    "46.46" numeric(21,19),	"46.47" numeric(21,19),	"46.48" numeric(21,19),	"46.49" numeric(21,19),	"46.51" numeric(21,19),	"46.52" numeric(21,19),	"46.61" numeric(21,19),
    "46.62" numeric(21,19),	"46.63" numeric(21,19),	"46.64" numeric(21,19),	"46.65" numeric(21,19),	"46.66" numeric(21,19),	"46.69" numeric(21,19),	"46.71" numeric(21,19),
    "46.72" numeric(21,19),	"46.73" numeric(21,19),	"46.74" numeric(21,19),	"46.75" numeric(21,19),	"46.76" numeric(21,19),	"46.77" numeric(21,19),	"46.90" numeric(21,19),
    "47.11" numeric(21,19),	"47.19" numeric(21,19),	"47.21" numeric(21,19),	"47.22" numeric(21,19),	"47.23" numeric(21,19),	"47.24" numeric(21,19),	"47.25" numeric(21,19),
    "47.26" numeric(21,19),	"47.29" numeric(21,19),	"47.30" numeric(21,19),	"47.41" numeric(21,19),	"47.42" numeric(21,19),	"47.43" numeric(21,19),	"47.51" numeric(21,19),
    "47.52" numeric(21,19),	"47.53" numeric(21,19),	"47.54" numeric(21,19),	"47.59" numeric(21,19),	"47.61" numeric(21,19),	"47.62" numeric(21,19),	"47.63" numeric(21,19),
    "47.64" numeric(21,19),	"47.65" numeric(21,19),	"47.71" numeric(21,19),	"47.72" numeric(21,19),	"47.73" numeric(21,19),	"47.74" numeric(21,19),	"47.75" numeric(21,19),
    "47.76" numeric(21,19),	"47.77" numeric(21,19),	"47.78" numeric(21,19),	"47.79" numeric(21,19),	"47.81" numeric(21,19),	"47.82" numeric(21,19),	"47.89" numeric(21,19),
    "47.91" numeric(21,19),	"47.99" numeric(21,19),	"49.10" numeric(21,19),	"49.20" numeric(21,19),	"49.31" numeric(21,19),	"49.32" numeric(21,19),	"49.39" numeric(21,19),
    "49.41" numeric(21,19),	"49.42" numeric(21,19),	"49.50" numeric(21,19),	"50.10" numeric(21,19),	"50.20" numeric(21,19),	"50.30" numeric(21,19),	"50.40" numeric(21,19),
    "51.10" numeric(21,19),	"51.21" numeric(21,19),	"51.22" numeric(21,19),	"52.10" numeric(21,19),	"52.21" numeric(21,19),	"52.22" numeric(21,19),	"52.23" numeric(21,19),
    "52.24" numeric(21,19),	"52.29" numeric(21,19),	"53.10" numeric(21,19),	"53.20" numeric(21,19),	"55.10" numeric(21,19),	"55.20" numeric(21,19),	"55.30" numeric(21,19),
    "55.90" numeric(21,19),	"56.10" numeric(21,19),	"56.21" numeric(21,19),	"56.29" numeric(21,19),	"56.30" numeric(21,19),	"58.11" numeric(21,19),	"58.12" numeric(21,19),
    "58.13" numeric(21,19),	"58.14" numeric(21,19),	"58.19" numeric(21,19),	"58.21" numeric(21,19),	"58.29" numeric(21,19),	"59.11" numeric(21,19),	"59.12" numeric(21,19),
    "59.13" numeric(21,19),	"59.14" numeric(21,19),	"59.20" numeric(21,19),	"60.10" numeric(21,19),	"60.20" numeric(21,19),	"61.10" numeric(21,19),	"61.20" numeric(21,19),
    "61.30" numeric(21,19),	"61.90" numeric(21,19),	"62.01" numeric(21,19),	"62.02" numeric(21,19),	"62.03" numeric(21,19),	"62.09" numeric(21,19),	"63.11" numeric(21,19),
    "63.12" numeric(21,19),	"63.91" numeric(21,19),	"63.99" numeric(21,19),	"64.11" numeric(21,19),	"64.19" numeric(21,19),	"64.20" numeric(21,19),	"64.30" numeric(21,19),
    "64.91" numeric(21,19),	"64.92" numeric(21,19),	"64.99" numeric(21,19),	"65.11" numeric(21,19),	"65.12" numeric(21,19),	"65.20" numeric(21,19),	"65.30" numeric(21,19),
    "66.11" numeric(21,19),	"66.12" numeric(21,19),	"66.19" numeric(21,19),	"66.21" numeric(21,19),	"66.22" numeric(21,19),	"66.29" numeric(21,19),	"66.30" numeric(21,19),
    "68.10" numeric(21,19),	"68.20" numeric(21,19),	"68.31" numeric(21,19),	"68.32" numeric(21,19),	"69.10" numeric(21,19),	"69.20" numeric(21,19),	"70.10" numeric(21,19),
    "70.21" numeric(21,19),	"70.22" numeric(21,19),	"71.11" numeric(21,19),	"71.12" numeric(21,19),	"71.20" numeric(21,19),	"72.11" numeric(21,19),	"72.19" numeric(21,19),
    "72.20" numeric(21,19),	"73.11" numeric(21,19),	"73.12" numeric(21,19),	"73.20" numeric(21,19),	"74.10" numeric(21,19),	"74.20" numeric(21,19),	"74.30" numeric(21,19),
    "74.90" numeric(21,19),	"75.00" numeric(21,19),	"77.11" numeric(21,19),	"77.12" numeric(21,19),	"77.21" numeric(21,19),	"77.22" numeric(21,19),	"77.29" numeric(21,19),
    "77.31" numeric(21,19),	"77.32" numeric(21,19),	"77.33" numeric(21,19),	"77.34" numeric(21,19),	"77.35" numeric(21,19),	"77.39" numeric(21,19),	"77.40" numeric(21,19),
    "78.10" numeric(21,19),	"78.20" numeric(21,19),	"78.30" numeric(21,19),	"79.11" numeric(21,19),	"79.12" numeric(21,19),	"79.90" numeric(21,19),	"80.10" numeric(21,19),
    "80.20" numeric(21,19),	"80.30" numeric(21,19),	"81.10" numeric(21,19),	"81.21" numeric(21,19),	"81.22" numeric(21,19),	"81.29" numeric(21,19),	"81.30" numeric(21,19),
    "82.11" numeric(21,19),	"82.19" numeric(21,19),	"82.20" numeric(21,19),	"82.30" numeric(21,19),	"82.91" numeric(21,19),	"82.92" numeric(21,19),	"82.99" numeric(21,19),
    "84.11" numeric(21,19),	"84.12" numeric(21,19),	"84.13" numeric(21,19),	"84.21" numeric(21,19),	"84.22" numeric(21,19),	"84.23" numeric(21,19),	"84.24" numeric(21,19),
    "84.25" numeric(21,19),	"84.30" numeric(21,19),	"85.10" numeric(21,19),	"85.20" numeric(21,19),	"85.31" numeric(21,19),	"85.32" numeric(21,19),	"85.41" numeric(21,19),
    "85.42" numeric(21,19),	"85.51" numeric(21,19),	"85.52" numeric(21,19),	"85.53" numeric(21,19),	"85.59" numeric(21,19),	"85.60" numeric(21,19),	"86.10" numeric(21,19),
    "86.21" numeric(21,19),	"86.22" numeric(21,19),	"86.23" numeric(21,19),	"86.90" numeric(21,19),	"87.10" numeric(21,19),	"87.20" numeric(21,19),	"87.30" numeric(21,19),
    "87.90" numeric(21,19),	"88.10" numeric(21,19),	"88.91" numeric(21,19),	"88.99" numeric(21,19),	"90.01" numeric(21,19),	"90.02" numeric(21,19),	"90.03" numeric(21,19),
    "90.04" numeric(21,19),	"91.01" numeric(21,19),	"91.02" numeric(21,19),	"91.03" numeric(21,19),	"91.04" numeric(21,19),	"92.00" numeric(21,19),	"93.11" numeric(21,19),
    "93.12" numeric(21,19),	"93.13" numeric(21,19),	"93.19" numeric(21,19),	"93.21" numeric(21,19),	"93.29" numeric(21,19),	"94.11" numeric(21,19),	"94.12" numeric(21,19),
    "94.20" numeric(21,19),	"94.91" numeric(21,19),	"94.92" numeric(21,19),	"94.99" numeric(21,19),	"95.11" numeric(21,19),	"95.12" numeric(21,19),	"95.21" numeric(21,19),
    "95.22" numeric(21,19),	"95.23" numeric(21,19),	"95.24" numeric(21,19),	"95.25" numeric(21,19),	"95.29" numeric(21,19),	"96.01" numeric(21,19),	"96.02" numeric(21,19),
    "96.03" numeric(21,19),	"96.04" numeric(21,19),	"96.09" numeric(21,19),	"97.00" numeric(21,19),	"98.10" numeric(21,19),	"98.20" numeric(21,19),	"W-Adj" numeric(21,19)
) ;

copy raw_iot_secteur_nace
    (
     nace,
     "01.11", "01.12", "01.13", "01.14", "01.15", "01.16", "01.19", "01.20", "01.21", "01.22", "01.23", "01.24", "01.25", "01.26",
     "01.27", "01.28", "01.29", "01.30", "01.41", "01.42", "01.43", "01.44", "01.45", "01.46", "01.47", "01.49", "01.50", "01.61",
     "01.62", "01.63", "01.64", "01.70", "02.10", "02.20", "02.30", "02.40", "03.11", "03.12", "03.21", "03.22", "05.10", "05.20",
     "06.10", "06.20", "07.10", "07.21", "07.29", "08.11", "08.12", "08.91", "08.92", "08.93", "08.99", "09.10", "09.90", "10.11",
     "10.12", "10.13", "10.20", "10.31", "10.32", "10.39", "10.41", "10.42", "10.51", "10.52", "10.61", "10.62", "10.71", "10.72",
     "10.73", "10.81", "10.82", "10.83", "10.84", "10.85", "10.86", "10.89", "10.91", "10.92", "11.01", "11.02", "11.03", "11.04",
     "11.05", "11.06", "11.07", "12.00", "13.10", "13.20", "13.30", "13.91", "13.92", "13.93", "13.94", "13.95", "13.96", "13.99",
     "14.11", "14.12", "14.13", "14.14", "14.19", "14.20", "14.31", "14.39", "15.11", "15.12", "15.20", "16.10", "16.21", "16.22",
     "16.23", "16.24", "16.29", "17.11", "17.12", "17.21", "17.22", "17.23", "17.24", "17.29", "18.11", "18.12", "18.13", "18.14",
     "18.20", "19.10", "19.20", "20.11", "20.12", "20.13", "20.14", "20.15", "20.16", "20.17", "20.20", "20.30", "20.41", "20.42",
     "20.51", "20.52", "20.53", "20.59", "20.60", "21.10", "21.20", "22.11", "22.19", "22.21", "22.22", "22.23", "22.29", "23.11",
     "23.12", "23.13", "23.14", "23.19", "23.20", "23.31", "23.32", "23.41", "23.42", "23.43", "23.44", "23.49", "23.51", "23.52",
     "23.61", "23.62", "23.63", "23.64", "23.65", "23.69", "23.70", "23.91", "23.99", "24.10", "24.20", "24.31", "24.32", "24.33",
     "24.34", "24.41", "24.42", "24.43", "24.44", "24.45", "24.46", "24.51", "24.52", "24.53", "24.54", "25.11", "25.12", "25.21",
     "25.29", "25.30", "25.40", "25.50", "25.61", "25.62", "25.71", "25.72", "25.73", "25.91", "25.92", "25.93", "25.94", "25.99",
     "26.11", "26.12", "26.20", "26.30", "26.40", "26.51", "26.52", "26.60", "26.70", "26.80", "27.11", "27.12", "27.20", "27.31",
     "27.32", "27.33", "27.40", "27.51", "27.52", "27.90", "28.11", "28.12", "28.13", "28.14", "28.15", "28.21", "28.22", "28.23",
     "28.24", "28.25", "28.29", "28.30", "28.41", "28.49", "28.91", "28.92", "28.93", "28.94", "28.95", "28.96", "28.99", "29.10",
     "29.20", "29.31", "29.32", "30.11", "30.12", "30.20", "30.30", "30.40", "30.91", "30.92", "30.99", "31.01", "31.02", "31.03",
     "31.09", "32.11", "32.12", "32.13", "32.20", "32.30", "32.40", "32.50", "32.91", "32.99", "33.11", "33.12", "33.13", "33.14",
     "33.15", "33.16", "33.17", "33.19", "33.20", "35.11", "35.12", "35.13", "35.14", "35.21", "35.22", "35.23", "35.30", "36.00",
     "37.00", "38.11", "38.12", "38.21", "38.22", "38.31", "38.32", "39.00", "41.10", "41.20", "42.11", "42.12", "42.13", "42.21",
     "42.22", "42.91", "42.99", "43.11", "43.12", "43.13", "43.21", "43.22", "43.29", "43.31", "43.32", "43.33", "43.34", "43.39",
     "43.91", "43.99", "45.11", "45.19", "45.20", "45.31", "45.32", "45.40", "46.11", "46.12", "46.13", "46.14", "46.15", "46.16",
     "46.17", "46.18", "46.19", "46.21", "46.22", "46.23", "46.24", "46.31", "46.32", "46.33", "46.34", "46.35", "46.36", "46.37",
     "46.38", "46.39", "46.41", "46.42", "46.43", "46.44", "46.45", "46.46", "46.47", "46.48", "46.49", "46.51", "46.52", "46.61",
     "46.62", "46.63", "46.64", "46.65", "46.66", "46.69", "46.71", "46.72", "46.73", "46.74", "46.75", "46.76", "46.77", "46.90",
     "47.11", "47.19", "47.21", "47.22", "47.23", "47.24", "47.25", "47.26", "47.29", "47.30", "47.41", "47.42", "47.43", "47.51",
     "47.52", "47.53", "47.54", "47.59", "47.61", "47.62", "47.63", "47.64", "47.65", "47.71", "47.72", "47.73", "47.74", "47.75",
     "47.76", "47.77", "47.78", "47.79", "47.81", "47.82", "47.89", "47.91", "47.99", "49.10", "49.20", "49.31", "49.32", "49.39",
     "49.41", "49.42", "49.50", "50.10", "50.20", "50.30", "50.40", "51.10", "51.21", "51.22", "52.10", "52.21", "52.22", "52.23",
     "52.24", "52.29", "53.10", "53.20", "55.10", "55.20", "55.30", "55.90", "56.10", "56.21", "56.29", "56.30", "58.11", "58.12",
     "58.13", "58.14", "58.19", "58.21", "58.29", "59.11", "59.12", "59.13", "59.14", "59.20", "60.10", "60.20", "61.10", "61.20",
     "61.30", "61.90", "62.01", "62.02", "62.03", "62.09", "63.11", "63.12", "63.91", "63.99", "64.11", "64.19", "64.20", "64.30",
     "64.91", "64.92", "64.99", "65.11", "65.12", "65.20", "65.30", "66.11", "66.12", "66.19", "66.21", "66.22", "66.29", "66.30",
     "68.10", "68.20", "68.31", "68.32", "69.10", "69.20", "70.10", "70.21", "70.22", "71.11", "71.12", "71.20", "72.11", "72.19",
     "72.20", "73.11", "73.12", "73.20", "74.10", "74.20", "74.30", "74.90", "75.00", "77.11", "77.12", "77.21", "77.22", "77.29",
     "77.31", "77.32", "77.33", "77.34", "77.35", "77.39", "77.40", "78.10", "78.20", "78.30", "79.11", "79.12", "79.90", "80.10",
     "80.20", "80.30", "81.10", "81.21", "81.22", "81.29", "81.30", "82.11", "82.19", "82.20", "82.30", "82.91", "82.92", "82.99",
     "84.11", "84.12", "84.13", "84.21", "84.22", "84.23", "84.24", "84.25", "84.30", "85.10", "85.20", "85.31", "85.32", "85.41",
     "85.42", "85.51", "85.52", "85.53", "85.59", "85.60", "86.10", "86.21", "86.22", "86.23", "86.90", "87.10", "87.20", "87.30",
     "87.90", "88.10", "88.91", "88.99", "90.01", "90.02", "90.03", "90.04", "91.01", "91.02", "91.03", "91.04", "92.00", "93.11",
     "93.12", "93.13", "93.19", "93.21", "93.29", "94.11", "94.12", "94.20", "94.91", "94.92", "94.99", "95.11", "95.12", "95.21",
     "95.22", "95.23", "95.24", "95.25", "95.29", "96.01", "96.02", "96.03", "96.04", "96.09", "97.00", "98.10", "98.20", "W-Adj"
        ) FROM '/srv/httpd/iat-api/sql/fixture/ci_naf.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';
create index raw_iot_secteur_nace_idx on raw_iot_secteur_nace(nace) ;

drop table if exists iot_production_nace ;

create table iot_production_nace
(
    nace varchar(5),
    dest varchar(5),
    qte numeric(21,19)
) ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '01.11' dest, "01.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.12' dest, "01.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.13' dest, "01.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.14' dest, "01.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.15' dest, "01.15" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.16' dest, "01.16" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.19' dest, "01.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.20' dest, "01.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.21' dest, "01.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.22' dest, "01.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.23' dest, "01.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.24' dest, "01.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.25' dest, "01.25" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.26' dest, "01.26" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.27' dest, "01.27" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.28' dest, "01.28" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.29' dest, "01.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.30' dest, "01.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.41' dest, "01.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.42' dest, "01.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.43' dest, "01.43" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.44' dest, "01.44" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.45' dest, "01.45" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.46' dest, "01.46" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.47' dest, "01.47" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.49' dest, "01.49" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.50' dest, "01.50" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.61' dest, "01.61" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.62' dest, "01.62" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.63' dest, "01.63" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.64' dest, "01.64" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '01.70' dest, "01.70" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '02.10' dest, "02.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '02.20' dest, "02.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '02.30' dest, "02.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '02.40' dest, "02.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '03.11' dest, "03.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '03.12' dest, "03.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '03.21' dest, "03.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '03.22' dest, "03.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '05.10' dest, "05.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '05.20' dest, "05.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '06.10' dest, "06.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '06.20' dest, "06.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '07.10' dest, "07.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '07.21' dest, "07.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '07.29' dest, "07.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '08.11' dest, "08.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '08.12' dest, "08.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '08.91' dest, "08.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '08.92' dest, "08.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '08.93' dest, "08.93" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '08.99' dest, "08.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '09.10' dest, "09.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '09.90' dest, "09.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.11' dest, "10.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.12' dest, "10.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.13' dest, "10.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.20' dest, "10.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.31' dest, "10.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.32' dest, "10.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.39' dest, "10.39" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.41' dest, "10.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.42' dest, "10.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.51' dest, "10.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.52' dest, "10.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.61' dest, "10.61" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.62' dest, "10.62" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.71' dest, "10.71" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.72' dest, "10.72" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.73' dest, "10.73" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.81' dest, "10.81" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.82' dest, "10.82" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.83' dest, "10.83" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.84' dest, "10.84" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.85' dest, "10.85" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.86' dest, "10.86" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.89' dest, "10.89" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.91' dest, "10.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '10.92' dest, "10.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '11.01' dest, "11.01" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '11.02' dest, "11.02" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '11.03' dest, "11.03" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '11.04' dest, "11.04" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '11.05' dest, "11.05" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '11.06' dest, "11.06" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '11.07' dest, "11.07" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '12.00' dest, "12.00" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.10' dest, "13.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.20' dest, "13.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.30' dest, "13.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.91' dest, "13.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.92' dest, "13.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.93' dest, "13.93" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.94' dest, "13.94" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.95' dest, "13.95" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.96' dest, "13.96" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '13.99' dest, "13.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '14.11' dest, "14.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '14.12' dest, "14.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '14.13' dest, "14.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '14.14' dest, "14.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '14.19' dest, "14.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '14.20' dest, "14.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '14.31' dest, "14.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '14.39' dest, "14.39" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '15.11' dest, "15.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '15.12' dest, "15.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '15.20' dest, "15.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '16.10' dest, "16.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '16.21' dest, "16.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '16.22' dest, "16.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '16.23' dest, "16.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '16.24' dest, "16.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '16.29' dest, "16.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '17.11' dest, "17.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '17.12' dest, "17.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '17.21' dest, "17.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '17.22' dest, "17.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '17.23' dest, "17.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '17.24' dest, "17.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '17.29' dest, "17.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '18.11' dest, "18.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '18.12' dest, "18.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '18.13' dest, "18.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '18.14' dest, "18.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '18.20' dest, "18.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '19.10' dest, "19.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '19.20' dest, "19.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.11' dest, "20.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.12' dest, "20.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.13' dest, "20.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.14' dest, "20.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.15' dest, "20.15" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.16' dest, "20.16" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.17' dest, "20.17" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.20' dest, "20.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.30' dest, "20.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.41' dest, "20.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.42' dest, "20.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.51' dest, "20.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.52' dest, "20.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.53' dest, "20.53" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.59' dest, "20.59" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '20.60' dest, "20.60" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '21.10' dest, "21.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '21.20' dest, "21.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '22.11' dest, "22.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '22.19' dest, "22.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '22.21' dest, "22.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '22.22' dest, "22.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '22.23' dest, "22.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '22.29' dest, "22.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '23.11' dest, "23.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.12' dest, "23.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.13' dest, "23.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.14' dest, "23.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.19' dest, "23.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.20' dest, "23.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.31' dest, "23.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.32' dest, "23.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.41' dest, "23.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.42' dest, "23.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.43' dest, "23.43" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.44' dest, "23.44" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.49' dest, "23.49" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.51' dest, "23.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.52' dest, "23.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.61' dest, "23.61" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.62' dest, "23.62" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.63' dest, "23.63" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.64' dest, "23.64" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.65' dest, "23.65" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.69' dest, "23.69" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.70' dest, "23.70" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.91' dest, "23.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '23.99' dest, "23.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.10' dest, "24.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.20' dest, "24.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.31' dest, "24.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.32' dest, "24.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.33' dest, "24.33" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.34' dest, "24.34" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.41' dest, "24.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.42' dest, "24.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.43' dest, "24.43" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.44' dest, "24.44" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.45' dest, "24.45" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.46' dest, "24.46" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.51' dest, "24.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.52' dest, "24.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.53' dest, "24.53" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '24.54' dest, "24.54" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.11' dest, "25.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.12' dest, "25.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.21' dest, "25.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.29' dest, "25.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.30' dest, "25.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.40' dest, "25.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.50' dest, "25.50" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.61' dest, "25.61" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.62' dest, "25.62" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.71' dest, "25.71" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.72' dest, "25.72" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '25.73' dest, "25.73" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.91' dest, "25.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.92' dest, "25.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.93' dest, "25.93" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.94' dest, "25.94" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '25.99' dest, "25.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.11' dest, "26.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.12' dest, "26.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.20' dest, "26.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.30' dest, "26.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.40' dest, "26.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.51' dest, "26.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.52' dest, "26.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.60' dest, "26.60" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.70' dest, "26.70" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '26.80' dest, "26.80" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.11' dest, "27.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.12' dest, "27.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.20' dest, "27.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.31' dest, "27.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.32' dest, "27.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.33' dest, "27.33" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.40' dest, "27.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.51' dest, "27.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.52' dest, "27.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '27.90' dest, "27.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.11' dest, "28.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.12' dest, "28.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.13' dest, "28.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.14' dest, "28.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.15' dest, "28.15" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.21' dest, "28.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.22' dest, "28.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.23' dest, "28.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.24' dest, "28.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.25' dest, "28.25" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.29' dest, "28.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.30' dest, "28.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.41' dest, "28.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.49' dest, "28.49" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.91' dest, "28.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.92' dest, "28.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.93' dest, "28.93" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.94' dest, "28.94" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.95' dest, "28.95" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.96' dest, "28.96" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '28.99' dest, "28.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '29.10' dest, "29.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '29.20' dest, "29.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '29.31' dest, "29.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '29.32' dest, "29.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '30.11' dest, "30.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '30.12' dest, "30.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '30.20' dest, "30.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '30.30' dest, "30.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '30.40' dest, "30.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '30.91' dest, "30.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '30.92' dest, "30.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '30.99' dest, "30.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '31.01' dest, "31.01" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '31.02' dest, "31.02" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '31.03' dest, "31.03" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '31.09' dest, "31.09" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.11' dest, "32.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.12' dest, "32.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.13' dest, "32.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.20' dest, "32.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.30' dest, "32.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.40' dest, "32.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.50' dest, "32.50" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.91' dest, "32.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '32.99' dest, "32.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.11' dest, "33.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.12' dest, "33.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.13' dest, "33.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.14' dest, "33.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.15' dest, "33.15" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.16' dest, "33.16" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.17' dest, "33.17" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.19' dest, "33.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '33.20' dest, "33.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '35.11' dest, "35.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '35.12' dest, "35.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '35.13' dest, "35.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '35.14' dest, "35.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '35.21' dest, "35.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '35.22' dest, "35.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '35.23' dest, "35.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '35.30' dest, "35.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '36.00' dest, "36.00" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '37.00' dest, "37.00" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '38.11' dest, "38.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '38.12' dest, "38.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '38.21' dest, "38.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '38.22' dest, "38.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '38.31' dest, "38.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '38.32' dest, "38.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '39.00' dest, "39.00" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '41.10' dest, "41.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '41.20' dest, "41.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '42.11' dest, "42.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '42.12' dest, "42.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '42.13' dest, "42.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '42.21' dest, "42.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '42.22' dest, "42.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '42.91' dest, "42.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '42.99' dest, "42.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.11' dest, "43.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.12' dest, "43.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.13' dest, "43.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.21' dest, "43.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.22' dest, "43.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.29' dest, "43.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.31' dest, "43.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.32' dest, "43.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.33' dest, "43.33" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.34' dest, "43.34" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.39' dest, "43.39" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.91' dest, "43.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '43.99' dest, "43.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '45.11' dest, "45.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '45.19' dest, "45.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '45.20' dest, "45.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '45.31' dest, "45.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '45.32' dest, "45.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '45.40' dest, "45.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.11' dest, "46.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.12' dest, "46.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.13' dest, "46.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.14' dest, "46.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.15' dest, "46.15" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.16' dest, "46.16" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.17' dest, "46.17" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.18' dest, "46.18" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.19' dest, "46.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.21' dest, "46.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.22' dest, "46.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.23' dest, "46.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.24' dest, "46.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.31' dest, "46.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.32' dest, "46.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.33' dest, "46.33" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.34' dest, "46.34" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.35' dest, "46.35" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.36' dest, "46.36" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.37' dest, "46.37" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.38' dest, "46.38" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.39' dest, "46.39" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.41' dest, "46.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.42' dest, "46.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.43' dest, "46.43" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.44' dest, "46.44" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.45' dest, "46.45" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '46.46' dest, "46.46" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.47' dest, "46.47" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.48' dest, "46.48" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.49' dest, "46.49" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.51' dest, "46.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.52' dest, "46.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.61' dest, "46.61" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.62' dest, "46.62" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.63' dest, "46.63" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.64' dest, "46.64" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.65' dest, "46.65" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.66' dest, "46.66" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.69' dest, "46.69" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.71' dest, "46.71" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.72' dest, "46.72" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.73' dest, "46.73" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.74' dest, "46.74" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.75' dest, "46.75" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.76' dest, "46.76" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.77' dest, "46.77" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '46.90' dest, "46.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.11' dest, "47.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.19' dest, "47.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.21' dest, "47.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.22' dest, "47.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.23' dest, "47.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.24' dest, "47.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.25' dest, "47.25" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.26' dest, "47.26" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.29' dest, "47.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.30' dest, "47.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.41' dest, "47.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.42' dest, "47.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.43' dest, "47.43" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.51' dest, "47.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.52' dest, "47.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.53' dest, "47.53" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.54' dest, "47.54" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.59' dest, "47.59" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.61' dest, "47.61" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.62' dest, "47.62" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.63' dest, "47.63" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.64' dest, "47.64" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.65' dest, "47.65" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.71' dest, "47.71" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.72' dest, "47.72" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.73' dest, "47.73" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.74' dest, "47.74" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.75' dest, "47.75" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.76' dest, "47.76" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.77' dest, "47.77" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '47.78' dest, "47.78" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.79' dest, "47.79" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.81' dest, "47.81" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.82' dest, "47.82" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.89' dest, "47.89" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.91' dest, "47.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '47.99' dest, "47.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '49.10' dest, "49.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '49.20' dest, "49.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '49.31' dest, "49.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '49.32' dest, "49.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '49.39' dest, "49.39" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '49.41' dest, "49.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '49.42' dest, "49.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '49.50' dest, "49.50" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '50.10' dest, "50.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '50.20' dest, "50.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '50.30' dest, "50.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '50.40' dest, "50.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '51.10' dest, "51.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '51.21' dest, "51.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '51.22' dest, "51.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '52.10' dest, "52.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '52.21' dest, "52.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '52.22' dest, "52.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '52.23' dest, "52.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '52.24' dest, "52.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '52.29' dest, "52.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '53.10' dest, "53.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '53.20' dest, "53.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '55.10' dest, "55.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '55.20' dest, "55.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '55.30' dest, "55.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '55.90' dest, "55.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '56.10' dest, "56.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '56.21' dest, "56.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '56.29' dest, "56.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '56.30' dest, "56.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '58.11' dest, "58.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '58.12' dest, "58.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '58.13' dest, "58.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '58.14' dest, "58.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '58.19' dest, "58.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '58.21' dest, "58.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '58.29' dest, "58.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '59.11' dest, "59.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '59.12' dest, "59.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '59.13' dest, "59.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '59.14' dest, "59.14" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '59.20' dest, "59.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '60.10' dest, "60.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '60.20' dest, "60.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '61.10' dest, "61.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '61.20' dest, "61.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '61.30' dest, "61.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '61.90' dest, "61.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '62.01' dest, "62.01" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '62.02' dest, "62.02" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '62.03' dest, "62.03" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '62.09' dest, "62.09" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '63.11' dest, "63.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '63.12' dest, "63.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '63.91' dest, "63.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '63.99' dest, "63.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '64.11' dest, "64.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '64.19' dest, "64.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '64.20' dest, "64.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '64.30' dest, "64.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '64.91' dest, "64.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '64.92' dest, "64.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '64.99' dest, "64.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '65.11' dest, "65.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '65.12' dest, "65.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '65.20' dest, "65.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '65.30' dest, "65.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '66.11' dest, "66.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '66.12' dest, "66.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '66.19' dest, "66.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '66.21' dest, "66.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '66.22' dest, "66.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '66.29' dest, "66.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '66.30' dest, "66.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '68.10' dest, "68.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '68.20' dest, "68.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '68.31' dest, "68.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '68.32' dest, "68.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '69.10' dest, "69.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '69.20' dest, "69.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '70.10' dest, "70.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '70.21' dest, "70.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '70.22' dest, "70.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '71.11' dest, "71.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '71.12' dest, "71.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '71.20' dest, "71.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '72.11' dest, "72.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '72.19' dest, "72.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '72.20' dest, "72.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '73.11' dest, "73.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '73.12' dest, "73.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '73.20' dest, "73.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '74.10' dest, "74.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '74.20' dest, "74.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '74.30' dest, "74.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '74.90' dest, "74.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '75.00' dest, "75.00" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.11' dest, "77.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.12' dest, "77.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.21' dest, "77.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.22' dest, "77.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.29' dest, "77.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.31' dest, "77.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.32' dest, "77.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.33' dest, "77.33" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.34' dest, "77.34" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.35' dest, "77.35" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.39' dest, "77.39" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '77.40' dest, "77.40" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '78.10' dest, "78.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '78.20' dest, "78.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '78.30' dest, "78.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '79.11' dest, "79.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '79.12' dest, "79.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '79.90' dest, "79.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '80.10' dest, "80.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '80.20' dest, "80.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '80.30' dest, "80.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '81.10' dest, "81.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '81.21' dest, "81.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '81.22' dest, "81.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '81.29' dest, "81.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '81.30' dest, "81.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '82.11' dest, "82.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '82.19' dest, "82.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '82.20' dest, "82.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '82.30' dest, "82.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '82.91' dest, "82.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '82.92' dest, "82.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '82.99' dest, "82.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.11' dest, "84.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.12' dest, "84.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.13' dest, "84.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.21' dest, "84.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.22' dest, "84.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.23' dest, "84.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.24' dest, "84.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.25' dest, "84.25" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '84.30' dest, "84.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.10' dest, "85.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.20' dest, "85.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.31' dest, "85.31" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.32' dest, "85.32" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.41' dest, "85.41" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.42' dest, "85.42" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0 ;

insert into iot_production_nace(nace, dest, qte)
select t.nace, t.dest, t.qte
from (
         with c as (
             select nace
             from raw_iot_secteur_nace
         )
         select c.nace, '85.51' dest, "85.51" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.52' dest, "85.52" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.53' dest, "85.53" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.59' dest, "85.59" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '85.60' dest, "85.60" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '86.10' dest, "86.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '86.21' dest, "86.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '86.22' dest, "86.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '86.23' dest, "86.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '86.90' dest, "86.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '87.10' dest, "87.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '87.20' dest, "87.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '87.30' dest, "87.30" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '87.90' dest, "87.90" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '88.10' dest, "88.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '88.91' dest, "88.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '88.99' dest, "88.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '90.01' dest, "90.01" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '90.02' dest, "90.02" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '90.03' dest, "90.03" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '90.04' dest, "90.04" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '91.01' dest, "91.01" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '91.02' dest, "91.02" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '91.03' dest, "91.03" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '91.04' dest, "91.04" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '92.00' dest, "92.00" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '93.11' dest, "93.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '93.12' dest, "93.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '93.13' dest, "93.13" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '93.19' dest, "93.19" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '93.21' dest, "93.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '93.29' dest, "93.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '94.11' dest, "94.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '94.12' dest, "94.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '94.20' dest, "94.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '94.91' dest, "94.91" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '94.92' dest, "94.92" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '94.99' dest, "94.99" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '95.11' dest, "95.11" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '95.12' dest, "95.12" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '95.21' dest, "95.21" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '95.22' dest, "95.22" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '95.23' dest, "95.23" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '95.24' dest, "95.24" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '95.25' dest, "95.25" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '95.29' dest, "95.29" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '96.01' dest, "96.01" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '96.02' dest, "96.02" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '96.03' dest, "96.03" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '96.04' dest, "96.04" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '96.09' dest, "96.09" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '97.00' dest, "97.00" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '98.10' dest, "98.10" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, '98.20' dest, "98.20" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
         union all select c.nace, 'W-Adj' dest, "W-Adj" qte from c inner join raw_iot_secteur_nace n on n.nace=c.nace
     ) t
where t.qte > 0;

create index iot_production_nace_idx on iot_production_nace(nace) ;

drop table if exists iot_consume_nace ;

create table iot_consume_nace
(
    nace varchar(5),
    dest varchar(5),
    qte numeric(21,19)
) ;

insert into iot_consume_nace(nace, dest, qte)
select nace, dest, qte
from (
         select nace dest, '01.11' nace, "01.11" qte from raw_iot_secteur_nace
         union all select nace dest, '01.12' nace, "01.12" qte from raw_iot_secteur_nace
         union all select nace dest, '01.13' nace, "01.13" qte from raw_iot_secteur_nace
         union all select nace dest, '01.14' nace, "01.14" qte from raw_iot_secteur_nace
         union all select nace dest, '01.15' nace, "01.15" qte from raw_iot_secteur_nace
         union all select nace dest, '01.16' nace, "01.16" qte from raw_iot_secteur_nace
         union all select nace dest, '01.19' nace, "01.19" qte from raw_iot_secteur_nace
         union all select nace dest, '01.20' nace, "01.20" qte from raw_iot_secteur_nace
         union all select nace dest, '01.21' nace, "01.21" qte from raw_iot_secteur_nace
         union all select nace dest, '01.22' nace, "01.22" qte from raw_iot_secteur_nace
         union all select nace dest, '01.23' nace, "01.23" qte from raw_iot_secteur_nace
         union all select nace dest, '01.24' nace, "01.24" qte from raw_iot_secteur_nace
         union all select nace dest, '01.25' nace, "01.25" qte from raw_iot_secteur_nace
         union all select nace dest, '01.26' nace, "01.26" qte from raw_iot_secteur_nace
         union all select nace dest, '01.27' nace, "01.27" qte from raw_iot_secteur_nace
         union all select nace dest, '01.28' nace, "01.28" qte from raw_iot_secteur_nace
         union all select nace dest, '01.29' nace, "01.29" qte from raw_iot_secteur_nace
         union all select nace dest, '01.30' nace, "01.30" qte from raw_iot_secteur_nace
         union all select nace dest, '01.41' nace, "01.41" qte from raw_iot_secteur_nace
         union all select nace dest, '01.42' nace, "01.42" qte from raw_iot_secteur_nace
         union all select nace dest, '01.43' nace, "01.43" qte from raw_iot_secteur_nace
         union all select nace dest, '01.44' nace, "01.44" qte from raw_iot_secteur_nace
         union all select nace dest, '01.45' nace, "01.45" qte from raw_iot_secteur_nace
         union all select nace dest, '01.46' nace, "01.46" qte from raw_iot_secteur_nace
         union all select nace dest, '01.47' nace, "01.47" qte from raw_iot_secteur_nace
         union all select nace dest, '01.49' nace, "01.49" qte from raw_iot_secteur_nace
         union all select nace dest, '01.50' nace, "01.50" qte from raw_iot_secteur_nace
         union all select nace dest, '01.61' nace, "01.61" qte from raw_iot_secteur_nace
         union all select nace dest, '01.62' nace, "01.62" qte from raw_iot_secteur_nace
         union all select nace dest, '01.63' nace, "01.63" qte from raw_iot_secteur_nace
         union all select nace dest, '01.64' nace, "01.64" qte from raw_iot_secteur_nace
         union all select nace dest, '01.70' nace, "01.70" qte from raw_iot_secteur_nace
         union all select nace dest, '02.10' nace, "02.10" qte from raw_iot_secteur_nace
         union all select nace dest, '02.20' nace, "02.20" qte from raw_iot_secteur_nace
         union all select nace dest, '02.30' nace, "02.30" qte from raw_iot_secteur_nace
         union all select nace dest, '02.40' nace, "02.40" qte from raw_iot_secteur_nace
         union all select nace dest, '03.11' nace, "03.11" qte from raw_iot_secteur_nace
         union all select nace dest, '03.12' nace, "03.12" qte from raw_iot_secteur_nace
         union all select nace dest, '03.21' nace, "03.21" qte from raw_iot_secteur_nace
         union all select nace dest, '03.22' nace, "03.22" qte from raw_iot_secteur_nace
         union all select nace dest, '05.10' nace, "05.10" qte from raw_iot_secteur_nace
         union all select nace dest, '05.20' nace, "05.20" qte from raw_iot_secteur_nace
         union all select nace dest, '06.10' nace, "06.10" qte from raw_iot_secteur_nace
         union all select nace dest, '06.20' nace, "06.20" qte from raw_iot_secteur_nace
         union all select nace dest, '07.10' nace, "07.10" qte from raw_iot_secteur_nace
         union all select nace dest, '07.21' nace, "07.21" qte from raw_iot_secteur_nace
         union all select nace dest, '07.29' nace, "07.29" qte from raw_iot_secteur_nace
         union all select nace dest, '08.11' nace, "08.11" qte from raw_iot_secteur_nace
         union all select nace dest, '08.12' nace, "08.12" qte from raw_iot_secteur_nace
         union all select nace dest, '08.91' nace, "08.91" qte from raw_iot_secteur_nace
         union all select nace dest, '08.92' nace, "08.92" qte from raw_iot_secteur_nace
         union all select nace dest, '08.93' nace, "08.93" qte from raw_iot_secteur_nace
         union all select nace dest, '08.99' nace, "08.99" qte from raw_iot_secteur_nace
         union all select nace dest, '09.10' nace, "09.10" qte from raw_iot_secteur_nace
         union all select nace dest, '09.90' nace, "09.90" qte from raw_iot_secteur_nace
         union all select nace dest, '10.11' nace, "10.11" qte from raw_iot_secteur_nace
         union all select nace dest, '10.12' nace, "10.12" qte from raw_iot_secteur_nace
         union all select nace dest, '10.13' nace, "10.13" qte from raw_iot_secteur_nace
         union all select nace dest, '10.20' nace, "10.20" qte from raw_iot_secteur_nace
         union all select nace dest, '10.31' nace, "10.31" qte from raw_iot_secteur_nace
         union all select nace dest, '10.32' nace, "10.32" qte from raw_iot_secteur_nace
         union all select nace dest, '10.39' nace, "10.39" qte from raw_iot_secteur_nace
         union all select nace dest, '10.41' nace, "10.41" qte from raw_iot_secteur_nace
         union all select nace dest, '10.42' nace, "10.42" qte from raw_iot_secteur_nace
         union all select nace dest, '10.51' nace, "10.51" qte from raw_iot_secteur_nace
         union all select nace dest, '10.52' nace, "10.52" qte from raw_iot_secteur_nace
         union all select nace dest, '10.61' nace, "10.61" qte from raw_iot_secteur_nace
         union all select nace dest, '10.62' nace, "10.62" qte from raw_iot_secteur_nace
         union all select nace dest, '10.71' nace, "10.71" qte from raw_iot_secteur_nace
         union all select nace dest, '10.72' nace, "10.72" qte from raw_iot_secteur_nace
         union all select nace dest, '10.73' nace, "10.73" qte from raw_iot_secteur_nace
         union all select nace dest, '10.81' nace, "10.81" qte from raw_iot_secteur_nace
         union all select nace dest, '10.82' nace, "10.82" qte from raw_iot_secteur_nace
         union all select nace dest, '10.83' nace, "10.83" qte from raw_iot_secteur_nace
         union all select nace dest, '10.84' nace, "10.84" qte from raw_iot_secteur_nace
         union all select nace dest, '10.85' nace, "10.85" qte from raw_iot_secteur_nace
         union all select nace dest, '10.86' nace, "10.86" qte from raw_iot_secteur_nace
         union all select nace dest, '10.89' nace, "10.89" qte from raw_iot_secteur_nace
         union all select nace dest, '10.91' nace, "10.91" qte from raw_iot_secteur_nace
         union all select nace dest, '10.92' nace, "10.92" qte from raw_iot_secteur_nace
         union all select nace dest, '11.01' nace, "11.01" qte from raw_iot_secteur_nace
         union all select nace dest, '11.02' nace, "11.02" qte from raw_iot_secteur_nace
         union all select nace dest, '11.03' nace, "11.03" qte from raw_iot_secteur_nace
         union all select nace dest, '11.04' nace, "11.04" qte from raw_iot_secteur_nace
         union all select nace dest, '11.05' nace, "11.05" qte from raw_iot_secteur_nace
         union all select nace dest, '11.06' nace, "11.06" qte from raw_iot_secteur_nace
         union all select nace dest, '11.07' nace, "11.07" qte from raw_iot_secteur_nace
         union all select nace dest, '12.00' nace, "12.00" qte from raw_iot_secteur_nace
         union all select nace dest, '13.10' nace, "13.10" qte from raw_iot_secteur_nace
         union all select nace dest, '13.20' nace, "13.20" qte from raw_iot_secteur_nace
         union all select nace dest, '13.30' nace, "13.30" qte from raw_iot_secteur_nace
         union all select nace dest, '13.91' nace, "13.91" qte from raw_iot_secteur_nace
         union all select nace dest, '13.92' nace, "13.92" qte from raw_iot_secteur_nace
         union all select nace dest, '13.93' nace, "13.93" qte from raw_iot_secteur_nace
         union all select nace dest, '13.94' nace, "13.94" qte from raw_iot_secteur_nace
         union all select nace dest, '13.95' nace, "13.95" qte from raw_iot_secteur_nace
         union all select nace dest, '13.96' nace, "13.96" qte from raw_iot_secteur_nace
         union all select nace dest, '13.99' nace, "13.99" qte from raw_iot_secteur_nace
         union all select nace dest, '14.11' nace, "14.11" qte from raw_iot_secteur_nace
         union all select nace dest, '14.12' nace, "14.12" qte from raw_iot_secteur_nace
         union all select nace dest, '14.13' nace, "14.13" qte from raw_iot_secteur_nace
     ) t
where t.qte>0 ;

insert into iot_consume_nace(nace, dest, qte)
select nace, dest, qte
from (
         select nace dest, '14.14' nace, "14.14" qte from raw_iot_secteur_nace
         union all select nace dest, '14.19' nace, "14.19" qte from raw_iot_secteur_nace
         union all select nace dest, '14.20' nace, "14.20" qte from raw_iot_secteur_nace
         union all select nace dest, '14.31' nace, "14.31" qte from raw_iot_secteur_nace
         union all select nace dest, '14.39' nace, "14.39" qte from raw_iot_secteur_nace
         union all select nace dest, '15.11' nace, "15.11" qte from raw_iot_secteur_nace
         union all select nace dest, '15.12' nace, "15.12" qte from raw_iot_secteur_nace
         union all select nace dest, '15.20' nace, "15.20" qte from raw_iot_secteur_nace
         union all select nace dest, '16.10' nace, "16.10" qte from raw_iot_secteur_nace
         union all select nace dest, '16.21' nace, "16.21" qte from raw_iot_secteur_nace
         union all select nace dest, '16.22' nace, "16.22" qte from raw_iot_secteur_nace
         union all select nace dest, '16.23' nace, "16.23" qte from raw_iot_secteur_nace
         union all select nace dest, '16.24' nace, "16.24" qte from raw_iot_secteur_nace
         union all select nace dest, '16.29' nace, "16.29" qte from raw_iot_secteur_nace
         union all select nace dest, '17.11' nace, "17.11" qte from raw_iot_secteur_nace
         union all select nace dest, '17.12' nace, "17.12" qte from raw_iot_secteur_nace
         union all select nace dest, '17.21' nace, "17.21" qte from raw_iot_secteur_nace
         union all select nace dest, '17.22' nace, "17.22" qte from raw_iot_secteur_nace
         union all select nace dest, '17.23' nace, "17.23" qte from raw_iot_secteur_nace
         union all select nace dest, '17.24' nace, "17.24" qte from raw_iot_secteur_nace
         union all select nace dest, '17.29' nace, "17.29" qte from raw_iot_secteur_nace
         union all select nace dest, '18.11' nace, "18.11" qte from raw_iot_secteur_nace
         union all select nace dest, '18.12' nace, "18.12" qte from raw_iot_secteur_nace
         union all select nace dest, '18.13' nace, "18.13" qte from raw_iot_secteur_nace
         union all select nace dest, '18.14' nace, "18.14" qte from raw_iot_secteur_nace
         union all select nace dest, '18.20' nace, "18.20" qte from raw_iot_secteur_nace
         union all select nace dest, '19.10' nace, "19.10" qte from raw_iot_secteur_nace
         union all select nace dest, '19.20' nace, "19.20" qte from raw_iot_secteur_nace
         union all select nace dest, '20.11' nace, "20.11" qte from raw_iot_secteur_nace
         union all select nace dest, '20.12' nace, "20.12" qte from raw_iot_secteur_nace
         union all select nace dest, '20.13' nace, "20.13" qte from raw_iot_secteur_nace
         union all select nace dest, '20.14' nace, "20.14" qte from raw_iot_secteur_nace
         union all select nace dest, '20.15' nace, "20.15" qte from raw_iot_secteur_nace
         union all select nace dest, '20.16' nace, "20.16" qte from raw_iot_secteur_nace
         union all select nace dest, '20.17' nace, "20.17" qte from raw_iot_secteur_nace
         union all select nace dest, '20.20' nace, "20.20" qte from raw_iot_secteur_nace
         union all select nace dest, '20.30' nace, "20.30" qte from raw_iot_secteur_nace
         union all select nace dest, '20.41' nace, "20.41" qte from raw_iot_secteur_nace
         union all select nace dest, '20.42' nace, "20.42" qte from raw_iot_secteur_nace
         union all select nace dest, '20.51' nace, "20.51" qte from raw_iot_secteur_nace
         union all select nace dest, '20.52' nace, "20.52" qte from raw_iot_secteur_nace
         union all select nace dest, '20.53' nace, "20.53" qte from raw_iot_secteur_nace
         union all select nace dest, '20.59' nace, "20.59" qte from raw_iot_secteur_nace
         union all select nace dest, '20.60' nace, "20.60" qte from raw_iot_secteur_nace
         union all select nace dest, '21.10' nace, "21.10" qte from raw_iot_secteur_nace
         union all select nace dest, '21.20' nace, "21.20" qte from raw_iot_secteur_nace
         union all select nace dest, '22.11' nace, "22.11" qte from raw_iot_secteur_nace
         union all select nace dest, '22.19' nace, "22.19" qte from raw_iot_secteur_nace
         union all select nace dest, '22.21' nace, "22.21" qte from raw_iot_secteur_nace
         union all select nace dest, '22.22' nace, "22.22" qte from raw_iot_secteur_nace
         union all select nace dest, '22.23' nace, "22.23" qte from raw_iot_secteur_nace
         union all select nace dest, '22.29' nace, "22.29" qte from raw_iot_secteur_nace
         union all select nace dest, '23.11' nace, "23.11" qte from raw_iot_secteur_nace
         union all select nace dest, '23.12' nace, "23.12" qte from raw_iot_secteur_nace
         union all select nace dest, '23.13' nace, "23.13" qte from raw_iot_secteur_nace
         union all select nace dest, '23.14' nace, "23.14" qte from raw_iot_secteur_nace
         union all select nace dest, '23.19' nace, "23.19" qte from raw_iot_secteur_nace
         union all select nace dest, '23.20' nace, "23.20" qte from raw_iot_secteur_nace
         union all select nace dest, '23.31' nace, "23.31" qte from raw_iot_secteur_nace
         union all select nace dest, '23.32' nace, "23.32" qte from raw_iot_secteur_nace
         union all select nace dest, '23.41' nace, "23.41" qte from raw_iot_secteur_nace
         union all select nace dest, '23.42' nace, "23.42" qte from raw_iot_secteur_nace
         union all select nace dest, '23.43' nace, "23.43" qte from raw_iot_secteur_nace
         union all select nace dest, '23.44' nace, "23.44" qte from raw_iot_secteur_nace
         union all select nace dest, '23.49' nace, "23.49" qte from raw_iot_secteur_nace
         union all select nace dest, '23.51' nace, "23.51" qte from raw_iot_secteur_nace
         union all select nace dest, '23.52' nace, "23.52" qte from raw_iot_secteur_nace
         union all select nace dest, '23.61' nace, "23.61" qte from raw_iot_secteur_nace
         union all select nace dest, '23.62' nace, "23.62" qte from raw_iot_secteur_nace
         union all select nace dest, '23.63' nace, "23.63" qte from raw_iot_secteur_nace
         union all select nace dest, '23.64' nace, "23.64" qte from raw_iot_secteur_nace
         union all select nace dest, '23.65' nace, "23.65" qte from raw_iot_secteur_nace
         union all select nace dest, '23.69' nace, "23.69" qte from raw_iot_secteur_nace
         union all select nace dest, '23.70' nace, "23.70" qte from raw_iot_secteur_nace
         union all select nace dest, '23.91' nace, "23.91" qte from raw_iot_secteur_nace
         union all select nace dest, '23.99' nace, "23.99" qte from raw_iot_secteur_nace
         union all select nace dest, '24.10' nace, "24.10" qte from raw_iot_secteur_nace
         union all select nace dest, '24.20' nace, "24.20" qte from raw_iot_secteur_nace
         union all select nace dest, '24.31' nace, "24.31" qte from raw_iot_secteur_nace
         union all select nace dest, '24.32' nace, "24.32" qte from raw_iot_secteur_nace
         union all select nace dest, '24.33' nace, "24.33" qte from raw_iot_secteur_nace
         union all select nace dest, '24.34' nace, "24.34" qte from raw_iot_secteur_nace
         union all select nace dest, '24.41' nace, "24.41" qte from raw_iot_secteur_nace
         union all select nace dest, '24.42' nace, "24.42" qte from raw_iot_secteur_nace
         union all select nace dest, '24.43' nace, "24.43" qte from raw_iot_secteur_nace
         union all select nace dest, '24.44' nace, "24.44" qte from raw_iot_secteur_nace
         union all select nace dest, '24.45' nace, "24.45" qte from raw_iot_secteur_nace
         union all select nace dest, '24.46' nace, "24.46" qte from raw_iot_secteur_nace
         union all select nace dest, '24.51' nace, "24.51" qte from raw_iot_secteur_nace
         union all select nace dest, '24.52' nace, "24.52" qte from raw_iot_secteur_nace
         union all select nace dest, '24.53' nace, "24.53" qte from raw_iot_secteur_nace
         union all select nace dest, '24.54' nace, "24.54" qte from raw_iot_secteur_nace
         union all select nace dest, '25.11' nace, "25.11" qte from raw_iot_secteur_nace
         union all select nace dest, '25.12' nace, "25.12" qte from raw_iot_secteur_nace
         union all select nace dest, '25.21' nace, "25.21" qte from raw_iot_secteur_nace
         union all select nace dest, '25.29' nace, "25.29" qte from raw_iot_secteur_nace
         union all select nace dest, '25.30' nace, "25.30" qte from raw_iot_secteur_nace
         union all select nace dest, '25.40' nace, "25.40" qte from raw_iot_secteur_nace
         union all select nace dest, '25.50' nace, "25.50" qte from raw_iot_secteur_nace
         union all select nace dest, '25.61' nace, "25.61" qte from raw_iot_secteur_nace
         union all select nace dest, '25.62' nace, "25.62" qte from raw_iot_secteur_nace
     ) t
where t.qte>0 ;

insert into iot_consume_nace(nace, dest, qte)
select nace, dest, qte
from (
         select nace dest, '25.71' nace, "25.71" qte from raw_iot_secteur_nace
         union all select nace dest, '25.72' nace, "25.72" qte from raw_iot_secteur_nace
         union all select nace dest, '25.73' nace, "25.73" qte from raw_iot_secteur_nace
         union all select nace dest, '25.91' nace, "25.91" qte from raw_iot_secteur_nace
         union all select nace dest, '25.92' nace, "25.92" qte from raw_iot_secteur_nace
         union all select nace dest, '25.93' nace, "25.93" qte from raw_iot_secteur_nace
         union all select nace dest, '25.94' nace, "25.94" qte from raw_iot_secteur_nace
         union all select nace dest, '25.99' nace, "25.99" qte from raw_iot_secteur_nace
         union all select nace dest, '26.11' nace, "26.11" qte from raw_iot_secteur_nace
         union all select nace dest, '26.12' nace, "26.12" qte from raw_iot_secteur_nace
         union all select nace dest, '26.20' nace, "26.20" qte from raw_iot_secteur_nace
         union all select nace dest, '26.30' nace, "26.30" qte from raw_iot_secteur_nace
         union all select nace dest, '26.40' nace, "26.40" qte from raw_iot_secteur_nace
         union all select nace dest, '26.51' nace, "26.51" qte from raw_iot_secteur_nace
         union all select nace dest, '26.52' nace, "26.52" qte from raw_iot_secteur_nace
         union all select nace dest, '26.60' nace, "26.60" qte from raw_iot_secteur_nace
         union all select nace dest, '26.70' nace, "26.70" qte from raw_iot_secteur_nace
         union all select nace dest, '26.80' nace, "26.80" qte from raw_iot_secteur_nace
         union all select nace dest, '27.11' nace, "27.11" qte from raw_iot_secteur_nace
         union all select nace dest, '27.12' nace, "27.12" qte from raw_iot_secteur_nace
         union all select nace dest, '27.20' nace, "27.20" qte from raw_iot_secteur_nace
         union all select nace dest, '27.31' nace, "27.31" qte from raw_iot_secteur_nace
         union all select nace dest, '27.32' nace, "27.32" qte from raw_iot_secteur_nace
         union all select nace dest, '27.33' nace, "27.33" qte from raw_iot_secteur_nace
         union all select nace dest, '27.40' nace, "27.40" qte from raw_iot_secteur_nace
         union all select nace dest, '27.51' nace, "27.51" qte from raw_iot_secteur_nace
         union all select nace dest, '27.52' nace, "27.52" qte from raw_iot_secteur_nace
         union all select nace dest, '27.90' nace, "27.90" qte from raw_iot_secteur_nace
         union all select nace dest, '28.11' nace, "28.11" qte from raw_iot_secteur_nace
         union all select nace dest, '28.12' nace, "28.12" qte from raw_iot_secteur_nace
         union all select nace dest, '28.13' nace, "28.13" qte from raw_iot_secteur_nace
         union all select nace dest, '28.14' nace, "28.14" qte from raw_iot_secteur_nace
         union all select nace dest, '28.15' nace, "28.15" qte from raw_iot_secteur_nace
         union all select nace dest, '28.21' nace, "28.21" qte from raw_iot_secteur_nace
         union all select nace dest, '28.22' nace, "28.22" qte from raw_iot_secteur_nace
         union all select nace dest, '28.23' nace, "28.23" qte from raw_iot_secteur_nace
         union all select nace dest, '28.24' nace, "28.24" qte from raw_iot_secteur_nace
         union all select nace dest, '28.25' nace, "28.25" qte from raw_iot_secteur_nace
         union all select nace dest, '28.29' nace, "28.29" qte from raw_iot_secteur_nace
         union all select nace dest, '28.30' nace, "28.30" qte from raw_iot_secteur_nace
         union all select nace dest, '28.41' nace, "28.41" qte from raw_iot_secteur_nace
         union all select nace dest, '28.49' nace, "28.49" qte from raw_iot_secteur_nace
         union all select nace dest, '28.91' nace, "28.91" qte from raw_iot_secteur_nace
         union all select nace dest, '28.92' nace, "28.92" qte from raw_iot_secteur_nace
         union all select nace dest, '28.93' nace, "28.93" qte from raw_iot_secteur_nace
         union all select nace dest, '28.94' nace, "28.94" qte from raw_iot_secteur_nace
         union all select nace dest, '28.95' nace, "28.95" qte from raw_iot_secteur_nace
         union all select nace dest, '28.96' nace, "28.96" qte from raw_iot_secteur_nace
         union all select nace dest, '28.99' nace, "28.99" qte from raw_iot_secteur_nace
         union all select nace dest, '29.10' nace, "29.10" qte from raw_iot_secteur_nace
         union all select nace dest, '29.20' nace, "29.20" qte from raw_iot_secteur_nace
         union all select nace dest, '29.31' nace, "29.31" qte from raw_iot_secteur_nace
         union all select nace dest, '29.32' nace, "29.32" qte from raw_iot_secteur_nace
         union all select nace dest, '30.11' nace, "30.11" qte from raw_iot_secteur_nace
         union all select nace dest, '30.12' nace, "30.12" qte from raw_iot_secteur_nace
         union all select nace dest, '30.20' nace, "30.20" qte from raw_iot_secteur_nace
         union all select nace dest, '30.30' nace, "30.30" qte from raw_iot_secteur_nace
         union all select nace dest, '30.40' nace, "30.40" qte from raw_iot_secteur_nace
         union all select nace dest, '30.91' nace, "30.91" qte from raw_iot_secteur_nace
         union all select nace dest, '30.92' nace, "30.92" qte from raw_iot_secteur_nace
         union all select nace dest, '30.99' nace, "30.99" qte from raw_iot_secteur_nace
         union all select nace dest, '31.01' nace, "31.01" qte from raw_iot_secteur_nace
         union all select nace dest, '31.02' nace, "31.02" qte from raw_iot_secteur_nace
         union all select nace dest, '31.03' nace, "31.03" qte from raw_iot_secteur_nace
         union all select nace dest, '31.09' nace, "31.09" qte from raw_iot_secteur_nace
         union all select nace dest, '32.11' nace, "32.11" qte from raw_iot_secteur_nace
         union all select nace dest, '32.12' nace, "32.12" qte from raw_iot_secteur_nace
         union all select nace dest, '32.13' nace, "32.13" qte from raw_iot_secteur_nace
         union all select nace dest, '32.20' nace, "32.20" qte from raw_iot_secteur_nace
         union all select nace dest, '32.30' nace, "32.30" qte from raw_iot_secteur_nace
         union all select nace dest, '32.40' nace, "32.40" qte from raw_iot_secteur_nace
         union all select nace dest, '32.50' nace, "32.50" qte from raw_iot_secteur_nace
         union all select nace dest, '32.91' nace, "32.91" qte from raw_iot_secteur_nace
         union all select nace dest, '32.99' nace, "32.99" qte from raw_iot_secteur_nace
         union all select nace dest, '33.11' nace, "33.11" qte from raw_iot_secteur_nace
         union all select nace dest, '33.12' nace, "33.12" qte from raw_iot_secteur_nace
         union all select nace dest, '33.13' nace, "33.13" qte from raw_iot_secteur_nace
         union all select nace dest, '33.14' nace, "33.14" qte from raw_iot_secteur_nace
         union all select nace dest, '33.15' nace, "33.15" qte from raw_iot_secteur_nace
         union all select nace dest, '33.16' nace, "33.16" qte from raw_iot_secteur_nace
         union all select nace dest, '33.17' nace, "33.17" qte from raw_iot_secteur_nace
         union all select nace dest, '33.19' nace, "33.19" qte from raw_iot_secteur_nace
         union all select nace dest, '33.20' nace, "33.20" qte from raw_iot_secteur_nace
         union all select nace dest, '35.11' nace, "35.11" qte from raw_iot_secteur_nace
         union all select nace dest, '35.12' nace, "35.12" qte from raw_iot_secteur_nace
         union all select nace dest, '35.13' nace, "35.13" qte from raw_iot_secteur_nace
         union all select nace dest, '35.14' nace, "35.14" qte from raw_iot_secteur_nace
         union all select nace dest, '35.21' nace, "35.21" qte from raw_iot_secteur_nace
         union all select nace dest, '35.22' nace, "35.22" qte from raw_iot_secteur_nace
         union all select nace dest, '35.23' nace, "35.23" qte from raw_iot_secteur_nace
         union all select nace dest, '35.30' nace, "35.30" qte from raw_iot_secteur_nace
         union all select nace dest, '36.00' nace, "36.00" qte from raw_iot_secteur_nace
         union all select nace dest, '37.00' nace, "37.00" qte from raw_iot_secteur_nace
         union all select nace dest, '38.11' nace, "38.11" qte from raw_iot_secteur_nace
         union all select nace dest, '38.12' nace, "38.12" qte from raw_iot_secteur_nace
         union all select nace dest, '38.21' nace, "38.21" qte from raw_iot_secteur_nace
         union all select nace dest, '38.22' nace, "38.22" qte from raw_iot_secteur_nace
         union all select nace dest, '38.31' nace, "38.31" qte from raw_iot_secteur_nace
         union all select nace dest, '38.32' nace, "38.32" qte from raw_iot_secteur_nace
         union all select nace dest, '39.00' nace, "39.00" qte from raw_iot_secteur_nace
         union all select nace dest, '41.10' nace, "41.10" qte from raw_iot_secteur_nace
     ) t
where t.qte>0 ;

insert into iot_consume_nace(nace, dest, qte)
select nace, dest, qte
from (
         select nace dest, '41.20' nace, "41.20" qte from raw_iot_secteur_nace
         union all select nace dest, '42.11' nace, "42.11" qte from raw_iot_secteur_nace
         union all select nace dest, '42.12' nace, "42.12" qte from raw_iot_secteur_nace
         union all select nace dest, '42.13' nace, "42.13" qte from raw_iot_secteur_nace
         union all select nace dest, '42.21' nace, "42.21" qte from raw_iot_secteur_nace
         union all select nace dest, '42.22' nace, "42.22" qte from raw_iot_secteur_nace
         union all select nace dest, '42.91' nace, "42.91" qte from raw_iot_secteur_nace
         union all select nace dest, '42.99' nace, "42.99" qte from raw_iot_secteur_nace
         union all select nace dest, '43.11' nace, "43.11" qte from raw_iot_secteur_nace
         union all select nace dest, '43.12' nace, "43.12" qte from raw_iot_secteur_nace
         union all select nace dest, '43.13' nace, "43.13" qte from raw_iot_secteur_nace
         union all select nace dest, '43.21' nace, "43.21" qte from raw_iot_secteur_nace
         union all select nace dest, '43.22' nace, "43.22" qte from raw_iot_secteur_nace
         union all select nace dest, '43.29' nace, "43.29" qte from raw_iot_secteur_nace
         union all select nace dest, '43.31' nace, "43.31" qte from raw_iot_secteur_nace
         union all select nace dest, '43.32' nace, "43.32" qte from raw_iot_secteur_nace
         union all select nace dest, '43.33' nace, "43.33" qte from raw_iot_secteur_nace
         union all select nace dest, '43.34' nace, "43.34" qte from raw_iot_secteur_nace
         union all select nace dest, '43.39' nace, "43.39" qte from raw_iot_secteur_nace
         union all select nace dest, '43.91' nace, "43.91" qte from raw_iot_secteur_nace
         union all select nace dest, '43.99' nace, "43.99" qte from raw_iot_secteur_nace
         union all select nace dest, '45.11' nace, "45.11" qte from raw_iot_secteur_nace
         union all select nace dest, '45.19' nace, "45.19" qte from raw_iot_secteur_nace
         union all select nace dest, '45.20' nace, "45.20" qte from raw_iot_secteur_nace
         union all select nace dest, '45.31' nace, "45.31" qte from raw_iot_secteur_nace
         union all select nace dest, '45.32' nace, "45.32" qte from raw_iot_secteur_nace
         union all select nace dest, '45.40' nace, "45.40" qte from raw_iot_secteur_nace
         union all select nace dest, '46.11' nace, "46.11" qte from raw_iot_secteur_nace
         union all select nace dest, '46.12' nace, "46.12" qte from raw_iot_secteur_nace
         union all select nace dest, '46.13' nace, "46.13" qte from raw_iot_secteur_nace
         union all select nace dest, '46.14' nace, "46.14" qte from raw_iot_secteur_nace
         union all select nace dest, '46.15' nace, "46.15" qte from raw_iot_secteur_nace
         union all select nace dest, '46.16' nace, "46.16" qte from raw_iot_secteur_nace
         union all select nace dest, '46.17' nace, "46.17" qte from raw_iot_secteur_nace
         union all select nace dest, '46.18' nace, "46.18" qte from raw_iot_secteur_nace
         union all select nace dest, '46.19' nace, "46.19" qte from raw_iot_secteur_nace
         union all select nace dest, '46.21' nace, "46.21" qte from raw_iot_secteur_nace
         union all select nace dest, '46.22' nace, "46.22" qte from raw_iot_secteur_nace
         union all select nace dest, '46.23' nace, "46.23" qte from raw_iot_secteur_nace
         union all select nace dest, '46.24' nace, "46.24" qte from raw_iot_secteur_nace
         union all select nace dest, '46.31' nace, "46.31" qte from raw_iot_secteur_nace
         union all select nace dest, '46.32' nace, "46.32" qte from raw_iot_secteur_nace
         union all select nace dest, '46.33' nace, "46.33" qte from raw_iot_secteur_nace
         union all select nace dest, '46.34' nace, "46.34" qte from raw_iot_secteur_nace
         union all select nace dest, '46.35' nace, "46.35" qte from raw_iot_secteur_nace
         union all select nace dest, '46.36' nace, "46.36" qte from raw_iot_secteur_nace
         union all select nace dest, '46.37' nace, "46.37" qte from raw_iot_secteur_nace
         union all select nace dest, '46.38' nace, "46.38" qte from raw_iot_secteur_nace
         union all select nace dest, '46.39' nace, "46.39" qte from raw_iot_secteur_nace
         union all select nace dest, '46.41' nace, "46.41" qte from raw_iot_secteur_nace
         union all select nace dest, '46.42' nace, "46.42" qte from raw_iot_secteur_nace
         union all select nace dest, '46.43' nace, "46.43" qte from raw_iot_secteur_nace
         union all select nace dest, '46.44' nace, "46.44" qte from raw_iot_secteur_nace
         union all select nace dest, '46.45' nace, "46.45" qte from raw_iot_secteur_nace
         union all select nace dest, '46.46' nace, "46.46" qte from raw_iot_secteur_nace
         union all select nace dest, '46.47' nace, "46.47" qte from raw_iot_secteur_nace
         union all select nace dest, '46.48' nace, "46.48" qte from raw_iot_secteur_nace
         union all select nace dest, '46.49' nace, "46.49" qte from raw_iot_secteur_nace
         union all select nace dest, '46.51' nace, "46.51" qte from raw_iot_secteur_nace
         union all select nace dest, '46.52' nace, "46.52" qte from raw_iot_secteur_nace
         union all select nace dest, '46.61' nace, "46.61" qte from raw_iot_secteur_nace
         union all select nace dest, '46.62' nace, "46.62" qte from raw_iot_secteur_nace
         union all select nace dest, '46.63' nace, "46.63" qte from raw_iot_secteur_nace
         union all select nace dest, '46.64' nace, "46.64" qte from raw_iot_secteur_nace
         union all select nace dest, '46.65' nace, "46.65" qte from raw_iot_secteur_nace
         union all select nace dest, '46.66' nace, "46.66" qte from raw_iot_secteur_nace
         union all select nace dest, '46.69' nace, "46.69" qte from raw_iot_secteur_nace
         union all select nace dest, '46.71' nace, "46.71" qte from raw_iot_secteur_nace
         union all select nace dest, '46.72' nace, "46.72" qte from raw_iot_secteur_nace
         union all select nace dest, '46.73' nace, "46.73" qte from raw_iot_secteur_nace
         union all select nace dest, '46.74' nace, "46.74" qte from raw_iot_secteur_nace
         union all select nace dest, '46.75' nace, "46.75" qte from raw_iot_secteur_nace
         union all select nace dest, '46.76' nace, "46.76" qte from raw_iot_secteur_nace
         union all select nace dest, '46.77' nace, "46.77" qte from raw_iot_secteur_nace
         union all select nace dest, '46.90' nace, "46.90" qte from raw_iot_secteur_nace
         union all select nace dest, '47.11' nace, "47.11" qte from raw_iot_secteur_nace
         union all select nace dest, '47.19' nace, "47.19" qte from raw_iot_secteur_nace
         union all select nace dest, '47.21' nace, "47.21" qte from raw_iot_secteur_nace
         union all select nace dest, '47.22' nace, "47.22" qte from raw_iot_secteur_nace
         union all select nace dest, '47.23' nace, "47.23" qte from raw_iot_secteur_nace
         union all select nace dest, '47.24' nace, "47.24" qte from raw_iot_secteur_nace
         union all select nace dest, '47.25' nace, "47.25" qte from raw_iot_secteur_nace
         union all select nace dest, '47.26' nace, "47.26" qte from raw_iot_secteur_nace
         union all select nace dest, '47.29' nace, "47.29" qte from raw_iot_secteur_nace
         union all select nace dest, '47.30' nace, "47.30" qte from raw_iot_secteur_nace
         union all select nace dest, '47.41' nace, "47.41" qte from raw_iot_secteur_nace
         union all select nace dest, '47.42' nace, "47.42" qte from raw_iot_secteur_nace
         union all select nace dest, '47.43' nace, "47.43" qte from raw_iot_secteur_nace
         union all select nace dest, '47.51' nace, "47.51" qte from raw_iot_secteur_nace
         union all select nace dest, '47.52' nace, "47.52" qte from raw_iot_secteur_nace
         union all select nace dest, '47.53' nace, "47.53" qte from raw_iot_secteur_nace
         union all select nace dest, '47.54' nace, "47.54" qte from raw_iot_secteur_nace
         union all select nace dest, '47.59' nace, "47.59" qte from raw_iot_secteur_nace
         union all select nace dest, '47.61' nace, "47.61" qte from raw_iot_secteur_nace
         union all select nace dest, '47.62' nace, "47.62" qte from raw_iot_secteur_nace
         union all select nace dest, '47.63' nace, "47.63" qte from raw_iot_secteur_nace
         union all select nace dest, '47.64' nace, "47.64" qte from raw_iot_secteur_nace
         union all select nace dest, '47.65' nace, "47.65" qte from raw_iot_secteur_nace
         union all select nace dest, '47.71' nace, "47.71" qte from raw_iot_secteur_nace
         union all select nace dest, '47.72' nace, "47.72" qte from raw_iot_secteur_nace
         union all select nace dest, '47.73' nace, "47.73" qte from raw_iot_secteur_nace
     ) t
where t.qte>0 ;

insert into iot_consume_nace(nace, dest, qte)
select nace, dest, qte
from (
         select nace dest, '47.74' nace, "47.74" qte from raw_iot_secteur_nace
         union all select nace dest, '47.75' nace, "47.75" qte from raw_iot_secteur_nace
         union all select nace dest, '47.76' nace, "47.76" qte from raw_iot_secteur_nace
         union all select nace dest, '47.77' nace, "47.77" qte from raw_iot_secteur_nace
         union all select nace dest, '47.78' nace, "47.78" qte from raw_iot_secteur_nace
         union all select nace dest, '47.79' nace, "47.79" qte from raw_iot_secteur_nace
         union all select nace dest, '47.81' nace, "47.81" qte from raw_iot_secteur_nace
         union all select nace dest, '47.82' nace, "47.82" qte from raw_iot_secteur_nace
         union all select nace dest, '47.89' nace, "47.89" qte from raw_iot_secteur_nace
         union all select nace dest, '47.91' nace, "47.91" qte from raw_iot_secteur_nace
         union all select nace dest, '47.99' nace, "47.99" qte from raw_iot_secteur_nace
         union all select nace dest, '49.10' nace, "49.10" qte from raw_iot_secteur_nace
         union all select nace dest, '49.20' nace, "49.20" qte from raw_iot_secteur_nace
         union all select nace dest, '49.31' nace, "49.31" qte from raw_iot_secteur_nace
         union all select nace dest, '49.32' nace, "49.32" qte from raw_iot_secteur_nace
         union all select nace dest, '49.39' nace, "49.39" qte from raw_iot_secteur_nace
         union all select nace dest, '49.41' nace, "49.41" qte from raw_iot_secteur_nace
         union all select nace dest, '49.42' nace, "49.42" qte from raw_iot_secteur_nace
         union all select nace dest, '49.50' nace, "49.50" qte from raw_iot_secteur_nace
         union all select nace dest, '50.10' nace, "50.10" qte from raw_iot_secteur_nace
         union all select nace dest, '50.20' nace, "50.20" qte from raw_iot_secteur_nace
         union all select nace dest, '50.30' nace, "50.30" qte from raw_iot_secteur_nace
         union all select nace dest, '50.40' nace, "50.40" qte from raw_iot_secteur_nace
         union all select nace dest, '51.10' nace, "51.10" qte from raw_iot_secteur_nace
         union all select nace dest, '51.21' nace, "51.21" qte from raw_iot_secteur_nace
         union all select nace dest, '51.22' nace, "51.22" qte from raw_iot_secteur_nace
         union all select nace dest, '52.10' nace, "52.10" qte from raw_iot_secteur_nace
         union all select nace dest, '52.21' nace, "52.21" qte from raw_iot_secteur_nace
         union all select nace dest, '52.22' nace, "52.22" qte from raw_iot_secteur_nace
         union all select nace dest, '52.23' nace, "52.23" qte from raw_iot_secteur_nace
         union all select nace dest, '52.24' nace, "52.24" qte from raw_iot_secteur_nace
         union all select nace dest, '52.29' nace, "52.29" qte from raw_iot_secteur_nace
         union all select nace dest, '53.10' nace, "53.10" qte from raw_iot_secteur_nace
         union all select nace dest, '53.20' nace, "53.20" qte from raw_iot_secteur_nace
         union all select nace dest, '55.10' nace, "55.10" qte from raw_iot_secteur_nace
         union all select nace dest, '55.20' nace, "55.20" qte from raw_iot_secteur_nace
         union all select nace dest, '55.30' nace, "55.30" qte from raw_iot_secteur_nace
         union all select nace dest, '55.90' nace, "55.90" qte from raw_iot_secteur_nace
         union all select nace dest, '56.10' nace, "56.10" qte from raw_iot_secteur_nace
         union all select nace dest, '56.21' nace, "56.21" qte from raw_iot_secteur_nace
         union all select nace dest, '56.29' nace, "56.29" qte from raw_iot_secteur_nace
         union all select nace dest, '56.30' nace, "56.30" qte from raw_iot_secteur_nace
         union all select nace dest, '58.11' nace, "58.11" qte from raw_iot_secteur_nace
         union all select nace dest, '58.12' nace, "58.12" qte from raw_iot_secteur_nace
         union all select nace dest, '58.13' nace, "58.13" qte from raw_iot_secteur_nace
         union all select nace dest, '58.14' nace, "58.14" qte from raw_iot_secteur_nace
         union all select nace dest, '58.19' nace, "58.19" qte from raw_iot_secteur_nace
         union all select nace dest, '58.21' nace, "58.21" qte from raw_iot_secteur_nace
         union all select nace dest, '58.29' nace, "58.29" qte from raw_iot_secteur_nace
         union all select nace dest, '59.11' nace, "59.11" qte from raw_iot_secteur_nace
         union all select nace dest, '59.12' nace, "59.12" qte from raw_iot_secteur_nace
         union all select nace dest, '59.13' nace, "59.13" qte from raw_iot_secteur_nace
         union all select nace dest, '59.14' nace, "59.14" qte from raw_iot_secteur_nace
         union all select nace dest, '59.20' nace, "59.20" qte from raw_iot_secteur_nace
         union all select nace dest, '60.10' nace, "60.10" qte from raw_iot_secteur_nace
         union all select nace dest, '60.20' nace, "60.20" qte from raw_iot_secteur_nace
         union all select nace dest, '61.10' nace, "61.10" qte from raw_iot_secteur_nace
         union all select nace dest, '61.20' nace, "61.20" qte from raw_iot_secteur_nace
         union all select nace dest, '61.30' nace, "61.30" qte from raw_iot_secteur_nace
         union all select nace dest, '61.90' nace, "61.90" qte from raw_iot_secteur_nace
         union all select nace dest, '62.01' nace, "62.01" qte from raw_iot_secteur_nace
         union all select nace dest, '62.02' nace, "62.02" qte from raw_iot_secteur_nace
         union all select nace dest, '62.03' nace, "62.03" qte from raw_iot_secteur_nace
         union all select nace dest, '62.09' nace, "62.09" qte from raw_iot_secteur_nace
         union all select nace dest, '63.11' nace, "63.11" qte from raw_iot_secteur_nace
         union all select nace dest, '63.12' nace, "63.12" qte from raw_iot_secteur_nace
         union all select nace dest, '63.91' nace, "63.91" qte from raw_iot_secteur_nace
         union all select nace dest, '63.99' nace, "63.99" qte from raw_iot_secteur_nace
         union all select nace dest, '64.11' nace, "64.11" qte from raw_iot_secteur_nace
         union all select nace dest, '64.19' nace, "64.19" qte from raw_iot_secteur_nace
         union all select nace dest, '64.20' nace, "64.20" qte from raw_iot_secteur_nace
         union all select nace dest, '64.30' nace, "64.30" qte from raw_iot_secteur_nace
         union all select nace dest, '64.91' nace, "64.91" qte from raw_iot_secteur_nace
         union all select nace dest, '64.92' nace, "64.92" qte from raw_iot_secteur_nace
         union all select nace dest, '64.99' nace, "64.99" qte from raw_iot_secteur_nace
         union all select nace dest, '65.11' nace, "65.11" qte from raw_iot_secteur_nace
         union all select nace dest, '65.12' nace, "65.12" qte from raw_iot_secteur_nace
         union all select nace dest, '65.20' nace, "65.20" qte from raw_iot_secteur_nace
         union all select nace dest, '65.30' nace, "65.30" qte from raw_iot_secteur_nace
         union all select nace dest, '66.11' nace, "66.11" qte from raw_iot_secteur_nace
         union all select nace dest, '66.12' nace, "66.12" qte from raw_iot_secteur_nace
         union all select nace dest, '66.19' nace, "66.19" qte from raw_iot_secteur_nace
         union all select nace dest, '66.21' nace, "66.21" qte from raw_iot_secteur_nace
         union all select nace dest, '66.22' nace, "66.22" qte from raw_iot_secteur_nace
         union all select nace dest, '66.29' nace, "66.29" qte from raw_iot_secteur_nace
         union all select nace dest, '66.30' nace, "66.30" qte from raw_iot_secteur_nace
         union all select nace dest, '68.10' nace, "68.10" qte from raw_iot_secteur_nace
         union all select nace dest, '68.20' nace, "68.20" qte from raw_iot_secteur_nace
         union all select nace dest, '68.31' nace, "68.31" qte from raw_iot_secteur_nace
         union all select nace dest, '68.32' nace, "68.32" qte from raw_iot_secteur_nace
         union all select nace dest, '69.10' nace, "69.10" qte from raw_iot_secteur_nace
         union all select nace dest, '69.20' nace, "69.20" qte from raw_iot_secteur_nace
         union all select nace dest, '70.10' nace, "70.10" qte from raw_iot_secteur_nace
         union all select nace dest, '70.21' nace, "70.21" qte from raw_iot_secteur_nace
         union all select nace dest, '70.22' nace, "70.22" qte from raw_iot_secteur_nace
         union all select nace dest, '71.11' nace, "71.11" qte from raw_iot_secteur_nace
         union all select nace dest, '71.12' nace, "71.12" qte from raw_iot_secteur_nace
         union all select nace dest, '71.20' nace, "71.20" qte from raw_iot_secteur_nace
         union all select nace dest, '72.11' nace, "72.11" qte from raw_iot_secteur_nace
         union all select nace dest, '72.19' nace, "72.19" qte from raw_iot_secteur_nace
         union all select nace dest, '72.20' nace, "72.20" qte from raw_iot_secteur_nace
     ) t
where t.qte>0 ;

insert into iot_consume_nace(nace, dest, qte)
select nace, dest, qte
from (
         select nace dest, '73.11' nace, "73.11" qte from raw_iot_secteur_nace
         union all select nace dest, '73.12' nace, "73.12" qte from raw_iot_secteur_nace
         union all select nace dest, '73.20' nace, "73.20" qte from raw_iot_secteur_nace
         union all select nace dest, '74.10' nace, "74.10" qte from raw_iot_secteur_nace
         union all select nace dest, '74.20' nace, "74.20" qte from raw_iot_secteur_nace
         union all select nace dest, '74.30' nace, "74.30" qte from raw_iot_secteur_nace
         union all select nace dest, '74.90' nace, "74.90" qte from raw_iot_secteur_nace
         union all select nace dest, '75.00' nace, "75.00" qte from raw_iot_secteur_nace
         union all select nace dest, '77.11' nace, "77.11" qte from raw_iot_secteur_nace
         union all select nace dest, '77.12' nace, "77.12" qte from raw_iot_secteur_nace
         union all select nace dest, '77.21' nace, "77.21" qte from raw_iot_secteur_nace
         union all select nace dest, '77.22' nace, "77.22" qte from raw_iot_secteur_nace
         union all select nace dest, '77.29' nace, "77.29" qte from raw_iot_secteur_nace
         union all select nace dest, '77.31' nace, "77.31" qte from raw_iot_secteur_nace
         union all select nace dest, '77.32' nace, "77.32" qte from raw_iot_secteur_nace
         union all select nace dest, '77.33' nace, "77.33" qte from raw_iot_secteur_nace
         union all select nace dest, '77.34' nace, "77.34" qte from raw_iot_secteur_nace
         union all select nace dest, '77.35' nace, "77.35" qte from raw_iot_secteur_nace
         union all select nace dest, '77.39' nace, "77.39" qte from raw_iot_secteur_nace
         union all select nace dest, '77.40' nace, "77.40" qte from raw_iot_secteur_nace
         union all select nace dest, '78.10' nace, "78.10" qte from raw_iot_secteur_nace
         union all select nace dest, '78.20' nace, "78.20" qte from raw_iot_secteur_nace
         union all select nace dest, '78.30' nace, "78.30" qte from raw_iot_secteur_nace
         union all select nace dest, '79.11' nace, "79.11" qte from raw_iot_secteur_nace
         union all select nace dest, '79.12' nace, "79.12" qte from raw_iot_secteur_nace
         union all select nace dest, '79.90' nace, "79.90" qte from raw_iot_secteur_nace
         union all select nace dest, '80.10' nace, "80.10" qte from raw_iot_secteur_nace
         union all select nace dest, '80.20' nace, "80.20" qte from raw_iot_secteur_nace
         union all select nace dest, '80.30' nace, "80.30" qte from raw_iot_secteur_nace
         union all select nace dest, '81.10' nace, "81.10" qte from raw_iot_secteur_nace
         union all select nace dest, '81.21' nace, "81.21" qte from raw_iot_secteur_nace
         union all select nace dest, '81.22' nace, "81.22" qte from raw_iot_secteur_nace
         union all select nace dest, '81.29' nace, "81.29" qte from raw_iot_secteur_nace
         union all select nace dest, '81.30' nace, "81.30" qte from raw_iot_secteur_nace
         union all select nace dest, '82.11' nace, "82.11" qte from raw_iot_secteur_nace
         union all select nace dest, '82.19' nace, "82.19" qte from raw_iot_secteur_nace
         union all select nace dest, '82.20' nace, "82.20" qte from raw_iot_secteur_nace
         union all select nace dest, '82.30' nace, "82.30" qte from raw_iot_secteur_nace
         union all select nace dest, '82.91' nace, "82.91" qte from raw_iot_secteur_nace
         union all select nace dest, '82.92' nace, "82.92" qte from raw_iot_secteur_nace
         union all select nace dest, '82.99' nace, "82.99" qte from raw_iot_secteur_nace
         union all select nace dest, '84.11' nace, "84.11" qte from raw_iot_secteur_nace
         union all select nace dest, '84.12' nace, "84.12" qte from raw_iot_secteur_nace
         union all select nace dest, '84.13' nace, "84.13" qte from raw_iot_secteur_nace
         union all select nace dest, '84.21' nace, "84.21" qte from raw_iot_secteur_nace
         union all select nace dest, '84.22' nace, "84.22" qte from raw_iot_secteur_nace
         union all select nace dest, '84.23' nace, "84.23" qte from raw_iot_secteur_nace
         union all select nace dest, '84.24' nace, "84.24" qte from raw_iot_secteur_nace
         union all select nace dest, '84.25' nace, "84.25" qte from raw_iot_secteur_nace
         union all select nace dest, '84.30' nace, "84.30" qte from raw_iot_secteur_nace
         union all select nace dest, '85.10' nace, "85.10" qte from raw_iot_secteur_nace
         union all select nace dest, '85.20' nace, "85.20" qte from raw_iot_secteur_nace
         union all select nace dest, '85.31' nace, "85.31" qte from raw_iot_secteur_nace
         union all select nace dest, '85.32' nace, "85.32" qte from raw_iot_secteur_nace
         union all select nace dest, '85.41' nace, "85.41" qte from raw_iot_secteur_nace
         union all select nace dest, '85.42' nace, "85.42" qte from raw_iot_secteur_nace
         union all select nace dest, '85.51' nace, "85.51" qte from raw_iot_secteur_nace
         union all select nace dest, '85.52' nace, "85.52" qte from raw_iot_secteur_nace
         union all select nace dest, '85.53' nace, "85.53" qte from raw_iot_secteur_nace
         union all select nace dest, '85.59' nace, "85.59" qte from raw_iot_secteur_nace
         union all select nace dest, '85.60' nace, "85.60" qte from raw_iot_secteur_nace
         union all select nace dest, '86.10' nace, "86.10" qte from raw_iot_secteur_nace
         union all select nace dest, '86.21' nace, "86.21" qte from raw_iot_secteur_nace
         union all select nace dest, '86.22' nace, "86.22" qte from raw_iot_secteur_nace
         union all select nace dest, '86.23' nace, "86.23" qte from raw_iot_secteur_nace
         union all select nace dest, '86.90' nace, "86.90" qte from raw_iot_secteur_nace
         union all select nace dest, '87.10' nace, "87.10" qte from raw_iot_secteur_nace
         union all select nace dest, '87.20' nace, "87.20" qte from raw_iot_secteur_nace
         union all select nace dest, '87.30' nace, "87.30" qte from raw_iot_secteur_nace
         union all select nace dest, '87.90' nace, "87.90" qte from raw_iot_secteur_nace
         union all select nace dest, '88.10' nace, "88.10" qte from raw_iot_secteur_nace
         union all select nace dest, '88.91' nace, "88.91" qte from raw_iot_secteur_nace
         union all select nace dest, '88.99' nace, "88.99" qte from raw_iot_secteur_nace
         union all select nace dest, '90.01' nace, "90.01" qte from raw_iot_secteur_nace
         union all select nace dest, '90.02' nace, "90.02" qte from raw_iot_secteur_nace
         union all select nace dest, '90.03' nace, "90.03" qte from raw_iot_secteur_nace
         union all select nace dest, '90.04' nace, "90.04" qte from raw_iot_secteur_nace
         union all select nace dest, '91.01' nace, "91.01" qte from raw_iot_secteur_nace
         union all select nace dest, '91.02' nace, "91.02" qte from raw_iot_secteur_nace
         union all select nace dest, '91.03' nace, "91.03" qte from raw_iot_secteur_nace
         union all select nace dest, '91.04' nace, "91.04" qte from raw_iot_secteur_nace
         union all select nace dest, '92.00' nace, "92.00" qte from raw_iot_secteur_nace
         union all select nace dest, '93.11' nace, "93.11" qte from raw_iot_secteur_nace
         union all select nace dest, '93.12' nace, "93.12" qte from raw_iot_secteur_nace
         union all select nace dest, '93.13' nace, "93.13" qte from raw_iot_secteur_nace
         union all select nace dest, '93.19' nace, "93.19" qte from raw_iot_secteur_nace
         union all select nace dest, '93.21' nace, "93.21" qte from raw_iot_secteur_nace
         union all select nace dest, '93.29' nace, "93.29" qte from raw_iot_secteur_nace
         union all select nace dest, '94.11' nace, "94.11" qte from raw_iot_secteur_nace
         union all select nace dest, '94.12' nace, "94.12" qte from raw_iot_secteur_nace
         union all select nace dest, '94.20' nace, "94.20" qte from raw_iot_secteur_nace
         union all select nace dest, '94.91' nace, "94.91" qte from raw_iot_secteur_nace
         union all select nace dest, '94.92' nace, "94.92" qte from raw_iot_secteur_nace
         union all select nace dest, '94.99' nace, "94.99" qte from raw_iot_secteur_nace
         union all select nace dest, '95.11' nace, "95.11" qte from raw_iot_secteur_nace
         union all select nace dest, '95.12' nace, "95.12" qte from raw_iot_secteur_nace
         union all select nace dest, '95.21' nace, "95.21" qte from raw_iot_secteur_nace
         union all select nace dest, '95.22' nace, "95.22" qte from raw_iot_secteur_nace
         union all select nace dest, '95.23' nace, "95.23" qte from raw_iot_secteur_nace
         union all select nace dest, '95.24' nace, "95.24" qte from raw_iot_secteur_nace
         union all select nace dest, '95.25' nace, "95.25" qte from raw_iot_secteur_nace
     ) t
where t.qte>0 ;

insert into iot_consume_nace(nace, dest, qte)
select nace, dest, qte
from (
         select nace dest, '95.29' nace, "95.29" qte from raw_iot_secteur_nace
         union all select nace dest, '96.01' nace, "96.01" qte from raw_iot_secteur_nace
         union all select nace dest, '96.02' nace, "96.02" qte from raw_iot_secteur_nace
         union all select nace dest, '96.03' nace, "96.03" qte from raw_iot_secteur_nace
         union all select nace dest, '96.04' nace, "96.04" qte from raw_iot_secteur_nace
         union all select nace dest, '96.09' nace, "96.09" qte from raw_iot_secteur_nace
         union all select nace dest, '97.00' nace, "97.00" qte from raw_iot_secteur_nace
         union all select nace dest, '98.10' nace, "98.10" qte from raw_iot_secteur_nace
         union all select nace dest, '98.20' nace, "98.20" qte from raw_iot_secteur_nace
         union all select nace dest, 'W-Adj' nace, "W-Adj" qte from raw_iot_secteur_nace
     ) t
where t.qte>0 ;

create index iot_consume_nace_idx on iot_consume_nace(nace) ;
call drop_any_type_of_view_if_exists('vw_establishment_for_partener');

CREATE MATERIALIZED VIEW vw_establishment_for_partener
AS
select e.id, e.geo_pos, e.department_code, d.region_id,
       case
           when e.workforce_count<1 then 0
           when e.workforce_count<4 then 1
           when e.workforce_count<7 then 2
           when e.workforce_count<15 then 3
           when e.workforce_count<35 then 4
           when e.workforce_count<75 then 5
           when e.workforce_count<150 then 6
           when e.workforce_count<225 then 7
           when e.workforce_count<375 then 8
           when e.workforce_count<750 then 9
           when e.workforce_count<1500 then 10
           when e.workforce_count<3500 then 11
           when e.workforce_count<7500 then 12
           else 13
           end workforce,
       left(na.code,5) nace
from establishment e
         inner join department d on d.code = e.department_code
         inner join nomenclature_activity na ON na.id = e.main_activity_id
where e.administrative_status = true and e.enabled=true
;

CREATE INDEX vw_establishment_for_partener_idx  ON vw_establishment_for_partener (region_id, nace);
CREATE INDEX vw_establishment_for_partener_id_idx  ON vw_establishment_for_partener (id);

DROP TABLE IF EXISTS partner_calc_iot ;

CREATE TABLE IF NOT EXISTS partner_calc_iot
(
    id integer,
    nb_supplier integer,
    nb_customer integer,
    calc boolean,
    PRIMARY KEY (id)
);
create index if not exists partner_calc_iot_idx on partner_calc_iot(id);

DROP TABLE IF EXISTS IA_potential_by_iot ;

CREATE TABLE IA_potential_by_iot
(
    establishment_id int not null,
    partner_id int not null,
    customer boolean,
    provider boolean,
    cust_coef numeric(12,8),
    prov_coef numeric(12,8),
    distance int,
    CONSTRAINT IA_establishment_potential_partners_establishment_id_fkey FOREIGN KEY (establishment_id) REFERENCES establishment(id),
    CONSTRAINT IA_establishment_potential_partners_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES establishment(id),
    PRIMARY KEY (establishment_id, partner_id)
) ;

CREATE INDEX IA_potential_by_iot_pk_idx
    ON IA_potential_by_iot (establishment_id, partner_id);
CREATE INDEX IA_potential_by_iot_pkinv_idx
    ON IA_potential_by_iot (partner_id, establishment_id);

DROP Table if exists tmp_iot ;

CREATE TABLE tmp_iot
(
    establishment_id int not null,
    partner_id int not null,
    customer boolean,
    provider boolean,
    cust_coef numeric(12,8),
    prov_coef numeric(12,8),
    distance int
);

DROP FUNCTION IF EXISTS func_list_partner_iot ;

CREATE FUNCTION func_list_partner_iot (p_e_id integer)
    RETURNS TABLE
            (
                e_id int,
                p_id int,
                customer boolean,
                provider boolean,
                distance int,
                cust_coef numeric(12,8),
                prov_coef numeric(12,8)
            )
AS $$
DECLARE
    _cst_nb_partner integer := 25 ;
    _min_coef numeric(10,8) := 0.03;
    _nb_supplier integer;
    _nb_customer integer;
    _calc boolean;
    _nace_start varchar(5);
    _region_id integer;
    _workforce integer;
    _geo_pos geometry;
BEGIN
    select
        iot.nb_supplier,
        iot.nb_customer,
        iot.calc,
        left(na.code, 5),
        d.region_id,
        case
            when e.workforce_count<1 then 0
            when e.workforce_count<4 then 1
            when e.workforce_count<7 then 2
            when e.workforce_count<15 then 3
            when e.workforce_count<35 then 4
            when e.workforce_count<75 then 5
            when e.workforce_count<150 then 6
            when e.workforce_count<225 then 7
            when e.workforce_count<375 then 8
            when e.workforce_count<750 then 9
            when e.workforce_count<1500 then 10
            when e.workforce_count<3500 then 11
            when e.workforce_count<7500 then 12
            else 13
            end workforce ,
        e.geo_pos
    into _nb_supplier, _nb_customer, _calc, _nace_start, _region_id, _workforce, _geo_pos
    from establishment e
             inner join nomenclature_activity na ON na.id = e.main_activity_id
             inner join department d on d.code = e.department_code
             left join partner_calc_iot iot on iot.id = e.id
    where e.id=p_e_id;

    IF (_calc is null or not _calc) THEN
        delete from tmp_iot where establishment_id = p_e_id;

        INSERT INTO tmp_iot ( establishment_id, partner_id, customer, provider, distance, cust_coef, prov_coef)
        with sel_raw as
                 (
                     select dest, round(qte/ sum(qte) over (partition by nace) * 100) :: integer nombre, qte/ sum(qte) over (partition by nace) coef
                     from (
                              select prod.nace, prod.dest, prod.qte, prod.qte / sum(prod.qte) over (partition by prod.nace) _sum
                              from iot_consume_nace prod
                              where prod.nace = _nace_start
                                and prod.dest <> _nace_start
                          ) t
                     where t._sum>_min_coef
                 )
        select  		p_e_id e_id,
                      part.id p_id,
                      false as customer,
                      true as provider,
                      round(part.distance/1000)::integer distance,
                      null::numeric(12,8) as cust_coef,
                      max(part.coef) as prov_coef
        from sel_raw sr
                 cross join lateral
            (
            select efp.id, efp.nace, ST_DISTANCE( efp.geo_pos, _geo_pos, false ) distance, sr.coef
            from vw_establishment_for_partener efp
                     left join partner_calc_iot pci on pci.id = efp.id
            where efp.nace = sr.dest
              and efp.region_id = _region_id
            order by abs(efp.workforce - _workforce)+(coalesce(pci.nb_supplier,0) * 0.1), ST_DISTANCE( efp.geo_pos, _geo_pos, false )
            limit sr.nombre
            ) part
        group by part.id, round(part.distance/1000)::integer ;

        INSERT INTO IA_potential_by_iot (establishment_id, partner_id, customer, provider, distance, cust_coef, prov_coef)
        select LEAST(tmp_iot.establishment_id, tmp_iot.partner_id),
               GREATEST(tmp_iot.establishment_id, tmp_iot.partner_id),
               tmp_iot.customer,
               tmp_iot.provider,
               tmp_iot.distance,
               tmp_iot.cust_coef,
               tmp_iot.prov_coef
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        ON CONFLICT (establishment_id, partner_id) DO
            UPDATE SET provider = true, prov_coef=excluded.prov_coef ;

        INSERT INTO partner_calc_iot (id, nb_supplier, nb_customer, calc)
        select tmp_iot.establishment_id, Count(1) nbr_s, 0 nbr_p, true
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        group by tmp_iot.establishment_id
        UNION ALL
        select tmp_iot.partner_id, count(1), 0, false
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        group by tmp_iot.partner_id
        ON CONFLICT (id) DO
            UPDATE SET
                       nb_supplier = partner_calc_iot.nb_supplier+excluded.nb_supplier,
                       calc = partner_calc_iot.calc or excluded.calc ;

        delete from tmp_iot where establishment_id = p_e_id;

        INSERT INTO tmp_iot ( establishment_id, partner_id, customer, provider, distance, cust_coef, prov_coef)
        with sel_raw as
                 (
                     select dest, round(qte/ sum(qte) over (partition by nace) * 100) :: integer nombre, qte/ sum(qte) over (partition by nace) coef
                     from (
                              select prod.nace, prod.dest, qte, (qte / sum(qte) over (partition by prod.nace)) _sum
                              from iot_production_nace prod
                              where prod.nace = _nace_start
                                and prod.dest <> _nace_start
                          ) t
                     where t._sum> _min_coef
                 )
        select p_e_id e_id,
               part.id p_id,
               true as customer,
               false as provider,
               round(part.distance/1000)::integer distance,
               max(part.coef) as cust_coef,
               null::numeric(12,8) as prov_coef
        from sel_raw sr
                 cross join lateral (
            select efp.id, efp.nace, ST_DISTANCE( efp.geo_pos, _geo_pos, false ) distance, sr.coef
            from vw_establishment_for_partener efp
                     left join partner_calc_iot pci on pci.id = efp.id
            where efp.nace = sr.dest
              and efp.region_id = _region_id
            order by abs(efp.workforce - _workforce)+(coalesce(pci.nb_customer,0) * 0.1), ST_DISTANCE( efp.geo_pos, _geo_pos, false )
            limit sr.nombre
            ) part
        group by part.id, round(part.distance/1000)::integer ;

        INSERT INTO IA_potential_by_iot (establishment_id, partner_id, customer, provider, distance, cust_coef, prov_coef)
        select LEAST(tmp_iot.establishment_id, tmp_iot.partner_id),
               GREATEST(tmp_iot.establishment_id, tmp_iot.partner_id),
               tmp_iot.customer,
               tmp_iot.provider,
               tmp_iot.distance,
               tmp_iot.cust_coef,
               tmp_iot.prov_coef
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        ON CONFLICT (establishment_id, partner_id) DO
            UPDATE SET customer = true, cust_coef = excluded.cust_coef;

        INSERT INTO partner_calc_iot (id, nb_supplier, nb_customer, calc)
        select tmp_iot.establishment_id, 0 nbr_s, Count(1) nbr_p, true
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        group by tmp_iot.establishment_id
        UNION ALL
        select tmp_iot.partner_id, 0, count(1), false
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        group by tmp_iot.partner_id
        ON CONFLICT (id) DO
            UPDATE SET
                       nb_customer = partner_calc_iot.nb_customer+excluded.nb_customer,
                       calc = partner_calc_iot.calc or excluded.calc ;

        -- cleaning
        delete from tmp_iot where establishment_id = p_e_id;
    END IF ;

    RETURN QUERY
        select epp.establishment_id, epp.partner_id, epp.customer, epp.provider, epp.distance, epp.cust_coef, epp.prov_coef
        from IA_potential_by_iot epp
        WHERE epp.establishment_id = p_e_id
        UNION ALL
        select epp.partner_id, epp.establishment_id, epp.customer, epp.provider, epp.distance, epp.cust_coef, epp.prov_coef
        from IA_potential_by_iot epp
        WHERE epp.partner_id = p_e_id
    ;
END ;
$$ LANGUAGE plpgsql;

DROP PROCEDURE IF EXISTS create_IA_establishment_potential_partners ;

CREATE PROCEDURE create_IA_establishment_potential_partners(_workforce_min int)
AS $$
DECLARE
    _nbr int ;
    _offset int ;
    _limit int = 100 ;
    _workforce int = 13;
    _nbr_actu int = 0;
    _nbr_max int = 999;
BEGIN
    <<workforce>>
    LOOP
        select count(1) into _nbr
        from vw_establishment_for_partener wefp
        where workforce=_workforce
          and not exists (select 1 from partner_calc_iot p where p.id = wefp.id and p.calc = true) ;
        if (_nbr>0) then
            _offset := 0 ;
            <<offset>>
            LOOP
                _nbr_actu = _nbr_actu + _limit;
                raise warning 'workforce %: % / %', _workforce, LEAST(_offset + _limit, _nbr), _nbr;
                PERFORM
                    (
                        with wefp as (
                            select wefp.id
                            from vw_establishment_for_partener wefp
                            where wefp.workforce=_workforce
                              and not exists (select 1 from partner_calc_iot p where p.id = wefp.id and p.calc = true)
                            order by wefp.id
                            limit _limit
                        )
                        select count(1) from wefp cross join lateral func_list_partner_iot(wefp.id) flp
                    ) ;
                BEGIN
                    COMMIT;
                EXCEPTION WHEN OTHERS THEN
                END ;
                if (_nbr_actu > _nbr_max) THEN
                    exit offset;
                END IF;
                _offset = _offset + _limit ;
                if (_offset > _nbr) THEN
                    EXIT offset;
                END IF ;
            END LOOP offset;
        END IF ;
        if (_nbr_actu > _nbr_max) THEN
            exit workforce;
        END IF;
        _workforce := _workforce - 1 ;
        if (_workforce < _workforce_min ) then
            exit workforce;
        end if;
    END LOOP workforce;
END ;
$$ LANGUAGE plpgsql;



