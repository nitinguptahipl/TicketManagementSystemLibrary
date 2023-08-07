
Pod::Spec.new do |s|
s.name             = 'TicketManagementSystemLibrary'
s.version          = '0.0.1'
s.summary = 'TicketManagementSystem lets a user select an ice cream flavor.'

s.description      = 'This is simple Ticket Listing and Details Project. We can simply add to the project only for SamaraTech product team.'

s.homepage         = 'https://github.com/nitinguptahipl/TicketManagementSystemLibrary'
s.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }
  
s.author           = { 'username' => 'nitin.gupta@hipl.co.in' }

s.source = { :git => "https://github.com/nitinguptahipl/TicketManagementSystemLibrary.git",
:tag => "#{s.version}" }


s.ios.deployment_target = '11.0'
s.source_files = 'TicketManagementSystem/**/*.{swift}'
s.swift_versions = '5.0'

s.framework = 'UIKit'
s.dependency 'Alamofire', '~> 4.0'
s.dependency 'MBProgressHUD'
s.dependency 'DropDown'
s.dependency 'SDWebImage'
s.dependency 'Cosmos', '~> 23.0'

end

