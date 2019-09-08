diff --git a/core/src/pettil-core.a65 b/core/src/pettil-core.a65
index 1824aa6..2f32f58 100644
--- a/core/src/pettil-core.a65
+++ b/core/src/pettil-core.a65
@@ -360,48 +360,6 @@ corebase
 ; * no editor (needs IRQ switching)
 ;==============================================================
 
-;--------------------------------------------------------------
-#if 0
-name=COLD
-stack=( -- )
-tags=system,startup
-COLD starts up the system and when invoked as a command will attempt
-to restore the system to as pristine a condition as possible.
-
-10 sys1037
-
-1st `restart` --> `liftoff` --> copy `tdict`
-2nd `restart` --> `cold` --> start `studio`
-3nd `restart` --> `warm` --> reentry "WELCOME TO PETTIL (version)"
-
-#endif
-#include "align.i65"
-_cold
-    jsr aloha
-    ldx usersp0
-    dex
-#include "align.i65"
-    jsr toforth                 ; transition from 6502 Assembly to Forth
-#include "pass.i65"
-    .word plits
-    .byt 5
-    .word ustart                ; erase
-    .word uendcore-ustart
-    .word userarea              ; cmove
-    .word ucore
-    .word uarea-userarea
-#include "page.i65"
-    .word cmove
-#include "page.i65"
-    .word erase
-#include "page.i65"
-coldpatch
-    .word next                  ; later transformed into `rehash`
-; ~ '#include page' can't be used here, but this may not break page alignment
-    .word next                  ; later transformed into `emptybuffers`
-#include "pass.i65"
-    .word restart               ; restart #2 (of 3) --> `studio`
-
 ;--------------------------------------------------------------
 #if 0
 name=ALOHA
@@ -483,6 +441,22 @@ fencepost
 #if 0
 name=LIFTOFF
 tags=system,startup,throwaway,nosymbol
+One time only startup code
+: liftoff   ( -- )
+    ['] there @+ tuck over @ 2+ cmove 2+ execute
+
+* relocate `tdict`
+* run first word in `tdict`
+
+* `: liftoff   ( -- )`
+** `sp!`
+    ['] there @+ tuck over @ 2+ cmove 2+ execute
+* `: cold   ( -- )`
+** `' warm startup !`
+* `: warm   ( -- )`
+** `sp!`
+
+
 A primitive relocator to move already-linked code to upper memory
 Gets us from `pettil-core` to module LAUNCH
 
@@ -537,7 +511,45 @@ fs01
 #include "page.i65"
     .word store                 ; `studio` -> `startup` for 2nd `restart`
 #include "page.i65"
-    .word _cold
+    .word restart
+
+;--------------------------------------------------------------
+#if 0
+name=COLD
+stack=( -- )
+tags=system,startup
+`cold` starts up the system
+10 sys1037
+
+1st `restart` --> `liftoff` --> copy `tdict`
+2nd `restart` --> `cold` --> start `studio`
+3nd `restart` --> `warm` --> reentry "WELCOME TO PETTIL (version)"
+
+#endif
+#include "align.i65"
+_cold
+    jsr toforth                 ; transition from 6502 Assembly to Forth
+#include "page.i65"
+    .word spstore
+#include "pass.i65"
+    .word plits
+    .byt 5
+    .word ustart                ; erase
+    .word uendcore-ustart
+    .word userarea              ; cmove
+    .word ucore
+    .word uarea-userarea
+#include "page.i65"
+    .word cmove
+#include "page.i65"
+    .word erase
+#include "page.i65"
+coldpatch
+    .word next                  ; later transformed into `rehash`
+; ~ '#include page' can't be used here, but this may not break page alignment
+    .word next                  ; later transformed into `emptybuffers`
+#include "pass.i65"
+    .word restart               ; restart #2 (of 3) --> `studio`
 
 ;--------------------------------------------------------------
 #if 0
