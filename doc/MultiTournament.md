# Multi tournament support 

Broke into phases

 - Phase 1: No double entry
  - Goal is to remove the need to re key in institution/participant/team manager data 
  - All data in one database
  - Migrate existing installations data
  - Will allow participants to login and manager their own participant data that can be reused for multiple tournaments

 - Phase 2: Add participant specific features
  - Capture tournament results and make it available to participants
  - <Other participant specific features that we feel important>

 - Phase 3: Complete host self service
  - Allows for host to create their own tournaments in the system without needing our intervention

## Phase 1 Flow

- FastRego team will be able to add tournaments to the system. 
  - When adding tournaments we will also add the admin_user (host) to the system.
  - When adding tournaments we will also determine the identifier of the tournament (e.g. uadc2012, neao2012 etc), which will be provided to the hosts
  - DISCUSS, do we need to support more then one tournament to an admin_user (host)
    - add tournament_id to admin_user (host)
    - or add admin-usert_tournament table
    - Either case the host will be able to only view one tournaments  data at time in the backend, determined by the subdomain used

- Host logging into the system backend
  - Hosts will be able to login to the system via 
    - identifier.fastrego.com/admin or  fastrego.com/identifier/admin, this is to be determined based on which is easier to implement
    
- Team managers registering for tournaments
  - Hosts will be able to publisize the provided URL, either fastrego.com/identifier or indentifier.fastrego.com to team managers to register themselves as team managers for a tournament
  - We will list all the institutions stored in the system backend and provide the ability to register as the institutions team manager 
  - DISCUSS -we do not care about historical team managers, we will simplify things by making team managers tournament specific
  _ As per current, team managers, will be able to login to the system (if they already exist in the fastrego system) or add themselves to the system
  - In the case that the institution does not exist, the team manager will be able to add the institution which will be added to the global institutions table
  - DISCUSS, this could result in a lot of crap data over time
  - DISCUSS, do we need to allow the ability of hosts to limit institutions for a tournament, I think not cause at the end of the day, even if limited someone will be able to just key in the instiution if they don't see it in the list anyway

- Team manager requesting slots
  - This would work exactly as it does today

- Host granting slots
  - This would work exactly as how it does today

- Team manager recording payments in the system
  - This would work exactly as how it does today

- Host granting slots
  - This would work exactly as how it does today

- Team manager adding participants against  hist confirmed slots 
  - Team manager will be able to key in email of participant, if the email already exists in the system the participants details are pulled up and only the tournament specific details are keyed in 
    - DISCUSS, do we do this whether or not the participants account has been "enabled" ?
  - If participant does not exist, team manager can key in participants details as per usual and participant will be sent an email to "enable" their fastrego account
    - What if participant does not "enable" account, do we care ?
  - DISCUSS, Institutions are associated to participants via the registration which is created by a team manager, in other words, institution is not a participant attribute
  - DISCUSS, for existing participants will participant fields be copied over and overidable by team managers or are participant fields just whatever they are 

  - DISCUSS, what fields are tournament specific ?
  
  participant table

  * email
  * name 
  * gender 
  * debate_experience
  * adjudicator_experience
  * t-shirt size
  * passport number
  * nationality
  * dietary_requirement
  * allergies
    
  participant_tournament table

  * registration_id
  * arrival_at
  * transportation_number
  * type (adjudicator / debater / observer)
  * point_of_entry
  * emergency_contact_person 
  * emergency_contact_number
  * preferred_roommate
  * preferred_roommate_institution
  * departure_at 
  * speaker_number 
  * team_number



## Phase 1 changes required

- For all existing installations, make email column on existing participants table unique. This will make migrating the data to the MT system easier

- Add tournament table
 
  * active
  * subdomain 
  
- add tournament_id to settings 

- institution is an attribute of the registration as it is now, it is decoupled from participant and is determined by the what the team manager sets  
- add tournament_id to registration 

###Front end changes

- add participant_registration table, move tournament specific fields over

- DISCUSS, what fields are tournament specific ?
  
  participant table

  * email
  * name 
  * gender 
  * debate_experience
  * adjudicator_experience
  * t-shirt size
  * passport number
  * nationality
  * dietary_requirement
  * allergies
    
  participant_tournament table

  * registration_id
  * arrival_at
  * transportation_number
  * type (adjudicator / debater / observer)
  * point_of_entry
  * emergency_contact_person 
  * emergency_contact_number
  * preferred_roommate
  * preferred_roommate_institution
  * departure_at 
  * speaker_number 
  * team_number


- add user_tournament table
