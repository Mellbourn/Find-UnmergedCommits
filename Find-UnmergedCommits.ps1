Function Find-UnmergedCommits() {
    <#
    .SYNOPSIS
    git helper function to find unmerged commits to another branch
    .PARAMETER branch
    Specify branch to compare with (default master)
    .NOTES
    Authors: P-A Eriksson <p-a@peeri.se>, Hampus Klarin <hampus@gmail.com>
    #>

    param (
        [parameter(Mandatory=$false)]
        [string] $branch
    )

    git fetch --all | Out-Null

    $currentBranchName = & git rev-parse --abbrev-ref HEAD

    if (!$branch) {
        $branch = "master"
    }

    $commits = git cherry origin/$branch $currentBranchName
    $commits = [string[]] $commits

    if ($commits.Length -eq 0) {
        Write-Host "No unmerged commits from this branch to $branch."
    }
    else {
        for($i=0; $i -le $commits.Length-1; $i++)
        {
            git show $commits[$i].Substring(2) --pretty=format:'%h: %an (%ae) | %s' | select-object -first 1
        }
    }
}

if (Test-Path alias:gunmerged) { Del alias:gunmerged -Force }
New-Alias gunmerged Find-UnmergedCommits