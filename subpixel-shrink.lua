#!/usr/bin/env lua

local function each(fn, ...)
  local t = table.pack(...)
  for i = 1, t.n do
    t[i] = fn(t[i])
  end
  return table.unpack(t, 1, t.n)
end

local function load_image(filename)
  local file = assert(io.open(filename))
  local data = file:read("a")
  file:close()
  local _, pos, dim_x, dim_y, depth = data:find("^P3%s+(%d+)%s+(%d+)%s+(%d+)")
  assert(depth == "255")
  dim_x, dim_y = each(math.tointeger, dim_x, dim_y)
  pos = pos+1
  local result = {w = dim_x, h = dim_y}
  for j = 1, result.h do
    result[j] = {}
    for i = 1, 3*result.w do
      local nextpos
      _, nextpos, result[j][i] = data:find("(%d+)", pos)
      nextpos = nextpos+1
      result[j][i] = math.tointeger(result[j][i])
      pos = nextpos
    end
  end
  return result
end

local function unpack_list(list, sep)
  local result = ""
  if #list > 0 then
    result = list[1]
    for i = 2, #list do
      result = result..sep..list[i]
    end
  end
  return result
end

local function save_image(image, filename)
  local out = io.open(filename, "w")
  out:write(
    "P3\n"..
    math.tointeger(image.w).." "..math.tointeger(image.h)..
    "\n255\n"
  )
  for _, row in ipairs(image) do
    out:write(unpack_list(row, " ").."\n")
  end
end

local function avg_downscale(image)
  local result = {w = image.w // 3, h = image.h // 3}
  for j = 1, result.h do
    result[j] = {}
    for i = 1, result.w do
      result[j][3*i-2] = (
        image[3*j-2][9*i-8] + image[3*j-2][9*i-5] + image[3*j-2][9*i-2] +
        image[3*j-1][9*i-8] + image[3*j-1][9*i-5] + image[3*j-1][9*i-2] +
        image[3*j  ][9*i-8] + image[3*j  ][9*i-5] + image[3*j  ][9*i-2]
      ) // 9
      result[j][3*i-1] = (
        image[3*j-2][9*i-7] + image[3*j-2][9*i-4] + image[3*j-2][9*i-1] +
        image[3*j-1][9*i-7] + image[3*j-1][9*i-4] + image[3*j-1][9*i-1] +
        image[3*j  ][9*i-7] + image[3*j  ][9*i-4] + image[3*j  ][9*i-1]
      ) // 9
      result[j][3*i  ] = (
        image[3*j-2][9*i-6] + image[3*j-2][9*i-3] + image[3*j-2][9*i  ] +
        image[3*j-1][9*i-6] + image[3*j-1][9*i-3] + image[3*j-1][9*i  ] +
        image[3*j  ][9*i-6] + image[3*j  ][9*i-3] + image[3*j  ][9*i  ]
      ) // 9
    end
  end
  return result
end

local function sp_avg_downscale(image)
  local result = {w = image.w // 3, h = image.h // 3}
  for j = 1, result.h do
    result[j] = {}
    for i = 1, result.w do
      result[j][3*i-2] = (
        image[3*j-2][9*i-8] +
        image[3*j-1][9*i-8] +
        image[3*j  ][9*i-8]
      ) // 3
      result[j][3*i-1] = (
        image[3*j-2][9*i-4] +
        image[3*j-1][9*i-4] +
        image[3*j  ][9*i-4]
      ) // 3
      result[j][3*i  ] = (
        image[3*j-2][9*i  ] +
        image[3*j-1][9*i  ] +
        image[3*j  ][9*i  ]
      ) // 3
    end
  end
  return result
end

local filename = assert(arg[1]:match("^(.-%.[pP][pP][mM])$"))

local test_image = load_image(filename)

local ext_patt = "(.[pP][pP][mM])$"
save_image(avg_downscale(test_image), filename:gsub(ext_patt, "_avg%1"))
save_image(sp_avg_downscale(test_image), filename:gsub(ext_patt, "_spr%1"))
