#
# Cookbook Name:: rackspace_generic
# Providor:: cbs
#
# Copyright 2014, Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fog'
require 'pathname'
require 'json'

service = Fog::Rackspace::BlockStorage.new({
  :rackspace_username => node['rackspace']['rackspace_username'],
  :rackspace_api_key => node['rackspace']['rackspace_api_key'],
  :rackspace_region => region
})

def check_if_exists(volume_name, region='ord')
  status = false
  drives = service.list_volumes.body['volumes']
  for volume in drives
    if volume['display_name'] == volume_name
      status = true
    end
  end
end  

def chef_if_attached(drive

def check_if_attached(drive, region='ord', volume_type='SSD', volume_size=100)
  unless File.stat(drive).blockdev?
    cbs_prefix = IPAddr.new node['ipaddress'].to_i.to_s
    cbs_postfix = Pathname.new(drive).basename
    volume_name = "#{cbs_prefix}_#{cbs_postfix}"

    unless check_if_exists(drive, region)
      volume = service.volumes.create(:size => volume_size,
                                      :display_name => volume_name,
                                      :volume_type => volume_type)
    end
  end
end

check_if_attached(drive='/dev/sda1', region='ord')
