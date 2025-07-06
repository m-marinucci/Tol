#!/bin/bash
# Documentation deployment script for TOL project
# Generates and deploys comprehensive documentation

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DOCS_DIR="${PROJECT_ROOT}/docs"
BUILD_DIR="${PROJECT_ROOT}/tol/build"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Create documentation directory
mkdir -p "$DOCS_DIR"

log_info "Starting documentation generation for TOL project"

# Generate Doxygen configuration
create_doxygen_config() {
    local config_file="$DOCS_DIR/Doxyfile"
    
    log_info "Creating Doxygen configuration: $config_file"
    
    cat > "$config_file" << 'EOF'
# Doxygen configuration for TOL project

# Project information
PROJECT_NAME           = "TOL - Time Oriented Language"
PROJECT_NUMBER         = "1.0.0"
PROJECT_BRIEF          = "A powerful language for time series analysis and mathematical modeling"
PROJECT_LOGO           = 

# Input configuration
INPUT                  = ../tol/
RECURSIVE              = YES
FILE_PATTERNS          = *.cpp *.h *.hpp *.c *.cc *.cxx *.h++ *.hh *.hxx *.tol
EXCLUDE_PATTERNS       = */build/* */cmake/* */contrib/* */config/* */autom4te.cache/*
EXCLUDE_SYMBOLS        = 

# Output configuration
OUTPUT_DIRECTORY       = ./
GENERATE_HTML          = YES
GENERATE_LATEX         = NO
GENERATE_XML           = YES
GENERATE_RTF           = NO
GENERATE_MAN           = NO

# HTML configuration
HTML_OUTPUT            = html
HTML_FILE_EXTENSION    = .html
HTML_HEADER            = 
HTML_FOOTER            = 
HTML_STYLESHEET        = 
HTML_EXTRA_STYLESHEET  = 
HTML_EXTRA_FILES       = 
HTML_COLORSTYLE_HUE    = 220
HTML_COLORSTYLE_SAT    = 100
HTML_COLORSTYLE_GAMMA  = 80
HTML_TIMESTAMP         = YES
HTML_DYNAMIC_SECTIONS  = YES
HTML_INDEX_NUM_ENTRIES = 100

# Navigation
GENERATE_TREEVIEW      = YES
ENUM_VALUES_PER_LINE   = 4
TREEVIEW_WIDTH         = 250
EXT_LINKS_IN_WINDOW    = NO

# Source code
SOURCE_BROWSER         = YES
INLINE_SOURCES         = NO
STRIP_CODE_COMMENTS    = YES
REFERENCED_BY_RELATION = YES
REFERENCES_RELATION    = YES
REFERENCES_LINK_SOURCE = YES
SOURCE_TOOLTIPS        = YES
USE_HTAGS              = NO
VERBATIM_HEADERS       = YES

# Extraction settings
EXTRACT_ALL            = YES
EXTRACT_PRIVATE        = NO
EXTRACT_PACKAGE        = NO
EXTRACT_STATIC         = YES
EXTRACT_LOCAL_CLASSES  = YES
EXTRACT_LOCAL_METHODS  = NO
EXTRACT_ANON_NSPACES   = NO
HIDE_UNDOC_MEMBERS     = NO
HIDE_UNDOC_CLASSES     = NO
HIDE_FRIEND_COMPOUNDS  = NO
HIDE_IN_BODY_DOCS      = NO
INTERNAL_DOCS          = NO
CASE_SENSE_NAMES       = YES
HIDE_SCOPE_NAMES       = NO
HIDE_COMPOUND_REFERENCE= NO
SHOW_INCLUDE_FILES     = YES
SHOW_GROUPED_MEMB_INC  = NO
FORCE_LOCAL_INCLUDES   = NO
INLINE_INFO            = YES
SORT_MEMBER_DOCS       = YES
SORT_BRIEF_DOCS        = NO
SORT_MEMBERS_CTORS_1ST = NO
SORT_GROUP_NAMES       = NO
SORT_BY_SCOPE_NAME     = NO
STRICT_PROTO_MATCHING  = NO
GENERATE_TODOLIST      = YES
GENERATE_TESTLIST      = YES
GENERATE_BUGLIST       = YES
GENERATE_DEPRECATEDLIST= YES
ENABLED_SECTIONS       = 
MAX_INITIALIZER_LINES  = 30
SHOW_USED_FILES        = YES
SHOW_FILES             = YES
SHOW_NAMESPACES        = YES

# Preprocessing
ENABLE_PREPROCESSING   = YES
MACRO_EXPANSION        = NO
EXPAND_ONLY_PREDEF     = NO
SEARCH_INCLUDES        = YES
INCLUDE_PATH           = 
INCLUDE_FILE_PATTERNS  = 
PREDEFINED             = 
EXPAND_AS_DEFINED      = 
SKIP_FUNCTION_MACROS   = YES

# Diagram generation
CLASS_DIAGRAMS         = YES
MSCGEN_PATH            = 
DIA_PATH               = 
HIDE_UNDOC_RELATIONS   = YES
HAVE_DOT               = YES
DOT_NUM_THREADS        = 0
DOT_FONTNAME           = Helvetica
DOT_FONTSIZE           = 10
DOT_FONTPATH           = 
CLASS_GRAPH            = YES
COLLABORATION_GRAPH    = YES
GROUP_GRAPHS           = YES
UML_LOOK               = NO
UML_LIMIT_NUM_FIELDS   = 10
TEMPLATE_RELATIONS     = NO
INCLUDE_GRAPH          = YES
INCLUDED_BY_GRAPH      = YES
CALL_GRAPH             = NO
CALLER_GRAPH           = NO
GRAPHICAL_HIERARCHY    = YES
DIRECTORY_GRAPH        = YES
DOT_IMAGE_FORMAT       = png
INTERACTIVE_SVG        = NO
DOT_PATH               = 
DOTFILE_DIRS           = 
MSCFILE_DIRS           = 
DIAFILE_DIRS           = 
PLANTUML_JAR_PATH      = 
PLANTUML_CFG_FILE      = 
PLANTUML_INCLUDE_PATH  = 
DOT_GRAPH_MAX_NODES    = 50
MAX_DOT_GRAPH_DEPTH    = 0
DOT_TRANSPARENT        = NO
DOT_MULTI_TARGETS      = NO
GENERATE_LEGEND        = YES
DOT_CLEANUP            = YES

# Search engine
SEARCHENGINE           = YES
SERVER_BASED_SEARCH    = NO
EXTERNAL_SEARCH        = NO
SEARCHENGINE_URL       = 
SEARCHDATA_FILE        = searchdata.xml
EXTERNAL_SEARCH_ID     = 
EXTRA_SEARCH_MAPPINGS  = 

# Warnings and progress
QUIET                  = NO
WARNINGS               = YES
WARN_IF_UNDOCUMENTED   = YES
WARN_IF_DOC_ERROR      = YES
WARN_NO_PARAMDOC       = NO
WARN_AS_ERROR          = NO
WARN_FORMAT            = "$file:$line: $text"
WARN_LOGFILE           = 
EOF

    echo "$config_file"
}

# Generate API documentation with Doxygen
generate_api_docs() {
    log_info "Generating API documentation with Doxygen"
    
    local config_file
    config_file=$(create_doxygen_config)
    
    cd "$DOCS_DIR"
    
    if command -v doxygen &> /dev/null; then
        doxygen "$config_file"
        log_info "Doxygen documentation generated successfully"
    else
        log_warn "Doxygen not found, skipping API documentation"
        return 1
    fi
}

# Generate user manual
generate_user_manual() {
    log_info "Generating user manual"
    
    local manual_dir="$DOCS_DIR/manual"
    mkdir -p "$manual_dir"
    
    # Create index page
    cat > "$manual_dir/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TOL User Manual</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }
        h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        h2 { color: #34495e; margin-top: 30px; }
        .section { margin: 20px 0; }
        .code { background: #f4f4f4; padding: 10px; border-left: 4px solid #3498db; }
        .nav { background: #ecf0f1; padding: 15px; margin-bottom: 20px; }
        .nav a { margin-right: 20px; text-decoration: none; color: #2980b9; }
        .nav a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="nav">
        <a href="#installation">Installation</a>
        <a href="#getting-started">Getting Started</a>
        <a href="#examples">Examples</a>
        <a href="#api">API Reference</a>
    </div>

    <h1>TOL - Time Oriented Language</h1>
    <p>Welcome to the TOL User Manual. TOL is a powerful language designed for time series analysis and mathematical modeling.</p>

    <div class="section" id="installation">
        <h2>Installation</h2>
        <p>TOL can be installed on Linux, Windows, and macOS systems.</p>
        
        <h3>Linux Installation</h3>
        <div class="code">
            <pre>
# Ubuntu/Debian
sudo apt-get install build-essential cmake libgsl-dev libfftw3-dev
git clone https://github.com/m-marinucci/Tol.git
cd Tol/tol
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
            </pre>
        </div>

        <h3>Windows Installation</h3>
        <div class="code">
            <pre>
# Using vcpkg for dependencies
vcpkg install gsl:x64-windows fftw3:x64-windows
# Then build with Visual Studio or CMake
            </pre>
        </div>
    </div>

    <div class="section" id="getting-started">
        <h2>Getting Started</h2>
        <p>Here's a simple example to get you started with TOL:</p>
        <div class="code">
            <pre>
// Hello World in TOL
WriteLn("Hello, TOL World!");

// Basic arithmetic
Real x = 10;
Real y = 20;
WriteLn("Sum: " + Text(x + y));
            </pre>
        </div>
    </div>

    <div class="section" id="examples">
        <h2>Examples</h2>
        <p>Explore various TOL examples:</p>
        <ul>
            <li><a href="examples/basic_math.html">Basic Mathematics</a></li>
            <li><a href="examples/time_series.html">Time Series Analysis</a></li>
            <li><a href="examples/statistics.html">Statistical Functions</a></li>
            <li><a href="examples/linear_algebra.html">Linear Algebra</a></li>
        </ul>
    </div>

    <div class="section" id="api">
        <h2>API Reference</h2>
        <p>For detailed API documentation, see the <a href="../html/index.html">Doxygen-generated API reference</a>.</p>
    </div>

    <footer style="margin-top: 50px; padding-top: 20px; border-top: 1px solid #bdc3c7; color: #7f8c8d;">
        <p>Generated on $(date) | TOL Project</p>
    </footer>
</body>
</html>
EOF

    log_info "User manual generated"
}

# Create main documentation index
create_main_index() {
    log_info "Creating main documentation index"
    
    cat > "$DOCS_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TOL Documentation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background: #f8f9fa; }
        .header { background: #2c3e50; color: white; padding: 40px 0; text-align: center; }
        .container { max-width: 1200px; margin: 0 auto; padding: 40px 20px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .card h2 { color: #2c3e50; margin-top: 0; }
        .card a { color: #3498db; text-decoration: none; font-weight: bold; }
        .card a:hover { text-decoration: underline; }
        .footer { background: #34495e; color: white; text-align: center; padding: 20px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>TOL Documentation</h1>
        <p>Time Oriented Language - Comprehensive Documentation</p>
    </div>

    <div class="container">
        <div class="grid">
            <div class="card">
                <h2>📚 User Manual</h2>
                <p>Complete user guide with installation instructions, tutorials, and examples.</p>
                <a href="manual/index.html">Read User Manual →</a>
            </div>

            <div class="card">
                <h2>🔧 API Reference</h2>
                <p>Detailed API documentation generated from source code.</p>
                <a href="html/index.html">Browse API Reference →</a>
            </div>

            <div class="card">
                <h2>🚀 Getting Started</h2>
                <p>Quick start guide to get up and running with TOL.</p>
                <a href="manual/index.html#getting-started">Get Started →</a>
            </div>

            <div class="card">
                <h2>💡 Examples</h2>
                <p>Code examples and use cases for various TOL features.</p>
                <a href="manual/index.html#examples">View Examples →</a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2025 TOL Project | Generated on $(date)</p>
    </div>
</body>
</html>
EOF
}

# Main execution
main() {
    log_info "TOL Documentation Deployment"
    log_info "============================"
    
    # Generate API documentation
    if generate_api_docs; then
        log_info "API documentation generated successfully"
    else
        log_warn "API documentation generation failed"
    fi
    
    # Generate user manual
    generate_user_manual
    
    # Create main index
    create_main_index
    
    log_info "Documentation deployment completed"
    log_info "Documentation available at: $DOCS_DIR/index.html"
    
    # List generated files
    if [ -d "$DOCS_DIR" ]; then
        log_info "Generated documentation files:"
        find "$DOCS_DIR" -name "*.html" | head -10
    fi
}

# Run main function
main "$@"
