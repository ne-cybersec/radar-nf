#!/usr/bin/env bash
# OG-карточка 1200×630 для «Радар.НФ». Мотив: радарная развёртка + блипы-цели.
# Требует ImageMagick (magick). Запуск: bash og.sh
set -e

OUT="./og-radar.png"
BRAND="@ne_cybersec · расследование"
URL="ne-cybersec.github.io/radar-nf"

AB="/System/Library/Fonts/Supplemental/Arial Bold.ttf"
MN="/System/Library/Fonts/Menlo.ttc"
BG="#13141b"; G2="#aeb6c4"; INK="#f4f6fa"; INK3="#8b97a8"
CYAN="#5cc2e0"; TEAL="#33cdbb"; LIME="#c7e04c"; AMBER="#e6a83c"; RED="#e8604f"; GRID="#2b3344"

# радар справа
GX=930; GY=300; GR=210
a=()
a+=( -fill none -stroke "$GRID" -strokewidth 2 -draw "ellipse $GX,$GY $GR,$GR 0,360" )
a+=( -draw "ellipse $GX,$GY 140,140 0,360" -draw "ellipse $GX,$GY 70,70 0,360" )
a+=( -strokewidth 1 -draw "line $((GX-GR)),$GY $((GX+GR)),$GY" -draw "line $GX,$((GY-GR)) $GX,$((GY+GR))" -stroke none )
# сектор развёртки (полупрозрачный клин)
a+=( -fill "rgba(232,96,79,0.16)" -stroke none -draw "path 'M $GX,$GY L $GX,$((GY-GR)) A $GR,$GR 0 0,1 $((GX+148)),$((GY-148)) Z'" )
a+=( -stroke "$RED" -strokewidth 2 -draw "line $GX,$GY $((GX+148)),$((GY-148))" -stroke none )
# блипы-цели
BLIPS=( "830 170 8 $AMBER" "1010 205 7 $RED" "1070 300 9 $CYAN" "870 400 7 $TEAL" "985 405 10 $RED" "800 300 6 $LIME" )
for d in "${BLIPS[@]}"; do set -- $d; a+=( -fill "$4" -draw "circle $1,$2 $(($1+$3)),$2" ); done

# текст слева
a+=( -stroke "$RED" -strokewidth 4 -draw "line 72,74 132,74" -strokewidth 0 -stroke none )
a+=( -font "$MN" -pointsize 25 -fill "$G2" -draw "text 72,106 '$BRAND'" )
a+=( -font "$AB" -pointsize 88 -fill "$INK" -draw "text 70,250 'Радар.НФ'" )
a+=( -font "$AB" -pointsize 52 -fill "$INK" -draw "text 70,332 'единственное в стране'" )
a+=( -fill "$RED" -draw "text 70,400 '— и неработоспособное'" )
a+=( -font "$MN" -pointsize 24 -fill "$INK3" -draw "text 72,470 'Единственный гражданский канал сообщить о БПЛА —'" )
a+=( -draw "text 72,502 'заброшен и отказывает в отправке. Данные на июнь 2026.'" )
a+=( -font "$MN" -pointsize 24 -fill "$AMBER" -draw "text 72,582 '$URL'" )

magick -size 1200x630 xc:"$BG" "${a[@]}" "$OUT"
echo "OG → $OUT"
