#!/usr/bin/env python3
"""
TOL Test Report Generator
Issue: NUM-11 - P0: Comprehensive Cross-Platform Testing Framework
Author: Massimiliano Marinucci
Date: 2025-07-06

This script aggregates test results and generates comprehensive reports
in multiple formats (JSON, XML, HTML, JUnit XML).
"""

import argparse
import json
import xml.etree.ElementTree as ET
from xml.dom import minidom
import os
import sys
import glob
from datetime import datetime
import re
from pathlib import Path

class TOLTestReportGenerator:
    def __init__(self, input_dir, output_dir):
        self.input_dir = Path(input_dir)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
    def parse_ctest_results(self):
        """Parse CTest results from Testing directory"""
        testing_dir = self.input_dir / "Testing"
        if not testing_dir.exists():
            print(f"Warning: Testing directory not found at {testing_dir}")
            return {}
            
        # Find the most recent test results
        test_dirs = [d for d in testing_dir.iterdir() if d.is_dir() and d.name != "Temporary"]
        if not test_dirs:
            print("Warning: No test result directories found")
            return {}
            
        latest_dir = max(test_dirs, key=lambda d: d.stat().st_mtime)
        
        results = {
            'timestamp': datetime.now().isoformat(),
            'platform': self.detect_platform(),
            'tests': [],
            'summary': {
                'total': 0,
                'passed': 0,
                'failed': 0,
                'skipped': 0
            }
        }
        
        # Parse Test.xml if it exists
        test_xml = latest_dir / "Test.xml"
        if test_xml.exists():
            results = results | self.parse_test_xml(test_xml)
            
        return results
    
    def parse_test_xml(self, xml_file):
        """Parse CTest XML results"""
        try:
            tree = ET.parse(xml_file)
            root = tree.getroot()
            
            results = {
                'tests': [],
                'summary': {'total': 0, 'passed': 0, 'failed': 0, 'skipped': 0}
            }
            
            for test in root.findall('.//Test'):
                test_name = test.get('Name', 'Unknown')
                status = test.get('Status', 'Unknown')
                
                # Parse execution time
                exec_time = 0.0
                time_elem = test.find('.//ExecutionTime')
                if time_elem is not None:
                    exec_time = float(time_elem.text)
                
                # Parse output for additional information
                output = ""
                output_elem = test.find('.//Output')
                if output_elem is not None:
                    output = output_elem.text or ""
                
                test_result = {
                    'name': test_name,
                    'status': 'PASS' if status == 'passed' else 'FAIL' if status == 'failed' else 'SKIP',
                    'execution_time': exec_time,
                    'output': output,
                    'category': self.extract_category_from_name(test_name)
                }
                
                results['tests'].append(test_result)
                results['summary']['total'] += 1
                
                if status == 'passed':
                    results['summary']['passed'] += 1
                elif status == 'failed':
                    results['summary']['failed'] += 1
                else:
                    results['summary']['skipped'] += 1
                    
            return results
            
        except Exception as e:
            print(f"Error parsing {xml_file}: {e}")
            return {'tests': [], 'summary': {'total': 0, 'passed': 0, 'failed': 0, 'skipped': 0}}
    
    def extract_category_from_name(self, test_name):
        """Extract test category from test name"""
        if 'unit_' in test_name:
            return 'unit'
        elif 'integration_' in test_name:
            return 'integration'
        elif 'performance_' in test_name:
            return 'performance'
        elif 'platform_' in test_name:
            return 'platform'
        elif 'memory_' in test_name:
            return 'memory'
        else:
            return 'other'
    
    def detect_platform(self):
        """Detect the current platform"""
        import platform
        system = platform.system()
        machine = platform.machine()
        return f"{system}_{machine}"
    
    def generate_json_report(self, results):
        """Generate JSON report"""
        report = {
            'test_suite': {
                'name': 'TOL_Comprehensive_Testing_Framework',
                'platform': results['platform'],
                'timestamp': results['timestamp'],
                'summary': results['summary'],
                'test_results': results['tests']
            }
        }
        
        output_file = self.output_dir / "comprehensive_test_report.json"
        with open(output_file, 'w') as f:
            json.dump(report, f, indent=2)
        
        print(f"Generated JSON report: {output_file}")
        return output_file
    
    def generate_junit_xml(self, results):
        """Generate JUnit XML report for CI/CD integration"""
        root = ET.Element('testsuite')
        root.set('name', 'TOL_Comprehensive_Testing_Framework')
        root.set('tests', str(results['summary']['total']))
        root.set('failures', str(results['summary']['failed']))
        root.set('errors', '0')
        root.set('skipped', str(results['summary']['skipped']))
        root.set('timestamp', results['timestamp'])
        
        total_time = sum(test.get('execution_time', 0) for test in results['tests'])
        root.set('time', str(total_time))
        
        for test in results['tests']:
            testcase = ET.SubElement(root, 'testcase')
            testcase.set('name', test['name'])
            testcase.set('classname', test['category'])
            testcase.set('time', str(test.get('execution_time', 0)))
            
            if test['status'] == 'FAIL':
                failure = ET.SubElement(testcase, 'failure')
                failure.set('type', 'TestFailure')
                failure.set('message', 'Test failed')
                failure.text = test.get('output', '')
            elif test['status'] == 'SKIP':
                ET.SubElement(testcase, 'skipped')
        
        # Pretty print XML
        rough_string = ET.tostring(root, 'unicode')
        reparsed = minidom.parseString(rough_string)
        pretty_xml = reparsed.toprettyxml(indent="  ")
        
        output_file = self.output_dir / "junit_test_results.xml"
        with open(output_file, 'w') as f:
            f.write(pretty_xml)
        
        print(f"Generated JUnit XML report: {output_file}")
        return output_file
    
    def generate_html_report(self, results):
        """Generate HTML report"""
        html_template = """
<!DOCTYPE html>
<html>
<head>
    <title>TOL Comprehensive Test Report</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 20px; }}
        .header {{ background-color: #f0f0f0; padding: 20px; border-radius: 5px; margin-bottom: 20px; }}
        .summary {{ display: flex; gap: 20px; margin-bottom: 20px; }}
        .summary-card {{ background-color: #fff; border: 1px solid #ddd; padding: 15px; border-radius: 5px; flex: 1; }}
        .pass {{ background-color: #d4edda; }}
        .fail {{ background-color: #f8d7da; }}
        .skip {{ background-color: #fff3cd; }}
        table {{ border-collapse: collapse; width: 100%; }}
        th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
        th {{ background-color: #f2f2f2; }}
        .status-pass {{ color: #28a745; font-weight: bold; }}
        .status-fail {{ color: #dc3545; font-weight: bold; }}
        .status-skip {{ color: #ffc107; font-weight: bold; }}
        .category-filter {{ margin: 10px 0; }}
        .category-filter button {{ margin: 5px; padding: 5px 10px; border: 1px solid #ddd; background: #f8f9fa; cursor: pointer; }}
        .category-filter button.active {{ background: #007bff; color: white; }}
    </style>
    <script>
        function filterByCategory(category) {{
            const rows = document.querySelectorAll('tbody tr');
            const buttons = document.querySelectorAll('.category-filter button');
            
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            rows.forEach(row => {{
                if (category === 'all' || row.dataset.category === category) {{
                    row.style.display = '';
                }} else {{
                    row.style.display = 'none';
                }}
            }});
        }}
    </script>
</head>
<body>
    <div class="header">
        <h1>TOL Comprehensive Test Report</h1>
        <p><strong>Platform:</strong> {platform}</p>
        <p><strong>Timestamp:</strong> {timestamp}</p>
    </div>
    
    <div class="summary">
        <div class="summary-card">
            <h3>Total Tests</h3>
            <h2>{total_tests}</h2>
        </div>
        <div class="summary-card pass">
            <h3>Passed</h3>
            <h2>{passed_tests}</h2>
        </div>
        <div class="summary-card fail">
            <h3>Failed</h3>
            <h2>{failed_tests}</h2>
        </div>
        <div class="summary-card skip">
            <h3>Skipped</h3>
            <h2>{skipped_tests}</h2>
        </div>
        <div class="summary-card">
            <h3>Success Rate</h3>
            <h2>{success_rate:.1f}%</h2>
        </div>
    </div>
    
    <div class="category-filter">
        <h3>Filter by Category:</h3>
        <button onclick="filterByCategory('all')" class="active">All</button>
        <button onclick="filterByCategory('unit')">Unit</button>
        <button onclick="filterByCategory('integration')">Integration</button>
        <button onclick="filterByCategory('performance')">Performance</button>
        <button onclick="filterByCategory('platform')">Platform</button>
        <button onclick="filterByCategory('memory')">Memory</button>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>Test Name</th>
                <th>Category</th>
                <th>Status</th>
                <th>Execution Time (s)</th>
                <th>Details</th>
            </tr>
        </thead>
        <tbody>
            {test_rows}
        </tbody>
    </table>
</body>
</html>
        """
        
        # Generate test rows
        test_rows = ""
        for test in results['tests']:
            status_class = f"status-{test['status'].lower()}"
            test_rows += f"""
            <tr data-category="{test['category']}">
                <td>{test['name']}</td>
                <td>{test['category']}</td>
                <td class="{status_class}">{test['status']}</td>
                <td>{test.get('execution_time', 0):.3f}</td>
                <td>{test.get('output', '')[:100]}{'...' if len(test.get('output', '')) > 100 else ''}</td>
            </tr>
            """
        
        success_rate = (results['summary']['passed'] / results['summary']['total'] * 100) if results['summary']['total'] > 0 else 0
        
        html_content = html_template.format(
            platform=results['platform'],
            timestamp=results['timestamp'],
            total_tests=results['summary']['total'],
            passed_tests=results['summary']['passed'],
            failed_tests=results['summary']['failed'],
            skipped_tests=results['summary']['skipped'],
            success_rate=success_rate,
            test_rows=test_rows
        )
        
        output_file = self.output_dir / "comprehensive_test_report.html"
        with open(output_file, 'w') as f:
            f.write(html_content)
        
        print(f"Generated HTML report: {output_file}")
        return output_file
    
    def generate_all_reports(self):
        """Generate all report formats"""
        print("Parsing test results...")
        results = self.parse_ctest_results()
        
        if not results['tests']:
            print("Warning: No test results found")
            return
        
        print(f"Found {len(results['tests'])} test results")
        
        # Generate all report formats
        self.generate_json_report(results)
        self.generate_junit_xml(results)
        self.generate_html_report(results)
        
        print(f"\nAll reports generated in: {self.output_dir}")
        print(f"Summary: {results['summary']['passed']}/{results['summary']['total']} tests passed")

def main():
    parser = argparse.ArgumentParser(description='Generate TOL test reports')
    parser.add_argument('--input', required=True, help='Input directory containing test results')
    parser.add_argument('--output', required=True, help='Output directory for reports')
    
    args = parser.parse_args()
    
    generator = TOLTestReportGenerator(args.input, args.output)
    generator.generate_all_reports()

if __name__ == '__main__':
    main()
