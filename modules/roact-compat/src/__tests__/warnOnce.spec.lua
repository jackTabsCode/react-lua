--!strict
--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]

return function()
	local Packages = script.Parent.Parent.Parent
	local RobloxJest = require(Packages.Dev.RobloxJest)
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local warnOnce

	beforeEach(function()
		RobloxJest.resetModules()
		warnOnce = require(script.Parent.Parent.warnOnce)
	end)

	it("warns exactly once", function()
		jestExpect(function()
			warnOnce("oldAPI", "Foo")
		end).toWarnDev(
			"Warning: The legacy Roact API 'oldAPI' is deprecated, and will be "
				.. "removed in a future release.\n\nFoo",
			{ withoutStack = true }
		)

		jestExpect(function()
			warnOnce("oldAPI", "Foo")
		end).toWarnDev({})
	end)
end
