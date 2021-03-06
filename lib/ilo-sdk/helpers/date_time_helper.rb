# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

module ILO_SDK
  # Contains helper methods for Date and Time actions
  module DateTimeHelper
    # Get the Time Zone
    # @raise [RuntimeError] if the request failed
    # @return [String] time_zone
    def get_time_zone
      response = rest_get('/redfish/v1/Managers/1/DateTime/')
      response_handler(response)['TimeZone']['Name']
    end

    # Set the Time Zone
    # @param [Fixnum] time_zone
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_time_zone(time_zone)
      time_response = rest_get('/redfish/v1/Managers/1/DateTime/')
      new_time_zone = response_handler(time_response)['TimeZoneList'].select { |timezone| timezone['Name'] == time_zone }
      new_action = { 'TimeZone' => { 'Index' => new_time_zone[0]['Index'] } }
      response = rest_patch('/redfish/v1/Managers/1/DateTime/', body: new_action)
      response_handler(response)
      true
    end

    # Get whether or not ntp servers are being used
    # @raise [RuntimeError] if the request failed
    # @return [TrueClass, FalseClass] use_ntp
    def get_ntp
      response = rest_get('/redfish/v1/Managers/1/EthernetInterfaces/1/')
      response_handler(response)['Oem']['Hp']['DHCPv4']['UseNTPServers']
    end

    # Set whether or not ntp servers are being used
    # @param [TrueClass, FalseClass] use_ntp
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_ntp(use_ntp)
      new_action = { 'Oem' => { 'Hp' => { 'DHCPv4' => { 'UseNTPServers' => use_ntp } } } }
      response = rest_patch('/redfish/v1/Managers/1/EthernetInterfaces/1/', body: new_action)
      response_handler(response)
      true
    end

    # Get the NTP Servers
    # @raise [RuntimeError] if the request failed
    # @return [Array] ntp_servers
    def get_ntp_servers
      response = rest_get('/redfish/v1/Managers/1/DateTime/')
      response_handler(response)['StaticNTPServers']
    end

    # Set the NTP Servers
    # @param [Fixnum] ntp_servers
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_ntp_servers(ntp_servers)
      new_action = { 'StaticNTPServers' => ntp_servers }
      response = rest_patch('/redfish/v1/Managers/1/DateTime/', body: new_action)
      response_handler(response)
      true
    end
  end
end
