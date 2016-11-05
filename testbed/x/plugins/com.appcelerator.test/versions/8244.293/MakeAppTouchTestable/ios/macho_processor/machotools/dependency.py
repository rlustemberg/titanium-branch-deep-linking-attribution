import re, macholib, struct

from macholib import mach_o
from macholib.ptypes import sizeof

from .common import _change_command_data_inplace, _find_lc_dylib_command
from .utils import convert_to_string, macho_path_as_data, safe_update

def _find_specific_lc_load_dylib(header, dependency_pattern):
    for index, (load_command, dylib_command, data) in \
            _find_lc_dylib_command(header, mach_o.LC_LOAD_DYLIB):
        m = dependency_pattern.search(convert_to_string(data))
        if m:
            return index, (load_command, dylib_command, data)

def _change_dependency_command(header, old_dependency_pattern, new_dependency):
    old_command = _find_specific_lc_load_dylib(header, old_dependency_pattern)
    if old_command is None:
        return
    command_index, command_tuple = old_command
    _change_command_data_inplace(header, command_index, command_tuple, new_dependency)

def dependencies(filename):
    """Returns the list of mach-o the given binary depends on.

    Parameters
    ----------
    filename: str
        Path to the mach-o to query

    Returns
    -------
    dependency_names: seq
        dependency_names[i] is the list of dependencies for the i-th header.
    """
    m = macholib.MachO.MachO(filename)
    return _list_dependencies_macho(m)

def _list_dependencies_macho(m):
    ret = []

    for header in m.headers:
        this_ret = []
        for load_command, dylib_command, data in header.commands:
            if load_command.cmd == mach_o.LC_LOAD_DYLIB:
                this_ret.append(convert_to_string(data))
        ret.append(this_ret)
    return ret

def change_dependency(filename, old_dependency_pattern, new_dependency):
    """Change the install name of a mach-o dylib file.

    For a multi-arch binary, every header is overwritten to the same install
    name

    Parameters
    ----------
    filename: str
        Path to the mach-o file to modify
    new_install_name: str
        New install name
    """
    _r_old_dependency = re.compile(old_dependency_pattern)
    m = macholib.MachO.MachO(filename)
    for header in m.headers:
        _change_dependency_command(header, _r_old_dependency, new_dependency)

    def writer(f):
        for header in m.headers:
            f.seek(0)
            header.write(f)
    safe_update(filename, writer, "wb")
    
def add_dependency(filename, new_dependency, compatibility_version, current_version):
    """Add the given dependency to all headers in a MachO file.

    Parameters
    ----------
    filename: str
        The path to the macho-o binary file to add dependency to
    new_dependency: str
        Name of the new dependency
    compatibility_version: str
        Compatibility Version of the new dependency
        Example: 1.2.3
    current_version: str
        Current Version of the new dependency
        Example: 1.2.3
    """
    macho = macholib.MachO.MachO(filename)
    for header in macho.headers:
            _add_dependency_to_header(header, new_dependency, compatibility_version, current_version)

    def writer(f):
        for header in macho.headers:
            f.seek(0)
            header.write(f)
    safe_update(filename, writer, "wb")
    
def add_dependency_if_not_exists(filename, new_dependency, compatibility_version, current_version):
    """Add the given dependency to all headers in a MachO file.

    Parameters
    ----------
    filename: str
        The path to the macho-o binary file to add dependency to
    new_dependency: str
        Name of the new dependency
    compatibility_version: str
        Compatibility Version of the new dependency
        Example: 1.2.3
    current_version: str
        Current Version of the new dependency
        Example: 1.2.3
    """
    dependency_already_exists = False
    macho = macholib.MachO.MachO(filename)
    for header in macho.headers:
        for lc, cmd, data in header.commands:
            if lc.cmd == macholib.mach_o.LC_LOAD_DYLIB and new_dependency in data:
                print "YES"
                dependency_already_exists = True

    if not dependency_already_exists:
        for header in macho.headers:
            _add_dependency_to_header(header, new_dependency, compatibility_version, current_version)
    
    def writer(f):
        for header in macho.headers:
            f.seek(0)
            header.write(f)
    safe_update(filename, writer, "wb")
    
def _add_dependency_to_header(header, new_dependency, compatibility_version, current_version):
    """Add an LC_LOAD_DYLIB load command to a MachOHeader.

    Parameters
    ----------
    header: MachOHeader instances
        A mach-o header to add dependency to
    new_dependency: str
        Name of the dependency to be added to the header
    compatibility_version: str
        Compatibility Version of the new dependency
        Example: 1.2.3
    current_version: str
        Current Version of the new dependency
        Example: 1.2.3
    """
    if header.header.magic in (macholib.mach_o.MH_MAGIC, macholib.mach_o.MH_CIGAM):
        pad_to = 4
    else:
        pad_to = 8
    data = macho_path_as_data(new_dependency, pad_to=pad_to)
    header_size = sizeof(macholib.mach_o.load_command) + sizeof(macholib.mach_o.dylib_command)

    rem = (header_size + len(data)) % pad_to
    if rem > 0:
        data += b'\x00' * (pad_to - rem)

    command_size = header_size + len(data)

    cmd = macholib.mach_o.dylib_command(header_size, _endian_=header.endian)
    
    # We assume that the compatibility version data is in the format major.minor.rev version numbers. Example: 1.2.3
    version_array = compatibility_version.split('.')
    compatibility_version_object = macholib.mach_o.mach_version_helper(int(version_array[0]), int(version_array[1]), int(version_array[2]))
    cmd.compatibility_version = compatibility_version_object

    # We assume that the current version data is in the format major.minor.rev version numbers. Example: 1.2.3    
    version_array = current_version.split('.')
    current_version_object = macholib.mach_o.mach_version_helper(int(version_array[0]), int(version_array[1]), int(version_array[2]))
    cmd.current_version = current_version_object
    
    lc = macholib.mach_o.load_command(macholib.mach_o.LC_LOAD_DYLIB, command_size, _endian_=header.endian)
    header.commands.append((lc, cmd, data))
    header.header.ncmds += 1
    header.changedHeaderSizeBy(command_size)
