//
//  SchemaDefenition.swift
//  InfoNetPm
//
//  Created by jyv on 11/26/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.


//



/*
 the project managment entity are
 
 Company
 
 A Company has 0 to many plan
 
 a project is defined for a service provider
 a project can have manys plan
 
 a Plan id is done by a service provider
 a Plan is for a client (cound be also the servie provider)
 a Plan could by flaged as template to create easily other plans of the same type
 a Plan has many activites executed by resources
 a Plan has a start time.
 an activivy has a duration and start after dependant activities
 an activity is execute by a resource with a predetermined role
 an activity has many tasks executed by the same resource
 an activiy has a document to explain tasks to execute

 a task is something to be done by a resource and has a result
 a task can generate an issue if the resource can't complete it
 
 
 
 
 
 
 */
import Foundation
