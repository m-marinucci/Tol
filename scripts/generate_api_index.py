#!/usr/bin/env python3
"""
TOL API Documentation Index Generator

This script automatically generates a structured README.md file for the API documentation
by scanning all markdown files in docs/api/ and extracting their YAML front-matter metadata.

Features:
- Category-based organization
- MCP-compatible module listing
- Alphabetical index
- Auto-updated timestamps
- Validation of YAML front-matter

Usage:
    python scripts/generate_api_index.py
    python scripts/generate_api_index.py --output docs/api/README.md
    python scripts/generate_api_index.py --validate-only
"""

import os
import sys
import yaml
import argparse
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional
import re

# Add the project root to Python path
project_root = Path(__file__).parent.parent.resolve()
sys.path.insert(0, str(project_root))

class APIDocumentationIndexer:
    """Generates and maintains the API documentation index."""
    
    def __init__(self, docs_dir: str = "docs/api"):
        self.docs_dir = Path(docs_dir).resolve()
        self.modules = []
        self.categories = {
            "core_computational": {
                "title": "Core Computational Modules",
                "description": "Mathematical operations, statistical analysis, and time-series processing",
                "modules": []
            },
            "data_handling": {
                "title": "Data Handling and I/O",
                "description": "Database connectivity and file system operations",
                "modules": []
            },
            "visualization": {
                "title": "Visualization and Plotting",
                "description": "Chart generation and data visualization tools",
                "modules": []
            },
            "ui": {
                "title": "User Interface",
                "description": "GUI applications and interactive tools",
                "modules": []
            },
            "integration": {
                "title": "Integration Modules",
                "description": "External language bindings and communication protocols",
                "modules": []
            },
            "utilities": {
                "title": "Utilities and Standard Library",
                "description": "Helper functions and standard library modules",
                "modules": []
            }
        }
    
    def extract_yaml_frontmatter(self, file_path: Path) -> Optional[Dict[str, Any]]:
        """Extract YAML front-matter from a markdown file."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Look for YAML front-matter between triple dashes
            yaml_match = re.match(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
            if not yaml_match:
                return None
            
            yaml_content = yaml_match.group(1)
            return yaml.safe_load(yaml_content)
        
        except Exception as e:
            print(f"Warning: Could not parse YAML from {file_path}: {e}")
            return None
    
    def validate_module_metadata(self, metadata: Dict[str, Any], file_path: Path) -> List[str]:
        """Validate module metadata and return list of errors."""
        errors = []
        
        # Required fields
        required_fields = ['module_id', 'category', 'version', 'last_updated']
        for field in required_fields:
            if field not in metadata:
                errors.append(f"Missing required field: {field}")
        
        # Validate category
        if 'category' in metadata and metadata['category'] not in self.categories:
            valid_categories = list(self.categories.keys())
            errors.append(f"Invalid category '{metadata['category']}'. Must be one of: {valid_categories}")
        
        # Validate version format (basic semantic versioning check)
        if 'version' in metadata:
            version_pattern = r'^\d+\.\d+\.\d+$'
            if not re.match(version_pattern, metadata['version']):
                errors.append(f"Invalid version format '{metadata['version']}'. Expected: X.Y.Z")
        
        # Validate date format
        if 'last_updated' in metadata:
            try:
                if isinstance(metadata['last_updated'], str):
                    datetime.strptime(metadata['last_updated'], '%Y-%m-%d')
                elif hasattr(metadata['last_updated'], 'strftime'):
                    # It's already a date/datetime object, just check if it can be formatted
                    metadata['last_updated'].strftime('%Y-%m-%d')
                else:
                    errors.append(f"Invalid date type '{type(metadata['last_updated'])}'. Expected: YYYY-MM-DD string or date object")
            except ValueError:
                errors.append(f"Invalid date format '{metadata['last_updated']}'. Expected: YYYY-MM-DD")
        
        return errors
    
    def scan_documentation_files(self) -> bool:
        """Scan all markdown files and extract metadata."""
        if not self.docs_dir.exists():
            print(f"Error: Documentation directory {self.docs_dir} does not exist")
            return False
        
        success = True
        
        for md_file in self.docs_dir.glob("*.md"):
            if md_file.name == "README.md":
                continue  # Skip the index file we're generating
            
            print(f"Processing {md_file.name}...")
            
            metadata = self.extract_yaml_frontmatter(md_file)
            if not metadata:
                print(f"Warning: No YAML front-matter found in {md_file.name}")
                continue
            
            # Validate metadata
            errors = self.validate_module_metadata(metadata, md_file)
            if errors:
                print(f"Validation errors in {md_file.name}:")
                for error in errors:
                    print(f"  - {error}")
                success = False
                continue
            
            # Add file information
            metadata['filename'] = md_file.name
            try:
                metadata['file_path'] = str(md_file.relative_to(project_root))
            except ValueError:
                # Fallback if relative path calculation fails
                metadata['file_path'] = str(md_file)
            
            # Add to appropriate category
            category = metadata['category']
            if category in self.categories:
                self.categories[category]['modules'].append(metadata)
            
            self.modules.append(metadata)
        
        # Sort modules within each category
        for category_data in self.categories.values():
            category_data['modules'].sort(key=lambda x: x.get('module_id', ''))
        
        return success
    
    def generate_readme_content(self) -> str:
        """Generate the README.md content."""
        content = []
        
        # Header
        content.append("# TOL API Documentation")
        content.append("")
        content.append("This directory contains comprehensive API documentation for all TOL modules.")
        content.append(f"Last updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}")
        content.append("")
        
        # Quick stats
        total_modules = len(self.modules)
        mcp_compatible = len([m for m in self.modules if m.get('mcp_compatible', False)])
        
        content.append("## Quick Overview")
        content.append("")
        content.append(f"- **Total Modules**: {total_modules}")
        content.append(f"- **MCP Compatible**: {mcp_compatible}")
        content.append(f"- **Categories**: {len([c for c in self.categories.values() if c['modules']])}")
        content.append("")
        
        # Table of Contents
        content.append("## Table of Contents")
        content.append("")
        for category_id, category_data in self.categories.items():
            if category_data['modules']:
                content.append(f"- [{category_data['title']}](#{category_id.replace('_', '-')})")
        content.append("- [Alphabetical Index](#alphabetical-index)")
        content.append("- [MCP-Compatible Modules](#mcp-compatible-modules)")
        content.append("")
        
        # Category sections
        for category_id, category_data in self.categories.items():
            if not category_data['modules']:
                continue
            
            content.append(f"## {category_data['title']}")
            content.append("")
            content.append(category_data['description'])
            content.append("")
            
            for module in category_data['modules']:
                module_id = module.get('module_id', 'Unknown')
                filename = module.get('filename', '')
                version = module.get('version', '')
                mcp_icon = " 🤖" if module.get('mcp_compatible', False) else ""
                
                content.append(f"### [{module_id}]({filename}){mcp_icon}")
                
                # Add description if available from the file
                if 'description' in module:
                    content.append(f"{module['description']}")
                
                content.append(f"- **Version**: {version}")

                last_updated = module.get('last_updated', '')
                if last_updated:
                    content.append(f"- **Last Updated**: {last_updated}")

                if 'tags' in module and module['tags']:
                    tags_str = ", ".join(f"`{tag}`" for tag in module['tags'])
                    content.append(f"- **Tags**: {tags_str}")
                
                content.append("")
        
        # Alphabetical index
        content.append("## Alphabetical Index")
        content.append("")
        sorted_modules = sorted(self.modules, key=lambda x: x.get('module_id', '').lower())
        
        for module in sorted_modules:
            module_id = module.get('module_id', 'Unknown')
            filename = module.get('filename', '')
            category = self.categories.get(module.get('category', ''), {}).get('title', 'Unknown')
            mcp_icon = " 🤖" if module.get('mcp_compatible', False) else ""
            
            content.append(f"- **[{module_id}]({filename})**{mcp_icon} - {category}")
        
        content.append("")
        
        # MCP-compatible modules
        mcp_modules = [m for m in self.modules if m.get('mcp_compatible', False)]
        if mcp_modules:
            content.append("## MCP-Compatible Modules")
            content.append("")
            content.append("These modules are available through the TOL MCP (Model Context Protocol) server ")
            content.append("for natural language interaction:")
            content.append("")
            
            for module in sorted(mcp_modules, key=lambda x: x.get('module_id', '').lower()):
                module_id = module.get('module_id', 'Unknown')
                filename = module.get('filename', '')
                content.append(f"- **[{module_id}]({filename})** 🤖")
            
            content.append("")
        
        # Footer
        content.append("---")
        content.append("")
        content.append("## Contributing")
        content.append("")
        content.append("When adding new API documentation:")
        content.append("1. Follow the [YAML front-matter template](../yaml_frontmatter_template.yaml)")
        content.append("2. Use consistent markdown formatting")
        content.append("3. Run `python scripts/generate_api_index.py` to update this index")
        content.append("4. Validate with `markdownlint docs/api/*.md`")
        content.append("")
        content.append("For detailed guidelines, see [CONTRIBUTOR_GUIDELINES.md](../CONTRIBUTOR_GUIDELINES.md)")
        
        return "\n".join(content)
    
    def write_readme(self, output_path: Optional[str] = None) -> bool:
        """Write the generated README to file."""
        if output_path is None:
            output_path = self.docs_dir / "README.md"
        else:
            output_path = Path(output_path)
        
        try:
            content = self.generate_readme_content()
            
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"Successfully generated {output_path}")
            return True
        
        except Exception as e:
            print(f"Error writing README: {e}")
            return False

def main():
    parser = argparse.ArgumentParser(description="Generate TOL API documentation index")
    parser.add_argument("--output", "-o", help="Output file path (default: docs/api/README.md)")
    parser.add_argument("--docs-dir", "-d", default="docs/api", help="Documentation directory")
    parser.add_argument("--validate-only", "-v", action="store_true", help="Only validate, don't generate")
    
    args = parser.parse_args()
    
    indexer = APIDocumentationIndexer(args.docs_dir)
    
    print("Scanning API documentation files...")
    success = indexer.scan_documentation_files()
    
    if not success:
        print("Validation failed. Please fix the errors above.")
        sys.exit(1)
    
    if args.validate_only:
        print("Validation successful!")
        return
    
    print("Generating README...")
    if indexer.write_readme(args.output):
        print("Index generation completed successfully!")
    else:
        print("Failed to generate index.")
        sys.exit(1)

if __name__ == "__main__":
    main()
