<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/72d00ab623502983ebd7ac0756cf2787df109811/packages/react-reconciler/src/ReactFiberComponentStack.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberComponentStack.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
<<<<<<< HEAD
]]

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
type Function = (...any) -> ...any
type Error = LuauPolyfill.Error

local ReactInternalTypes = require("./ReactInternalTypes")
type Fiber = ReactInternalTypes.Fiber

local ReactWorkTags = require("./ReactWorkTags")
local HostComponent = ReactWorkTags.HostComponent
local LazyComponent = ReactWorkTags.LazyComponent
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local SuspenseListComponent = ReactWorkTags.SuspenseListComponent
local FunctionComponent = ReactWorkTags.FunctionComponent
local IndeterminateComponent = ReactWorkTags.IndeterminateComponent
local ForwardRef = ReactWorkTags.ForwardRef
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local ClassComponent = ReactWorkTags.ClassComponent

local ReactComponentStackFrame = require("@pkg/@jsdotlua/shared").ReactComponentStackFrame
local describeBuiltInComponentFrame =
	ReactComponentStackFrame.describeBuiltInComponentFrame
local describeFunctionComponentFrame =
	ReactComponentStackFrame.describeFunctionComponentFrame
local describeClassComponentFrame = ReactComponentStackFrame.describeClassComponentFrame

=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local exports = {}
local reactInternalTypesModule = require(script.Parent.ReactInternalTypes)
type Fiber = reactInternalTypesModule.Fiber
local reactWorkTagsModule = require(script.Parent.ReactWorkTags)
local HostComponent = reactWorkTagsModule.HostComponent
local LazyComponent = reactWorkTagsModule.LazyComponent
local SuspenseComponent = reactWorkTagsModule.SuspenseComponent
local SuspenseListComponent = reactWorkTagsModule.SuspenseListComponent
local FunctionComponent = reactWorkTagsModule.FunctionComponent
local IndeterminateComponent = reactWorkTagsModule.IndeterminateComponent
local ForwardRef = reactWorkTagsModule.ForwardRef
local SimpleMemoComponent = reactWorkTagsModule.SimpleMemoComponent
local ClassComponent = reactWorkTagsModule.ClassComponent
local sharedReactComponentStackFrameModule = require(Packages.shared.ReactComponentStackFrame)
local describeBuiltInComponentFrame = sharedReactComponentStackFrameModule.describeBuiltInComponentFrame
local describeFunctionComponentFrame = sharedReactComponentStackFrameModule.describeFunctionComponentFrame
local describeClassComponentFrame = sharedReactComponentStackFrameModule.describeClassComponentFrame
>>>>>>> upstream-apply
local function describeFiber(fiber: Fiber): string
	-- deviation: untangling some nested ternaries to use more idiomatic if/else
	local owner: nil | Function = nil
	if _G.__DEV__ then
		-- FIXME (roblox): Luau's limited narrowing necessitates this local
		local debugOwner = fiber._debugOwner
		if debugOwner then
			owner = debugOwner.type
		end
	end
	local source = nil
	if _G.__DEV__ then
		source = fiber._debugSource
	end
	if fiber.tag == HostComponent then
		return describeBuiltInComponentFrame(fiber.type, source, owner)
	elseif fiber.tag == LazyComponent then
		return describeBuiltInComponentFrame("Lazy", source, owner)
	elseif fiber.tag == SuspenseComponent then
		return describeBuiltInComponentFrame("Suspense", source, owner)
	elseif fiber.tag == SuspenseListComponent then
		return describeBuiltInComponentFrame("SuspenseList", source, owner)
	elseif
		fiber.tag == FunctionComponent
		or fiber.tag == IndeterminateComponent
		or fiber.tag == SimpleMemoComponent
	then
		return describeFunctionComponentFrame(fiber.type, source, owner)
	elseif fiber.tag == ForwardRef then
		return describeFunctionComponentFrame(fiber.type.render, source, owner)
<<<<<<< HEAD
	elseif fiber.tag == ClassComponent then
=======
	elseif condition_ == ClassComponent then
>>>>>>> upstream-apply
		return describeClassComponentFrame(fiber.type, source, owner)
	else
		return ""
	end
end

return {
	getStackByFiberInDevAndProd = function(workInProgress: Fiber?): string
		local ok: boolean, result: Error | string = pcall(function()
			local info = ""
			local node = workInProgress
			repeat
				info ..= describeFiber(node :: Fiber)
				node = (node :: Fiber).return_
			until node == nil
			return info
		end)

		if not ok then
			local message = "\nError generating stack: "
			if
				typeof(result) == "table"
				and (result :: Error).message
				and (result :: Error).stack
			then
				return message
					.. (result :: Error).message
					.. "\n"
					.. tostring((result :: Error).stack)
			end
			return message .. tostring(result)
		end

		return result :: string
	end,
}
