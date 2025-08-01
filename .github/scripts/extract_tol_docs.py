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
    """Extract and format documentation from TOL and C++ source files."""
    
    # Fixed list of valid TOL types for validation
    VALID_TYPES = [
        'Real', 'Text', 'Matrix', 'Serie', 'NameBlock', 
        'Set', 'Code', 'Date', 'TimeSet', 'Complex',
        'VMatrix', 'Polynomial', 'PolMat', 'Ratio', 'CTime'
    ]
    
    # C++ types commonly used in TOL
    CPP_TYPES = [
        'void', 'int', 'double', 'float', 'bool', 'char', 'string',
        'BReal', 'BText', 'BMatrix', 'BSerie', 'BNameBlock',
        'BSet', 'BCode', 'BDate', 'BTimeSet', 'BComplex'
    ]
    
    def __init__(self, output_dir: str = "docs/generated"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.tol_functions = []
        self.tol_types = []
        self.tol_examples = []
        self.cpp_functions = []
        self.cpp_classes = []
        self.tol_cpp_mappings = []  # Maps between TOL and C++ functions
        
    def parse_parameters(self, param_string: str) -> List[Dict]:
        """
        Parse parameter string into structured data.
        Example: "Real x, Text filename, Real threshold = 0.5"
        Returns: [
            {'type': 'Real', 'name': 'x', 'default': None},
            {'type': 'Text', 'name': 'filename', 'default': None},
            {'type': 'Real', 'name': 'threshold', 'default': '0.5'}
        ]
        """
        if not param_string.strip():
            return []
        
        params = []
        # Split by comma, handling nested types like Set(Real)
        param_parts = re.split(r',\s*(?![^()]*\))', param_string)
        
        for param in param_parts:
            param = param.strip()
            if not param:
                continue
                
            # Match type name (with optional nested type), parameter name, and optional default
            match = re.match(r'(\w+(?:\([^)]+\))?)\s+(\w+)(?:\s*=\s*(.+))?', param)
            if match:
                param_type, param_name, default_value = match.groups()
                params.append({
                    'type': param_type,
                    'name': param_name,
                    'default': default_value.strip() if default_value else None,
                    'description': ''  # Will be filled from @param tags
                })
        
        return params
    
    def extract_param_docs(self, content: str, start_pos: int) -> Dict[str, str]:
        """Extract @param documentation from comments preceding a function."""
        # Look backwards from function position to find @param tags
        preceding_content = content[:start_pos]
        lines = preceding_content.split('\n')
        
        param_docs = {}
        i = len(lines) - 1
        
        # Scan backwards through lines looking for @param tags
        while i >= 0 and (lines[i].strip().startswith('//!') or not lines[i].strip()):
            line = lines[i].strip()
            if line.startswith('//!'):
                # Check for @param tag
                param_match = re.match(r'//!\s*@param\s+(\w+)\s+(.+)', line)
                if param_match:
                    param_name, param_desc = param_match.groups()
                    param_docs[param_name] = param_desc.strip()
            i -= 1
            
        return param_docs
    
    def extract_return_doc(self, content: str, start_pos: int) -> Optional[str]:
        """Extract @return documentation from comments preceding a function."""
        preceding_content = content[:start_pos]
        lines = preceding_content.split('\n')
        
        i = len(lines) - 1
        while i >= 0 and (lines[i].strip().startswith('//!') or not lines[i].strip()):
            line = lines[i].strip()
            if line.startswith('//!'):
                return_match = re.match(r'//!\s*@return\s+(.+)', line)
                if return_match:
                    return return_match.group(1).strip()
            i -= 1
            
        return None
        
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
            brief, return_type, name, params_str = match.groups()
            
            # Parse parameters into structured data
            params = self.parse_parameters(params_str)
            
            # Extract parameter documentation
            param_docs = self.extract_param_docs(content, match.start())
            
            # Update parameter descriptions
            for param in params:
                if param['name'] in param_docs:
                    param['description'] = param_docs[param['name']]
            
            # Extract return documentation
            return_doc = self.extract_return_doc(content, match.start())
            
            func_doc = {
                'name': name,
                'return_type': return_type.strip(),
                'params': params,  # Now structured data instead of string
                'params_str': params_str,  # Keep original string for backward compatibility
                'brief': brief.strip(),
                'return_doc': return_doc,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1
            }
            doc_info['functions'].append(func_doc)
            self.tol_functions.append(func_doc)
        
        # Extract type definitions - including function signatures and complex types
        
        # 1. Extract simple variable declarations
        # Improved pattern: optional modifiers, allow colon or equals, avoid matching in comments
        var_pattern = r'^(?!\s*(//|#|\*|/\*)).*?\b(?:public|private|protected)?\s*(' + '|'.join(self.VALID_TYPES) + r')\s+(\w+)\s*[:=]'
        for match in re.finditer(var_pattern, content, re.MULTILINE):
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
                'category': 'variable',
                'type': type_name,
                'name': var_name,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1,
                'members': None
            }
            doc_info['types'].append(type_info)
            self.tol_types.append(type_info)
        
        # 2. Extract function signatures (functions as types)
        func_sig_pattern = r'(' + '|'.join(self.VALID_TYPES) + r')\s+(\w+)\s*\(([^)]*)\)\s*\{'
        for match in re.finditer(func_sig_pattern, content):
            return_type, func_name, params = match.groups()
            type_info = {
                'category': 'function',
                'type': return_type,
                'name': func_name,
                'params': self.parse_parameters(params),
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1,
                'members': None
            }
            doc_info['types'].append(type_info)
            self.tol_types.append(type_info)
        
        # 3. Extract NameBlock definitions with members
        nameblock_pattern = r'NameBlock\s+(\w+)\s*=\s*\[\[(.*?)\]\]'
        for match in re.finditer(nameblock_pattern, content, re.DOTALL):
            nb_name, nb_content = match.groups()
            
            # Parse members within the NameBlock
            members = []
            
            # Find member variables
            member_var_pattern = r'(' + '|'.join(self.VALID_TYPES) + r')\s+(\w+)\s*(?:=|;)'
            for member_match in re.finditer(member_var_pattern, nb_content):
                member_type, member_name = member_match.groups()
                members.append({
                    'category': 'variable',
                    'type': member_type,
                    'name': member_name
                })
            
            # Find member functions
            member_func_pattern = r'(' + '|'.join(self.VALID_TYPES) + r')\s+(\w+)\s*\(([^)]*)\)'
            for member_match in re.finditer(member_func_pattern, nb_content):
                ret_type, func_name, params = member_match.groups()
                members.append({
                    'category': 'function',
                    'type': ret_type,
                    'name': func_name,
                    'params': self.parse_parameters(params)
                })
            
            type_info = {
                'category': 'nameblock',
                'type': 'NameBlock',
                'name': nb_name,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1,
                'members': members
            }
            doc_info['types'].append(type_info)
            self.tol_types.append(type_info)
        
        # Extract code examples
        example_pattern = r'//\s*Example:(.*(?:\n\s*//.*)*)'
        for match in re.finditer(example_pattern, content):
            raw_example = match.group(1)
            # Split into lines, remove leading // and whitespace
            example_lines = [
                re.sub(r'^\s*//\s?', '', line)
                for line in raw_example.splitlines()
            ]
            # Remove any empty lines at the start/end
            example = '\n'.join(line.rstrip() for line in example_lines).strip()
            example_info = {
                'code': example,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1
            }
            doc_info['examples'].append(example_info)
            self.tol_examples.append(example_info)
        
        return doc_info
    
    def extract_from_cpp_file(self, filepath: Path) -> Dict:
        """Extract documentation from a C++ source file."""
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        doc_info = {
            'file': str(filepath),
            'functions': [],
            'classes': [],
            'tol_bindings': [],
            'description': ''
        }
        
        # Extract file-level documentation (Doxygen style)
        file_doc = re.search(r'/\*\*\s*\n\s*\*\s*@file.*?\n(.*?)\*/', content, re.DOTALL)
        if file_doc:
            doc_info['description'] = file_doc.group(1).strip()
        
        # Extract C++ function documentation
        # Match Doxygen comments followed by function declarations
        func_pattern = r'/\*\*\s*(.*?)\*/\s*\n\s*(?:TOLBASE_API|BSR_API|BTOL_API|extern|static|inline)*\s*(\w+(?:\s*\*)?)\s+(\w+)\s*\(([^)]*)\)'
        
        for match in re.finditer(func_pattern, content, re.DOTALL):
            doxygen_comment, return_type, func_name, params = match.groups()
            
            # Parse Doxygen comment
            brief = ''
            param_docs = {}
            return_doc = ''
            
            # Extract @brief
            brief_match = re.search(r'@brief\s+(.+?)(?=@|\*\/)', doxygen_comment, re.DOTALL)
            if brief_match:
                brief = ' '.join(brief_match.group(1).split())
            
            # Extract @param tags
            for param_match in re.finditer(r'@param\s+(\w+)\s+(.+?)(?=@|\*\/)', doxygen_comment, re.DOTALL):
                param_name, param_desc = param_match.groups()
                param_docs[param_name] = ' '.join(param_desc.split())
            
            # Extract @return
            return_match = re.search(r'@return\s+(.+?)(?=@|\*\/)', doxygen_comment, re.DOTALL)
            if return_match:
                return_doc = ' '.join(return_match.group(1).split())
            
            # Parse parameters
            params_list = self.parse_cpp_parameters(params)
            
            # Update parameter descriptions
            for param in params_list:
                if param['name'] in param_docs:
                    param['description'] = param_docs[param['name']]
            
            func_doc = {
                'name': func_name,
                'return_type': return_type.strip(),
                'params': params_list,
                'brief': brief,
                'return_doc': return_doc,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1
            }
            
            doc_info['functions'].append(func_doc)
            self.cpp_functions.append(func_doc)
        
        # Extract TOL function registrations
        # Look for patterns like AddFunction("FuncName", ...)
        registration_pattern = r'(?:AddFunction|RegisterFunction|BGrammar::AddFunction)\s*\(\s*"(\w+)"'
        
        for match in re.finditer(registration_pattern, content):
            tol_name = match.group(1)
            
            # Try to find the corresponding C++ function
            cpp_func = None
            # Look backwards for the nearest function definition
            pos = match.start()
            for func in doc_info['functions']:
                if func['line'] < content[:pos].count('\n'):
                    cpp_func = func['name']
            
            binding = {
                'tol_name': tol_name,
                'cpp_function': cpp_func,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1
            }
            
            doc_info['tol_bindings'].append(binding)
            self.tol_cpp_mappings.append(binding)
        
        # Extract class definitions
        class_pattern = r'class\s+(?:TOLBASE_API|BSR_API|BTOL_API)?\s*(\w+)(?:\s*:\s*public\s+(\w+))?'
        
        for match in re.finditer(class_pattern, content):
            class_name = match.group(1)
            base_class = match.group(2) or None
            
            class_info = {
                'name': class_name,
                'base': base_class,
                'file': str(filepath),
                'line': content[:match.start()].count('\n') + 1
            }
            
            doc_info['classes'].append(class_info)
            self.cpp_classes.append(class_info)
        
        return doc_info
    
    def parse_cpp_parameters(self, param_string: str) -> List[Dict]:
        """Parse C++ parameter string into structured data."""
        if not param_string.strip():
            return []
        
        params = []
        # Split by comma, handling nested templates
        param_parts = re.split(r',\s*(?![^<>]*>)', param_string)
        
        for param in param_parts:
            param = param.strip()
            if not param or param == 'void':
                continue
            
            # Match type and name, handling pointers and references
            # Pattern handles: const type& name, type* name, type name = default
            match = re.match(r'((?:const\s+)?[\w:]+(?:\s*[*&])?)\s+(\w+)(?:\s*=\s*(.+))?', param)
            if match:
                param_type, param_name, default_value = match.groups()
                params.append({
                    'type': param_type.strip(),
                    'name': param_name,
                    'default': default_value.strip() if default_value else None,
                    'description': ''
                })
        
        return params
    
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
                    f.write(f"**Signature:** `{func['return_type']} {func['name']}({func['params_str']})`\n\n")
                    f.write(f"**Description:** {func['brief']}\n\n")
                    
                    # Add parameter table if parameters exist
                    if func['params']:
                        f.write("**Parameters:**\n\n")
                        f.write("| Name | Type | Default | Description |\n")
                        f.write("|------|------|---------|-------------|\n")
                        for param in func['params']:
                            name = param['name']
                            ptype = param['type']
                            default = param['default'] or '-'
                            desc = param['description'] or '-'
                            f.write(f"| `{name}` | `{ptype}` | {default} | {desc} |\n")
                        f.write("\n")
                    
                    # Add return documentation if available
                    if func.get('return_doc'):
                        f.write(f"**Returns:** {func['return_doc']}\n\n")
                    
                    f.write(f"**Source:** {func['file']}:{func['line']}\n\n")
    
    def generate_type_reference(self):
        """Generate markdown reference for all types."""
        output_file = self.output_dir / "type_reference.md"
        
        with open(output_file, 'w') as f:
            f.write("# TOL Type Reference\n\n")
            f.write(f"Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            # Group by category first
            by_category = {
                'variable': [],
                'function': [],
                'nameblock': []
            }
            
            for type_info in self.tol_types:
                category = type_info.get('category', 'variable')
                by_category[category].append(type_info)
            
            # Write variables section
            if by_category['variable']:
                f.write("\n## Variables\n\n")
                
                # Group variables by type
                vars_by_type = {}
                for var in by_category['variable']:
                    t = var['type']
                    if t not in vars_by_type:
                        vars_by_type[t] = []
                    vars_by_type[t].append(var)
                
                for type_name, instances in sorted(vars_by_type.items()):
                    f.write(f"\n### {type_name} Variables\n\n")
                    for inst in sorted(instances, key=lambda x: x['name']):
                        f.write(f"- `{inst['name']}` - {inst['file']}:{inst['line']}\n")
            
            # Write functions section
            if by_category['function']:
                f.write("\n## Functions\n\n")
                f.write("Functions defined at module level:\n\n")
                
                for func in sorted(by_category['function'], key=lambda x: x['name']):
                    params_str = ', '.join([f"{p['type']} {p['name']}" for p in func.get('params', [])])
                    f.write(f"- `{func['type']} {func['name']}({params_str})` - {func['file']}:{func['line']}\n")
            
            # Write NameBlocks section
            if by_category['nameblock']:
                f.write("\n## NameBlocks\n\n")
                f.write("Complex type definitions with members:\n\n")
                
                for nb in sorted(by_category['nameblock'], key=lambda x: x['name']):
                    f.write(f"\n### `{nb['name']}`\n\n")
                    f.write(f"**Location:** {nb['file']}:{nb['line']}\n\n")
                    
                    if nb.get('members'):
                        f.write("**Members:**\n\n")
                        
                        # Separate variables and functions
                        member_vars = [m for m in nb['members'] if m['category'] == 'variable']
                        member_funcs = [m for m in nb['members'] if m['category'] == 'function']
                        
                        if member_vars:
                            f.write("*Variables:*\n")
                            for var in member_vars:
                                f.write(f"- `{var['type']} {var['name']}`\n")
                            f.write("\n")
                        
                        if member_funcs:
                            f.write("*Methods:*\n")
                            for func in member_funcs:
                                params_str = ', '.join([f"{p['type']} {p['name']}" for p in func.get('params', [])])
                                f.write(f"- `{func['type']} {func['name']}({params_str})`\n")
                            f.write("\n")
    
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
    
    def generate_cpp_reference(self):
        """Generate markdown reference for C++ functions and classes."""
        output_file = self.output_dir / "cpp_reference.md"
        
        with open(output_file, 'w') as f:
            f.write("# C++ API Reference\n\n")
            f.write(f"Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            # C++ Functions
            if self.cpp_functions:
                f.write("## C++ Functions\n\n")
                
                # Group by file
                by_file = {}
                for func in self.cpp_functions:
                    file_name = Path(func['file']).name
                    if file_name not in by_file:
                        by_file[file_name] = []
                    by_file[file_name].append(func)
                
                for file_name, funcs in sorted(by_file.items()):
                    f.write(f"\n### {file_name}\n\n")
                    
                    for func in funcs:
                        f.write(f"#### `{func['name']}`\n\n")
                        
                        params_str = ', '.join([f"{p['type']} {p['name']}" for p in func['params']])
                        f.write(f"**Signature:** `{func['return_type']} {func['name']}({params_str})`\n\n")
                        
                        if func['brief']:
                            f.write(f"**Description:** {func['brief']}\n\n")
                        
                        if func['params']:
                            f.write("**Parameters:**\n\n")
                            f.write("| Name | Type | Description |\n")
                            f.write("|------|------|-------------|\n")
                            for param in func['params']:
                                desc = param['description'] or '-'
                                f.write(f"| `{param['name']}` | `{param['type']}` | {desc} |\n")
                            f.write("\n")
                        
                        if func['return_doc']:
                            f.write(f"**Returns:** {func['return_doc']}\n\n")
            
            # C++ Classes
            if self.cpp_classes:
                f.write("\n## C++ Classes\n\n")
                
                for cls in sorted(self.cpp_classes, key=lambda x: x['name']):
                    f.write(f"### `{cls['name']}`\n\n")
                    if cls['base']:
                        f.write(f"**Inherits from:** `{cls['base']}`\n\n")
                    f.write(f"**Source:** {cls['file']}:{cls['line']}\n\n")
    
    def generate_tol_cpp_mappings(self):
        """Generate documentation showing TOL to C++ function mappings."""
        output_file = self.output_dir / "tol_cpp_mappings.md"
        
        with open(output_file, 'w') as f:
            f.write("# TOL to C++ Function Mappings\n\n")
            f.write(f"Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            if self.tol_cpp_mappings:
                f.write("| TOL Function | C++ Implementation | Source File |\n")
                f.write("|--------------|-------------------|-------------|\n")
                
                for mapping in sorted(self.tol_cpp_mappings, key=lambda x: x['tol_name']):
                    tol_name = mapping['tol_name']
                    cpp_func = mapping['cpp_function'] or 'Unknown'
                    file_name = Path(mapping['file']).name
                    f.write(f"| `{tol_name}` | `{cpp_func}` | {file_name}:{mapping['line']} |\n")
            else:
                f.write("No TOL to C++ mappings found.\n")
    
    def generate_index_page(self, tol_files_processed: int, cpp_files_processed: int):
        """Generate main index page."""
        output_file = self.output_dir / "index.md"
        
        with open(output_file, 'w') as f:
            f.write("# TOL Auto-Generated Documentation\n\n")
            f.write(f"Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            f.write("## Statistics\n\n")
            f.write(f"- TOL files processed: {tol_files_processed}\n")
            f.write(f"- C++ files processed: {cpp_files_processed}\n")
            f.write(f"- TOL functions documented: {len(self.tol_functions)}\n")
            f.write(f"- C++ functions documented: {len(self.cpp_functions)}\n")
            f.write(f"- Type definitions found: {len(self.tol_types)}\n")
            f.write(f"- C++ classes found: {len(self.cpp_classes)}\n")
            f.write(f"- Code examples: {len(self.tol_examples)}\n")
            f.write(f"- TOL-C++ bindings: {len(self.tol_cpp_mappings)}\n\n")
            
            f.write("## Documentation Pages\n\n")
            f.write("### TOL Documentation\n")
            f.write("- [Function Reference](function_reference.md)\n")
            f.write("- [Type Reference](type_reference.md)\n")
            f.write("- [Code Examples](examples.md)\n\n")
            
            f.write("### C++ Documentation\n")
            f.write("- [C++ API Reference](cpp_reference.md)\n")
            f.write("- [TOL-C++ Function Mappings](tol_cpp_mappings.md)\n")
    
    def process_directory(self, directory: Path):
        """Process all TOL and C++ files in a directory."""
        tol_files = list(directory.rglob("*.tol"))
        cpp_files = list(directory.rglob("*.cpp")) + list(directory.rglob("*.h")) + list(directory.rglob("*.hpp"))
        
        # Filter out test and third-party files using precise path checks (case-insensitive)
        skip_dirs = {'test', 'tests', 'deprecated', 'third-party'}
        cpp_files = [
            f for f in cpp_files
            if not any(part.lower() in skip_dirs for part in f.parts)
        ]
        
        print(f"Found {len(tol_files)} TOL files to process")
        print(f"Found {len(cpp_files)} C++ files to process")
        
        # Process TOL files
        for tol_file in tol_files:
            print(f"Processing TOL: {tol_file}")
            try:
                self.extract_from_file(tol_file)
            except Exception as e:
                print(f"Error processing {tol_file}: {e}")
        
        # Process C++ files
        for cpp_file in cpp_files:
            print(f"Processing C++: {cpp_file}")
            try:
                self.extract_from_cpp_file(cpp_file)
            except Exception as e:
                print(f"Error processing {cpp_file}: {e}")
        
        # Generate documentation pages
        self.generate_function_reference()
        self.generate_type_reference()
        self.generate_examples_page()
        self.generate_cpp_reference()
        self.generate_tol_cpp_mappings()
        self.generate_index_page(len(tol_files), len(cpp_files))
        
        print(f"\nDocumentation generated in: {self.output_dir}")
        print(f"- TOL functions documented: {len(self.tol_functions)}")
        print(f"- C++ functions documented: {len(self.cpp_functions)}")
        print(f"- Types found: {len(self.tol_types)}")
        print(f"- C++ classes found: {len(self.cpp_classes)}")
        print(f"- Examples extracted: {len(self.tol_examples)}")
        print(f"- TOL-C++ bindings: {len(self.tol_cpp_mappings)}")

def main():
    parser = argparse.ArgumentParser(description="Extract documentation from TOL files")
    parser.add_argument("directory", help="Directory containing TOL files")
    parser.add_argument("-o", "--output", default="docs/generated", 
                       help="Output directory for documentation")

    args = parser.parse_args()

    input_dir = args.directory
    if not os.path.isdir(input_dir):
        print(f"Error: The specified directory '{input_dir}' does not exist or is not accessible.", file=sys.stderr)
        sys.exit(1)

    extractor = TOLDocExtractor(args.output)
    extractor.process_directory(Path(input_dir))

if __name__ == "__main__":
    main()