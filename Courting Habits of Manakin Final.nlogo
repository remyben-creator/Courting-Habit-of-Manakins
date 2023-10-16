globals [
  ;;these are to help with the setup of the display-areas
  available-colors
  display-areas
  branches

  copulation-chance

  here
  there

  branch0
  branch1
  branch2
  branch3

  current-dance
]
;;display-area-own [display-branch cleanliness owner]
breed [fManakins fManakin]
breed [mManakins mManakin]
breed [regions region]


;; role is alpha or beta
;; partnership possibly link or the specific area as if a tribe
;; plumage and age may play different roles
;; age is 0-18
;; reproductive success is % up to 100, that grows with experience need work**********************
mManakins-own [role partnership-num reproductive-success in-region?
  high-enough low-enough bounces total-bounces]
;; reproductive success is how hard to sway. based on age

fManakins-own [freproductive-success in-region? current-region attention pregnant? fdance]
patches-own [region? display-branch? branch-num]

;;-------------
;; setup code
;;-------------

to setup
  clear-all
  setup-mManakins
  setup-fManakin
  setup-lek
  ask mManakins [
    set current-dance "start"
    set bounces 0
    set total-bounces ((random 3) + 2)]
  set here 0
  reset-ticks
end

;;--------
;; birds
;;--------


to setup-mManakins
  ;;make the male birds
  set-default-shape mManakins "bird side"

  if Alpha [
  create-mManakins 1 [
    setxy random-xcor random-ycor
    set color red
    set reproductive-success alpha-rating
    set role "alpha"
    set partnership-num 1]]

  if Beta1 [
  create-mManakins 1 [
    setxy random-xcor random-ycor
    set color blue
    set reproductive-success beta1-rating
    set role "beta"
    set partnership-num 1]]

  if Beta2 [
  create-mManakins 1 [
    setxy random-xcor random-ycor
    set color blue
    set reproductive-success beta2-rating
    set role "beta"
    set partnership-num 1]]


end

to setup-fManakin
  if female [
  ;;make the female birds
  set-default-shape fManakins "bird side"
  create-fManakins 1 [
    setxy random-xcor random-ycor
    set color pink
    set pregnant? false
    set freproductive-success female-rating
    set attention 0
  ]]


  set copulation-chance 0
end

;;--------------
;; environment
;;--------------

;;to stay far enough away from each other
;;not any? other (patches with [region?]) in-radius 4
;;to use later

to setup-lek
  ;;making green colors for zones
  set available-colors shuffle filter [ c ->
    (c mod 10 >= 2) and (c mod 10 <= 6)
  ] n-values 20 [ n -> n + 50 ]

;;to originaly make display zones
  create-regions 1 [set color green - 1]

  ;; need to make sure they do not touch

  ;;paint zone
  ask regions
    [ paint-areas patches in-radius 9 ]
  display

  ;;setup regions
  ask patches [set region? false set display-branch? false]
  set display-areas patches with [pcolor = green]
  ask display-areas [set region? true]

  ;;paint branches
  ask regions [set color (33 + (number-of-Branches - 1))]
  ask regions [
    if (color = 33)
    [paint-areas patches at-points [[-2 2] [-3 2] [-4 2]]
      number0 patches at-points [[-2 2] [-3 2] [-4 2]]
      set branch0 patch-set patches with [pxcor < -1 and pxcor > -4 and pycor = 2]]
    if (color = 34)
    [paint-areas patches at-points [[2 2] [3 2] [4 2] [-2 2] [-3 2] [-4 2]]
      number0 patches at-points [[-2 2] [-3 2] [-4 2]]
      number1 patches at-points [[2 2] [3 2] [4 2]]
    set branch0 patch-set patches with [pxcor < -1 and pxcor > -5 and pycor = 2]
    set branch1 patch-set patches with [pxcor < 5 and pxcor > 1 and pycor = 2]]
    if (color = 35)
    [paint-areas patches at-points [[-2 -2] [-3 -2] [-4 -2] [2 2] [3 2] [4 2] [-2 2] [-3 2] [-4 2]]
      number0 patches at-points [[-2 2] [-3 2] [-4 2]]
      number1 patches at-points [[2 2] [3 2] [4 2]]
      number2 patches at-points [[-2 -2] [-3 -2] [-4 -2]]
    set branch0 patch-set patches with [pxcor < -1 and pxcor > -5 and pycor = 2]
    set branch1 patch-set patches with [pxcor < 5 and pxcor > 1 and pycor = 2]
    set branch2 patch-set patches with [pxcor < -1 and pxcor > -5 and pycor = -2]]
    if (color = 36)
    [paint-areas patches at-points [[2 -2] [3 -2] [4 -2] [-2 -2] [-3 -2] [-4 -2] [2 2] [3 2] [4 2] [-2 2] [-3 2] [-4 2]]
      number0 patches at-points [[-2 2] [-3 2] [-4 2]]
      number1 patches at-points [[2 2] [3 2] [4 2]]
      number2 patches at-points [[-2 -2] [-3 -2] [-4 -2]]
      number3 patches at-points [[2 -2] [3 -2] [4 -2]]
    set branch0 patch-set patches with [pxcor < -1 and pxcor > -5 and pycor = 2]
    set branch1 patch-set patches with [pxcor < 5 and pxcor > 1 and pycor = 2]
    set branch2 patch-set patches with [pxcor < -1 and pxcor > -5 and pycor = -2]
    set branch3 patch-set patches with [pxcor < 5 and pxcor > 1 and pycor = -2]]
        ]
  display

  ;;setup branches
  set branches patches with [(pcolor > 32 and pcolor < 37)]
  ask branches [set display-branch? true]

  ask regions [die]
end

;; code for numbering the branches individually

to number0 [agents]
  ask agents [set branch-num "0"]
end
to number1 [agents]
  ask agents [set branch-num "1"]
end
to number2 [agents]
  ask agents [set branch-num "2"]
end
to number3 [agents]
  ask agents [set branch-num "3"]
end

to paint-areas [agents]
  ask agents [ set pcolor [color] of myself]
end

;;--------
;; TO GO
;;--------

to go
  ;;manakin behaviors
  ask mManakins [mManakin-actions]
  ask fManakins [fManakin-actions]

  tick
end

;;---------------
;; agent upkeep
;;---------------



;;-------------------------------------------
;; mother code for the actions of the birds
;; base of the actions tree that calls functions that call other functions
;;-------------------------------------------

to fManakin-actions
  if (attention = 0) [wander]
    ;;will need to be more complex with the calls in the future
  if (attention = 0) [give-attention]
  if (attention != 0) [
    fperform
  ]

end

to mManakin-actions
  ;;male actions
    ;;mating
  if (fManakins != 0) [when-females]
  ;;female actions

end

;;just wandering
to wander
    rt random 90
    lt random 90
    forward 1
end

;;--------------------
;; male bird actions
;;--------------------

to when-females
  ;;beta activities
  ifelse (any? turtles with [breed = fManakins]) [perform] [wander]
end

;; mating ritual behaviors

to perform

  ;;if we are at a dance, that dance has been done. therefor points should be awarded
  ;;if we are at a dance we can go to other dances depending on a few things
  ;;a random number will be manipulated by the copulation chance and reporductive succes
  ;;that random number will decide where we go from there
  ;;but this decision is only made after a cetain amount of repititions from that dance
  ;;some dances take longer than others because of their looping nature
  ;;while loops within these dances to keep inside of the perform so that a dance is done each perform loop
  ;;would that mess up the female cutting down their score, though?
  ;;either way, there should be a mess up possibility and a random helpful possibility based on
  ;;age this time, because age is undeniable experience

  ;;now depending on how good they are doing and how experienced the alpha is, they will repeat
  ;; important expeciallly for single male performances
  if (role = "beta") and
  (current-dance = "solo-slow-flight1" or
   current-dance = "back-and-forth" or
   current-dance = "swoop" or
   current-dance = "solo-slow-flight2" or
   current-dance = "bounce" or
   current-dance = "bow" or
    current-dance = "copulate") [watch-support stop]

  let three ((alpha-rating + beta1-rating + beta2-rating) / 3)
  let two ((alpha-rating + beta1-rating) / 2)
  let multiplier 0

  if (count mManakins) = 2 [set multiplier two]
  if (count mManakins) = 3 [set multiplier three]

  print multiplier

  if current-dance = "start" [
    start

    if (role = "alpha") [
      ifelse ((count mManakins) > 1) [set current-dance "paired-slow-flight1"] [set current-dance "solo-slow-flight1"]]

    stop
  ]
  if current-dance = "return-to-branch0" [
    while [patch-here != patch -3 2] [return-to-branch0]

    stop
  ]
  if current-dance = "pip-flight" [
    if (role = "alpha") [
      set copulation-chance copulation-chance + (multiplier / (random 5 + 8))]
    let i 0
    while [i < 30] [pip-flight set i i + 1]
    ;;to paired-slow-flight1
    if (role = "alpha") [
      set current-dance "paired-slow-flight1"]

    stop
    ]
  if current-dance = "up-and-down" [
    if (role = "alpha") [
      set copulation-chance copulation-chance + (multiplier / (random 5 + 8))]
    let i 0
    while [i < 20] [up-and-down set i i + 1]
    ;;to paired-slow-flight1
    if (role = "alpha") [
      set current-dance "paired-slow-flight1"]

    stop
    ]
  if current-dance = "paired-slow-flight1" [
    if (role = "alpha") [
      set copulation-chance copulation-chance + (multiplier / (random 5 + 8))]
    let i 0
    while [i < 40] [paired-slow-flight set i i + 1]

    let next (random 4)
    if (copulation-chance < 10) [if ((random 100) < multiplier) [set next next + 2]]
    ;;to up-and-down
    ;;to leapfrog-dance
    if (role = "alpha") [
      ifelse next > 2 [set current-dance "up-and-down"] [set current-dance "leapfrog-dance"]]

    stop
    ]
  if current-dance = "paired-slow-flight2" [
    if (role = "alpha") [
      set copulation-chance copulation-chance + (multiplier / (random 5 + 8))]
    let i 0
    while [i < 40] [paired-slow-flight set i i + 1]
    ;;solo-slow-flight1
    if (role = "alpha") [
      set current-dance "solo-slow-flight1"]

    stop
      ]
  if current-dance = "leapfrog-dance" [
    if (role = "alpha") [
      set copulation-chance copulation-chance + (multiplier / (random 5 + 8))]
    let i 0
    while [i < 20] [leapfrog-dance set i i + 1]

    let next (random 4)
    if (copulation-chance < 30) [if ((random 100) < multiplier) [set next next + 2]]
    ;;to eek
    ;;to solo-slow-flight1
    if (role = "alpha") [
      if-else next > 2 [set current-dance "eek"] [set current-dance "solo-slow-flight1"]]

    stop
      ]
  if current-dance = "eek" [
    if (role = "alpha") [
      set copulation-chance copulation-chance + (multiplier / (random 5 + 8))]
    let i 0
    while [i < 10] [eek set i i + 1]

    let next (random 4)
    if (copulation-chance < 40) [if ((random 100) < alpha-rating) [set next next + 2]]
    ;;to paired-slow-flight1
    ;;to paired-slow-flight2
    if (role = "alpha") [
      ifelse next > 2 [set current-dance "paired-slow-flight1"] [set current-dance "paired-slow-flight2"]]

    stop
  ]
  if current-dance = "solo-slow-flight1" [
    set copulation-chance copulation-chance + (alpha-rating / (random 5 + 8))
    let i 0
    while [i < 40] [solo-slow-flight set i i + 1]

    let next (random 4)
    if (copulation-chance < 50) [if ((random 100) < alpha-rating) [set next next + 2]]
    ;;to back-and-forth
    ;;to swoop
    if (role = "alpha") [
      ifelse next > 2 [set current-dance "back-and-forth"] [set current-dance "swoop"]]

    stop
  ]
  if current-dance = "back-and-forth" [
    set copulation-chance copulation-chance + (alpha-rating / (random 5 + 8))
    let i 0
    while [i < 10] [back-and-forth set i i + 1]

    ;;to solo-slow-flight1
    if (role = "alpha") [
      set current-dance "solo-slow-flight1"]

    stop
  ]
  if current-dance = "swoop" [
    set copulation-chance copulation-chance + (alpha-rating / (random 5 + 8))
    let i 0
    while [i < 20] [swoop set i i + 1]
    ;;to solo-slow-flight2
    if (role = "alpha") [
      set current-dance "solo-slow-flight2"]

    stop
  ]
  if current-dance = "solo-slow-flight2" [
    set copulation-chance copulation-chance + (alpha-rating / (random 5 + 8))
    let i 0
    while [i < 40] [solo-slow-flight set i i + 1]

    ;;to bounce
    if (role = "alpha") [
      set current-dance "bounce"]

    stop
  ]
  if current-dance = "bounce" [
    set copulation-chance copulation-chance + (alpha-rating / (random 5 + 8))
    let i 0
    while [i < 40] [bounce set i i + 1]

    ;;to bow
    set current-dance "bow"
      ]
   if current-dance = "bow" [
     bow

     ;;maybe back to solo-slow-flight
     let next (random 4)
     if (copulation-chance < 70) [if ((random 100) < alpha-rating) [set next next + 1]]
    if (role = "alpha") [
      if-else next > 2 [set current-dance "solo-slow-flight2"] [set current-dance "copulate"]]

    stop
  ]
   if current-dance = "copulate" [
        copulate-male]

end

to start
  print "start"
  ;; to draw out a female
  while [patch-here != (patch -3 2)] [return-to-branch0]

end

to return-to-branch0
  print "return-to-branch0"

  face patch -3 2
  fd 0.5
end

to watch-support
  print "solo"

  while [patch-here != patch 9 0] [
    face patch 9 0
    fd 0.5]
end

to pip-flight
  print "pip-flight"

  if distance (patch -3 2) < 2 [
    fd 0.5]
  if distance (patch -3 2) > 2 and distance (patch -3 2) < 3[
    lt 15 fd 0.5]
  if distance (patch -3 2) > 3 [
    face patch -3 2 fd 1]


end

to paired-slow-flight
  print "paired-slow-flight"

  if there = 0 [face patch -3 2 forward 0.3]
    if patch-here = patch -3 2 [set here 0 set-there]
  if there = 1 [face patch 3 2 forward 0.3]
    if patch-here = patch 3 2 [set here 1 set-there]
  if there = 2 [face patch -3 -2 forward 0.3]
    if patch-here = patch -3 -2 [set here 2 set-there]
  if there = 3 [face patch 3 -2 forward 0.3]
    if patch-here = patch 3 -2 [set here 3 set-there]

end

to set-there
  set there (random number-of-branches)
  if (here = there) [
    set there there + 1
    if there > (number-of-Branches - 1) [set there 0]]
end

to up-and-down
  print "up-and-down"

  while [patch-here != (patch -3 2)] [return-to-branch0]

  set heading 0
  forward 1
  set heading 180
  forward 1


end

to leapfrog-dance
  print "leapfrog-dance"

  while [patch-here != (patch -3 2)] [return-to-branch0]

  ask min-one-of mManakins [xcor] [
    set heading 0
    forward 1
    set heading 90
    forward 0.7
    set heading 180
    forward 1]

  set heading 270
  forward 0.7

end

to back-and-forth
  print "back-and-forth"

  while [patch-here != (patch -3 2)] [return-to-branch0]

  if role = "alpha" [
    set heading 90
    fd 1
    fd 1
    set heading 270
    fd 1
    fd 1
    set heading 90
    fd 1
    fd 1
    set heading 270
    fd 1
    fd 1
    set heading 90
    fd 1
    fd 1
    set heading 270
    fd 1
    fd 1]
  if current-dance = "back-and-forth" and role = "beta" [wander]

end

to eek
  ;;this will determine what happens next/if the performance will become solo
end

to solo-slow-flight
  print "solo-slow-flight"

  set-there

  if there = 0 [face patch -3 2 forward 0.3]
    if patch-here = patch -3 2 [set here 0 set-there]
  if there = 1 [face patch 3 2 forward 0.3]
    if patch-here = patch 3 2 [set here 1 set-there]
  if there = 2 [face patch -3 -2 forward 0.3]
    if patch-here = patch -3 -2 [set here 2 set-there]
  if there = 3 [face patch 3 -2 forward 0.3]
    if patch-here = patch 3 -2 [set here 3 set-there]


end

to quick-turn
  print "quick-turn"

  let x here
  set here there
  set there x

end

to swoop
  print "swoop"

  if high-enough = 0 [
    set heading 0
    forward 0.5]
  if ycor >= 9 [set high-enough 1]
  if high-enough = 1 [
    set heading 180
    forward 2]
  if ycor <= 0 [set low-enough 1]
  if low-enough = 1 [while [patch-here != (patch -3 2)] [return-to-branch0]]

end

to bounce
  print "bounce"

  if there = 0 [face patch -3 4 forward 0.3]
  if patch-here = patch -3 4 [
    set here 0
    set heading 180
    fd 2
    set heading 90
    fd 2
    set-there
    set bounces bounces + 1
  ]
  if there = 1 [face patch 3 4 forward 0.3]
  if patch-here = patch 3 4 [
    set here 1
    set heading 180
    fd 2
    set heading 90
    fd 2
    set-there
    set bounces bounces + 1
  ]
  if there = 2 [face patch -3 0 forward 0.3]
  if patch-here = patch -3 0 [
    set here 2
    set heading 180
    fd 2
    set heading 90
    fd 2
    set-there
    set bounces bounces + 1
  ]
  if there = 3 [face patch 3 0 forward 0.3]
    if patch-here = patch 3 0 [
    set here 3
    set heading 180
    fd 2
    set heading 90
    fd 2
    set-there
    set bounces bounces + 1
  ]

  if total-bounces = bounces [while [patch-here != (patch -3 2)] [return-to-branch0]]

end

to bow
  print "bow"

  while [patch-here != (patch -3 2)] [return-to-branch0]

  set heading 90
  set heading 180
  set heading 90
  set heading 0
  set heading 90
  set heading 270

end

to copulate-male
  face patch -3 2
  fd 1
  ask fManakins [copulate]
end

;;---------------------
;; female bird actions
;;----------------------

;; stoping at a display area to possibly copulate

to give-attention
    set attention 1
    ;;if other females dont make connection
    if ((count my-links) = 0 and attention != 0) [
      create-links-with other fManakins with [[attention] of myself = attention]
      if ((count my-links) > 0) [
        ask my-links [die]
        set attention 0
        stop
    ]]

  if attention != 0 and (any? mManakins with [[attention] of myself = partnership-num]) [
      create-links-with other mManakins with [[attention] of myself = partnership-num and (role = "alpha")]
  ]
end

to fperform
  if copulation-chance > 10 [to-branch0]

  ;;back and forth at some point
  if copulation-chance > freproductive-success and
  (count mManakins with [current-dance = "solo-slow-flight"]) = 1 [
    let show-affection (random 4)
    if show-affection = 0 [fBack-and-forth]

  ]

end

to to-branch0
  while [patch-here != (patch -4 2)] [
    face patch -4 2
    fd 0.5]
end

to fBack-and-forth
  set heading 90
    fd 1
    fd 1
    set heading 270
    fd 1
    fd 1
    set heading 90
    fd 1
    fd 1
    set heading 270
    fd 1
    fd 1
    set heading 90
    fd 1
    fd 1
    set heading 270
    fd 1
    fd 1

  set fdance "to-branch0"
end

;; successful mating performance
to copulate

    if (copulation-chance > freproductive-success) [
        set pregnant?
        true print "successful copulation"]

    if (copulation-chance < freproductive-success) [print "unsuccessful copulation"]

   ;;break link with female whether or not copulate
     set attention 0
     ask my-links [die]


end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
491
292
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-10
10
-10
10
0
0
1
ticks
30.0

BUTTON
10
12
74
45
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
12
60
184
93
number-of-Branches
number-of-Branches
1
4
4.0
1
1
NIL
HORIZONTAL

BUTTON
98
18
162
52
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
496
10
600
43
Alpha
Alpha
0
1
-1000

SLIDER
621
63
794
96
alpha-rating
alpha-rating
0
100
50.0
1
1
NIL
HORIZONTAL

SWITCH
507
139
611
172
Beta1
Beta1
0
1
-1000

SLIDER
626
170
799
203
beta1-rating
beta1-rating
0
100
100.0
1
1
NIL
HORIZONTAL

SWITCH
510
223
614
256
Beta2
Beta2
0
1
-1000

SLIDER
624
267
797
300
beta2-rating
beta2-rating
0
100
100.0
1
1
NIL
HORIZONTAL

BUTTON
33
242
153
276
Send in Female
female
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
273
304
446
337
female-rating
female-rating
0
100
50.0
1
1
NIL
HORIZONTAL

PLOT
28
106
188
226
Copulation-chance
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot copulation-chance"

SWITCH
43
293
146
326
female
female
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

This is a model for showing the behavior of the long tailed manakin and the way that they court.

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)

## MY TO-DO LIST

- begin by making the lek
- add slider for display areas
display areas are generally occupied by two to eight males, one paur of which perform courtship displays for females. males change but the areas dont. 
- random amount of display perches
	display perches need to be able to be used as a spot to be for the birds, even though they can be anywhere
- birds and their shape
- male birds and their characteristics
	dom, sub, ownership, plumage, partnerships
- female birds and their characteristics
	plumage
- work on partnerships of male birds
	dances, cleaning, practices
ideas for the dances
 shake, turn different colors, jump around and movement, 
- work on solo dances of male birds
- work on female reaction to these things
- finally figure out the percentage of success rates for all everything

-year clock
	seasons, mating, aging, pluamge(4th year breeding season)
-figure out the changing of roles in male birds
-possibility of songs to accompany dance
	color to display calls
	page on this



Leks consist of multiple display areas
Display areas generally contained 1-4 display perches.

*slider for amount of display areas in the lek

Both display areas and display perches were reused in multuple years and remained in use even when the birds at them changes. dance perches are ubiquitous

males will clean their areas. tearing nearby leaves and dropping them. the would also peck at the perches themselves, scoring the branch where they danced.

dance displays were usually done by matured birds(in definitve plumage). In the rare case that a premature bird danced, it did not end in copulation(ended badly in fact). However, these young birds will pratice dances and clean display areas. these dances were directed at the partner, rather than a third bird or area were a third bird would be.

in each display area only one male bird performs the solo dances that always precede copulation. therefore each display area is the territory of one male bird where a female can mate. 

sometimes the displays are entirely solitary

females have a bunch of oppourtunities to access males. females attend dance displays year round, i am not sure if these dance displays are meant to end in copulation eunless they are during the peak breeding season. 

the males seem to form affiliations with one another, leading to stable relationships and tighter displays for the women

*a year long clock may be something worth looking into

some dances are only for solo artists

 Many males who did not participate in alpha beta duets had lower reproductive success than those who participated (DuVal, 2012) Males who participated in the beta role were more likely to have future reproductive success after helping the alpha mate (DuVal 2012). This is likely because they become the new alpha males once the original alpha males leave (DuVal 2012). This demonstrates a complex social network helps drive the cooperative courtship behaviors of certain manakin species such as the lance-tailed manakin

Duet singing and dance displays for females were observed during all daylight hours, with a relatively inactive period in the mid-morning. Copulations, too, took place throughout the day, but were somewhat more common in the early aft ernoon than at other times (Fig. 2C)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bird side
false
0
Polygon -7500403 true true 0 120 45 90 75 90 105 120 150 120 240 135 285 120 285 135 300 150 240 150 195 165 255 195 210 195 150 210 90 195 60 180 45 135
Circle -16777216 true false 38 98 14

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="f25" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count fManakins with [pregnant? = true]</metric>
    <enumeratedValueSet variable="beta1-rating">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta1">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta2-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Alpha">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta2">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-Branches">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="2b50" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count fManakins with [pregnant? = true]</metric>
    <enumeratedValueSet variable="beta1-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta1">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta2-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Alpha">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta2">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-Branches">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="2b75" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count fManakins with [pregnant? = true]</metric>
    <enumeratedValueSet variable="beta1-rating">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta1">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta2-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Alpha">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta2">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-Branches">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="2b100" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count fManakins with [pregnant? = true]</metric>
    <enumeratedValueSet variable="beta1-rating">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta1">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta2-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Alpha">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta2">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-Branches">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3b25" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count fManakins with [pregnant? = true]</metric>
    <enumeratedValueSet variable="beta1-rating">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta1">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta2-rating">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Alpha">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta2">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-Branches">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3b50" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count fManakins with [pregnant? = true]</metric>
    <enumeratedValueSet variable="beta1-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta1">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta2-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Alpha">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta2">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-Branches">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3b75" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count fManakins with [pregnant? = true]</metric>
    <enumeratedValueSet variable="beta1-rating">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta1">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta2-rating">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Alpha">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta2">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-Branches">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3b100" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count fManakins with [pregnant? = true]</metric>
    <enumeratedValueSet variable="beta1-rating">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta1">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta2-rating">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Alpha">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Beta2">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="female-rating">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-Branches">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
