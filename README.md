# infonetpm :
Mobile First Project Management (iOS)

NOT READY YET


An overview of the functionalities

This software is designed to manage the execution of a plan for a project with a IPhone. It is a mobile first application, because the mobile version is develop first. It most be possible to define, design and execute plan via a IPhone. The interface must be very simple and must contains only the essential information.

3 server applications servers will be needed for this mobile application
- a chat server
- a database server
- a services server on to of the database server

Here are short descriptions of the functionalities that will be needed for the version 1.

The goal of this mobile application is to follow plan's activities with a IPhone and minimize the action needed by the PM.
The software manage the plan via a chat room. With simple chatting pattern (activity xx success, activity xx failed) the software will automatically launch the next activity, call a resource to resolve issues or stop the execution of the plan.

The PM simply followed the plan execution via the chat room. The chat room contain human conversations and conversations with the software. A kind of artificial intelligence for managing live project.

- A project has one to many plans
- A plan is executed at a start date
- A plan has one to many activities
- An activity is executed by a resource and has a duration
- A resource has a role for an activity and work within a specific time zone
- The project manager follows activities
- An activity could have a supported document (list of tasks, helps, etc.)
- An activity has zero to many tasks (the tasks level is optional)
- Tasks are not followed by the project manager
- Tasks are more detailed than activities
- A task can have a supported document (steps to follow, photo and video)
- A task is executed by a resource, has duration and a result
- A task has zero to many issues.
- An issue is created when a task can't be completed (status: failed)
- An issue can have a supported document (photo, video)
- A chat room is created at the beginning of the execution plan
- Resources report status via the chat room:  (activity xx completed, activity xx failed)
- The chat room could also be used for normal chatting between resources assigned to the plan
- Notification to start next activity is managed by the software (chat room, SMS, email, telephone) via status get from the chat room
- The project manager drives the plan and take action when needed

