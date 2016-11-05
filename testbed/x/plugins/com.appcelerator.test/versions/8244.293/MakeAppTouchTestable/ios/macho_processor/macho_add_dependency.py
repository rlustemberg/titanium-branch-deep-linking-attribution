import sys, os

sys.path.append(os.path.abspath('macholib'))
sys.path.append(os.path.abspath('machotools'))

from machotools import dependency
    
"""Add an LC_LOAD_DYLIB load command to a MachOHeader.

Parameters
----------
MachO Binary file:
    Binary file whose mach-o header needs to be modified
New Dependency: str
    Name of the dependency to be added to the header
Compatibility Version: str
    Compatibility Version of the new dependency
    Example: 1.2.3
Current Version: str
    Current Version of the new dependency
    Example: 1.2.3
"""
dependency.add_dependency_if_not_exists(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])