# WebTOLJavaDEMO Web Content (`tol-master/TolJava/WebTOLJavaDEMO/web/`)

## Overview

This directory contains the web application content root for the **WebTOLJavaDEMO**. It holds the files that define the user interface and static resources served to the browser.

## Contents

This follows the standard structure for a Java Web Application:

- **JavaServer Pages (`.jsp`, `.jspf`):** Files defining the dynamic HTML content and presentation logic. Notable pages include `Inicio.jsp` (likely the start page), `Explorador.jsp` (Object explorer?), `Interprete.jsp` (TOL interpreter interface?), and `Ejemplos.jsp` (Examples view?). `.jspf` files (`Encabezado.jspf`, `MenuIzquierdo.jspf`) are likely reusable page fragments (header, menu).
- **Standard Directories:**
    - **`META-INF/`:** Standard Java EE directory, might contain context information.
    - **`WEB-INF/`:** Crucial directory containing:
        - `web.xml`: The web application deployment descriptor (defining servlets, filters, listeners, etc.).
        - `lib/` (if present): Required JAR libraries (though `TolJava.jar` might be deployed separately).
        - `classes/` (if present): Compiled Java classes (usually handled by the build process).
- **Static Resources:** Directories containing client-side assets:
    - **`js/`:** JavaScript files.
    - **`resources/`:** Likely CSS files, images, or other static assets (e.g., PrimeFaces resources if used).
    - **`docs/`:** Documentation specific to the web demo.
    - **`dist/`:** Possibly distribution-related files or compiled/minified static assets.
    - **`sh/`:** Shell scripts, perhaps for deployment or management tasks related to the web app.

## Purpose

These files define the user-facing part of the WebTOLJavaDEMO, providing the HTML structure, dynamic content generation (via JSP), and client-side interactivity (via JavaScript and CSS) for interacting with the TOL engine through a web browser.

## Appendix

- **Technology:** JSP, HTML, CSS, JavaScript, possibly JSF or other Java web frameworks.
- **Deployment:** Packaged into a `.war` file along with the compiled Java classes from the `src` directory. 
