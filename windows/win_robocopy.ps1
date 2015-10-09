#!powershell
# This file is part of Ansible
#
# Copyright 2015, Corwin Brown <blakfeld@gmail.com>
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

$robocopy_opts = @()
If (Get-Member -InputObject $params -Name src) {
    $src = $params.src.ToString()
    $robocopy_opts += $src

    If (-Not (Test-Path -path $src)) {
        Fail-Json $result "src file: $src does not exist."
    }

    Set-Attr $result.win_robocopy "src" $src
}
Else {
    Fail-Json $result "missing required argument: src"
}

If (Get-Member -InputObject $params -Name dest) {
    $dest = $params.dest.ToString()
    $robocopy_opts += $params.dest.toString()

    Set-Attr $result.win_robocopy "dest" $dest
}
Else {
    Fail-Json $result "missing required argument: dest"
}

If (Get-Member -InputObject $params -Name purge) {
    If ($params.purge) {
        $robocopy_opts += "/purge"

        Set-Attr $result.win_robocopy "purge" $params.purge
    }
}

If (Get-Member -InputObject $params -Name recurse) {
    If ($params.recurse) {
        $robocopy_opts += "/e"

        Set-Attr $result.win_robocopy "recurse" $params.recurse
    }
}

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
