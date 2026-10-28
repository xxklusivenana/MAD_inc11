# Sign Up Form
Janiya Green<br>
Undergraduate Track<br>
Github Repo Link: https://github.com/xxklusivenana/MAD_inc11/tree/main/signup_app

## Concept Questions
1. The Clairvoyant Ghost 
Imagine a student let an AI write the date-picker, and it shipped lastDate: DateTime(1990). Nobody notices because nobody tested. Design a five-row test table (input → expected → observed) that would have exposed this bug, run it against your picker, and report which rows your current code passes or fails — with screenshots. 

2. The Poltergeist Field 
After rotating your emulator mid-signup, one of your three values disappears while others survive. Identify which value haunts you in your build (name? toggle? birth date?), trace exactly where each value lives in your code (controller? State field? nothing?), explain why one survives rotation and another doesn't, and propose the smallest fix. 

## Ghost Hunt
| Test Case | Observed Results |
| --------- | ---------------- |
| Empty fields + Join the Mansion → all three validators fire from Activity 10. | ![Case Results](media/evidence/empty_submit.png) |
| Email without @, password under 6 chars → correct error under the right field. | ![Case Results](media/evidence/hunt2.png) |
| Eye toggle → password shows as letters, then hides again; validator still works both ways. | ![Case Results](media/evidence/hunt3.png) |
| Date picker → no future date selectable; empty date blocks submission. | ![Case Results](media/evidence/hunt4.png) |
| Back from the Lab → returns to the Foyer; typed values are gone (state died with the screen). | ![Case Results](media/evidence/hunt5.png) |
| From the Ballroom → system Back does not resubmit the form (pushReplacement worked). | ![Case Results](media/evidence/hunt6.png) |
| Double-tap Sign Up during loading → only one navigation happens (button was disabled). | ![Case Results](media/evidence/hunt7.png) |
| Confetti fires once on arrival; leaving and returning doesn't crash.  | ![Case Results](media/evidence/hunt8.png) |


## Bug Graveyard
| Symptom | suspected Cause | fix | evidence |
| ------- | --------------- | --- | -------- |
| ------- | --------------- | --- | -------- |