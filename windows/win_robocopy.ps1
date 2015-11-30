#!powershell
# This file is part of Ansible
#
# Copyright 2015, Corwin Brown <corwin.brown@maxpoint.com>
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

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;

$result = New-Object psobject @{
    win_robocopy = New-Object psobject @{
        recurse         = $false
        purge           = $false
    }
    changed = $false
}

$src = Get-AnsibleParam -obj $params -name "src" -failifempty $true
$dest = Get-AnsibleParam -obj $params -name "dest" -failifempty $true
$purge = Get-AnsibleParam -obj $params -name "purge" -default $false
$recurse = Get-AnsibleParam -obj $params -name "recurse" -default $false
$flags = Get-AnsibleParam -obj $params -name "flags" -default $null

# Build Arguments
$robocopy_opts = @()

$robocopy_opts += $src
Set-Attr $result.win_robocopy "src" $src

$robocopy_opts += $dest
Set-Attr $result.win_robocopy "dest" $dest

If ($flags -eq $null) {
    If ($purge) {
        $robocopy_opts += "/purge"
    }

    If ($recurse) {
        $robocopy_opts += "/e"
    }
}
Else {
    $robocopy_opts += $flags
}

Set-Attr $result.win_robocopy "purge" $purge
Set-Attr $result.win_robocopy "recurse" $recurse
Set-Attr $result.win_robocopy "flags" $flags

Try {
    &robocopy $robocopy_opts
    $rc = $LASTEXITCODE
}
Catch {
    $ErrorMessage = $_.Exception.Message
    Fail-Json $result "Error synchronizing $src to $dest! Msg: $ErrorMessage"
}

If ($rc -ne 0) {
    $result.changed = $true
}

Exit-Json $result
