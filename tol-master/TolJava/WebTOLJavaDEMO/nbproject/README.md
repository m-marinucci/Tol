# NetBeans Project Files (Web Demo) (`tol-master/TolJava/WebTOLJavaDEMO/nbproject/`)

## Overview

This directory contains project configuration files specifically for the **NetBeans Integrated Development Environment (IDE)**. These files are used by NetBeans to manage the **WebTOLJavaDEMO** web application project located in the parent directory (`tol-master/TolJava/WebTOLJavaDEMO/`).

## Contents

These files are characteristic of a NetBeans Java Web Application project:

- **`project.xml`, `project.properties`:** Define project metadata, web application structure (source/web directories), classpath (including dependencies like `TolJava.jar` and servlet APIs), server deployment settings, and other project-level configuration.
- **`build-impl.xml`, `ant-deploy.xml`:** Contain NetBeans-generated Ant build and deployment script logic, extending the main `build.xml` in the parent directory, handling tasks like compiling servlets/classes, packaging into a `.war` file, and deploying to a configured server (e.g., Tomcat).
- **`faces-config.NavData`:** NetBeans-specific file related to visual configuration of JavaServer Faces (JSF) navigation rules, indicating JSF might be used in the demo.
- **`genfiles.properties`:** Properties related to generated files.
- **`private/`:** Contains user-specific NetBeans settings or metadata for the web demo project.

## Purpose

These files enable developers using the NetBeans IDE to easily open, build, run, debug, and deploy the `WebTOLJavaDEMO` web application. They store the IDE-specific configuration needed for managing a Java web project that utilizes the TolJava API.

## Appendix

- **Technology:** NetBeans IDE Web project format, Apache Ant, Java Web Applications (.war), possibly JSF.
- **Usage:** Used automatically by the NetBeans IDE when working with the WebTOLJavaDEMO project. 
