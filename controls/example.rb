# encoding: utf-8
# copyright: 2015, The Authors
# license: All rights reserved

title 'determine last patch date'

# control 'os-patch-date-1.0' do
#   impact 0.5
#   title 'Check OS for patching date'
#   desc 'This test will check linux patching within 30 days, and windows within 90'
#   if os[:family] == 'redhat'
#     describe patch_date do
#       its('linux_within_30_days') { should be <= 30 }
#     end
#   end
#   if os[:family] == 'windows'
#     describe patch_date do
#       its('windows_within_90_days') { should be <= 90 }
#     end
#   end
# end

control 'os-patch-date-1.1' do
  impact 0.5
  title 'Check OS for last patching date - windows'
  desc 'This test will check windows applied a patch in the last 90 days'
  only_if { os[:family] == 'windows' }
  describe patch_date do
    its('windows_within_90_days') { should be <= 90 }
  end
end

control 'os-patch-date-1.2' do
  impact 0.5
  title 'Check OS for last patching date - redhat'
  desc 'This test will check redhat applied a patch in the last 30 days'
  only_if { os[:family] == 'redhat' }
  describe patch_date do
    its('linux_within_30_days') { should be <= 30 }
  end
end
