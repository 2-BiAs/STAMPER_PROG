//define some functions
function z=myplus(x, y)
  z = x + y
endfunction

function z=yourplus(x, y)
  x = x - y
endfunction

//create the *.bin files in libdir
libdir = TMPDIR;
save(libdir + '/myplus.bin', myplus);
save(libdir + '/yourplus.bin', yourplus);

//create the name file
mputl(['myplus';'yourplus'],TMPDIR+'/names');

//build the library containing myplus and yourplus
mylibfoo = lib(libdir+'/');

//erase the variables
clear myplus yourplus

//Automatic loading and execution
myplus(1,2)

//erase the variables
clear myplus yourplus

mylibfoo
[n,p] = libraryinfo('mylibfoo')

isdef('myplus')
clear mylibfoo
isdef('myplus')
