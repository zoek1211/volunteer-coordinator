# volunteer-coordinator

## Overview

This project addresses the challenge of efficiently managing volunteer coordination for nonprofit organizations. 
By developing an object-relational database system, it supports multiple user groups including Volunteers, Coordinators, and Nonprofit Organizations, streamlining communication, task assignment, and record keeping.

The database design follows an object-oriented approach, leveraging Oracle's advanced features such as user-defined types, object tables, and methods to implement complex behaviors and relationships.

## Problem Statement

Nonprofit organizations often struggle to coordinate volunteers effectively due to disparate record-keeping systems and lack of real-time task management. 
This project solves these problems by creating a robust, flexible database that captures all essential entities and their interactions, improving operational efficiency and volunteer engagement.

## Major User Views

Volunteers: View and update their availability, track assigned tasks, and receive notifications.


Coordinators: Manage volunteer assignments, schedule events, and oversee volunteer performance.

Nonprofit Organizations: Oversee multiple projects and coordinate with coordinators and volunteers.

## Design Approach

Object-Relational Model: The database design uses an object-oriented paradigm within Oracle, employing user-defined types (UDTs) and object tables.

Class Diagram: Developed a detailed class diagram illustrating class hierarchies, inheritance (supertype-subtype), associations, compositions, and association classes to represent relationships between entities.

Type Bodies & Methods: Created member methods such as map, order, and overridden methods to implement business logic and encapsulate behavior within types.
References: Utilized REF properties to establish relationships between objects, ensuring referential integrity and efficient navigation.

XML and XSU Queries: Formulated XML and XSU queries to demonstrate advanced data extraction and transformation capabilities.

## Features

Logical schema conversion from class diagram to SQL statements.

Definition of object types, type bodies, and object tables in Oracle.

Implementation of member methods for complex operations and inheritance behaviors.

Demonstration of querying capabilities with SQL and XML/XSU.

Support for multiple user roles with tailored data views.

## Technologies Used

Oracle Database (Object-Relational features)

SQL / PL/SQL

XML and XSU (XML SQL Utility)

UML (Class Diagrams for design)
