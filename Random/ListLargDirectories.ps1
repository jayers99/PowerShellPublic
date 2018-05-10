dir . -Directory | foreach {
    $stats = dir %_.FUllName -Recurse -File |
     Measure length -sum
    $_ | select Fullname,
    @{Name="Size";Expression={$stats.sum}},
    @{Name="Files";Expression={$stats.Count}}
} | sort Size -Descending | select -First 10
