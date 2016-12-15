
require 'date'

# class to determine last patch date
class PatchDate < Inspec.resource(1)
  name 'patch_date'

  def initialize
    if inspec.os.redhat?
      @params = {}
      # @params['last-update'] = %x{rpm -qa -last | awk 'NR==1 { print $3,$4,$5 }'}.chomp
      @params['last_update'] = inspec.command("rpm -qa -last | awk 'NR==1 { print $3,$4,$5 }'").stdout.chomp
    elsif inspec.os.windows?
      @wparams = {}
      # @wparams['last-update'] = `powershell.exe "(Get-Hotfix | sort installedon | select -ExpandProperty installedon -Last 1).ToShortDateString()"`
      @wparams['last_update'] = inspec.powershell('(Get-Hotfix | ? {$_.installedon -ne $null} | Sort-Object installedon | Select -ExpandProperty installedon -Last 1).ToShortDateString()').stdout.chomp
    end
  end

  def linux_within_30_days
    return [] if @params.nil? || @params.empty?
    # (Date.today - Date.strptime(@params['last_update'], '%d %b %Y')).to_i
    (Date.today - Date.parse(@params['last_update'])).to_i
  end

  def windows_within_90_days
    return [] if @wparams.nil? || @wparams.empty?
    # (Date.today - Date.strptime(@wparams['last_update'], '%m/%d/%Y')).to_i
    (Date.today - Date.parse(@wparams['last_update'])).to_i
  end
end
