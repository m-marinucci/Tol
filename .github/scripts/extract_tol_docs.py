#!/usr/bin/env python3
"""
Extract documentation from TOL source files.
Generates markdown documentation from TOL comments and code structure.
"""

import os
import re
import json
import argparse
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Tuple, Optional

class TOLDocExtractor:
    """Extract and format documentation from TOL files."""
    
    def __init__(self, output_dir: str = "docs/generated"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.tol_functions = []
        self.tol_types = []
        self.tol_examples = []
        
    def extract_from_file(self, filepath: Path) -> Dict:
        """Extract documentation from a single TOL file."""
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        doc_info = {
            'file': str(filepath),
            'functions': [],
            'types': [],
            'examples': [],
            'description': ''
        }
        
        # Extract file-level documentation (all consecutive //! lines at the top)
        file_doc_lines = []
        for line in content.splitlines():
            if line.strip().startswith('//!'):
                file_doc_lines.append(line.strip()[3:].strip())
            elif file_doc_lines:
                break
        if file_doc_lines:
            doc_info['description'] = "\n".join(file_doc_lines).strip()
        
        # Extract function documentation
        # NOTE: This regex attempts to match TOL function signatures that may span multiple lines,
        # include qualified return types, and allow for complex parameter lists.
        # It may still miss some edge cases (e.g., function pointers, macros, or unusual formatting).
        # For full accuracy, consider using a proper parser.
        func_pattern = (
            r'//!\s*@brief\s+(.+?)\n'                # @brief line
            r'(?://!\s*@.+?\n)*'                     # any other doc lines
            r'\s*([a-zA-Z_][\w:\s\*&<>]*)\s+'        # return type (qualified, with spaces, *, &, etc.)
            r'([a-zA-Z_]\w*)\s*'                     # function name
            r'\(([^)]*)\)'                           # parameter list (not perfect for nested)
        )
        for match in re.finditer(func_pattern, content, re.MULTILINE | re.DOTALL):
            brief, return_type, name, params = match.groups()
            func_doc = {
                'name': name,
                'return_type': return_type,
                'params': params,
                'brief': brief.strip(),
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1
            }
            doc_info['functions'].append(func_doc)
            self.tol_functions.append(func_doc)
        
        # Extract type definitions
        # Improved pattern: optional modifiers, allow colon or equals, avoid matching in comments
        type_pattern = r'^(?!\s*(//|#|\*|/\*)).*?\b(?:public|private|protected)?\s*(Real|Text|Matrix|Serie|NameBlock|Set|Code)\s+(\w+)\s*[:=]'
        for match in re.finditer(type_pattern, content, re.MULTILINE):
            # Skip matches inside multi-line comments
            line_start = content.rfind('\n', 0, match.start()) + 1
            line_end = content.find('\n', match.start())
            if line_end == -1:
                line_end = len(content)
            line_text = content[line_start:line_end]
            if (
                line_text.strip().startswith('//')
                or line_text.strip().startswith('#')
                or line_text.strip().startswith('*')
                or '/*' in line_text
                or '*/' in line_text
            ):
                continue
            # Extract type and variable name
            type_name, var_name = match.groups()[-2:]
            type_info = {
                'type': type_name,
                'name': var_name,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1
            }
            doc_info['types'].append(type_info)
            self.tol_types.append(type_info)
        
        # Extract code examples
        example_pattern = r'//\s*Example:(.+?)(?=\n(?!//)|$)'
        for match in re.finditer(example_pattern, content, re.DOTALL):
            example = match.group(1).strip()
            example_info = {
                'code': example,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1
            }
            doc_info['examples'].append(example_info)
            self.tol_examples.append(example_info)
        
        return doc_info
    
    def generate_function_reference(self):
        """Generate markdown reference for all functions."""
        output_file = self.output_dir / "function_reference.md"
        
        with open(output_file, 'w') as f:
            f.write("# TOL Function Reference\n\n")
            f.write(f"Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            # Group functions by return type
            by_type = {}
            for func in sorted(self.tol_functions, key=lambda x: x['name']):
                ret_type = func['return_type']
                if ret_type not in by_type:
                    by_type[ret_type] = []
                by_type[ret_type].append(func)
            
            for ret_type, funcs in sorted(by_type.items()):
                f.write(f"\n## {ret_type} Functions\n\n")
                
                for func in funcs:
                    f.write(f"### `{func['name']}`\n\n")
                    f.write(f"**Signature:** `{func['return_type']} {func['name']}({func['params']})`\n\n")
                    f.write(f"**Description:** {func['brief']}\n\n")
                    f.write(f"**Source:** {func['file']}:{func['line']}\n\n")
    
    def generate_type_reference(self):
        """Generate markdown reference for all types."""
        output_file = self.output_dir / "type_reference.md"
        
        with open(output_file, 'w') as f:
            f.write("# TOL Type Reference\n\n")
            f.write(f"Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            # Group by type
            by_type = {}
            for type_info in self.tol_types:
                t = type_info['type']
                if t not in by_type:
                    by_type[t] = []
                by_type[t].append(type_info)
            
            for type_name, instances in sorted(by_type.items()):
                f.write(f"\n## {type_name}\n\n")
                f.write(f"Found {len(instances)} instances of {type_name}:\n\n")
                
                for inst in sorted(instances, key=lambda x: x['name']):
                    f.write(f"- `{inst['name']}` - {inst['file']}:{inst['line']}\n")
    
    def generate_examples_page(self):
        """Generate a page with all code examples."""
        output_file = self.output_dir / "examples.md"
        
        with open(output_file, 'w') as f:
            f.write("# TOL Code Examples\n\n")
            f.write(f"Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            for i, example in enumerate(self.tol_examples, 1):
                f.write(f"\n## Example {i}\n\n")
                f.write(f"Source: {example['file']}:{example['line']}\n\n")
                f.write("```tol\n")
                f.write(example['code'])
                f.write("\n```\n")
    
    def generate_index_page(self, files_processed: int):
        """Generate main index page."""
        output_file = self.output_dir / "index.md"
        
        with open(output_file, 'w') as f:
            f.write("# TOL Auto-Generated Documentation\n\n")
            f.write(f"Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            f.write("## Statistics\n\n")
            f.write(f"- Files processed: {files_processed}\n")
            f.write(f"- Functions documented: {len(self.tol_functions)}\n")
            f.write(f"- Type definitions found: {len(self.tol_types)}\n")
            f.write(f"- Code examples: {len(self.tol_examples)}\n\n")
            
            f.write("## Documentation Pages\n\n")
            f.write("- [Function Reference](function_reference.md)\n")
            f.write("- [Type Reference](type_reference.md)\n")
            f.write("- [Code Examples](examples.md)\n")
    
    def process_directory(self, directory: Path):
        """Process all TOL files in a directory."""
        tol_files = list(directory.rglob("*.tol"))
        
        print(f"Found {len(tol_files)} TOL files to process")
        
        for tol_file in tol_files:
            print(f"Processing: {tol_file}")
            try:
                self.extract_from_file(tol_file)
            except Exception as e:
                print(f"Error processing {tol_file}: {e}")
        
        # Generate documentation pages
        self.generate_function_reference()
        self.generate_type_reference()
        self.generate_examples_page()
        self.generate_index_page(len(tol_files))
        
        print(f"\nDocumentation generated in: {self.output_dir}")
        print(f"- Functions documented: {len(self.tol_functions)}")
        print(f"- Types found: {len(self.tol_types)}")
        print(f"- Examples extracted: {len(self.tol_examples)}")

def main():
    parser = argparse.ArgumentParser(description="Extract documentation from TOL files")
    parser.add_argument("directory", help="Directory containing TOL files")
    parser.add_argument("-o", "--output", default="docs/generated", 
                       help="Output directory for documentation")
    
    args = parser.parse_args()
    
    extractor = TOLDocExtractor(args.output)
    extractor.process_directory(Path(args.directory))

if __name__ == "__main__":
    main()