require('game/scripts/vscripts/internal/util')

TestSplit = {}

function TestSplit:setUp()
  self.string1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sed orci arcu. Duis tristique sagittis turpis, eget laoreet nisi lobortis ac. Nullam eu ultricies est, vitae venenatis nunc. Ut faucibus, nisi vel eleifend rutrum, sapien elit lacinia nibh, vitae gravida lacus tortor sed magna. Sed ullamcorper accumsan tellus, et tempus neque lobortis ut. Quisque at lacinia elit. Curabitur posuere orci vel orci ultrices posuere. Donec tristique lobortis lectus, non semper risus egestas non. Phasellus bibendum, arcu et feugiat condimentum, erat nibh ornare justo, nec ullamcorper nunc tortor quis mi. Vivamus interdum molestie elit, quis commodo neque tempor eget. Curabitur consequat at massa in convallis."
end

function TestSplit:test1()
  print("Splitting on ','")
  local result = {
    "Lorem ipsum dolor sit amet",
    " consectetur adipiscing elit. Nam sed orci arcu. Duis tristique sagittis turpis",
    " eget laoreet nisi lobortis ac. Nullam eu ultricies est",
    " vitae venenatis nunc. Ut faucibus",
    " nisi vel eleifend rutrum",
    " sapien elit lacinia nibh",
    " vitae gravida lacus tortor sed magna. Sed ullamcorper accumsan tellus",
    " et tempus neque lobortis ut. Quisque at lacinia elit. Curabitur posuere orci vel orci ultrices posuere. Donec tristique lobortis lectus",
    " non semper risus egestas non. Phasellus bibendum",
    " arcu et feugiat condimentum",
    " erat nibh ornare justo",
    " nec ullamcorper nunc tortor quis mi. Vivamus interdum molestie elit",
    " quis commodo neque tempor eget. Curabitur consequat at massa in convallis."
  }
  luaunit.assertEquals(split(self.string1, ","), result)
end

function TestSplit:test2()
  print("Splitting on '.'")
  local result = {
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    " Nam sed orci arcu",
    " Duis tristique sagittis turpis, eget laoreet nisi lobortis ac",
    " Nullam eu ultricies est, vitae venenatis nunc",
    " Ut faucibus, nisi vel eleifend rutrum, sapien elit lacinia nibh, vitae gravida lacus tortor sed magna",
    " Sed ullamcorper accumsan tellus, et tempus neque lobortis ut",
    " Quisque at lacinia elit",
    " Curabitur posuere orci vel orci ultrices posuere",
    " Donec tristique lobortis lectus, non semper risus egestas non",
    " Phasellus bibendum, arcu et feugiat condimentum, erat nibh ornare justo, nec ullamcorper nunc tortor quis mi",
    " Vivamus interdum molestie elit, quis commodo neque tempor eget",
    " Curabitur consequat at massa in convallis",
    ""
  }
  luaunit.assertEquals(split(self.string1, "\."), result)
end

TestRegexSplit = {}

function TestRegexSplit:setUp()
  self.string1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sed orci arcu. Duis tristique sagittis turpis, eget laoreet nisi lobortis ac. Nullam eu ultricies est, vitae venenatis nunc. Ut faucibus, nisi vel eleifend rutrum, sapien elit lacinia nibh, vitae gravida lacus tortor sed magna. Sed ullamcorper accumsan tellus, et tempus neque lobortis ut. Quisque at lacinia elit. Curabitur posuere orci vel orci ultrices posuere. Donec tristique lobortis lectus, non semper risus egestas non. Phasellus bibendum, arcu et feugiat condimentum, erat nibh ornare justo, nec ullamcorper nunc tortor quis mi. Vivamus interdum molestie elit, quis commodo neque tempor eget. Curabitur consequat at massa in convallis."
end

function TestRegexSplit:test1()
  print("Splitting on it|ti")
  local result = {
    "Lorem ipsum dolor s",
    " amet, consectetur adipiscing el",
    ". Nam sed orci arcu. Duis tris",
    "que sag",
    "",
    "s turpis, eget laoreet nisi lobor",
    "s ac. Nullam eu ultricies est, v",
    "ae venena",
    "s nunc. Ut faucibus, nisi vel eleifend rutrum, sapien el",
    " lacinia nibh, v",
    "ae gravida lacus tortor sed magna. Sed ullamcorper accumsan tellus, et tempus neque lobor",
    "s ut. Quisque at lacinia el",
    ". Curab",
    "ur posuere orci vel orci ultrices posuere. Donec tris",
    "que lobor",
    "s lectus, non semper risus egestas non. Phasellus bibendum, arcu et feugiat condimentum, erat nibh ornare justo, nec ullamcorper nunc tortor quis mi. Vivamus interdum moles",
    "e el",
    ", quis commodo neque tempor eget. Curab",
    "ur consequat at massa in convallis."
  }
  luaunit.assertEquals(regexsplit(self.string1, "it|ti"), result)
end
