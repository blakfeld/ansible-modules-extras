#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2015, Corwin Brown <blakfeld@gmail.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

DOCUMENATION = """
---
module: win_robocopy
version_added: "2.0"
short_description: Synchronizes the contents of two directories using Robocopy.
description:
    - Synchronizes the contents of two directories on the remote machine. Under the hood this just calls out to RoboCopy, since that should be available on most modern Windows Systems.
options:
  src:
    description:
      - Source file to sync.
    required: true
  dest:
    description:
      - Destination file to sync (Will receive contents of src).
    required: true
  recurse:
    description:
      - Includes all subdirectories (Toggles the `/e` flag to RoboCopy). This option is ignored if you use the 'flags' argument.
    choices:
      - true
      - false
    defaults: false
    required: false
  purge:
    description:
      - Deletes any files/directories found in the destination that do not exist in the source (Toggles the `/purge` flag to RoboCopy). This option is ignored if you use the 'flags' argument.
    choices:
      - true
      - false
    defaults: false
    required: false
  flags:
    description:
      - Directly pass through any custom arguments to Robocopy.
    defaults: false
    required: false
author: Corwin Brown (@blakfeld)
notes:
    - This is not a complete port of the "synchronize" module. Unlike the "synchronize" module this only performs the sync/copy on the remote machine, not from the master to the remote machine.
    - This module does not currently support all Robocopy flags.
    - Works on Windows 7, Windows 8, Windows Server 2k8, and Windows Server 2k12
"""

EXAMPLES = """
# Syncs the contents of one diretory to another.
$ ansible -i hosts all -m win_robocopy -a "src=C:\\DirectoryOne dest=C:\\DirectoryTwo"

# Sync the contents of one directory to another, including subdirectories.
$ ansible -i hosts all -m win_robocopy -a "src=C:\\DirectoryOne dest=C:\\DirectoryTwo recurse=true"

# Sync the contents of one directory to another, and remove any files/directories found in destination that do not exist in the source.
$ ansible -i hosts all -m win_robocopy -a "src=C:\\DirectoryOne dest=C:\\DirectoryTwo purge=true"

# Sample sync
---
- name: Sync Two Directories
  win_robocopy:
    src: "C:\\DirectoryOne"
    dest: "C:\\DirectoryTwo"
    recurse: true
    purge: true

---
- name: Sync Two Directories
  win_robocopy:
    src: "C:\\DirectoryOne"
    dest: "C:\\DirectoryTwo"
    flags: '/XD SOME_DIR /XF SOME_FILE /MT:32'
"""
