# TolJava Web Application Demo (`tol-master/TolJava/WebTOLJavaDEMO/`)

## Overview

This directory contains a sample Java web application demonstrating the use of the **TolJava** binding within a server-side web environment.

## Contents

- **Java Source (`src/`):** Contains server-side Java code, likely including:
    - Java Servlets or other framework controllers that handle HTTP requests.
    - Business logic classes that utilize the TolJava API (`TolJava.jar` and the JNI library) to interact with the TOL engine (e.g., execute TOL scripts based on user input).
    - Data handling classes to prepare data for TOL or process results for web display.
- **Web Content (`web/`):** Contains the standard components of a Java web application:
    - User interface files (HTML, JSP, CSS, JavaScript).
    - Web application deployment descriptor (`WEB-INF/web.xml`), defining servlets, mappings, and other configuration.
    - Potentially required JAR libraries (`WEB-INF/lib/` - although `TolJava.jar` might be expected elsewhere on the server).
- **Build Script (`build.xml`):** An Apache Ant script defining targets to:
    - Compile the Java source code in `src/`.
    - Assemble the web application structure.
    - Create a Web Application Archive (`.war`) file suitable for deployment to a Java Servlet container/Application Server (e.g., Tomcat, Jetty).
- **IDE Support (`nbproject/`):** NetBeans IDE project files for developing and running this web application demo.

## Purpose

This web application serves as a demonstration of how the TolJava binding can be used in a server-side context. It shows how to build web interfaces that allow users to interact with the TOL engine through a browser, enabling web-based access to TOL's computational capabilities.

## Appendix

- **Technology:** Java Servlets/JSP, HTML, CSS, JavaScript, Apache Ant, JNI, TolJava.
- **Dependencies:** Requires a Java Servlet container (e.g., Tomcat), the compiled `TolJava.jar`, and the TolJava JNI native library.
- **Build:** Built into a `.war` file using Apache Ant (`build.xml`). 
