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
	local Packages = script.Parent.Parent.Parent.Parent
	local jestExpect = require(Packages.Dev.JestGlobals).expect

	local Type = require(script.Parent.Parent.Parent["Type.roblox"])
	local Event = require(script.Parent.Parent.Event)

	it("should yield event objects when indexed", function()
		jestExpect(Type.of(Event.MouseButton1Click)).toBe(Type.HostEvent)
		jestExpect(Type.of(Event.Touched)).toBe(Type.HostEvent)
	end)

	it("should yield the same object when indexed again", function()
		local a = Event.MouseButton1Click
		local b = Event.MouseButton1Click
		local c = Event.Touched

		jestExpect(a).toBe(b)
		jestExpect(a).never.toBe(c)
	end)
end
