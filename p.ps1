param([String]$folder=$null,[Int32]$week=0)

# TODO: This file needs to be generalized for easy configuration in different hierarchy systems

<#
 To import commands: ". ./p.ps1"
 To execute single command: "./p.ps1 a|t week:int"

 Methods:
   a($week=cwd) -> cd root/week$week/assignment
   t($week=cwd) -> cd root/week$week/team
   s($file=$null) -> python $file | if cwd assignment: python assignment.py | if cwd team: python team.py
   b() -> cd ..
   bb() -> cd root

   Enter-Venv -> cd root; activate venv
   Set-Location-From-Root($week, $folder) -> cd root/week$week/$folder
#>

# Virtual Environment is entered on import (See end of file for execution)

# Declare helper functions
Write-Output "Loading Helper Commands";

function a {
  param (
    $week
  )

  if ($week -eq $null) {
    Set-Location ./assignment
  } else {
    Set-Location-From-Root $week "assignment";
  }
}

function t {
  param (
    $week
  )
  
  if ($week -eq $null) {
    Set-Location ./team
  } else {
    Set-Location-From-Root $week "team";
  }
}

function s {
  param (
    $filename
  )
  if ($null -eq $filename) {
    $Current_Folder = Split-Path -Path (Get-Location) -Leaf;

    if ($Current_Folder -Match "team") {
      python team.py;
    } elseif ($Current_Folder -Match "assignment") {
      python assignment.py;
    }
  } else {
    python $filename
  }
}

function b {
  cd..;
}

function bb {
  Set-Location $PSScriptRoot;
}


function Enter-Venv {
  Write-Output "Activating Virtual Environment"

  Set-Location $PSScriptRoot
  venv/scripts/activate
}

function Set-Location-From-Root {
  param (
    $week,
    $folder
  )

  if ($week -lt 10) {$week = "0" + $week;}

  $path = $PSScriptRoot + "/week" + $week + "/" + $folder;

  Write-Output "Navigating to '$path'";
  Set-Location $path;
}

# Start the virtual environment
Enter-Venv;

# If given parameters, navigate
if ($folder -ne $null) {
  if ($folder -eq "a") {
    a $week
  } elseif ($folder -eq "t") {
    t $week
  }
}
