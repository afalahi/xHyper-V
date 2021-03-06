configuration Sample_xVHD_NewVhd
{
    param
    (
        [Parameter()]
        [string[]]
        $NodeName = 'localhost',

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [Uint64]
        $MaximumSizeBytes,

        [Parameter()]
        [ValidateSet('Vhd', 'Vhdx')]
        [string]$Generation = 'Vhd',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [string]
        $Ensure = 'Present'
    )

    Import-DscResource -ModuleName xHyper-V

    Node $NodeName
    {
        # Install HyperV feature, if not installed - Server SKU only
        WindowsFeature HyperV
        {
            Ensure = 'Present'
            Name   = 'Hyper-V'
        }

        WindowsFeature HyperVPowerShell
        {
            Ensure = 'Present'
            Name   = 'Hyper-V-PowerShell'
        }

        xVhd NewVhd
        {
            Ensure           = $Ensure
            Name             = $Name
            Path             = $Path
            Generation       = $Generation
            MaximumSizeBytes = $MaximumSizeBytes
            DependsOn        = '[WindowsFeature]HyperV', '[WindowsFeature]HyperVPowerShell'
        }
    }
}
