local Class = {}
Class.__index = Class

-- default implementation
function Class:new() end

function Class:derive(type)
  local cls = {}
  cls["__call"] = Class.__call;
  cls.type = type
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

function Class:is(class)
  assert(class ~= nil, "parameter class must not be nil!")
  assert(type(class) == "table", "parameter class must be of Type Class!")
  local mt = getmetatable(self)
  while mt do
    if mt == class then return true end
    mt = getmetatable(mt)
  end
  return false
end

function Class:__call(...)
  local inst = setmetatable({}, self)
  inst:new(...)
  return inst
end

function Class:get_type()
  return self.type
end

return Class
