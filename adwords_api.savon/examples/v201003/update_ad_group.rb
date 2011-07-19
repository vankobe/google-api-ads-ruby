#!/usr/bin/ruby
#
# Author:: api.sgomes@gmail.com (Sérgio Gomes)
#
# Copyright:: Copyright 2011, Google Inc. All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
# This example illustrates how to update an ad group, setting its status to
# 'PAUSED'. To create an ad group, run add_ad_group.rb.
#
# Tags: AdGroupService.mutate

require 'rubygems'
require 'adwords_api'

API_VERSION = :v201003

def update_ad_group()
  # AdwordsApi::Api will read a config file from ENV['HOME']/adwords_api.yml
  # when called without parameters.
  adwords = AdwordsApi::Api.new

  # To enable logging of SOAP requests, set the log_level value to 'DEBUG' in
  # the configuration file or provide your own logger:
  # adwords.logger = Logger.new('adwords_xml.log')

  ad_group_srv = adwords.service(:AdGroupService, API_VERSION)

  ad_group_id = 'INSERT_AD_GROUP_ID_HERE'.to_i

  # Prepare for updating ad group.
  operation = {
    :operator => 'SET',
    :operand => {
      :status => 'PAUSED',
      :id => ad_group_id
    }
  }

  # Update ad group.
  response = ad_group_srv.mutate([operation])
  if response and response[:value]
    ad_group = response[:value].first
    puts 'Ad group id %d was successfully updated.' % ad_group[:id]
  else
    puts 'No ad groups were updated.'
  end
end

if __FILE__ == $0
  begin
    update_ad_group()

  # HTTP errors.
  rescue AdsCommon::Errors::HttpError => e
    puts "HTTP Error: %s" % e

  # API errors.
  rescue AdwordsApi::Errors::ApiException => e
    puts "Message: %s" % e.message
    puts 'Errors:'
    e.errors.each_with_index do |error, index|
      puts "\tError [%d]:" % (index + 1)
      error.each do |field, value|
        puts "\t\t%s: %s" % [field, value]
      end
    end
  end
end
